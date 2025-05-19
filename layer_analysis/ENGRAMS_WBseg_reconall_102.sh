#!/bin/bash

for ID in sub-102v1s1
do
	path_src=/mnt/work/yyi/ENGRAMS/preproc/${ID}/anat/t1
	path_out=/mnt/work/yyi/ENGRAMS/preproc/${ID}/anat/t1/${ID}/mri
	t1w=${path_src}/m${ID}_run-01_T1w_0pt35.nii.gz

	export FREESURFER_HOME=/share/apps/freesurfer_7.1  
	source $FREESURFER_HOME/SetUpFreeSurfer.sh
	export SUBJECTS_DIR=$path_src
	
	#mkdir /mnt/work/yyi/ENGRAMS/preproc/${ID}/anat/t1/${ID}

	which recon-all

	export SUBJECTS_DIR=$path_src

	# stage 1
	recon-all \
		-s ${ID} \
		-i ${t1w} \
		-expert /mnt/work/yyi/ENGRAMS/hires_expert.txt \
		-hires \
		-autorecon1 \
		-noskullstrip
	mri_convert -it mgz -ot nii ${path_out}/orig.mgz ${path_src}/orig.nii.gz
	antsRegistrationSyNQuick.sh -d 3 -t r -f ${path_src}/orig.nii.gz -m ${t1w} -o ${path_src}/FStoNat_
	
	# # stage 2
	# antsApplyTransforms -d 3 -n Linear -i ${path_src}/brainmask.nii -r ${path_src}/orig.nii.gz -o ${path_out}/brainmask.nii.gz -t ${path_src}/FStoNat_0GenericAffine.mat
	# mri_convert -it nii -ot mgz ${path_out}/brainmask.nii.gz ${path_out}/brainmask.mgz

	# recon-all -s ${ID} \
	#  	-expert /mnt/work/yyi/ENGRAMS/hires_expert.txt \
	#  	-hires \
	# 	-xopts-overwrite \
	#  	-autorecon2

	# recon-all -s ${ID} \
	#  	-expert /mnt/work/yyi/ENGRAMS/hires_expert.txt \
	#  	-hires \
	# 	-xopts-overwrite \
	#  	-autorecon3

done
