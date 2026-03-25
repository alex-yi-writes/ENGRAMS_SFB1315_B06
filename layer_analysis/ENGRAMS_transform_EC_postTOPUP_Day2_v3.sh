#!/bin/bash

# source ~/anaconda3/etc/profile.d/conda.sh
# conda activate hd-bet-env

for ID in sub-303 #sub-202 
do

	# prep
	path_anat=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/anat
	path_func=/Volumes/korokdorf/ENGRAMS//preproc/${ID}v2s1/func
	path_trx=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/transx
	path_roi=/Volumes/korokdorf/ENGRAMS/analyses/${ID}v1s1/anat/roi
	t1w=${path_anat}/t1/m${ID}v1s1_run-01_T1w_0pt35
	t2w=${path_anat}/hpc/${ID}v1s1_T2w
	func_origrec2=${path_func}/mean${ID}v2s1_task-origrec2_run-05_bold_topup
	func_recombienc=${path_func}/mean${ID}v2s1_task-recombienc_run-03_bold_topup
	func_recombirec=${path_func}/mean${ID}v2s1_task-recombirec1_run-04_bold_topup
	mkdir ${path_roi}
	mkdir ${path_trx}

	# # ======== strip skulls ======== #
	# # 06-10-2025: alex: unfortunately either synthstrip or hd-bet doesn't work on my imac so i'm doing this specific step separately on another machine

	# # hd-bet -i ${t1w}.nii.gz -o ${t1w}_stripped.nii.gz -device cpu
	# mri_synthstrip -i ${func_origrec2}.nii.gz -o ${func_origrec2}_stripped.nii.gz
	# mri_synthstrip -i ${func_recombienc}.nii.gz -o ${func_recombienc}_stripped.nii.gz
	# mri_synthstrip -i ${func_recombirec}.nii.gz -o ${func_recombirec}_stripped.nii.gz


	# # ======== move ASHS seg ======== #

	# ASHSseg=$(find "${path_anat}/hpc" -type f -iname 'layer_002*' -print -quit) # which seg?

	# mkdir ${path_roi}/func
	# mkdir ${path_roi}/func/origrec2
	# mkdir ${path_roi}/func/recombienc
	# mkdir ${path_roi}/func/recombirec

	# # use unstripped for HPC
	# antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${func_origrec2}.nii.gz -f ${t2w}.nii.gz -o ${path_trx}/origrec22hpc_
	# antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${func_recombienc}.nii.gz -f ${t2w}.nii.gz -o ${path_trx}/recombienc2hpc_
	# antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${func_recombirec}.nii.gz -f ${t2w}.nii.gz -o ${path_trx}/recombirec2hpc_

	# # move segs to each fMRI space
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${func_origrec2}.nii.gz -o ${path_roi}/hpc_on_func-origrec2.nii.gz -n NearestNeighbor -t [${path_trx}/rest2hpc_0GenericAffine.mat,1]
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${func_recombienc}.nii.gz -o ${path_roi}/hpc_on_func-recombienc.nii.gz -n NearestNeighbor -t [${path_trx}/recombienc2hpc_0GenericAffine.mat,1] 
	# antsApplyTransforms -d 3 -v 0 -i ${ASHSseg} -r ${func_recombirec}.nii.gz -o ${path_roi}/hpc_on_func-recombirec.nii.gz -n NearestNeighbor -t [${path_trx}/recombirec2hpc_0GenericAffine.mat,1] 

	# # extract
	# /Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_func-origrec2.nii.gz ${path_roi}/func/origrec2
	# /Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_func-recombienc.nii.gz ${path_roi}/func/recombienc
	# /Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_binarise_ASHSseg_vf.sh ${path_roi}/hpc_on_func-recombirec.nii.gz ${path_roi}/func/recombirec


	======== move layer segs ======== #
	#(run ENGRAMS_createROImasks.m first)

	# to original recognition late
	antsRegistrationSyN.sh -d 3 -n 3 -t r -r 3 -m ${t1w}_stripped.nii.gz -f ${func_origrec2}_stripped.nii.gz -o ${path_trx}/wb2origrec2_
	antsApplyTransforms -d 3 \
	   -i ${path_roi}/regmask/mPFC_dilated.nii.gz \
	   -r ${func_origrec2}_stripped.nii.gz \
	   -o ${path_roi}/regmask/mPFC_on_func_origrec2.nii.gz \
	   -t ${path_trx}/wb2origrec2_0GenericAffine.mat \
	   -n NearestNeighbor
	   antsApplyTransforms -d 3 \
	   -i ${path_anat}/t1/aparc+aseg_nat.nii.gz \
	   -r ${func_origrec2}_stripped.nii.gz \
	   -o ${path_roi}/aparc_on_func_origrec2.nii.gz \
	   -t ${path_trx}/wb2origrec2_0GenericAffine.mat \
	   -n NearestNeighbor
	# antsRegistration -d 3 \
	#   -o "[${path_trx}/mPFCref_origrec2_,${path_trx}/mPFCref_origrec2_Warped.nii.gz]" \
	#   --initial-moving-transform "${path_trx}/wb2origrec2_0GenericAffine.mat" \
	#   --initial-moving-transform "${path_trx}/wb2origrec2_1Warp.nii.gz" \
	#   -t "SyN[0.02,3,0]" \
	#   -m "CC[${func_origrec2}_stripped.nii.gz,${t1w}_stripped.nii.gz,1,4]" \
	#   -c "[500x250x0,1e-7,10]" \
	#   -s 2x1x0vox \
	#   -f 4x2x1 \
	#   -x "[${path_roi}/regmask/mPFC_on_func_origrec2.nii.gz,${path_roi}/regmask/mPFC_dilated.nii.gz]"

	# to recombienc
	antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${t1w}_stripped.nii.gz -f ${func_recombienc}_stripped.nii.gz -o ${path_trx}/wb2recombienc_
	antsApplyTransforms -d 3 \
	   -v 0 \
	   -i ${path_roi}/regmask/mPFC_dilated.nii.gz \
	   -r ${func_recombienc}_stripped.nii.gz \
	   -o ${path_roi}/regmask/mPFC_on_func_recombienc.nii.gz \
	   -t ${path_trx}/wb2recombienc_0GenericAffine.mat \
	   -n NearestNeighbor
	   antsApplyTransforms -d 3 \
	   -v 0 \
	   -i ${path_anat}/t1/aparc+aseg_nat.nii.gz \
	   -r ${func_recombienc}_stripped.nii.gz \
	   -o ${path_roi}/aparc_on_func_recombienc.nii.gz \
	   -t ${path_trx}/wb2recombienc_0GenericAffine.mat \
	   -n NearestNeighbor
	# antsRegistration -d 3 \
	#   -o "[${path_trx}/mPFCref_recombienc_,${path_trx}/mPFCref_recombienc_Warped.nii.gz]" \
	#   --initial-moving-transform "${path_trx}/wb2recombienc_0GenericAffine.mat" \
	#   --initial-moving-transform "${path_trx}/wb2recombienc_1Warp.nii.gz" \
	#   -t "SyN[0.015,3,0]" \
	#   -m "CC[${func_recombienc}_stripped.nii.gz,${t1w}_stripped.nii.gz,1,3]" \
	#   -c "[1000x500x250x100,1e-8,15]" \
	#   -s 3x1.5x1x0vox \
	#   -f 6x3x2x1 \
	#   -x "[${path_roi}/regmask/mPFC_on_func_recombienc.nii.gz,${path_roi}/regmask/mPFC_bin.nii.gz]"

	# to recombirec
	antsRegistrationSyN.sh -d 3 -n 3 -t r -m ${t1w}_stripped.nii.gz -f ${func_recombirec}_stripped.nii.gz -o ${path_trx}/wb2recombirec_
	antsApplyTransforms -d 3 \
	   -v 0 \
	   -i ${path_roi}/regmask/mPFC_dilated.nii.gz \
	   -r ${func_recombirec}_stripped.nii.gz \
	   -o ${path_roi}/regmask/mPFC_on_func_recombirec.nii.gz \
	   -t ${path_trx}/wb2recombirec_0GenericAffine.mat \
	   -n NearestNeighbor
	antsApplyTransforms -d 3 \
	   -v 0 \
	   -i ${path_anat}/t1/aparc+aseg_nat.nii.gz \
	   -r ${func_recombirec}_stripped.nii.gz \
	   -o ${path_roi}/aparc_on_func_recombirec.nii.gz \
	   -t ${path_trx}/wb2recombirec_0GenericAffine.mat \
	   -n NearestNeighbor
	# antsRegistration -d 3 \
	#   -o "[${path_trx}/mPFCref_recombirec_,${path_trx}/mPFCref_recombirec_Warped.nii.gz]" \
	#   --initial-moving-transform "${path_trx}/wb2recombirec_0GenericAffine.mat" \
	#   --initial-moving-transform "${path_trx}/wb2recombirec_1Warp.nii.gz" \
	#   -t "SyN[0.015,3,0]" \
	#   -m "CC[${func_recombirec}_stripped.nii.gz,${t1w}_stripped.nii.gz,1,3]" \
	#   -c "[1000x500x250x100,1e-8,15]" \
	#   -s 3x1.5x1x0vox \
	#   -f 6x3x2x1 \
	#   -x "[${path_roi}/regmask/mPFC_on_func_recombirec.nii.gz,${path_roi}/regmask/mPFC_bin.nii.gz]"


	############# RESTING STATE #############

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/LC.nii.gz \
		-o ${path_roi}/func/origrec2/LC.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/VTA.nii.gz \
		-o ${path_roi}/func/origrec2/VTA.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/SN.nii.gz \
		-o ${path_roi}/func/origrec2/SN.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat

	# ~~~ retrosplenial cortex ~~~ #

	# superficial layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_sup.nii.gz \
		-o ${path_roi}/func/origrec2/EC_R_layer_sup.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_sup.nii.gz \
		-o ${path_roi}/func/origrec2/EC_L_layer_sup.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_sup.nii.gz \
		-o ${path_roi}/func/origrec2/EC_layer_sup.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat

	# middle layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_mid.nii.gz \
		-o ${path_roi}/func/origrec2/EC_R_layer_mid.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_mid.nii.gz \
		-o ${path_roi}/func/origrec2/EC_L_layer_mid.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_mid.nii.gz \
		-o ${path_roi}/func/origrec2/EC_layer_mid.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat

	# deep layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_deep.nii.gz \
		-o ${path_roi}/func/origrec2/EC_R_layer_deep.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_deep.nii.gz \
		-o ${path_roi}/func/origrec2/EC_L_layer_deep.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_origrec2}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_deep.nii.gz \
		-o ${path_roi}/func/origrec2/EC_layer_deep.nii.gz \
		-t ${path_trx}/wb2origrec2_0GenericAffine.mat


	

	############# ENCODING (recombi) #############

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/LC.nii.gz \
		-o ${path_roi}/func/recombienc/LC.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/VTA.nii.gz \
		-o ${path_roi}/func/recombienc/VTA.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/SN.nii.gz \
		-o ${path_roi}/func/recombienc/SN.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat

	# ~~~ retrosplenial cortex ~~~ #

	# superficial layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_sup.nii.gz \
		-o ${path_roi}/func/recombienc/EC_R_layer_sup.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_sup.nii.gz \
		-o ${path_roi}/func/recombienc/EC_L_layer_sup.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_sup.nii.gz \
		-o ${path_roi}/func/recombienc/EC_layer_sup.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat

	# middle layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_mid.nii.gz \
		-o ${path_roi}/func/recombienc/EC_R_layer_mid.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_mid.nii.gz \
		-o ${path_roi}/func/recombienc/EC_L_layer_mid.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_mid.nii.gz \
		-o ${path_roi}/func/recombienc/EC_layer_mid.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat

	# deep layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_deep.nii.gz \
		-o ${path_roi}/func/recombienc/EC_R_layer_deep.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_deep.nii.gz \
		-o ${path_roi}/func/recombienc/EC_L_layer_deep.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombienc}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_deep.nii.gz \
		-o ${path_roi}/func/recombienc/EC_layer_deep.nii.gz \
		-t ${path_trx}/wb2recombienc_0GenericAffine.mat


	

	############# RECOGNITION (recombi) #############

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/LC.nii.gz \
		-o ${path_roi}/func/recombirec/LC.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/SN.nii.gz \
		-o ${path_roi}/func/recombirec/SN.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat

	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/VTA.nii.gz \
		-o ${path_roi}/func/recombirec/VTA.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat

	# ~~~ retrosplenial cortex ~~~ #

	# superficial layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_sup.nii.gz \
		-o ${path_roi}/func/recombirec/EC_R_layer_sup.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_sup.nii.gz \
		-o ${path_roi}/func/recombirec/EC_L_layer_sup.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_sup.nii.gz \
		-o ${path_roi}/func/recombirec/EC_layer_sup.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat

	# middle layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_mid.nii.gz \
		-o ${path_roi}/func/recombirec/EC_R_layer_mid.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_mid.nii.gz \
		-o ${path_roi}/func/recombirec/EC_L_layer_mid.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_mid.nii.gz \
		-o ${path_roi}/func/recombirec/EC_layer_mid.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat

	# deep layer
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_R_layer_deep.nii.gz \
		-o ${path_roi}/func/recombirec/EC_R_layer_deep.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_L_layer_deep.nii.gz \
		-o ${path_roi}/func/recombirec/EC_L_layer_deep.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat
	antsApplyTransforms -d 3 -v 0 -n NearestNeighbor \
		-r ${func_recombirec}_stripped.nii.gz \
		-i ${path_roi}/native/EC_layer_deep.nii.gz \
		-o ${path_roi}/func/recombirec/EC_layer_deep.nii.gz \
		-t ${path_trx}/wb2recombirec_0GenericAffine.mat


	
done