#!/bin/bash

# Paths
raw_data_dir="/Users/alex/Dropbox/paperwriting/1315/data/mri_control/raw"    # Directory containing subject data
extracted_dir="/Users/alex/Dropbox/paperwriting/1315/data/mri_control/tmp"   # Temporary directory for processing
output_dir="/Users/alex/Dropbox/paperwriting/1315/data/mri_control"          # Target BIDS directory
config_file="/Users/alex/Dropbox/paperwriting/1315/script/ENGRAMS_dcm2bids_new.json" # dcm2bids config file
subject_ids=("102")   #("101" "102" "103")                                              # List of subject IDs

# loop over ids
for subject in "${subject_ids[@]}"; do
    echo "Processing subject $subject"

    # define id-specific paths
    subject_raw_dir="${raw_data_dir}/${subject}/scans"
    temp_dir="${extracted_dir}/${subject}"
    
    # run
    dcm2bids -d "${subject_raw_dir}" \
             -p "${subject}" \
             -c "${config_file}" \
             -o "${output_dir}" 

    # rm -rf "${temp_dir}"

    echo "finished processing subject $subject"
done
