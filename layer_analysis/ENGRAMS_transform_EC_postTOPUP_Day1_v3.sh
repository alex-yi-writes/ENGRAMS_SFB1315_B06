#!/bin/bash

# source ~/anaconda3/etc/profile.d/conda.sh
# conda activate hd-bet-env

for ID in sub-111 #sub-207 sub-302 sub-304 sub-303 # sub-202
do

	# prep
	path_anat=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/anat
	path_func=/Volumes/korokdorf/ENGRAMS/preproc/${ID}v1s1/func
	path_trx=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/transx
	path_roi=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/anat/roi
	t1w=${path_anat}/t1/m${ID}v1s1_run-01_T1w_0pt35
	t2w=${path_anat}/hpc/${ID}v1s1_T2w
	func_rest=${path_func}/mean${ID}v1s1_task-rest_run-01_bold_topup
	func_origenc=${path_func}/mean${ID}v1s1_task-origenc_run-03_bold_topup
	func_origrec=${path_func}/mean${ID}v1s1_task-origrec1_run-04_bold_topup
	mkdir ${path_roi}
	mkdir ${path_trx}

	# ======== strip skulls ======== #
	# 06-10-2025: alex: unfortunately either synthstrip or hd-bet doesn't work on my imac so i'm doing this specific step separately on another machine

	# mri_synthstrip -i ${t1w}.nii.gz -o ${t1w}_stripped.nii.gz
	mri_synthstrip -i ${func_rest}.nii.gz -o ${func_rest}_stripped.nii.gz
	mri_synthstrip -i ${func_origenc}.nii.gz -o ${func_origenc}_stripped.nii.gz
	mri_synthstrip -i ${func_origrec}.nii.gz -o ${func_origrec}_stripped.nii.gz


	# # ======== move ASHS seg ======== #

	# ASHSseg=$(find "${path_anat}/hpc" -type f -iname 'layer_002*' -print -quit) # which seg?

	# mkdir ${path_roi}/func
	# mkdir ${path_roi}/func/rest
	# mkdir ${path_roi}/func/origenc
	# mkdir ${path_roi}/func/origrec1

	# # use unstripped for HPC
	# antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${func_rest}.nii.gz -f ${t2w}.nii.gz -o ${path_trx}/rest2hpc_
	# antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${func_origenc}.nii.gz -f ${t2w}.nii.gz -o ${path_trx}/origenc2hpc_
	# antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${func_origrec}.nii.gz -f ${t2w}.nii.gz -o ${path_trx}/origrec2hpc_

	# # move segs to each fMRI space
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${func_rest}.nii.gz -o ${path_roi}/hpc_on_func-rest.nii.gz -n NearestNeighbor -t [${path_trx}/rest2hpc_0GenericAffine.mat,1]
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${func_origenc}.nii.gz -o ${path_roi}/hpc_on_func-origenc.nii.gz -n NearestNeighbor -t [${path_trx}/origenc2hpc_0GenericAffine.mat,1] 
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${func_origrec}.nii.gz -o ${path_roi}/hpc_on_func-origrec1.nii.gz -n NearestNeighbor -t [${path_trx}/origrec2hpc_0GenericAffine.mat,1] 

	# # extract
	# /Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_func-rest.nii.gz ${path_roi}/func/rest
	# /Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_func-origenc.nii.gz ${path_roi}/func/origenc
	# /Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_func-origrec.nii.gz ${path_roi}/func/origrec


	# #======== move layer segs ======== #
	# #(run ENGRAMS_createROImasks.m first)

	# # to resting state
	antsRegistrationSyN.sh -d 3 -n 3 -t r -r 3 -m ${t1w}_stripped.nii.gz -f ${func_rest}_stripped.nii.gz -o ${path_trx}/wb2rest_
	# antsApplyTransforms -d 3 \
	#    -i ${path_roi}/regmask/mPFC_dilated.nii.gz \
	#    -r ${func_rest}_stripped.nii.gz \
	#    -o ${path_roi}/regmask/mPFC_on_func_rest.nii.gz \
	#    -t ${path_trx}/wb2rest_0GenericAffine.mat \
	#    -n NearestNeighbor
	# antsApplyTransforms -d 3 \
	#    -i ${path_anat}/t1/aparc+aseg_nat.nii.gz \
	#    -r ${func_rest}_stripped.nii.gz \
	#    -o ${path_roi}/aparc_on_func_rest.nii.gz \
	#    -t ${path_trx}/wb2rest_0GenericAffine.mat \
	#    -n NearestNeighbor
	# # antsRegistration -d 3 \
	# #   -o "[${path_trx}/mPFCref_rest_,${path_trx}/mPFCref_rest_Warped.nii.gz]" \
	# #   --initial-moving-transform "${path_trx}/wb2rest_0GenericAffine.mat" \
	# #   --initial-moving-transform "${path_trx}/wb2rest_1Warp.nii.gz" \
	# #   -t "SyN[0.02,3,0]" \
	# #   -m "CC[${func_rest}_stripped.nii.gz,${t1w}_stripped.nii.gz,1,4]" \
	# #   -c "[500x250x0,1e-7,10]" \
	# #   -s 2x1x0vox \
	# #   -f 4x2x1 \
	# #   -x "[${path_roi}/regmask/mPFC_on_func_rest.nii.gz,${path_roi}/regmask/mPFC_dilated.nii.gz]"

	# # to origenc
	antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${t1w}_stripped.nii.gz -f ${func_origenc}_stripped.nii.gz -o ${path_trx}/wb2origenc_
	# antsApplyTransforms -d 3 \
	#    -v 0 \
	#    -i ${path_roi}/regmask/mPFC_dilated.nii.gz \
	#    -r ${func_origenc}_stripped.nii.gz \
	#    -o ${path_roi}/regmask/mPFC_on_func_origenc.nii.gz \
	#    -t ${path_trx}/wb2origenc_0GenericAffine.mat \
	#    -n NearestNeighbor
	#    antsApplyTransforms -d 3 \
	#    -v 0 \
	#    -i ${path_anat}/t1/aparc+aseg_nat.nii.gz \
	#    -r ${func_origenc}_stripped.nii.gz \
	#    -o ${path_roi}/aparc_on_func_origenc.nii.gz \
	#    -t ${path_trx}/wb2origenc_0GenericAffine.mat \
	#    -n NearestNeighbor
	# # antsRegistration -d 3 \
	# #   -o "[${path_trx}/mPFCref_origenc_,${path_trx}/mPFCref_origenc_Warped.nii.gz]" \
	# #   --initial-moving-transform "${path_trx}/wb2origenc_0GenericAffine.mat" \
	# #   --initial-moving-transform "${path_trx}/wb2origenc_1Warp.nii.gz" \
	# #   -t "SyN[0.015,3,0]" \
	# #   -m "CC[${func_origenc}_stripped.nii.gz,${t1w}_stripped.nii.gz,1,3]" \
	# #   -c "[1000x500x250x100,1e-8,15]" \
	# #   -s 3x1.5x1x0vox \
	# #   -f 6x3x2x1 \
	# #   -x "[${path_roi}/regmask/mPFC_on_func_origenc.nii.gz,${path_roi}/regmask/mPFC_bin.nii.gz]"

	# # to origrec
	antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${t1w}_stripped.nii.gz -f ${func_origrec}_stripped.nii.gz -o ${path_trx}/wb2origrec_
	# antsApplyTransforms -d 3 \
	#    -v 0 \
	#    -i ${path_roi}/regmask/mPFC_dilated.nii.gz \
	#    -r ${func_origrec}_stripped.nii.gz \
	#    -o ${path_roi}/regmask/mPFC_on_func_origrec.nii.gz \
	#    -t ${path_trx}/wb2origrec_0GenericAffine.mat \
	#    -n NearestNeighbor
	#    antsApplyTransforms -d 3 \
	#    -v 0 \
	#    -i ${path_anat}/t1/aparc+aseg_nat.nii.gz \
	#    -r ${func_origrec}_stripped.nii.gz \
	#    -o ${path_roi}/aparc_on_func_origrec1.nii.gz \
	#    -t ${path_trx}/wb2origrec_0GenericAffine.mat \
	#    -n NearestNeighbor
	# # antsRegistration -d 3 \
	# #   -o "[${path_trx}/mPFCref_origrec_,${path_trx}/mPFCref_origrec_Warped.nii.gz]" \
	# #   --initial-moving-transform "${path_trx}/wb2origrec_0GenericAffine.mat" \
	# #   --initial-moving-transform "${path_trx}/wb2origrec_1Warp.nii.gz" \
	# #   -t "SyN[0.015,3,0]" \
	# #   -m "CC[${func_origrec}_stripped.nii.gz,${t1w}_stripped.nii.gz,1,3]" \
	# #   -c "[1000x500x250x100,1e-8,15]" \
	# #   -s 3x1.5x1x0vox \
	# #   -f 6x3x2x1 \
	# #   -x "[${path_roi}/regmask/mPFC_on_func_origrec.nii.gz,${path_roi}/regmask/mPFC_bin.nii.gz]"



	# ############# RESTING STATE #############

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/SN.nii.gz \
		-o ${path_roi}/func/rest/SN.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/VTA.nii.gz \
		-o ${path_roi}/func/rest/VTA.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/LC.nii.gz \
		-o ${path_roi}/func/rest/LC.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat

	# ~~~ retrosplenial cortex ~~~ #

	# superficial layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_sup.nii.gz \
		-o ${path_roi}/func/rest/EC_R_layer_sup.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_sup.nii.gz \
		-o ${path_roi}/func/rest/EC_L_layer_sup.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_sup.nii.gz \
		-o ${path_roi}/func/rest/EC_layer_sup.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat

	# middle layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_mid.nii.gz \
		-o ${path_roi}/func/rest/EC_R_layer_mid.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_mid.nii.gz \
		-o ${path_roi}/func/rest/EC_L_layer_mid.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_mid.nii.gz \
		-o ${path_roi}/func/rest/EC_layer_mid.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat

	# deep layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_deep.nii.gz \
		-o ${path_roi}/func/rest/EC_R_layer_deep.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_deep.nii.gz \
		-o ${path_roi}/func/rest/EC_L_layer_deep.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_rest}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_deep.nii.gz \
		-o ${path_roi}/func/rest/EC_layer_deep.nii.gz \
		-t ${path_trx}/wb2rest_0GenericAffine.mat




	# ############# ENCODING (ORIG) #############

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/SN.nii.gz \
		-o ${path_roi}/func/origenc/SN.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/VTA.nii.gz \
		-o ${path_roi}/func/origenc/VTA.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/LC.nii.gz \
		-o ${path_roi}/func/origenc/LC.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat


	# ~~~ retrosplenial cortex ~~~ #

	# superficial layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_sup.nii.gz \
		-o ${path_roi}/func/origenc/EC_R_layer_sup.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_sup.nii.gz \
		-o ${path_roi}/func/origenc/EC_L_layer_sup.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_sup.nii.gz \
		-o ${path_roi}/func/origenc/EC_layer_sup.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat

	# middle layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_mid.nii.gz \
		-o ${path_roi}/func/origenc/EC_R_layer_mid.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_mid.nii.gz \
		-o ${path_roi}/func/origenc/EC_L_layer_mid.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_mid.nii.gz \
		-o ${path_roi}/func/origenc/EC_layer_mid.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat

	# deep layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_deep.nii.gz \
		-o ${path_roi}/func/origenc/EC_R_layer_deep.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_deep.nii.gz \
		-o ${path_roi}/func/origenc/EC_L_layer_deep.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origenc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_deep.nii.gz \
		-o ${path_roi}/func/origenc/EC_layer_deep.nii.gz \
		-t ${path_trx}/wb2origenc_0GenericAffine.mat




	# ############# RECOGNITION (ORIG) #############

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/LC.nii.gz \
		-o ${path_roi}/func/origrec1/LC.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/VTA.nii.gz \
		-o ${path_roi}/func/origrec1/VTA.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/SN.nii.gz \
		-o ${path_roi}/func/origrec1/SN.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat

	# ~~~ retrosplenial cortex ~~~ #

	# superficial layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_sup.nii.gz \
		-o ${path_roi}/func/origrec1/EC_R_layer_sup.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_sup.nii.gz \
		-o ${path_roi}/func/origrec1/EC_L_layer_sup.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_sup.nii.gz \
		-o ${path_roi}/func/origrec1/EC_layer_sup.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat

	# middle layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_mid.nii.gz \
		-o ${path_roi}/func/origrec1/EC_R_layer_mid.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_mid.nii.gz \
		-o ${path_roi}/func/origrec1/EC_L_layer_mid.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_mid.nii.gz \
		-o ${path_roi}/func/origrec1/EC_layer_mid.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat

	# deep layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_deep.nii.gz \
		-o ${path_roi}/func/origrec1/EC_R_layer_deep.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_deep.nii.gz \
		-o ${path_roi}/func/origrec1/EC_L_layer_deep.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_deep.nii.gz \
		-o ${path_roi}/func/origrec1/EC_layer_deep.nii.gz \
		-t ${path_trx}/wb2origrec_0GenericAffine.mat


done