#!/bin/bash

# dwi preproc pipeline with nordic and gibbs removal
# current workflow (20251004): nordic (done in MATLAB) -> gibbs (mrtrix3) -> TOPUP -> EDDY -> dtifit
# read the manuals!: https://mrtrix.readthedocs.io/en/latest/

SUBJECT="sub-302v1s2"

# workspaces
NORDIC_DIR="/mnt/work/yyi/ENGRAMS/analyses/${SUBJECT}/dwi/nordic"
DWI_DIR="/mnt/work/yyi/ENGRAMS/preproc/${SUBJECT}/dwi"
OUTPUT_DIR="/mnt/work/yyi/ENGRAMS/analyses/${SUBJECT}/dwi"

export OMP_NUM_THREADS=8
echo $OMP_NUM_THREADS

mkdir -p "$OUTPUT_DIR"

##########################################################################
# STEP 1: Gibbs ringing removal on NORDIC denoised data
##########################################################################

echo "STEP 1: gibbs ringing removal"

for acq in b1pt0k-AP b1pt0k-PA b2pt5k-AP b2pt5k-PA; do
    echo "proc ${acq}..."
    
    singularity run -B /mnt/work/yyi /share/apps/images/mrtrix.simg mrdegibbs "${NORDIC_DIR}/${SUBJECT}_${acq}_nordic.nii.gz" \
              "${OUTPUT_DIR}/${SUBJECT}_${acq}_nordic_degibbs.nii.gz"
    
    # Copy bval and bvec files
    cp "${DWI_DIR}/${SUBJECT}_${acq}_dwi.bval" \
       "${OUTPUT_DIR}/${SUBJECT}_${acq}_nordic_degibbs.bval"
    
    cp "${DWI_DIR}/${SUBJECT}_${acq}_dwi.bvec" \
       "${OUTPUT_DIR}/${SUBJECT}_${acq}_nordic_degibbs.bvec"
done

echo "gibbs removal done"

##########################################################################
# STEP 2: extract b0 images for topup
##########################################################################

echo "STEP 2: extract b=0 images"

fslroi "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-AP_nordic_degibbs.nii.gz" \
       "${OUTPUT_DIR}/${SUBJECT}_AP_b0.nii.gz" 0 1

fslroi "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-PA_nordic_degibbs.nii.gz" \
       "${OUTPUT_DIR}/${SUBJECT}_PA_b0.nii.gz" 0 1

##########################################################################
# STEP 3: merge b=0 images for topup
##########################################################################

echo "STEP 3: merge b=0 images"

fslmerge -t "${OUTPUT_DIR}/${SUBJECT}_b0_AP_PA.nii.gz" \
         "${OUTPUT_DIR}/${SUBJECT}_AP_b0.nii.gz" \
         "${OUTPUT_DIR}/${SUBJECT}_PA_b0.nii.gz"

##########################################################################
# STEP 4: create acquisition parameters dot txt
##########################################################################

echo "STEP 4: create acqparams.txt"

cat <<EOT > "${OUTPUT_DIR}/acqparams.txt"
0 -1 0 0.0464791
0 1 0 0.0464791
EOT

##########################################################################
# STEP 5: run TOPUP
##########################################################################

echo "STEP 5: run TOPUP (takes a while)"

topup --imain="${OUTPUT_DIR}/${SUBJECT}_b0_AP_PA.nii.gz" \
      --datain="${OUTPUT_DIR}/acqparams.txt" \
      --config=b02b0.cnf \
      --out="${OUTPUT_DIR}/${SUBJECT}_topup_results" \
      --iout="${OUTPUT_DIR}/${SUBJECT}_hifi_b0_tmp.nii.gz"

echo "TOPUP done"

##########################################################################
# STEP 6: make a brain mask
##########################################################################

echo "STEP 6: make a brain mask"

# average the corrected b=0 volumes
fslmaths "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_tmp.nii.gz" \
         -Tmean "${OUTPUT_DIR}/${SUBJECT}_hifi_b0.nii.gz"

# synthstrip
# on hydra
/share/apps/freesurfer_7.3/bin/mri_synthstrip -i "${OUTPUT_DIR}/${SUBJECT}_hifi_b0.nii.gz" \
                 -o "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain.nii.gz" \
                 -m "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz"
# on imac (may not work)
# mri_synth_strip -i "${OUTPUT_DIR}/${SUBJECT}_hifi_b0.nii.gz" \
#                 -o "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain.nii.gz" \
#                 -m "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz"

##########################################################################
# STEP 7: concat all dwi data
##########################################################################

echo "STEP 7: concat dwi"

fslmerge -t "${OUTPUT_DIR}/${SUBJECT}_all_dwi.nii.gz" \
    "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-AP_nordic_degibbs.nii.gz" \
    "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-PA_nordic_degibbs.nii.gz" \
    "${OUTPUT_DIR}/${SUBJECT}_b2pt5k-AP_nordic_degibbs.nii.gz" \
    "${OUTPUT_DIR}/${SUBJECT}_b2pt5k-PA_nordic_degibbs.nii.gz"

##########################################################################
# STEP 8: concat bvecs and bvals
##########################################################################

echo "STEP 8: concat bvecs and bvals"

# Concatenate bvecs
paste -d ' ' "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-AP_nordic_degibbs.bvec" \
             "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-PA_nordic_degibbs.bvec" \
             "${OUTPUT_DIR}/${SUBJECT}_b2pt5k-AP_nordic_degibbs.bvec" \
             "${OUTPUT_DIR}/${SUBJECT}_b2pt5k-PA_nordic_degibbs.bvec" \
             > "${OUTPUT_DIR}/${SUBJECT}_all.bvec"

# Concatenate bvals (on single line)
awk '{printf "%s ", $0} END {print ""}' \
    "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-AP_nordic_degibbs.bval" \
    "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-PA_nordic_degibbs.bval" \
    "${OUTPUT_DIR}/${SUBJECT}_b2pt5k-AP_nordic_degibbs.bval" \
    "${OUTPUT_DIR}/${SUBJECT}_b2pt5k-PA_nordic_degibbs.bval" \
    > "${OUTPUT_DIR}/${SUBJECT}_all.bval"

# Validate
echo "validating concatenated files:"
echo -n "bvec columns: "
awk '{print NF; exit}' "${OUTPUT_DIR}/${SUBJECT}_all.bvec"
echo -n "bval values: "
awk '{print NF}' "${OUTPUT_DIR}/${SUBJECT}_all.bval"
echo -n "DWI volumes: "
fslval "${OUTPUT_DIR}/${SUBJECT}_all_dwi.nii.gz" dim4

##########################################################################
# STEP 9: Create index file for EDDY
##########################################################################

echo "STEP 9: create index for EDDY"

dwi_files=(
    "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-AP_nordic_degibbs.nii.gz"
    "${OUTPUT_DIR}/${SUBJECT}_b1pt0k-PA_nordic_degibbs.nii.gz"
    "${OUTPUT_DIR}/${SUBJECT}_b2pt5k-AP_nordic_degibbs.nii.gz"
    "${OUTPUT_DIR}/${SUBJECT}_b2pt5k-PA_nordic_degibbs.nii.gz"
)

> "${OUTPUT_DIR}/index.txt"
for file in "${dwi_files[@]}"; do
    nvols=$(fslval "$file" dim4 | tr -d '[:space:]')
    
    if ! [[ "$nvols" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid volume count for $file: '$nvols'" >&2
        exit 1
    fi
    
    [[ "$file" == *-AP_* ]] && index="1" || index="2"
    yes "$index" | head -n "$nvols" >> "${OUTPUT_DIR}/index.txt"
done

##########################################################################
# STEP 10: Run EDDY for motion and distortion correction
##########################################################################

echo "STEP 10: run EDDY (this takes even longer)"


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

# only on hydra
singularity run -B /mnt/work/yyi /share/apps/images/fsl_6.0.0.simg eddy_openmp --imain="${OUTPUT_DIR}/${SUBJECT}_all_dwi.nii.gz" \
            --mask="${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz" \
            --acqp="${OUTPUT_DIR}/acqparams.txt" \
            --index="${OUTPUT_DIR}/index.txt" \
            --bvecs="${OUTPUT_DIR}/${SUBJECT}_all.bvec" \
            --bvals="${OUTPUT_DIR}/${SUBJECT}_all.bval" \
            --topup="${OUTPUT_DIR}/${SUBJECT}_topup_results" \
            --out="${OUTPUT_DIR}/${SUBJECT}_eddy_corrected" \
            --slm=linear \
            --repol \
            --data_is_shelled \
            --verbose

# on my macbook
# eddy --imain="${OUTPUT_DIR}/${SUBJECT}_all_dwi.nii.gz" \
#      --mask="${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz" \
#      --acqp="${OUTPUT_DIR}/acqparams.txt" \
#      --index="${OUTPUT_DIR}/index.txt" \
#      --bvecs="${OUTPUT_DIR}/${SUBJECT}_all.bvec" \
#      --bvals="${OUTPUT_DIR}/${SUBJECT}_all.bval" \
#      --topup="${OUTPUT_DIR}/${SUBJECT}_topup_results" \
#      --out="${OUTPUT_DIR}/${SUBJECT}_eddy_corrected" \
#      --slm=linear \
#      --repol \
#      --data_is_shelled \
#      --verbose # gotta see what's going on

echo "EDDY done"

##########################################################################
# STEP 11: bias field correction (N4)
##########################################################################

echo "STEP 11: bias field correction"

# convert to MIF for dwibiascorrect
mrconvert "${OUTPUT_DIR}/${SUBJECT}_eddy_corrected.nii.gz" \
          "${OUTPUT_DIR}/${SUBJECT}_eddy_corrected.mif" \
          -fslgrad "${OUTPUT_DIR}/${SUBJECT}_eddy_corrected.eddy_rotated_bvecs" \
                   "${OUTPUT_DIR}/${SUBJECT}_all.bval"

# run bias correction
dwibiascorrect ants "${OUTPUT_DIR}/${SUBJECT}_eddy_corrected.mif" \
                    "${OUTPUT_DIR}/${SUBJECT}_preprocessed.mif" \
                    -mask "${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz"

# convert back to NIfTI
mrconvert "${OUTPUT_DIR}/${SUBJECT}_preprocessed.mif" \
          "${OUTPUT_DIR}/${SUBJECT}_preprocessed.nii.gz" \
          -export_grad_fsl "${OUTPUT_DIR}/${SUBJECT}_preprocessed.bvec" \
                          "${OUTPUT_DIR}/${SUBJECT}_preprocessed.bval"

echo "bias correction done"

##########################################################################
# STEP 12: dtifit
##########################################################################

echo "STEP 12: dtifit"

dtifit --data="${OUTPUT_DIR}/${SUBJECT}_preprocessed.nii.gz" \
       --out="${OUTPUT_DIR}/${SUBJECT}_dti" \
       --mask="${OUTPUT_DIR}/${SUBJECT}_hifi_b0_brain_mask.nii.gz" \
       --bvecs="${OUTPUT_DIR}/${SUBJECT}_preprocessed.bvec" \
       --bvals="${OUTPUT_DIR}/${SUBJECT}_preprocessed.bval" \
       --sse \
       --save_tensor

echo "dtifit done"

##########################################################################
# all complete
##########################################################################

echo ""
echo "pipeline finished for ${SUBJECT}"


