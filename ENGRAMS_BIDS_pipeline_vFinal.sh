#!/bin/bash

# Paths
raw_data_dir="/Users/yyi/Desktop/ENGRAMS/raw"    # Directory containing subject data
extracted_dir="/Users/yyi/Desktop/ENGRAMS/preproc/tmp"   # Temporary directory for processing
output_dir="/Users/yyi/Desktop/ENGRAMS/preproc"          # Target BIDS directory
config_file="/Users/yyi/Desktop/ENGRAMS/scripts/ENGRAMS_dcm2bids_new.json" # dcm2bids config file
subject_ids=("102v2s2") #("101v1s1" "101v1s2" "101v2s1" "101v2s2" "102v1s1" "102v1s2" "102v2s1" "102v2s2" "103v1s1" "103v1s2" "103v2s1" "103v2s2")                  # List of subject IDs

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

    rm -rf "${temp_dir}"

    echo "finished processing subject $subject"
done
