#!/bin/bash

for ID in 102 #104 106 107 108 109 110 111 #304 303 302 207 202 111 110 109 108
do

	# prep
	path_anat=/Users/yyi/Desktop/ENGRAMS/preproc/sub-${ID}v1s1/anat
	path_trx=/Users/yyi/Desktop/ENGRAMS/analyses/sub-${ID}v1s1/transx
	path_mniROI=/Users/yyi/Desktop/ENGRAMS/templates/mni_icbm152
	path_natROI=/Users/yyi/Desktop/ENGRAMS/analyses/sub-${ID}v1s1/anat/roi/native
	t1w=${path_anat}/sub-${ID}v1s1_run-01_T1w.nii.gz
	mni=/Users/yyi/Desktop/ENGRAMS/templates/mni_icbm152_t1_tal_nlin_asym_09c.nii.gz

	# antsRegistrationSyN.sh -d 3 -n 10 -t s -r 3 -f ${t1w} -m ${mni} -o ${path_trx}/mni2wb_

	mkdir /Users/yyi/Desktop/ENGRAMS/analyses/sub-${ID}v1s1/anat/roi/
	mkdir ${path_natROI}

	antsApplyTransforms -d 3 -v 0 -i ${path_mniROI}/VTA.nii.gz -r ${t1w} -o ${path_natROI}/VTA_temp.nii.gz -n NearestNeighbor -t ${path_trx}/mni2wb_1Warp.nii.gz -t ${path_trx}/mni2wb_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -i ${path_mniROI}/SN.nii.gz -r ${t1w} -o ${path_natROI}/SN_temp.nii.gz -n NearestNeighbor -t ${path_trx}/mni2wb_1Warp.nii.gz -t ${path_trx}/mni2wb_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -i ${path_mniROI}/LC.nii.gz -r ${t1w} -o ${path_natROI}/LC_temp.nii.gz -n NearestNeighbor -t ${path_trx}/mni2wb_1Warp.nii.gz -t ${path_trx}/mni2wb_0GenericAffine.mat

	ResampleImage 3 ${path_natROI}/LC_temp.nii.gz ${path_natROI}/LC.nii.gz 0.35 0.35 0.35 1 4
	ResampleImage 3 ${path_natROI}/VTA_temp.nii.gz ${path_natROI}/VTA.nii.gz 0.35 0.35 0.35 1 4
	ResampleImage 3 ${path_natROI}/SN_temp.nii.gz ${path_natROI}/SN.nii.gz 0.35 0.35 0.35 1 4

	rm ${path_natROI}/SN_temp.nii.gz
	rm ${path_natROI}/LC_temp.nii.gz
	rm ${path_natROI}/VTA_temp.nii.gz

done
