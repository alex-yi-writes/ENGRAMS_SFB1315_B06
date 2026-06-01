#!/bin/bash

# Paths
raw_data_dir="/Users/yyi/Desktop/ENGRAMS/sourcedata"    # Directory containing subject data
extracted_dir="/Users/yyi/Desktop/ENGRAMS/sourcedata/tmp"   # Temporary directory for processing
output_dir="/Users/yyi/Desktop/ENGRAMS/"          # Target BIDS directory
config_file="/Users/yyi/Desktop/ENGRAMS/codes/final_workflow/Zs_ENGRAMS_dcm2bids_vf-4.json" # dcm2bids config file
subject_ids=("sub-309")
session_ids=("ses-v1s1" "ses-v1s2" "ses-v2s1" "ses-v2s2")

# loop over ids
for subject in "${subject_ids[@]}"; do
    for session in "${session_ids[@]}"; do

        # define id-specific paths
        subject_raw_dir="${raw_data_dir}/${subject}/${session}/scans"
        #temp_dir="${extracted_dir}/${subject}"/${session}
        if [[ ! -d "${subject_raw_dir}" ]]; then
            echo "skipping $subject - $session because it seems that it does not exist yet... check your data"
            continue
        fi

        echo "Processing subject $subject and $session"
        
        # run
        dcm2bids -d "${subject_raw_dir}" \
                 -p "${subject}" \
                 -s "${session}" \
                 -c "${config_file}" \
                 -o "${output_dir}" 
                 

        # rm -rf "${temp_dir}"
        gzip ${output_dir}/${subject}/${session}/func/*.nii

        echo "finished processing subject $subject - $session"
    done
done