#!/bin/bash

echo "starting ALF: Amlpitude from low frequancy Fluctuations"

# ALF_melmac_ENGRAMS.sh  <4D_BOLD.nii[.gz]>
# creates: fslFFT_<in>.nii.gz   (power-spectrum)
#          AFL_<in>.nii.gz      (ALF map, scaled)
# 20250527: alex wrote this because she doesn't have afni

set -e
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "usage: $0 4D_BOLD.nii.gz [out_dir]"; exit 1
fi
in="$1"
outdir="${2:-$(dirname "$in")}"        # default = same folder
mkdir -p "$outdir"

in="$1"
base=$(basename "$in") # e.g. bold.nii.gz
echo ">>> ALF: low-freq amplitude from $base"

# 1. voxwise power spectrum (freq in 4th dim)
fslpspec "$in"  "$outdir/fslFFT_${base}"

# 2. mean across all frequency bins -> voxelwise ALF
fslmaths "$outdir/fslFFT_${base}" -Tmean "$outdir/AFL_${base}"

# 3. scale (just like from laynii tutorial)
fslmaths "$outdir/AFL_${base}" -div 10000 "$outdir/AFL_${base}"

echo "created: AFL_${base}"


### from here on the original code from LAYNII blog ###

# fslpspec "$1" "fslFFT_$1"

# 3dTstat -mean -prefix "AFL_$1" -overwrite "fslFFT_$1" 

# 3dcalc -a "AFL_$1" -expr 'a/10000' -prefix "AFL_$1" -overwrite


#3dcalc -a "mean_fslFFT_$1" -b "fslFFT_$1" -expr 'b/a' -prefix "fslFFT_$1" -overwrite

#rm "mean_fslFFT_$1"



#3dTstat -mean -overwrite -prefix "ALF_$1" "fslFFT_$1"'[2..20]'  

#3dcalc -a "mean_fslFFT_$1" -b "ALF_$1" -expr 'b/a' -prefix "normaliced_ALF_$1" -overwrite

#######

echo "done: I expect: ALF_melmac.sh Dataset_timeseries.nii" # original code's echo

 
