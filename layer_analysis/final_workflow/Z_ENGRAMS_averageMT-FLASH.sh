#!/bin/bash

# subjects
IDs=("sub-307v2s2" "sub-308v2s2")

for ids in "${IDs[@]}"; do

	# subject-specific directories
	DIR_SLAB=/Users/yyi/Desktop/ENGRAMS/preproc/"${ids}"/anat
	DIR_OUT=/Users/yyi/Desktop/ENGRAMS/analyses/"${ids}"/anat/mtw

	mkdir -p "${DIR_OUT}"

	for echos in {1..5}; do

		# skullstrip
		mri_synthstrip -i "${DIR_SLAB}"/"${ids}"_run-0"${echos}"_MTw.nii.gz -o "${DIR_OUT}"/"${ids}"_run-0"${echos}"_MTw_stripped.nii.gz -m "${DIR_OUT}"/"${ids}"_run-0"${echos}"_MTw_mask.nii.gz
		# bias-field correct
		N4BiasFieldCorrection \
		  -d 3 \
		  -i "${DIR_SLAB}"/"${ids}"_run-0"${echos}"_MTw.nii.gz \
		  -x ${DIR_OUT}/"${ids}"_run-0"${echos}"_MTw_mask.nii.gz \
		  -s 4 \
		  -b [200] \
		  -c [100x100x70x50,0.0000001] \
		  -o ["${DIR_OUT}"/"${ids}"_run-0"${echos}"_MTw_n4.nii.gz,"${DIR_OUT}"/"${ids}"_run-0"${echos}"_MTw_biasfield.nii.gz]

	done

	# gather them in one space, perfectly aligned
	for echos in {2..5}; do
        antsRegistrationSyNQuick.sh \
            -d 3 \
            -f "${DIR_OUT}"/"${ids}"_run-01_MTw_n4.nii.gz \
            -m "${DIR_OUT}"/"${ids}"_run-0"${echos}"_MTw_n4.nii.gz \
            -t r \
            -o "${DIR_OUT}"/slab"${echos}"_to_slab1_
    done

    # average
    AverageImages 3 "${DIR_OUT}"/hackathon_averaged.nii.gz 0 \
        "${DIR_OUT}"/"${ids}"_run-01_MTw_n4.nii.gz \
        "${DIR_OUT}"/slab2_to_slab1_Warped.nii.gz \
        "${DIR_OUT}"/slab3_to_slab1_Warped.nii.gz \
        "${DIR_OUT}"/slab4_to_slab1_Warped.nii.gz \
        "${DIR_OUT}"/slab5_to_slab1_Warped.nii.gz

done