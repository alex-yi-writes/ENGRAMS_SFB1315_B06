#!/bin/bash


for ID in sub-310 #sub-104 sub-109 sub-110 sub-207 sub-301 sub-302 sub-303 sub-304 sub-306 # still need to do sub-111 sub-202 
do

    # prep
    path_anat=/Users/yyi/Desktop/ENGRAMS/derivatives/analyses/${ID}v1s1/anat
    path_bsl=/Users/yyi/Desktop/ENGRAMS/derivatives/analyses/${ID}v1s1/dwi
    path_origE=/Users/yyi/Desktop/ENGRAMS/derivatives/analyses/${ID}v1s2/dwi
    path_origL=/Users/yyi/Desktop/ENGRAMS/derivatives/analyses/${ID}v2s1/dwi
    path_recombi=/Users/yyi/Desktop/ENGRAMS/derivatives/analyses/${ID}v2s2/dwi
    path_trx=/Users/yyi/Desktop/ENGRAMS/derivatives/analyses/${ID}v1s1/transx
    path_roi=/Users/yyi/Desktop/ENGRAMS/derivatives/analyses/${ID}v1s1/anat/roi_dwi

    t1w=${path_anat}/t1/m${ID}v1s1_run-01_T1w_0pt35_stripped.nii.gz
    t2w=${path_anat}/hpc/${ID}v1s1_T2w.nii.gz
    dwi_bsl=${path_bsl}/${ID}v1s1_hifi_b0_brain.nii.gz
    dwi_origE=${path_origE}/${ID}v1s2_hifi_b0_brain.nii.gz
    dwi_origL=${path_origL}/${ID}v2s1_hifi_b0_brain.nii.gz
    dwi_recombi=${path_recombi}/${ID}v2s2_hifi_b0_brain.nii.gz
    WBseg=${path_anat}/t1/aparc+aseg_nat.nii.gz
    ASHSseg=$(find "${path_anat}/hpc" -type f -iname 'layer_002*' -print -quit) # which seg?

    mkdir -p ${path_roi}
    mkdir -p ${path_roi}/bsl
    mkdir -p ${path_roi}/origE
    mkdir -p ${path_roi}/origL
    mkdir -p ${path_roi}/recombi
    if [ ! -d "${path_trx}" ]; then
        mkdir -p ${path_trx}
    fi

    cd $path_trx

    # ======== make transformations for moving the whole-brain segmentations ======== #

    # first, t1->bsl
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -m ${t1w} -f ${dwi_bsl} -o ${path_trx}/t1w2bsldwi_ > t1w2bsldwi_logfile.txt 2>&1
    antsRegistrationSyN.sh -d 3 -n 10 -t r -f ${t1w} -m ${dwi_bsl} -o ${path_trx}/bsldwi2t1w_ > bsldwi2t1w_logfile.txt 2>&1

    # # t1->original early
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -m ${t1w} -f ${dwi_origE} -o ${path_trx}/t1w2origEdwi_ > t1w2origEdwi_logfile.txt 2>&1
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -f ${t1w} -m ${dwi_origE} -o ${path_trx}/origEdwi2t1w_ > origEdwi2t1w_logfile.txt 2>&1

    # # t1->original late
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -m ${t1w} -f ${dwi_origL} -o ${path_trx}/t1w2origLdwi_ > t1w2origLdwi_logfile.txt 2>&1
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -f ${t1w} -m ${dwi_origL} -o ${path_trx}/origLdwi2t1w_ > origLdwi2t1w_logfile.txt 2>&1

    # # t1->recombination
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -m ${t1w} -f ${dwi_recombi} -o ${path_trx}/t1w2recombidwi_ > t1w2recombidwi_logfile.txt 2>&1
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -f ${t1w} -m ${dwi_recombi} -o ${path_trx}/recombidwi2t1w_ > recombidwi2t1w_logfile.txt 2>&1

    # ======== make transformations for moving the ASHS segmentations ======== #

    # first, t2->bsl
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -m ${t2w} -f ${dwi_bsl} -o ${path_trx}/t2w2bsldwi_ > t2w2bsldwi_logfile.txt 2>&1
    antsRegistrationSyN.sh -d 3 -n 10 -t r -f ${t2w} -m ${dwi_bsl} -o ${path_trx}/bsldwi2t2w_ > bsldwi2t2w_logfile.txt 2>&1

    # # t2->original early
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -m ${t2w} -f ${dwi_origE} -o ${path_trx}/t2w2origEdwi_ > t2w2origEdwi_logfile.txt 2>&1
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -f ${t2w} -m ${dwi_origE} -o ${path_trx}/origEdwi2t2w_ > origEdwi2t2w_logfile.txt 2>&1

    # # t2->original late
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -m ${t2w} -f ${dwi_origL} -o ${path_trx}/t2w2origLdwi_ > t2w2origLdwi_logfile.txt 2>&1
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -f ${t2w} -m ${dwi_origL} -o ${path_trx}/origLdwi2t2w_ > origLdwi2t2w_logfile.txt 2>&1

    # # t2->recombination
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -m ${t2w} -f ${dwi_recombi} -o ${path_trx}/t2w2recombidwi_ > t2w2recombidwi_logfile.txt 2>&1
    # antsRegistrationSyN.sh -d 3 -n 10 -t r -f ${t2w} -m ${dwi_recombi} -o ${path_trx}/recombidwi2t2w_ > recombidwi2t2w_logfile.txt 2>&1



    # ======== move segs ======== #
    # first, t1->bsl
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_bsl} -o ${path_roi}/aparc_on_bsl.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2bsldwi_0GenericAffine.txt
    antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_bsl} -o ${path_roi}/aparc_on_bsl.nii.gz -n NearestNeighbor -t [${path_trx}/bsldwi2t1w_0GenericAffine.mat,1]

    # # t1->original early
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origE} -o ${path_roi}/aparc_on_origE.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2origEdwi_0GenericAffine.mat
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origE} -o ${path_roi}/aparc_on_origE.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2origEdwi_0GenericAffine.txt
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origE} -o ${path_roi}/aparc_on_origE.nii.gz -n NearestNeighbor -t [${path_trx}/origEdwi2t1w_0GenericAffine.mat,1]

    # # t1->original late
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origL} -o ${path_roi}/aparc_on_origL.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2origLdwi_0GenericAffine.mat
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origL} -o ${path_roi}/aparc_on_origL.nii.gz -n NearestNeighbor -t [${path_trx}/origLdwi2t1w_0GenericAffine.mat,1]
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origL} -o ${path_roi}/aparc_on_origL.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2origLdwi_0GenericAffine.txt

    # # t1->recombination
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_recombi} -o ${path_roi}/aparc_on_recombi.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2recombidwi_0GenericAffine.mat
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_recombi} -o ${path_roi}/aparc_on_recombi.nii.gz -n NearestNeighbor -t [${path_trx}/recombidwi2t1w_0GenericAffine.mat,1]
    # antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_recombi} -o ${path_roi}/aparc_on_recombi.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2recombidwi_0GenericAffine.txt



    # first, t2->bsl
    # antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_bsl} -o ${path_roi}/hpc_on_bsl.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2bsldwi_0GenericAffine.txt
    antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_bsl} -o ${path_roi}/hpc_on_bsl.nii.gz -n NearestNeighbor -t [${path_trx}/bsldwi2t2w_0GenericAffine.mat,1]

    # # t2->original early
    # antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origE} -o ${path_roi}/hpc_on_origE.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2origEdwi_0GenericAffine.mat
    # antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origE} -o ${path_roi}/hpc_on_origE.nii.gz -n NearestNeighbor -t [${path_trx}/origEdwi2t2w_0GenericAffine.mat,1]
    # antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origE} -o ${path_roi}/hpc_on_origE.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2origEdwi_0GenericAffine.txt

    # # t2->original late
    # antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origL} -o ${path_roi}/hpc_on_origL.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2origLdwi_0GenericAffine.mat
    # antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origL} -o ${path_roi}/hpc_on_origL.nii.gz -n NearestNeighbor -t [${path_trx}/origLdwi2t2w_0GenericAffine.mat,1]
    # antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origL} -o ${path_roi}/hpc_on_origL.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2origLdwi_0GenericAffine.txt

    # t2->recombination
    # antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_recombi} -o ${path_roi}/hpc_on_recombi.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2recombidwi_0GenericAffine.txt
    # antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_recombi} -o ${path_roi}/hpc_on_recombi.nii.gz -n NearestNeighbor -t [${path_trx}/recombidwi2t2w_0GenericAffine.mat,1]



    # ======== extract segs ======== #
    /Users/yyi/Desktop/ENGRAMS/codes/final_workflow/laminar/Z-1_ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_bsl.nii.gz ${path_roi}/bsl
    # /Users/yyi/Desktop/ENGRAMS/codes/final_workflow/laminar/Z-1_ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_origE.nii.gz ${path_roi}/origE
    # /Users/yyi/Desktop/ENGRAMS/codes/final_workflow/laminar/Z-1_ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_origL.nii.gz ${path_roi}/origL
    # /Users/yyi/Desktop/ENGRAMS/codes/final_workflow/laminar/Z-1_ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_recombi.nii.gz ${path_roi}/recombi

done