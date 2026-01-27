#!/bin/bash

nThreads=8

for ID in sub-207
do

	# prep
	path_dwi_bsl=/mnt/work/yyi/ENGRAMS/preproc/${ID}v1s1/dwi
	path_dwi_origE=/mnt/work/yyi/ENGRAMS/preproc/${ID}v1s2/dwi
	path_dwi_origL=/mnt/work/yyi/ENGRAMS/preproc/${ID}v2s1/dwi
	path_dwi_recombi=/mnt/work/yyi/ENGRAMS/preproc/${ID}v2s2/dwi

	path_mask_bsl=/mnt/work/yyi/ENGRAMS/analyses/${ID}v1s1/dwi
	path_mask_origE=/mnt/work/yyi/ENGRAMS/analyses/${ID}v1s2/dwi
	path_mask_origL=/mnt/work/yyi/ENGRAMS/analyses/${ID}v2s1/dwi
	path_mask_recombi=/mnt/work/yyi/ENGRAMS/analyses/${ID}v2s2/dwi

	path_trx=/mnt/work/yyi/ENGRAMS/analyses/${ID}v1s1/transx
	path_roi=/mnt/work/yyi/ENGRAMS/analyses/${ID}v1s1/anat/roi_dwi

	mask_bsl=${path_mask_bsl}/${ID}v1s1_hifi_b0_brain_mask.nii.gz
	mask_origE=${path_mask_origE}/${ID}v1s2_hifi_b0_brain_mask.nii.gz
	mask_origL=${path_mask_origL}/${ID}v2s1_hifi_b0_brain_mask.nii.gz
	mask_recombi=${path_mask_recombi}/${ID}v2s2_hifi_b0_brain_mask.nii.gz

	SUBJECT=${ID}
	
	# ------ baseline ------ #

	# 1. mag acquisitions
	for acq in b1pt0k-AP b1pt0k-PA b2pt5k-AP b2pt5k-PA; do
	   echo "proc mag ${acq}..."	    
	   singularity run -B /mnt/work/yyi /share/apps/images/mrtrix.simg dwidenoise \
	   -mask ${mask_bsl} \
	   -datatype float32 \
	   -nthreads ${nThreads} \
	   -noise "${path_dwi_bsl}/${SUBJECT}v1s1_${acq}_dwi_noise.nii.gz" \
	   "${path_dwi_bsl}/${SUBJECT}v1s1_${acq}_dwi.nii.gz" \
	   "${path_dwi_bsl}/${SUBJECT}v1s1_${acq}_dwi_dn.nii.gz"	   
	done

	# 2. phase acquisitions
	for acq in b1pt0k-AP b1pt0k-PA b2pt5k-AP b2pt5k-PA; do
	   echo "proc phase ${acq}..."	    
	   singularity run -B /mnt/work/yyi /share/apps/images/mrtrix.simg dwidenoise \
	   -mask ${mask_bsl} \
	   -datatype complex64 \
	   -nthreads ${nThreads} \
	   -noise "${path_dwi_bsl}/${SUBJECT}v1s1_${acq}_dwi_ph_noise.nii.gz" \
	   "${path_dwi_bsl}/${SUBJECT}v1s1_${acq}_dwi_ph.nii.gz" \
	   "${path_dwi_bsl}/${SUBJECT}v1s1_${acq}_dwi_ph_dn.nii.gz"
	done

	# ---------------------- #


	# ------ orig early ------ #

	# 1. mag acquisitions
	for acq in b1pt0k-AP b1pt0k-PA b2pt5k-AP b2pt5k-PA; do
	   echo "proc mag ${acq}..."	    
	   singularity run -B /mnt/work/yyi /share/apps/images/mrtrix.simg dwidenoise \
	   -mask ${mask_origE} \
	   -datatype float32 \
	   -nthreads ${nThreads} \
	   -noise "${path_dwi_origE}/${SUBJECT}v1s2_${acq}_dwi_noise.nii.gz" \
	   "${path_dwi_origE}/${SUBJECT}v1s2_${acq}_dwi.nii.gz" \
	   "${path_dwi_origE}/${SUBJECT}v1s2_${acq}_dwi_dn.nii.gz"	   
	done

	# 2. phase acquisitions
	for acq in b1pt0k-AP b1pt0k-PA b2pt5k-AP b2pt5k-PA; do
	   echo "proc phase ${acq}..."	    
	   singularity run -B /mnt/work/yyi /share/apps/images/mrtrix.simg dwidenoise \
	   -mask ${mask_origE} \
	   -datatype complex64 \
	   -nthreads ${nThreads} \
	   -noise "${path_dwi_origE}/${SUBJECT}v1s2_${acq}_dwi_ph_noise.nii.gz" \
	   "${path_dwi_origE}/${SUBJECT}v1s2_${acq}_dwi_ph.nii.gz" \
	   "${path_dwi_origE}/${SUBJECT}v1s2_${acq}_dwi_ph_dn.nii.gz"
	done

	# ---------------------- #


	# ------ orig late ------ #

	# 1. mag acquisitions
	for acq in b1pt0k-AP b1pt0k-PA b2pt5k-AP b2pt5k-PA; do
	   echo "proc mag ${acq}..."	    
	   singularity run -B /mnt/work/yyi /share/apps/images/mrtrix.simg dwidenoise \
	   -mask ${mask_origL} \
	   -datatype float32 \
	   -nthreads ${nThreads} \
	   -noise "${path_dwi_origL}/${SUBJECT}v2s1_${acq}_dwi_noise.nii.gz" \
	   "${path_dwi_origL}/${SUBJECT}v2s1_${acq}_dwi.nii.gz" \
	   "${path_dwi_origL}/${SUBJECT}v2s1_${acq}_dwi_dn.nii.gz"	   
	done

	# 2. phase acquisitions
	for acq in b1pt0k-AP b1pt0k-PA b2pt5k-AP b2pt5k-PA; do
	   echo "proc phase ${acq}..."	    
	   singularity run -B /mnt/work/yyi /share/apps/images/mrtrix.simg dwidenoise \
	   -mask ${mask_origL} \
	   -datatype complex64 \
	   -nthreads ${nThreads} \
	   -noise "${path_dwi_origL}/${SUBJECT}v2s1_${acq}_dwi_ph_noise.nii.gz" \
	   "${path_dwi_origL}/${SUBJECT}v2s1_${acq}_dwi_ph.nii.gz" \
	   "${path_dwi_origL}/${SUBJECT}v2s1_${acq}_dwi_ph_dn.nii.gz"
	done

	# ---------------------- #



	# ------ post recombi ------ #

	# 1. mag acquisitions
	for acq in b1pt0k-AP b1pt0k-PA b2pt5k-AP b2pt5k-PA; do
	   echo "proc mag ${acq}..."	    
	   singularity run -B /mnt/work/yyi /share/apps/images/mrtrix.simg dwidenoise \
	   -mask ${mask_recombi} \
	   -datatype float32 \
	   -nthreads ${nThreads} \
	   -noise "${path_dwi_recombi}/${SUBJECT}v2s2_${acq}_dwi_noise.nii.gz" \
	   "${path_dwi_recombi}/${SUBJECT}v2s2_${acq}_dwi.nii.gz" \
	   "${path_dwi_recombi}/${SUBJECT}v2s2_${acq}_dwi_dn.nii.gz"	   
	done

	# 2. phase acquisitions
	for acq in b1pt0k-AP b1pt0k-PA b2pt5k-AP b2pt5k-PA; do
	   echo "proc phase ${acq}..."	    
	   singularity run -B /mnt/work/yyi /share/apps/images/mrtrix.simg dwidenoise \
	   -mask ${mask_recombi} \
	   -datatype complex64 \
	   -nthreads ${nThreads} \
	   -noise "${path_dwi_recombi}/${SUBJECT}v2s2_${acq}_dwi_ph_noise.nii.gz" \
	   "${path_dwi_recombi}/${SUBJECT}v2s2_${acq}_dwi_ph.nii.gz" \
	   "${path_dwi_recombi}/${SUBJECT}v2s2_${acq}_dwi_ph_dn.nii.gz"
	done

	# ---------------------- #

done
