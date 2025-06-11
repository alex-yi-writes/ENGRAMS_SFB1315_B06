#!/bin/bash

export FSLDIR=/usr/local/fsl
export PATH=$PATH:/usr/local/fsl/bin
source $FSLDIR/etc/fslconf/fsl.sh

# subject
SUBJECT="sub-205"   # TODO: update list
echo "$SUBJECT"

##########################################################################
#                    TOPUP-based correction for REST                     #
##########################################################################

# paths
DATA_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v1s1/func"
OUTPUT_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v1s1/func"

####### ===== STEP 1: extract single-volume references (AP & PA) ===== #######
echo "extracting single-volume BOLD references"
fslroi "$DATA_DIR/${SUBJECT}v1s1_task-rest_run-01_bold.nii.gz" "$OUTPUT_DIR/${SUBJECT}v1s1_rest_AP_b0.nii.gz" 0 1
fslroi "$DATA_DIR/${SUBJECT}v1s1_run-01_antiPE_bold.nii.gz" "$OUTPUT_DIR/${SUBJECT}v1s1_PA_b0.nii.gz" 0 1

for f in  "${SUBJECT}v1s1_rest_AP_b0.nii.gz" "${SUBJECT}v1s1_PA_b0.nii.gz"; do
    fslreorient2std "$OUTPUT_DIR/$f" "${OUTPUT_DIR}/${f%.nii.gz}_std.nii.gz"
    mv "${OUTPUT_DIR}/${f%.nii.gz}_std.nii.gz" "$OUTPUT_DIR/$f"
done
fslcpgeom "$OUTPUT_DIR/${SUBJECT}v1s1_rest_AP_b0.nii.gz" \
          "$OUTPUT_DIR/${SUBJECT}v1s1_PA_b0.nii.gz"  -overwrite

####### ===== STEP 2: merge references ===== #######
echo "merging references"
fslmerge -t "$OUTPUT_DIR/${SUBJECT}v1s1_rest_b0_AP_PA.nii.gz" \
         "$OUTPUT_DIR/${SUBJECT}v1s1_rest_AP_b0.nii.gz" \
         "$OUTPUT_DIR/${SUBJECT}v1s1_PA_b0.nii.gz"

####### ===== STEP 3: create acqparams.txt ===== #######
# FSL tutorial: The first three elements of each line comprise a vector that specifies the direction of the phase encoding. The non-zero number in the second column means that is along the y-direction. A -1 means that k-space was traversed Anterior→Posterior and a 1 that it was traversed Posterior→Anterior. The final column specifies the "total readout time", which is the time (in seconds) between the collection of the centre of the first echo and the centre of the last echo. In the FAQ section of the online help for topup there are instructions for how to find this information for Siemens scanners.

echo "creating acquisition parameters file"
cat <<EOT > "$OUTPUT_DIR/acqparams.txt"
0 -1 0  0.055253
0 1 0  0.055253
EOT

####### ===== STEP 4: run TOPUP ===== #######
echo "running TOPUP"
topup --imain="$OUTPUT_DIR/${SUBJECT}v1s1_rest_b0_AP_PA.nii.gz" \
      --datain="$OUTPUT_DIR/acqparams.txt" \
      --config=b02b0.cnf \
      --out="$OUTPUT_DIR/${SUBJECT}v1s1_rest_topup_results" \
      --fout="$OUTPUT_DIR/${SUBJECT}v1s1_rest_fieldmap_Hz.nii.gz" \
      --iout="$OUTPUT_DIR/${SUBJECT}v1s1_rest_unwarped_b0.nii.gz"
echo "TOPUP done"

####### ===== STEP 5: apply correction to full BOLD runs ===== #######
echo "applying TOPUP to full timeseries"
applytopup --imain="$DATA_DIR/${SUBJECT}v1s1_task-rest_run-01_bold.nii.gz" \
           --datain="$OUTPUT_DIR/acqparams.txt" \
           --inindex=1 \
           --topup="$OUTPUT_DIR/${SUBJECT}v1s1_rest_topup_results" \
           --method=jac \
           --out="$OUTPUT_DIR/${SUBJECT}v1s1_task-rest_run-01_bold_topup"

echo "resting state processing done"



##########################################################################
#          TOPUP-based susceptibility correction for ORIGENC             #
##########################################################################

# paths
DATA_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v1s1/func"
OUTPUT_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v1s1/func"

####### ===== STEP 1: extract single-volume references (AP & PA) ===== #######
echo "extracting single-volume BOLD references"
fslroi "$DATA_DIR/${SUBJECT}v1s1_task-origenc_run-03_bold.nii.gz" "$OUTPUT_DIR/${SUBJECT}v1s1_origenc_AP_b0.nii.gz" 0 1

####### ===== STEP 2: merge references ===== #######
echo "merging references"
fslmerge -t "$OUTPUT_DIR/${SUBJECT}v1s1_origenc_b0_AP_PA.nii.gz" \
         "$OUTPUT_DIR/${SUBJECT}v1s1_origenc_AP_b0.nii.gz" \
         "$OUTPUT_DIR/${SUBJECT}v1s1_PA_b0.nii.gz"

####### ===== STEP 4: run TOPUP ===== #######
echo "running TOPUP"
topup --imain="$OUTPUT_DIR/${SUBJECT}v1s1_origenc_b0_AP_PA.nii.gz" \
      --datain="$OUTPUT_DIR/acqparams.txt" \
      --config=b02b0.cnf \
      --out="$OUTPUT_DIR/${SUBJECT}v1s1_origenc_topup_results" \
      --fout="$OUTPUT_DIR/${SUBJECT}v1s1_origenc_fieldmap_Hz.nii.gz" \
      --iout="$OUTPUT_DIR/${SUBJECT}v1s1_origenc_unwarped_b0.nii.gz"
echo "TOPUP done"

####### ===== STEP 5: apply correction to full BOLD runs ===== #######
echo "applying TOPUP to full timeseries"
applytopup --imain="$DATA_DIR/${SUBJECT}v1s1_task-origenc_run-03_bold.nii.gz" \
           --datain="$OUTPUT_DIR/acqparams.txt" \
           --inindex=2 \
           --topup="$OUTPUT_DIR/${SUBJECT}v1s1_origenc_topup_results" \
           --method=jac \
           --out="$OUTPUT_DIR/${SUBJECT}v1s1_task-origenc_run-03_bold_topup"

echo "encoding (original) done"



##########################################################################
#          TOPUP-based susceptibility correction for ORIGREC             #
##########################################################################

# paths
DATA_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v1s1/func"
OUTPUT_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v1s1/func"

####### ===== STEP 1: extract single-volume references (AP & PA) ===== #######
echo "extracting single-volume BOLD references"
fslroi "$DATA_DIR/${SUBJECT}v1s1_task-origrec_run-03_bold.nii.gz" "$OUTPUT_DIR/${SUBJECT}v1s1_origrec_AP_b0.nii.gz" 0 1

####### ===== STEP 2: merge references ===== #######
echo "merging references"
fslmerge -t "$OUTPUT_DIR/${SUBJECT}v1s1_origrec_b0_AP_PA.nii.gz" \
         "$OUTPUT_DIR/${SUBJECT}v1s1_origrec_AP_b0.nii.gz" \
         "$OUTPUT_DIR/${SUBJECT}v1s1_PA_b0.nii.gz"

####### ===== STEP 4: run TOPUP ===== #######
echo "running TOPUP"
topup --imain="$OUTPUT_DIR/${SUBJECT}v1s1_origrec_b0_AP_PA.nii.gz" \
      --datain="$OUTPUT_DIR/acqparams.txt" \
      --config=b02b0.cnf \
      --out="$OUTPUT_DIR/${SUBJECT}v1s1_origrec_topup_results" \
      --fout="$OUTPUT_DIR/${SUBJECT}v1s1_origrec_fieldmap_Hz.nii.gz" \
      --iout="$OUTPUT_DIR/${SUBJECT}v1s1_origrec_unwarped_b0.nii.gz"
echo "TOPUP done"

####### ===== STEP 5: apply correction to full BOLD runs ===== #######
echo "applying TOPUP to full timeseries"
applytopup --imain="$DATA_DIR/${SUBJECT}v1s1_task-origrec_run-03_bold.nii.gz" \
           --datain="$OUTPUT_DIR/acqparams.txt" \
           --inindex=2 \
           --topup="$OUTPUT_DIR/${SUBJECT}v1s1_origrec_topup_results" \
           --method=jac \
           --out="$OUTPUT_DIR/${SUBJECT}v1s1_task-origrec1_run-03_bold_topup"

echo "recognition (original) done"
