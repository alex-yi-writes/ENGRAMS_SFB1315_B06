#!/bin/bash

export FSLDIR=/usr/local/fsl
export PATH=$PATH:/usr/local/fsl/bin
export OMP_NUM_THREADS=1 # keep having memory problems
export FSLMULTIFILEQUIT=TRUE
source $FSLDIR/etc/fslconf/fsl.sh

# ids
SUBJECTS=("sub-207" "sub-302" "sub-303" "sub-304")

# subject loop starts

for SUBJECT in "${SUBJECTS[@]}"; do
      echo "=============================="
      echo "processing $SUBJECT"
      echo "=============================="

      ##########################################################################
      #                  TOPUP-based correction for ORIGREC2                   #
      ##########################################################################

      # paths
      DATA_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v2s1/func"
      OUTPUT_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v2s1/func"

      ####### ===== STEP 1: extract single-volume references (AP & PA) ===== #######
      echo "extracting single-volume BOLD references"
      fslroi "$DATA_DIR/${SUBJECT}v2s1_task-origrec2_run-05_bold.nii.gz" "$OUTPUT_DIR/${SUBJECT}v2s1_origrec2_AP_b0.nii.gz" 0 1
      fslroi "$DATA_DIR/${SUBJECT}v2s1_run-01_antiPE_bold.nii.gz" "$OUTPUT_DIR/${SUBJECT}v2s1_PA_b0.nii.gz" 0 1

      for f in  "${SUBJECT}v2s1_origrec2_AP_b0.nii.gz" "${SUBJECT}v2s1_PA_b0.nii.gz"; do
          fslreorient2std "$OUTPUT_DIR/$f" "${OUTPUT_DIR}/${f%.nii.gz}_std.nii.gz"
          mv "${OUTPUT_DIR}/${f%.nii.gz}_std.nii.gz" "$OUTPUT_DIR/$f"
      done
      fslcpgeom "$OUTPUT_DIR/${SUBJECT}v2s1_origrec2_AP_b0.nii.gz" \
                "$OUTPUT_DIR/${SUBJECT}v2s1_PA_b0.nii.gz"  -overwrite

      ####### ===== STEP 2: merge references ===== #######
      echo "merging references"
      fslmerge -t "$OUTPUT_DIR/${SUBJECT}v2s1_origrec2_b0_AP_PA.nii.gz" \
               "$OUTPUT_DIR/${SUBJECT}v2s1_origrec2_AP_b0.nii.gz" \
               "$OUTPUT_DIR/${SUBJECT}v2s1_PA_b0.nii.gz"

      ####### ===== STEP 3: create acqparams.txt ===== #######
      # FSL tutorial: The first three elements of each line comprise a vector that specifies the direction of the phase encoding. The non-zero number in the second column means that is along the y-direction. A -1 means that k-space was traversed Anterior→Posterior and a 1 that it was traversed Posterior→Anterior. The final column specifies the "total readout time", which is the time (in seconds) between the collection of the centre of the first echo and the centre of the last echo. In the FAQ section of the online help for topup there are instructions for how to find this information for Siemens scanners.

echo "creating acquisition parameters file"
cat <<EOT > "$OUTPUT_DIR/acqparams.txt"
0 -1 0  0.055253
0 1 0  0.055253
EOT

      ####### ===== STEP 4: run TOPUP ===== #######
      echo "running TOPUP"
      topup --imain="$OUTPUT_DIR/${SUBJECT}v2s1_origrec2_b0_AP_PA.nii.gz" \
            --datain="$OUTPUT_DIR/acqparams.txt" \
            --config=b02b0.cnf \
            --out="$OUTPUT_DIR/${SUBJECT}v2s1_origrec2_topup_results" \
            --fout="$OUTPUT_DIR/${SUBJECT}v2s1_origrec2_fieldmap_Hz.nii.gz" \
            --iout="$OUTPUT_DIR/${SUBJECT}v2s1_origrec2_unwarped_b0.nii.gz"
      echo "TOPUP done"

      ####### ===== STEP 5: apply correction to full BOLD runs ===== #######
      echo "applying TOPUP to full timeseries"
      applytopup --imain="$DATA_DIR/${SUBJECT}v2s1_task-origrec2_run-05_bold.nii.gz" \
                 --datain="$OUTPUT_DIR/acqparams.txt" \
                 --inindex=1 \
                 --topup="$OUTPUT_DIR/${SUBJECT}v2s1_origrec2_topup_results" \
                 --method=jac \
                 --out="$OUTPUT_DIR/${SUBJECT}v2s1_task-origrec2_run-05_bold_topup"

      echo "2nd phase original recognition processing done"



      # ##########################################################################
      # #         TOPUP-based susceptibility correction for RECOMBIENC           #
      # ##########################################################################

      # # paths
      # DATA_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v2s1/func"
      # OUTPUT_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v2s1/func"

      # ####### ===== STEP 1: extract single-volume references (AP & PA) ===== #######
      # echo "extracting single-volume BOLD references"
      # fslroi "$DATA_DIR/${SUBJECT}v2s1_task-recombienc_run-03_bold.nii" "$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_AP_b0.nii.gz" 0 1

      # ####### ===== STEP 2: merge references ===== #######
      # echo "merging references"
      # fslmerge -t "$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_b0_AP_PA.nii.gz" \
      #          "$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_AP_b0.nii.gz" \
      #          "$OUTPUT_DIR/${SUBJECT}v2s1_PA_b0.nii.gz"

      # ####### ===== STEP 4: run TOPUP ===== #######
      # echo "running TOPUP"
      # topup --imain="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_b0_AP_PA.nii.gz" \
      #       --datain="$OUTPUT_DIR/acqparams.txt" \
      #       --config=b02b0.cnf \
      #       --out="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_topup_results" \
      #       --fout="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_fieldmap_Hz.nii.gz" \
      #       --iout="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_unwarped_b0.nii.gz"
      # echo "TOPUP done"

      # ####### ===== STEP 5: apply correction to full BOLD runs ===== #######
      # echo "applying TOPUP to full timeseries"
      # applytopup --imain="$DATA_DIR/${SUBJECT}v2s1_task-recombienc_run-03_bold.nii" \
      #            --datain="$OUTPUT_DIR/acqparams.txt" \
      #            --inindex=1 \
      #            --topup="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_topup_results" \
      #            --method=jac \
      #            --out="$OUTPUT_DIR/${SUBJECT}v2s1_task-recombienc_run-03_bold_topup"

      # # try another method some other time
      #            # --method=jac \ # this one's too memory heavy


      # echo "encoding (recombination) done"



      ##########################################################################
      #         TOPUP-based susceptibility correction for RECOMBIREC           #
      ##########################################################################

      # paths
      DATA_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v2s1/func"
      OUTPUT_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v2s1/func"

      ####### ===== STEP 1: extract single-volume references (AP & PA) ===== #######
      echo "extracting single-volume BOLD references"
      fslroi "$DATA_DIR/${SUBJECT}v2s1_task-recombirec_run-04_bold.nii" "$OUTPUT_DIR/${SUBJECT}v2s1_recombirec_AP_b0.nii.gz" 0 1

      ####### ===== STEP 2: merge references ===== #######
      echo "merging references"
      fslmerge -t "$OUTPUT_DIR/${SUBJECT}v2s1_recombirec_b0_AP_PA.nii.gz" \
               "$OUTPUT_DIR/${SUBJECT}v2s1_recombirec_AP_b0.nii.gz" \
               "$OUTPUT_DIR/${SUBJECT}v2s1_PA_b0.nii.gz"

      # ####### ===== STEP 4: run TOPUP ===== #######
      echo "running TOPUP"
      topup --imain="$OUTPUT_DIR/${SUBJECT}v2s1_recombirec_b0_AP_PA.nii.gz" \
            --datain="$OUTPUT_DIR/acqparams.txt" \
            --config=b02b0.cnf \
            --out="$OUTPUT_DIR/${SUBJECT}v2s1_recombirec_topup_results" \
            --fout="$OUTPUT_DIR/${SUBJECT}v2s1_recombirec_fieldmap_Hz.nii.gz" \
            --iout="$OUTPUT_DIR/${SUBJECT}v2s1_recombirec_unwarped_b0.nii.gz"
      echo "TOPUP done"

      ####### ===== STEP 5: apply correction to full BOLD runs ===== #######
      echo "applying TOPUP to full timeseries"
      applytopup --imain="$DATA_DIR/${SUBJECT}v2s1_task-recombirec_run-04_bold.nii" \
                 --datain="$OUTPUT_DIR/acqparams.txt" \
                 --inindex=1 \
                 --topup="$OUTPUT_DIR/${SUBJECT}v2s1_recombirec_topup_results" \
                 --method=jac \
                 --out="$OUTPUT_DIR/${SUBJECT}v2s1_task-recombirec1_run-04_bold_topup"

      echo "recognition (recombination) done"

done
