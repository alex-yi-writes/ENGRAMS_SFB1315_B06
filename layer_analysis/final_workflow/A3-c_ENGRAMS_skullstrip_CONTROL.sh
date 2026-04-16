#!/bin/bash


# done: 202 
for ID in 101 102 104 106 107 108 109 110 111
do

	# synthstrip

	# DAY 1
	mri_synthstrip \
	-i /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s2/func/meanusub-"${ID}"v2s2_task-origrec_run-04_bold.nii.gz \
	-o /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s2/func/meanusub-"${ID}"v2s2_task-origrec_run-04_bold_stripped.nii.gz

	mri_synthstrip \
	-i /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s2/func/meanusub-"${ID}"v2s2_task-origenc_run-03_bold.nii.gz \
	-o /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s2/func/meanusub-"${ID}"v2s2_task-origenc_run-03_bold_stripped.nii.gz

	mri_synthstrip \
	-i /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v1s1/func/meanusub-"${ID}"v1s1_task-rest_run-01_bold.nii.gz \
	-o /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v1s1/func/meanusub-"${ID}"v1s1_task-rest_run-01_bold_stripped.nii.gz \


done
