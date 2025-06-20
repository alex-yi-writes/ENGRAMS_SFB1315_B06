#!/bin/bash 

# TOPUP is somehow generaing NaN values in my images and they're messing up the deveining step... manually fixing the headers because i couldn't find a better way

for s in sub-111 sub-205; do
  for t in rest origenc origrec; do
    for f in /Users/alex/Dropbox/paperwriting/1315/data/segmentation/${s}v1s1/func/ar${s}*task-${t}*_bold_topup.nii.gz; do
      [ -e "$f" ] || continue
      out=${f%.nii.gz}_fixed.nii.gz
      echo "creating $out"
      fslmaths "$f" -nan "$out" -odt float
    done
  done
done
