#!/bin/bash

# =============================================================================
# dwi preprocessing pipeline for ENGRAMS 
#
# workflow: NORDIC (MATLAB) -> Gibbs (MRtrix3) -> TOPUP -> EDDY -> N4 -> dtifit
#
# important: this script (after 20260127) now expects a single NORDIC output 
# containing all acquisitions merged together, rather than separate files per 
# b-value shell
#
# helpful docs:
#   - MRtrix3: https://mrtrix.readthedocs.io/en/latest/
#   - FSL TOPUP: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup
#   - FSL EDDY: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy
#
# 20251004: alex: initial version
# 20260127: alex: revised for combined NORDIC processing in MATLAB (for now)
# =============================================================================

set -e  # Exit on error
set -u  # Error on undefined variables

SUBJECT="sub-207v1s1"

# paths
NORDIC_DIR="/mnt/work/yyi/ENGRAMS/analyses/${SUBJECT}/dwi/nordic"
OUTPUT_DIR="/mnt/work/yyi/ENGRAMS/analyses/${SUBJECT}/dwi"
DWI_DIR="/mnt/work/yyi/ENGRAMS/preproc/${SUBJECT}/dwi"

# tools
SYNTHSTRIP="/share/apps/freesurfer_7.3/bin/mri_synthstrip"

# resources
export OMP_NUM_THREADS=20
echo "using ${OMP_NUM_THREADS} threads"

mkdir -p "$OUTPUT_DIR"


# =============================================================================
# STEP 0: before all this and that, did you actually run nordic?
# =============================================================================

echo "------------------------------------------------------"
echo "STEP 0: checking nordic output and volume information"
echo "------------------------------------------------------"

NORDIC_INPUT="${NORDIC_DIR}/${SUBJECT}_all_nordic.nii.gz"
VOL_INFO="${NORDIC_DIR}/${SUBJECT}_volume_info.txt"

if [ ! -f "${NORDIC_INPUT}" ]; then
    echo "error: nordic output not found: ${NORDIC_INPUT}"
    echo "run the matlab nordic script first"
    exit 1
fi

if [ ! -f "${VOL_INFO}" ]; then
    echo "error: volume info file not found: ${VOL_INFO}"
    echo "this file should be created by the matlab script"
    exit 1
fi

# parse volume counts from info file
# expected order: b1pt0k-AP, b1pt0k-PA, b2pt5k-AP, b2pt5k-PA
N_B1K_AP=$(grep "b1pt0k-AP" "${VOL_INFO}" | awk '{print $2}')
N_B1K_PA=$(grep "b1pt0k-PA" "${VOL_INFO}" | awk '{print $2}')
N_B2K_AP=$(grep "b2pt5k-AP" "${VOL_INFO}" | awk '{print $2}')
N_B2K_PA=$(grep "b2pt5k-PA" "${VOL_INFO}" | awk '{print $2}')

echo "volume counts:"
echo "  b1pt0k-AP: ${N_B1K_AP}"
echo "  b1pt0k-PA: ${N_B1K_PA}"
echo "  b2pt5k-AP: ${N_B2K_AP}"
echo "  b2pt5k-PA: ${N_B2K_PA}"

N_TOTAL=$((N_B1K_AP + N_B1K_PA + N_B2K_AP + N_B2K_PA))
echo "  total: ${N_TOTAL}"

# verify against actual file
N_ACTUAL=$(fslval "${NORDIC_INPUT}" dim4)
if [ "${N_TOTAL}" -ne "${N_ACTUAL}" ]; then
    echo "error: volume count mismatch!"
    echo "  expected: ${N_TOTAL}, found: ${N_ACTUAL}"
    exit 1
fi
echo "volume count all good"


# =============================================================================
# STEP 1: gibbs ringing removal on nordic denoised data
# =============================================================================

echo "-----------------------------"
echo "STEP 1: gibbs ringing removal"
echo "-----------------------------"

DEGIBBS_OUTPUT="${OUTPUT_DIR}/${SUBJECT}_all_nordic_degibbs.nii.gz"

if [ -f "${DEGIBBS_OUTPUT}" ]; then
    echo "degibbs output already exists, skipping..."
else
    mrdegibbs "${NORDIC_INPUT}" "${DEGIBBS_OUTPUT}" -nthreads ${OMP_NUM_THREADS}
    echo "gibbs removal done"
fi


# =============================================================================
# STEP 2: concat bvecs and bvals in the same order as nordic input
# =============================================================================

echo "------------------------------------"
echo "STEP 2: concatenate bvecs and bvals"
echo "------------------------------------"

# order must match MATLAB concatenation: b1pt0k-AP, b1pt0k-PA, b2pt5k-AP, b2pt5k-PA
BVEC_OUT="${OUTPUT_DIR}/${SUBJECT}_all.bvec"
BVAL_OUT="${OUTPUT_DIR}/${SUBJECT}_all.bval"

paste -d ' ' \
    "${DWI_DIR}/${SUBJECT}_b1pt0k-AP_dwi.bvec" \
    "${DWI_DIR}/${SUBJECT}_b1pt0k-PA_dwi.bvec" \
    "${DWI_DIR}/${SUBJECT}_b2pt5k-AP_dwi.bvec" \
    "${DWI_DIR}/${SUBJECT}_b2pt5k-PA_dwi.bvec" \
    > "${BVEC_OUT}"

# for bvals, we need to concatenate horizontally (single row)
awk '{printf "%s ", $0} END {print ""}' \
    "${DWI_DIR}/${SUBJECT}_b1pt0k-AP_dwi.bval" \
    "${DWI_DIR}/${SUBJECT}_b1pt0k-PA_dwi.bval" \
    "${DWI_DIR}/${SUBJECT}_b2pt5k-AP_dwi.bval" \
    "${DWI_DIR}/${SUBJECT}_b2pt5k-PA_dwi.bval" \
    > "${BVAL_OUT}"

echo "bvecs/bvals concatenated"


# =============================================================================
# STEP 3: extract b0 images for TOPUP
# =============================================================================

echo "-------------------------------------"
echo "STEP 3: extract b=0 images for TOPUP"
echo "-------------------------------------"

# Calculate volume indices
# Volume indexing is 0-based in fslroi
IDX_B1K_AP_START=0
IDX_B1K_PA_START=${N_B1K_AP}
IDX_B2K_AP_START=$((N_B1K_AP + N_B1K_PA))
IDX_B2K_PA_START=$((N_B1K_AP + N_B1K_PA + N_B2K_AP))

echo "volume indices:"
echo "  b1pt0k-AP starts at: ${IDX_B1K_AP_START}"
echo "  b1pt0k-PA starts at: ${IDX_B1K_PA_START}"
echo "  b2pt5k-AP starts at: ${IDX_B2K_AP_START}"
echo "  b2pt5k-PA starts at: ${IDX_B2K_PA_START}"

# extract AP b0 (first volume of b1pt0k-AP, which is volume 0)
fslroi "${DEGIBBS_OUTPUT}" \
    "${OUTPUT_DIR}/${SUBJECT}_AP_b0.nii.gz" \
    ${IDX_B1K_AP_START} 1

# extract PA b0 (first volume of b1pt0k-PA)
fslroi "${DEGIBBS_OUTPUT}" \
    "${OUTPUT_DIR}/${SUBJECT}_PA_b0.nii.gz" \
    ${IDX_B1K_PA_START} 1

echo "b0 images extracted."


# =============================================================================
# STEP 4: merge b0 images for TOPUP
# =============================================================================

echo "-----------------------"
echo "STEP 4: merge b0 images"
echo "-----------------------"

fslmerge -t "${OUTPUT_DIR}/${SUBJECT}_b0_AP_PA.nii.gz" \
    "${OUTPUT_DIR}/${SUBJECT}_AP_b0.nii.gz" \
    "${OUTPUT_DIR}/${SUBJECT}_PA_b0.nii.gz"

echo "b0 images merged."


# =============================================================================
# STEP 5: create acquisition parameters file
# =============================================================================

echo "----------------------------"
echo "STEP 5: create acqparams.txt"
echo "----------------------------"

# i asked siemens how this works in their sidecar... here's the response:
# Phase encoding directions and total readout time
# Line 1: AP (A>>P = 0 -1 0)
# Line 2: PA (P>>A = 0 1 0)
#
# Total readout time calculation for your sequence:
#   Echo spacing: 0.56 ms
#   iPAT (GRAPPA) factor: 3
#   Partial Fourier: 6/8
#   Base resolution: 250
#
#   Effective PE steps = ceil(250 * 0.75 / 3) = ceil(62.5) = 63
#   But with partial Fourier 6/8, acquired lines ≈ 250 * 0.75 = 187.5 → 188
#   After GRAPPA: 188 / 3 ≈ 63 effective echoes
#   Total readout = echo_spacing * (n_echoes - 1)
#                 = 0.00056 * (63 - 1) = 0.03472 s
#
# NOTE: Verify this value using your BIDS JSON sidecar if available.
# The TotalReadoutTime or EffectiveEchoSpacing fields are authoritative.
# Your original value was 0.0464791; adjust if you have confirmed it.

TOTAL_READOUT=0.0464791 # i think this is correct

cat <<EOT > "${OUTPUT_DIR}/acqparams.txt"
0 -1 0 ${TOTAL_READOUT}
0 1 0 ${TOTAL_READOUT}
EOT

echo "acqparams.txt created with total readout time: ${TOTAL_READOUT}"


# =============================================================================
# STEP 6: run TOPUP
# =============================================================================

echo "-----------------"
echo "STEP 6: run TOPUP"
echo "-----------------"

TOPUP_BASE="${OUTPUT_DIR}/${SUBJECT}_topup_results"

if [ -f "${TOPUP_BASE}_fieldcoef.nii.gz" ]; then
    echo "TOPUP results already exist, skipping..."
else
    topup --imain="${OUTPUT_DIR}/${SUBJECT}_b0_AP_PA.nii.gz" \
          --datain="${OUTPUT_DIR}/acqparams.txt" \
          --config=b02b0.cnf \
          --out="${TOPUP_BASE}" \
          --iout="${OUTPUT_DIR}/${SUBJECT}_hifi_b0_tmp.nii.gz" \
          --verbose
    echo "TOPUP done"
fi


# =============================================================================
# STEP 7: create brain mask
# =============================================================================

echo "-------------------------"
echo "STEP 7: create brain mask"
echo "-------------------------"

# average the TOPUP-corrected b0 images
fslmaths "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_tmp.nii.gz" \
    -Tmean "${OUTPUT_DIR}/${SUBJECT}_hifi_b0.nii.gz"

# use synthstrip for robust skull stripping
# i define the synthstrip path above... change there according to the env
if [ -x "${SYNTHSTRIP}" ]; then
    ${SYNTHSTRIP} \
        -i "${OUTPUT_DIR}/${SUBJECT}_hifi_b0.nii.gz" \
        -o "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain.nii.gz" \
        -m "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz"
else
    echo "Warning: SynthStrip not found at ${SYNTHSTRIP}"
    echo "Falling back to FSL bet..."
    bet "${OUTPUT_DIR}/${SUBJECT}_hifi_b0.nii.gz" \
        "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain.nii.gz" \
        -m -f 0.3
    # rename mask to expected filename
    mv "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz" \
       "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz" 2>/dev/null || true
fi

echo "brain tissue mask is made"


# =============================================================================
# STEP 8: create index file for eddy
# =============================================================================

echo "-----------------------------------"
echo "STEP 8: create index file for EDDY"
echo "-----------------------------------"

# index file maps each volume to a line in acqparams.txt
# line 1 (index 1): AP direction
# line 2 (index 2): PA direction
#
# my data's concatenation order:
#   b1pt0k-AP (N_B1K_AP volumes) -> index 1
#   b1pt0k-PA (N_B1K_PA volumes) -> index 2
#   b2pt5k-AP (N_B2K_AP volumes) -> index 1
#   b2pt5k-PA (N_B2K_PA volumes) -> index 2

INDEX_FILE="${OUTPUT_DIR}/index.txt"
> "${INDEX_FILE}"

# b1pt0k-AP: index 1
for i in $(seq 1 ${N_B1K_AP}); do
    echo "1" >> "${INDEX_FILE}"
done

# b1pt0k-PA: index 2
for i in $(seq 1 ${N_B1K_PA}); do
    echo "2" >> "${INDEX_FILE}"
done

# b2pt5k-AP: index 1
for i in $(seq 1 ${N_B2K_AP}); do
    echo "1" >> "${INDEX_FILE}"
done

# b2pt5k-PA: index 2
for i in $(seq 1 ${N_B2K_PA}); do
    echo "2" >> "${INDEX_FILE}"
done

N_INDEX=$(wc -l < "${INDEX_FILE}")
echo "index file created with ${N_INDEX} entries"

if [ "${N_INDEX}" -ne "${N_TOTAL}" ]; then
    echo "error: index file has wrong number of entries! something's wrong..."
    exit 1
fi


# =============================================================================
# STEP 9: run eddy
# =============================================================================

echo "---------------------------------------------"
echo "STEP 9: Run EDDY (this takes super long time)"
echo "---------------------------------------------"

# what each eddy switch means (from tutorial) #

# --imain: input 4D dwi file (all volumes concatenated together)
# --mask: brain mask that tells eddy which voxels are brain tissue vs background. this speeds up processing and improves accuracy.
# --acqp: acquisition parameters file. tells eddy how the data were acquired (PE direction and readout time). needed to model and correct distortions.
# --index: index file that maps each volume to a line in acqparams. since i have AP and PA acquisitions, this tells eddy which volumes were acquired with which phase encoding direction.
# --bvecs: gradient directions for each diffusion volume. eddy needs these to model expected signal and will also rotate them to account for motion.
# --bvals: b-values for each volume. tells eddy the diffusion weighting strength.
# --topup: points to topup results. eddy uses this initial distortion correction and refines it further.
# --out: output filename prefix.
# optional parameters:
# --slm=linear: slice-to-volume motion correction. my data uses multiband (simultaneous multi-slice), meaning multiple slices are acquired at once. standard volume-to-volume motion correction assumes all slices in a volume move together, but with multiband this isn't true. this flag models motion between individual slices, which is critical for SMS data like mine.
# --repol: replace outliers. at 7T, you can get signal dropouts from subject motion or physiological noise. this detects corrupted slices and replaces them with predictions from the diffusion model. i heard it's essential for UHF data..
# --data_is_shelled: confirms data's bvals form discrete shells (in my case 1000 and 2500) rather than being continuously distributed. this lets eddy use better models.
# --verbose: prints detailed progress information so i can monitor what's happening during the (very long) processing time.
# other useful parameters i might consider (but not right now):
# --niter=5: number of iterations (default is 5). more iterations can improve correction but increase processing time.
# --fwhm=0: smoothing kernel. setting to 0 preserves 0.8mm data (we might do laminar analyses so we keep it at 0).
# *** the order matters: topup corrects static distortions, then eddy corrects motion and eddy current distortions while accounting for the topup correction.


EDDY_OUTPUT="${OUTPUT_DIR}/${SUBJECT}_eddy_corrected"

if [ -f "${EDDY_OUTPUT}.nii.gz" ]; then
    echo "EDDY output already exists, skipping..."
else
    eddy --imain="${DEGIBBS_OUTPUT}" \
         --mask="${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz" \
         --acqp="${OUTPUT_DIR}/acqparams.txt" \
         --index="${INDEX_FILE}" \
         --bvecs="${BVEC_OUT}" \
         --bvals="${BVAL_OUT}" \
         --topup="${TOPUP_BASE}" \
         --out="${EDDY_OUTPUT}" \
         --fwhm=0 \
         --slm=linear \
         --repol \
         --data_is_shelled \
         --verbose

    echo "eddy done"
fi


# =============================================================================
# STEP 10: bias field correction (N4 via ANTs)
# =============================================================================

echo "------------------------------"
echo "STEP 10: bias field correction"
echo "------------------------------"

# convert to mrtrix format with gradient information
mrconvert "${EDDY_OUTPUT}.nii.gz" \
          "${OUTPUT_DIR}/${SUBJECT}_eddy_corrected.mif" \
          -fslgrad "${EDDY_OUTPUT}.eddy_rotated_bvecs" "${BVAL_OUT}" \
          -force

# apply N4 bias field correction (renat didn't like the performance but i don't quite remember why)
dwibiascorrect ants \
    "${OUTPUT_DIR}/${SUBJECT}_eddy_corrected.mif" \
    "${OUTPUT_DIR}/${SUBJECT}_preprocessed.mif" \
    -mask "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz" \
    -nthreads ${OMP_NUM_THREADS} \
    -force

# convert back to NIfTI with updated gradients
mrconvert "${OUTPUT_DIR}/${SUBJECT}_preprocessed.mif" \
          "${OUTPUT_DIR}/${SUBJECT}_preprocessed.nii.gz" \
          -export_grad_fsl "${OUTPUT_DIR}/${SUBJECT}_preprocessed.bvec" \
                           "${OUTPUT_DIR}/${SUBJECT}_preprocessed.bval" \
          -force

echo "bias correction done"


# =============================================================================
# STEP 11: dtifit
# =============================================================================

echo "--------------------"
echo "STEP 11: dtifit"
echo "--------------------"

dtifit --data="${OUTPUT_DIR}/${SUBJECT}_preprocessed.nii.gz" \
       --out="${OUTPUT_DIR}/${SUBJECT}_dti" \
       --mask="${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz" \
       --bvecs="${OUTPUT_DIR}/${SUBJECT}_preprocessed.bvec" \
       --bvals="${OUTPUT_DIR}/${SUBJECT}_preprocessed.bval" \
       --sse \
       --save_tensor

echo "dtifit done"


# # =============================================================================
# # STEP 12: QA (wip!!!!!! have to run something at SDFlex first!)
# # =============================================================================

# echo "----------------------------------"
# echo "STEP 12: QA summary for debugging"
# echo "---------------------------------"

# QA_FILE="${OUTPUT_DIR}/${SUBJECT}_qa_summary.txt"

# cat <<EOT > "${QA_FILE}"
# ================================================================================
# DWI Preprocessing QA Summary for ${SUBJECT}
# Generated: $(date)
# ================================================================================

# INPUT DATA
# ----------
# NORDIC input: ${NORDIC_INPUT}
# Total volumes: ${N_TOTAL}
#   - b1pt0k-AP: ${N_B1K_AP} volumes
#   - b1pt0k-PA: ${N_B1K_PA} volumes
#   - b2pt5k-AP: ${N_B2K_AP} volumes
#   - b2pt5k-PA: ${N_B2K_PA} volumes

# ACQUISITION PARAMETERS
# ----------------------
# Total readout time: ${TOTAL_READOUT} s
# Phase encoding: AP (0 -1 0) and PA (0 1 0)

# OUTPUT FILES
# ------------
# Preprocessed DWI: ${OUTPUT_DIR}/${SUBJECT}_preprocessed.nii.gz
# Brain mask: ${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz
# DTI outputs: ${OUTPUT_DIR}/${SUBJECT}_dti_*

# EDDY QA METRICS
# ---------------
# EOT

# # append EDDY QA if available
# if [ -f "${EDDY_OUTPUT}.eddy_movement_rms" ]; then
#     echo "Movement RMS (first 5 volumes):" >> "${QA_FILE}"
#     head -5 "${EDDY_OUTPUT}.eddy_movement_rms" >> "${QA_FILE}"
# fi

# if [ -f "${EDDY_OUTPUT}.eddy_outlier_report" ]; then
#     echo "" >> "${QA_FILE}"
#     echo "Outlier summary:" >> "${QA_FILE}"
#     echo "Total outlier slices: $(wc -l < ${EDDY_OUTPUT}.eddy_outlier_report)" >> "${QA_FILE}"
# fi

# echo "QA summary saved to: ${QA_FILE}"


# =============================================================================
# Complete
# =============================================================================

echo ""
echo "========================================"
echo "pipeline finally done for ${SUBJECT}"
echo "========================================"
echo ""
echo "check the outputs:"
echo "  - preprocessed DWI: ${OUTPUT_DIR}/${SUBJECT}_preprocessed.nii.gz"
echo "  - FA map: ${OUTPUT_DIR}/${SUBJECT}_dti_FA.nii.gz"
echo "  - MD map: ${OUTPUT_DIR}/${SUBJECT}_dti_MD.nii.gz"
# echo "  - QA summary: ${QA_FILE}"
echo ""
