#!/bin/bash

for ID in sub-109v1s1 #sub-104v1s1 sub-105v1s1 sub-106v1s1 sub-107v1s1 sub-101v1s1
do

	# prep
	path_anat=/Users/alex/Dropbox/paperwriting/1315/data/segmentation/${ID}/anat
	path_func=/Users/alex/Dropbox/paperwriting/1315/data/segmentation/${ID}/func
	path_trx=/Users/alex/Dropbox/paperwriting/1315/data/segmentation/${ID}/transx
	path_roi=/Users/alex/Dropbox/paperwriting/1315/data/segmentation/${ID}/anat/roi
	t1w=${path_anat}/t1/m${ID}_run-01_T1w_0pt35
	t2w=${path_anat}/hpc/${ID}_T2w
	func_rest=${path_func}/meanusub-109v1s1_task-rest_run-01_bold
	func_origenc=${path_func}/meanusub-109v2s2_task-origenc_run-03_bold
	func_origrec=${path_func}/meanusub-109v2s2_task-origrec_run-04_bold


	# ======== strip skulls ======== #

	# mri_synthstrip -i ${t1w}.nii.gz -o ${t1w}_stripped.nii.gz
	# mri_synthstrip -i ${func_rest}.nii.gz -o ${func_rest}_stripped.nii.gz
	# mri_synthstrip -i ${func_origenc}.nii.gz -o ${func_origenc}_stripped.nii.gz
	# mri_synthstrip -i ${func_origrec}.nii.gz -o ${func_origrec}_stripped.nii.gz


	# ======== move ASHS seg ======== #

	ASHSseg=$(find "${path_anat}/hpc" -type f -iname 'layer_002*' -print -quit) # which seg?

	mkdir ${path_roi}/func/rest
	mkdir ${path_roi}/func/origenc
	mkdir ${path_roi}/func/origrec

	# use unstripped for HPC
	antsRegistrationSyNQuick.sh -d 3 -n 4 -t sr -m ${func_rest}.nii.gz -f ${t2w}.nii.gz -o ${path_trx}/rest2hpc_
	antsRegistrationSyNQuick.sh -d 3 -n 4 -t sr -m ${func_origenc}.nii.gz -f ${t2w}.nii.gz -o ${path_trx}/origenc2hpc_
	antsRegistrationSyNQuick.sh -d 3 -n 4 -t sr -m ${func_origrec}.nii.gz -f ${t2w}.nii.gz -o ${path_trx}/origrec2hpc_

	# move segs to each fMRI space
	antsApplyTransforms -d 3 -v 1 -i ${ASHSseg} -r ${func_rest}.nii.gz -o ${path_roi}/hpc_on_func-rest.nii.gz -n NearestNeighbor -t [${path_trx}/rest2hpc_0GenericAffine.mat,1]
	antsApplyTransforms -d 3 -v 1 -i ${ASHSseg} -r ${func_origenc}.nii.gz -o ${path_roi}/hpc_on_func-origenc.nii.gz -n NearestNeighbor -t [${path_trx}/origenc2hpc_0GenericAffine.mat,1]
	antsApplyTransforms -d 3 -v 1 -i ${ASHSseg} -r ${func_origrec}.nii.gz -o ${path_roi}/hpc_on_func-origrec.nii.gz -n NearestNeighbor -t [${path_trx}/origrec2hpc_0GenericAffine.mat,1]

	# extract
	/Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_func-rest.nii.gz ${path_roi}/func/rest
	/Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_func-origenc.nii.gz ${path_roi}/func/origenc
	/Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_func-origrec.nii.gz ${path_roi}/func/origrec


	# ======== move layer segs ======== #
	# (run ENGRAMS_createROImasks.m first)

	# antsRegistrationSyN.sh -d 3 -n 4 -t sr -m ${t1w}_stripped.nii.gz -f ${func_rest}_stripped.nii.gz -o ${path_trx}/wb2rest_
	# antsRegistrationSyN.sh -d 3 -n 4 -t sr -m ${t1w}_stripped.nii.gz -f ${func_origenc}_stripped.nii.gz -o ${path_trx}/wb2origenc_
	# antsRegistrationSyN.sh -d 3 -n 4 -t sr -m ${t1w}_stripped.nii.gz -f ${func_origrec}_stripped.nii.gz -o ${path_trx}/wb2origrec_


	# ~~~ retrosplenial cortex ~~~ #

	# superficial layer
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/RSC_R_layer_sup.nii.gz \
		-o ${path_roi}/func/rest/RSC_R_layer_sup.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/RSC_L_layer_sup.nii.gz \
		-o ${path_roi}/func/rest/RSC_L_layer_sup.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/RSC_layer_sup.nii.gz \
		-o ${path_roi}/func/rest/RSC_layer_sup.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat

	# middle layer
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/RSC_R_layer_mid.nii.gz \
		-o ${path_roi}/func/rest/RSC_R_layer_mid.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/RSC_L_layer_mid.nii.gz \
		-o ${path_roi}/func/rest/RSC_L_layer_mid.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/RSC_layer_mid.nii.gz \
		-o ${path_roi}/func/rest/RSC_layer_mid.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat

	# deep layer
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/RSC_R_layer_deep.nii.gz \
		-o ${path_roi}/func/rest/RSC_R_layer_deep.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/RSC_L_layer_deep.nii.gz \
		-o ${path_roi}/func/rest/RSC_L_layer_deep.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/RSC_layer_deep.nii.gz \
		-o ${path_roi}/func/rest/RSC_layer_deep.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat


	# ~~~ medial prefrontal cortex ~~~ #

	# superficial layer
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/mPFC_R_layer_sup.nii.gz \
		-o ${path_roi}/func/rest/mPFC_R_layer_sup.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/mPFC_L_layer_sup.nii.gz \
		-o ${path_roi}/func/rest/mPFC_L_layer_sup.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/mPFC_layer_sup.nii.gz \
		-o ${path_roi}/func/rest/mPFC_layer_sup.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat

	# middle layer
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/mPFC_R_layer_mid.nii.gz \
		-o ${path_roi}/func/rest/mPFC_R_layer_mid.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/mPFC_L_layer_mid.nii.gz \
		-o ${path_roi}/func/rest/mPFC_L_layer_mid.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/mPFC_layer_mid.nii.gz \
		-o ${path_roi}/func/rest/mPFC_layer_mid.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat

	# deep layer
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/mPFC_R_layer_deep.nii.gz \
		-o ${path_roi}/func/rest/mPFC_R_layer_deep.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/mPFC_L_layer_deep.nii.gz \
		-o ${path_roi}/func/rest/mPFC_L_layer_deep.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 1 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/mPFC_layer_deep.nii.gz \
		-o ${path_roi}/func/rest/mPFC_layer_deep.nii.gz \
		-t /Users/alex/Dropbox/paperwriting/1315/data/segmentation/sub-109v1s1/transx/wb2rest_0GenericAffine.mat

done