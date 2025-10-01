#!/bin/bash

export FSLDIR=/usr/local/fsl
export PATH=$PATH:/usr/local/fsl/bin
export OMP_NUM_THREADS=1 # keep having memory problems
export FSLMULTIFILEQUIT=TRUE
source $FSLDIR/etc/fslconf/fsl.sh

# ids
SUBJECTS=("sub-302" "sub-303" "sub-304")

# subject loop starts

for SUBJECT in "${SUBJECTS[@]}"; do
    echo "=============================="
    echo "processing $SUBJECT"
    echo "=============================="

    ##########################################################################
    #          TOPUP-based susceptibility correction for ORIGENC             #
    ##########################################################################

    # paths
    DATA_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v1s1/func"
    OUTPUT_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v1s1/func"
    OUT_BASE="$OUTPUT_DIR/${SUBJECT}v1s1_task-origenc_run-03_bold_topup"
    TMPDIR="$OUTPUT_DIR/temp_chunking"

    mkdir -p "$TMPDIR"

    ####### ===== STEP 0: chunk the fMRI so that my machine can handle the series

    # total number of volumes
    nvols=$(fslval "$DATA_DIR/${SUBJECT}v1s1_task-origenc_run-03_bold.nii" dim4)
    halfvols=$((nvols / 2))
    remainvols=$((nvols - halfvols))  # odd number up

    # check how many vols in each chunk
    echo "total vols: $nvols"
    echo "chunk 1: $halfvols vols"
    echo "chunk 2: $remainvols vols"

    # split into two chunks
    fslroi "$DATA_DIR/${SUBJECT}v1s1_task-origenc_run-03_bold.nii" "$TMPDIR/chunk1.nii.gz" 0 $halfvols
    fslroi "$DATA_DIR/${SUBJECT}v1s1_task-origenc_run-03_bold.nii" "$TMPDIR/chunk2.nii.gz" $halfvols $remainvols


    ####### ===== STEP 1: extract single-volume references (AP & PA) ===== #######
    echo "extracting single-volume BOLD references"
    fslroi "$DATA_DIR/${SUBJECT}v1s1_task-origenc_run-03_bold.nii" "$OUTPUT_DIR/${SUBJECT}v1s1_origenc_AP_b0.nii.gz" 0 1

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
    echo "applying TOPUP to full timeseries: chunk 1"
    applytopup --imain="$TMPDIR/chunk1.nii" \
               --datain="$OUTPUT_DIR/acqparams.txt" \
               --inindex=1 \
               --topup="$OUTPUT_DIR/${SUBJECT}v1s1_origenc_topup_results" \
               --method=jac \
               --out="$TMPDIR/chunk1_topup"

    applytopup --imain="$TMPDIR/chunk2.nii" \
               --datain="$OUTPUT_DIR/acqparams.txt" \
               --inindex=1 \
               --topup="$OUTPUT_DIR/${SUBJECT}v1s1_origenc_topup_results" \
               --method=jac \
               --out="$TMPDIR/chunk2_topup"

    # merge output
    fslmerge -t "$OUTPUT_DIR/${SUBJECT}v1s1_task-origenc_run-03_bold_topup.nii.gz" "$TMPDIR/chunk1_topup.nii.gz" "$TMPDIR/chunk2_topup.nii.gz"
    rm -rf "$TMPDIR"

    echo "encoding (original) done"

    ##########################################################################
    #         TOPUP-based susceptibility correction for RECOMBIENC           #
    ##########################################################################

    # paths
    DATA_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v2s1/func"
    OUTPUT_DIR="/Users/yyi/Desktop/ENGRAMS/preproc/${SUBJECT}v2s1/func"
    OUT_BASE="$OUTPUT_DIR/${SUBJECT}v2s1_task-recombienc_run-03_bold_topup"
    TMPDIR="$OUTPUT_DIR/temp_chunking"

    mkdir -p "$TMPDIR"

    ####### ===== STEP 0: chunk the fMRI so that my machine can handle the series

    # total number of volumes
    nvols=$(fslval "$DATA_DIR/${SUBJECT}v2s1_task-recombienc_run-03_bold.nii" dim4)
    halfvols=$((nvols / 2))
    remainvols=$((nvols - halfvols))  # odd number up

    # check how many vols in each chunk
    echo "total vols: $nvols"
    echo "chunk 1: $halfvols vols"
    echo "chunk 2: $remainvols vols"

    # split into two chunks
    fslroi "$DATA_DIR/${SUBJECT}v2s1_task-recombienc_run-03_bold.nii" "$TMPDIR/chunk1.nii.gz" 0 $halfvols
    fslroi "$DATA_DIR/${SUBJECT}v2s1_task-recombienc_run-03_bold.nii" "$TMPDIR/chunk2.nii.gz" $halfvols $remainvols


    ####### ===== STEP 1: extract single-volume references (AP & PA) ===== #######
    echo "extracting single-volume BOLD references"
    fslroi "$DATA_DIR/${SUBJECT}v2s1_task-recombienc_run-03_bold.nii" "$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_AP_b0.nii.gz" 0 1

    ####### ===== STEP 2: merge references ===== #######
    echo "merging references"
    fslmerge -t "$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_b0_AP_PA.nii.gz" \
             "$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_AP_b0.nii.gz" \
             "$OUTPUT_DIR/${SUBJECT}v2s1_PA_b0.nii.gz"

    ####### ===== STEP 4: run TOPUP ===== #######
    echo "running TOPUP"
    topup --imain="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_b0_AP_PA.nii.gz" \
          --datain="$OUTPUT_DIR/acqparams.txt" \
          --config=b02b0.cnf \
          --out="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_topup_results" \
          --fout="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_fieldmap_Hz.nii.gz" \
          --iout="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_unwarped_b0.nii.gz"

    echo "TOPUP done"

    ####### ===== STEP 5: apply correction to full BOLD runs ===== #######
    echo "applying TOPUP to full timeseries: chunk 1"
    applytopup --imain="$TMPDIR/chunk1.nii" \
               --datain="$OUTPUT_DIR/acqparams.txt" \
               --inindex=1 \
               --topup="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_topup_results" \
               --method=jac \
               --out="$TMPDIR/chunk1_topup"

    applytopup --imain="$TMPDIR/chunk2.nii" \
               --datain="$OUTPUT_DIR/acqparams.txt" \
               --inindex=1 \
               --topup="$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_topup_results" \
               --method=jac \
               --out="$TMPDIR/chunk2_topup"

    # merge output
    fslmerge -t "$OUTPUT_DIR/${SUBJECT}v2s1_recombienc_run-03_bold_topup.nii.gz" "$TMPDIR/chunk1_topup.nii.gz" "$TMPDIR/chunk2_topup.nii.gz"
    rm -rf "$TMPDIR"

    echo "encoding (recombination) done"

done
