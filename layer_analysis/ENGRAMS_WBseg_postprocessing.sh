#!/bin/bash

for ID in sub-207v1s1 sub-302v1s1 sub-303v1s1 #sub-104v1s1 sub-105v1s1 sub-106v1s1
do
	path_src=/Users/yyi/Desktop/ENGRAMS/analyses/${ID}/anat/t1/${ID}/mri
	path_out=/Users/yyi/Desktop/ENGRAMS/analyses/${ID}/anat/t1
	path_trx=/Users/yyi/Desktop/ENGRAMS/analyses/${ID}/anat/transx
	t1w=${path_out}/m${ID}_run-01_T1w_0pt35.nii.gz
	fsorig=${path_out}/orig.nii.gz

	#antsRegistrationSyNQuick.sh -d 3 -t r -m ${t1w} -f ${fsorig} -o ${path_trx}/Nat2FS_
	mri_convert -it mgz -ot nii ${path_src}/aparc+aseg.mgz ${path_out}/aparc+aseg.nii.gz
	# antsApplyTransforms -d 3 -n NearestNeighbor -i ${path_out}/aparc+aseg.nii.gz -r ${t1w} -o ${path_out}/aparc+aseg_nat.nii.gz -t [${path_trx}/Nat2FS_0GenericAffine.mat,1]
	antsApplyTransforms -d 3 -n NearestNeighbor -i ${path_out}/aparc+aseg.nii.gz -r ${t1w} -o ${path_out}/aparc+aseg_nat.nii.gz -t ${path_trx}/FStoNat_0GenericAffine.mat
	
done
