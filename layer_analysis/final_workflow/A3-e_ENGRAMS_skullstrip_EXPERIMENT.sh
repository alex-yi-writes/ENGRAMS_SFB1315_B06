#!/bin/bash


# done: 202 
for ID in 307 308
do

	# synthstrip

	# DAY 1
	mri_synthstrip \
	-i /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v1s1/func/meansub-"${ID}"v1s1_task-rest_run-01_bold_topup.nii.gz \
	-o /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v1s1/func/meansub-"${ID}"v1s1_task-rest_run-01_bold_topup_stripped.nii.gz

	mri_synthstrip \
	-i /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v1s1/func/meansub-"${ID}"v1s1_task-origenc_run-03_bold_topup.nii.gz \
	-o /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v1s1/func/meansub-"${ID}"v1s1_task-origenc_run-03_bold_topup_stripped.nii.gz

	mri_synthstrip \
	-i /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v1s1/func/meansub-"${ID}"v1s1_task-origrec1_run-04_bold_topup.nii.gz \
	-o /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v1s1/func/meansub-"${ID}"v1s1_task-origrec1_run-04_bold_topup_stripped.nii.gz \

	# DAY 2
	mri_synthstrip \
	-i /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s1/func/meansub-"${ID}"v2s1_task-origrec2_run-05_bold_topup.nii.gz \
	-o /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s1/func/meansub-"${ID}"v2s1_task-origrec2_run-05_bold_topup_stripped.nii.gz

	mri_synthstrip \
	-i /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s1/func/meansub-"${ID}"v2s1_task-recombienc_run-03_bold_topup.nii.gz \
	-o /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s1/func/meansub-"${ID}"v2s1_task-recombienc_run-03_bold_topup_stripped.nii.gz

	mri_synthstrip \
	-i /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s1/func/meansub-"${ID}"v2s1_task-recombirec_run-04_bold_topup.nii.gz \
	-o /Users/yyi/Desktop/ENGRAMS/preproc/sub-"${ID}"v2s1/func/meansub-"${ID}"v2s1_task-recombirec_run-04_bold_topup_stripped.nii.gz \


done
