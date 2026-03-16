#!/bin/bash

# subjects
IDs=("ygh350_x253")

for ids in "${IDs[@]}"; do

	# subject-specific directories
	DIR_SLAB=/Users/yyi/Downloads/$ids
	DIR_OUT=/Users/yyi/Downloads/$ids

	for echos in {1..5}; do

		# skullstrip
		mri_synthstrip -i ${DIR_SLAB}/hackathon4.nii.gz -o ${DIR_OUT}/hackathon"${echos}"_stripped.nii.gz -m ${DIR_OUT}/hackathon"${echos}"_mask.nii.gz
		# bias-field correct
		N4BiasFieldCorrection \
		  -d 3 \
		  -i ${DIR_OUT}/hackathon"${echos}".nii.gz \
		  -x ${DIR_OUT}/hackathon"${echos}"_mask.nii.gz \
		  -s 4 \
		  -b [200] \
		  -c [100x100x70x50,0.0000001] \
		  -o [${DIR_OUT}/hackathon${echos}_n4.nii.gz,${DIR_OUT}/hackathon${echos}_biasfield.nii.gz]

	done

	# gather them in one space, perfectly aligned
	for echos in {2..5}; do
        antsRegistrationSyNQuick.sh \
            -d 3 \
            -f ${DIR_OUT}/hackathon1_n4.nii.gz \
            -m ${DIR_OUT}/hackathon${echos}_n4.nii.gz \
            -t r \
            -o ${DIR_OUT}/slab${echos}_to_slab1_
    done

    # average
    AverageImages 3 ${DIR_OUT}/hackathon_averaged.nii.gz 0 \
        ${DIR_OUT}/hackathon1_n4.nii.gz \
        ${DIR_OUT}/slab2_to_slab1_Warped.nii.gz \
        ${DIR_OUT}/slab3_to_slab1_Warped.nii.gz \
        ${DIR_OUT}/slab4_to_slab1_Warped.nii.gz \
        ${DIR_OUT}/slab5_to_slab1_Warped.nii.gz

done