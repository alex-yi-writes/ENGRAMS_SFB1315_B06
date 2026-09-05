#!/bin/bash

# out: ${roi_dir}/${phase}/${ROI}_layers.nii.gz

for ID in sub-110 #sub-102 sub-103 sub-104 sub-105 sub-106 sub-107 sub-108 sub-109 sub-110 sub-111 sub-201 sub-202 sub-205 sub-207 sub-301 sub-304 sub-305 sub-306 sub-307 sub-308 sub-309 sub-310 sub-311 sub-312 sub-313 sub-314 sub-315 sub-317 sub-319 sub-321
do

    root=/Users/yyi/Desktop/ENGRAMS/derivatives/analyses

    # paths
    path_anat=${root}/${ID}v1s1/anat
    path_trx=${root}/${ID}v1s1/transx
    path_roi=${root}/${ID}v1s1/anat/roi_dwi

    layers_t1=${path_anat}/t1/${ID}v1s1_run-01_T1w_0pt35_bs_equi_volume_layers_bined_3layers.nii.gz

    if [ ! -f "${layers_t1}" ]; then
        echo "layer image not found for ${ID}, skipping, check here: ${layers_t1}"
        continue
    fi

    declare -a LABELS=( bsl      origE      origL      recombi    )
    declare -a SUFFIXES=( v1s1   v1s2       v2s1       v2s2       )
    declare -a TRX_PFX=( t1w2bsldwi_  t1w2origEdwi_  t1w2origLdwi_  t1w2recombidwi_ )

    for i in 0 1 2 3
    do
        label=${LABELS[$i]}
        suffix=${SUFFIXES[$i]}
        trx_pfx=${TRX_PFX[$i]}

        phase_dir=${path_roi}/${label}
        ref_b0=${root}/${ID}${suffix}/dwi/${ID}${suffix}_hifi_b0_brain.nii.gz
        affine=${path_trx}/${trx_pfx}0GenericAffine.txt

        # skip if this session does not exist for this subject
        if [ ! -f "${ref_b0}" ]; then
            echo "  skipping ${ID} ${label}: b0 not found (${ref_b0})"
            continue
        fi

        if [ ! -f "${affine}" ]; then
            echo "  skipping ${ID} ${label}: transform not found (${affine})"
            continue
        fi

        if [ ! -d "${phase_dir}" ]; then
            echo "  skipping ${ID} ${label}: ROI directory not found (${phase_dir})"
            continue
        fi

        # warp layer image into this session's DWI space
        layers_dwi=${path_roi}/layers_on_${label}.nii.gz

        echo "  ${ID} ${label}: warping layer image"
        antsApplyTransforms \
            -d 3 -v 0 \
            -i  ${layers_t1} \
            -r  ${ref_b0} \
            -o  ${layers_dwi} \
            -n  NearestNeighbor \
            -t  ${affine}

        # mask with each binary ROI in this phase directory
        for roi_mask in ${phase_dir}/*.nii.gz
        do
            roi_name=$(basename ${roi_mask} .nii.gz)

            # skip files that are already _layers outputs from a previous run because your time is precious
            [[ "${roi_name}" == *_layers ]] && continue

            out=${phase_dir}/${roi_name}_layers.nii.gz

            fslmaths ${layers_dwi} -mas ${roi_mask} ${out}

        done

        echo "  ${ID} ${label}: done"

    done

    unset LABELS SUFFIXES TRX_PFX

done