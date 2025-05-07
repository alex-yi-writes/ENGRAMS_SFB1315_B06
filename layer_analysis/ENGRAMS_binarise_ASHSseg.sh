#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <segmentation.nii.gz> <output_dir>"
  exit 1
fi

SEG="$1"
OUTDIR="$2"

# ensure FSL is loaded (adjust if your FSLDIR is elsewhere)
if [[ -z "${FSLDIR:-}" ]]; then
  echo "FSLDIR not set – source your FSL setup (e.g. 'source \$FSLDIR/etc/fslconf/fsl.sh')"
  exit 1
fi

if [[ ! -f "$SEG" ]]; then
  echo "error: segmentation file '$SEG' not found."
  exit 1
fi

mkdir -p "$OUTDIR"

labels=(1 2 3 4 5 6 7 8 9 10 11 12 13 17 101 102 103 104 105 106 107 108 109 110 111 112 113 117)
rois=(CA1_L CA2_L DG_L CA3_L Tail_L Label6_L Label7_L Sub_L ErC_L A35_L A36_L PhC_L Cysts_L Label17_L \
      CA1_R CA2_R DG_R CA3_R Tail_R Label6_R Label7_R Sub_R ErC_R A35_R A36_R PhC_R Cysts_R Label17_R)

for i in "${!labels[@]}"; do
  lbl=${labels[i]}
  roi=${rois[i]}
  out="${OUTDIR}/${roi}.nii.gz"
  echo "→ binarising label $lbl to ${roi}.nii.gz"
  fslmaths "$SEG" -thr "$lbl" -uthr "$lbl" -bin "$out"
done

echo "all subfield masks saved in $OUTDIR. don't forget to check if they actually look OK!"
