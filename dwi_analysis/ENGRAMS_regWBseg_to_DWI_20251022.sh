#!/bin/bash


for ID in sub-302
do

	# prep
	path_anat=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/anat
	path_bsl=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/dwi
	path_origE=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s2/dwi
	path_origL=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v2s1/dwi
	path_recombi=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v2s2/dwi
	path_trx=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/anat/transx
	path_roi=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/anat/roi_dwi

	t1w=${path_anat}/t1/m${ID}v1s1_run-01_T1w_0pt35.nii.gz
	t2w=${path_anat}/hpc/${ID}v1s1_T2w.nii.gz
	dwi_bsl=${path_bsl}/${ID}v1s1_hifi_b0_brain.nii.gz
	dwi_origE=${path_origE}/${ID}v1s2_hifi_b0_brain.nii.gz
	dwi_origL=${path_origL}/${ID}v2s1_hifi_b0_brain.nii.gz
	dwi_recombi=${path_recombi}/${ID}v2s2_hifi_b0_brain.nii.gz
	WBseg=${path_anat}/t1/aparc+aseg_nat.nii.gz
	ASHSseg=$(find "${path_anat}/hpc" -type f -iname 'layer_002*' -print -quit) # which seg?

	mkdir ${path_roi}
	mkdir ${path_roi}/bsl
	mkdir ${path_roi}/origE
	mkdir ${path_roi}/origL
	mkdir ${path_roi}/recombi

	# # ======== make transformations for moving the whole-brain segmentations ======== #

	# # first, t1->bsl
	# antsRegistrationSyN.sh -d 3 -n 1 -t r -m ${t1w} -f ${dwi_bsl} -o ${path_trx}/t1w2bsldwi_
	# # t1->original early
	antsRegistrationSyN.sh -d 3 -n 1 -t r -m ${t1w} -f ${dwi_origE} -o ${path_trx}/t1w2origEdwi_
	# # t1->original late
	# antsRegistrationSyN.sh -d 3 -n 1 -t r -m ${t1w} -f ${dwi_origL} -o ${path_trx}/t1w2origLdwi_
	# # t1->recombination
	antsRegistrationSyN.sh -d 3 -n 1 -t r -m ${t1w} -f ${dwi_recombi} -o ${path_trx}/t1w2recombidwi_

	# # ======== make transformations for moving the ASHS segmentations ======== #

	# # first, t2->bsl
	# antsRegistrationSyN.sh -d 3 -n 1 -t r -m ${t2w} -f ${dwi_bsl} -o ${path_trx}/t2w2bsldwi_
	# # t2->original early
	antsRegistrationSyN.sh -d 3 -n 1 -t r -m ${t2w} -f ${dwi_origE} -o ${path_trx}/t2w2origEdwi_
	# # t2->original late
	# antsRegistrationSyN.sh -d 3 -n 1 -t r -m ${t2w} -f ${dwi_origL} -o ${path_trx}/t2w2origLdwi_
	# # t2->recombination
	antsRegistrationSyN.sh -d 3 -n 1 -t r -m ${t2w} -f ${dwi_recombi} -o ${path_trx}/t2w2recombidwi_

	# ======== move segs ======== #
	# first, t1->bsl
	antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_bsl} -o ${path_roi}/aparc_on_bsl.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2bsldwi_0GenericAffine.mat
	# antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_bsl} -o ${path_roi}/aparc_on_bsl.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2bsldwi_0GenericAffine.txt
	# t1->original early
	antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origE} -o ${path_roi}/aparc_on_origE.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2origEdwi_0GenericAffine.mat
	# antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origE} -o ${path_roi}/aparc_on_origE.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2origEdwi_0GenericAffine.txt
	# t1->original late
	antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origL} -o ${path_roi}/aparc_on_origL.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2origLdwi_0GenericAffine.mat
	# antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_origL} -o ${path_roi}/aparc_on_origL.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2origLdwi_0GenericAffine.txt
	# t1->recombination
	antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_recombi} -o ${path_roi}/aparc_on_recombi.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2recombidwi_0GenericAffine.mat
	# antsApplyTransforms -d 3 -v 0 -i ${WBseg} -r ${dwi_recombi} -o ${path_roi}/aparc_on_recombi.nii.gz -n NearestNeighbor -t ${path_trx}/t1w2recombidwi_0GenericAffine.txt

	# first, t2->bsl
	antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_bsl} -o ${path_roi}/hpc_on_bsl.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2bsldwi_0GenericAffine.mat
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_bsl} -o ${path_roi}/hpc_on_bsl.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2bsldwi_0GenericAffine.txt
	# t2->original early
	antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origE} -o ${path_roi}/hpc_on_origE.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2origEdwi_0GenericAffine.mat
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origE} -o ${path_roi}/hpc_on_origE.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2origEdwi_0GenericAffine.txt
	# t2->original late
	antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origL} -o ${path_roi}/hpc_on_origL.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2origLdwi_0GenericAffine.mat
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_origL} -o ${path_roi}/hpc_on_origL.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2origLdwi_0GenericAffine.txt
	# t2->recombination
	antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_recombi} -o ${path_roi}/hpc_on_recombi.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2recombidwi_0GenericAffine.mat
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${dwi_recombi} -o ${path_roi}/hpc_on_recombi.nii.gz -n NearestNeighbor -t ${path_trx}/t2w2recombidwi_0GenericAffine.txt

	# ======== extract segs ======== #
	/Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_bsl.nii.gz ${path_roi}/bsl
	/Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_origE.nii.gz ${path_roi}/origE
	/Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_origL.nii.gz ${path_roi}/origL
	/Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_recombi.nii.gz ${path_roi}/recombi

done
