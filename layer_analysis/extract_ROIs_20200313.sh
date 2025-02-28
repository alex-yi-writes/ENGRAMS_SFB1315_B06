#!/bin/bash

# generate individual masks for perfusion analyses

path=${path}

# subject folders in ${path}
ls -d "${path}"/*/ > "${path}"/cc280_2.txt

while read folder; do

	# subject ID
	ID=$(echo "${folder}" | grep -o -E '[0-9][0-9][0-9][0-9][0-9][0-9]')

  ######################## high density regions ########################

  # hippocampus, left (label 17)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 17 -uthr 17 ${path}/done/Hippocampus_L_${ID}.nii

  # hippocampus, right (label 53)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 53 -uthr 53 ${path}/done/Hippocampus_R_${ID}.nii

  # BA24(cingulate gyrus), left (label 1026+1002)
  # extract each
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 1026 -uthr 1026 ${path}/done/MCC_L_${ID}.nii
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 1002 -uthr 1002 ${path}/done/ACC_L_${ID}.nii
  # combine
  fslmaths ${path}/done/MCC_L_${ID}.nii -add ${path}/done/ACC_L_${ID}.nii ${path}/done/BA10_L_${ID}.nii
  # clean up
  rm ${path}/done/MCC_L_${ID}.nii.gz ${path}/done/ACC_L_${ID}.nii.gz

  # BA24(cingulate gyrus), right (label 2026+2002)
  # extract each
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 2026 -uthr 2026 ${path}/done/MCC_R_${ID}.nii
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 2002 -uthr 2002 ${path}/done/ACC_R_${ID}.nii
  # combine
  fslmaths ${path}/done/MCC_R_${ID}.nii -add ${path}/done/ACC_R_${ID}.nii ${path}/done/BA10_R_${ID}.nii
  # clean up
  rm ${path}/done/MCC_R_${ID}.nii.gz ${path}/done/ACC_R_${ID}.nii.gz

  # BA7(precuneus), left (label 1029)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 1029 -uthr 1029 ${path}/done/BA7_L_${ID}.nii

  # BA7(precuneus), right (label 2029)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 2029 -uthr 2029 ${path}/done/BA7_R_${ID}.nii

  ######################################################################


  ######################## low density regions #########################

  # BA10(aPFC), left (label 1032)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 1032 -uthr 1032 ${path}/done/BA10_L_${ID}.nii

  # BA10(aPFC), right (label 2032)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 2032 -uthr 2032 ${path}/done/BA10_R_${ID}.nii

  # caudate, left (label 11)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 11 -uthr 11 ${path}/done/caudate_L_${ID}.nii

  # caudate, right (label 50)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 50 -uthr 60 ${path}/done/caudate_R_${ID}.nii

  # putamen, left (label 12)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 12 -uthr 12 ${path}/done/putamen_L_${ID}.nii

  # putamen, right (label 51)
  fslmaths ${path}/${ID}/${ID}/mri/aparc+aseg.nii -thr 51 -uthr 51 ${path}/done/putamen_R_${ID}.nii

  ######################################################################

  cp ${path}/${ID}/${ID}/mri/aparc+aseg.nii ${path}/done/${ID}_aparc+aseg.nii

  echo "ID ${ID} DONE!"

done < "${path}"/cc280_2.txt
