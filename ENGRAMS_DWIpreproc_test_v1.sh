#!/bin/bash

# separate subjects into single scripts for parallel computing
SUBJECT="sub-102"

# places
DATA_DIR="/Users/alex/Dropbox/paperwriting/1315/data/mri_control/${SUBJECT}/dwi"
OUTPUT_DIR="/Users/alex/Dropbox/paperwriting/1315/data/mri_control/${SUBJECT}/preproc/dwi"

mkdir -p "$OUTPUT_DIR"


##########################################################################
# start with TOPUP, assuming the images are already converted to niftii  #
# 22-10-2024: all dwi images are now in BIDS format - use that one!!!!   #
# scripts/ENGRAMS_BIDS_pipeline_vFinal.sh (main pipeline)                #
# & scripts/ENGRAMS_dcm2bids_new.json (config) : uses dcm2bids           #
##########################################################################

# FSL tutorial: A minimum requirement for using topup for correcting distortions is that two spin-echo (SE) EPI images with different PE-directions have been acquired. The best is to acquire them with opposing PE-directions (i.e. A→P AND P→A or L→R AND R→L). An SE-EPI image is the same as a b=0 image acquired as a part of a diffusion protocol. Just as for fieldmaps this pair must be acquired at the same occasion as the full diffusion protocol and the subject must not leave the scanner in between and no re-shimming can be done.

# FSL tutorial: Identifying susceptibility-induced distortions
# From the dwidata choose a volume without diffusion weighting (e.g. the first volume). You can now extract this as a standalone 3D image, using fslroi. Figure out this command by yourself. Typing fslroi into the terminal will produce instructions on how to use fslroi. Call the extracted file nodif.

####### ===== STEP 1: merge b0 images from AP and PA directions (run-01 only because the run-02, part-phase images looked super weird... i think run-01 should be the correct one) ===== #######

echo "extracting b0 images"

# ******************** #
fslroi "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-AP_dwi.nii.gz" "$OUTPUT_DIR/${SUBJECT}_AP_b0.nii.gz" 0 1
fslroi "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-PA_dwi.nii.gz" "$OUTPUT_DIR/${SUBJECT}_PA_b0.nii.gz" 0 1
# ******************** #

# FSL tutorial: Open nodif in FSLeyes and have a look at different slices. Notice that as you go to more inferior slices, the frontal part of the brain starts to appear distorted (e.g. "squashed" or "elongated"). These distortions are always present in EPI images and are caused by differences in the magnetic susceptibilities of the areas being imaged.

# FSL tutorial: Now open and superimpose in FSLeyes the image nodif_PA. This is an image without diffusion-weighting (i.e. b=0) of the same subject that has been acquired with the opposite PE direction (Posterior→Anterior). Switch on and off the visibility of this image to see how the distortions change sign between nodif and nodif_PA. Regions that are squashed in the first appear elongated in the second and vice versa. Unsurprisingly the areas that were very obviously distorted when viewed in the nodif image changes a lot as you switch back and forth between nodif and nodif_PA. Perhaps more disturbing is that some areas that didn't appear obviously distorted do too, meaning that these are also distorted, only not quite so obvious. For example look at the Cerebellum in a sagittal view at ~x=58 as you switch back and forth. We will correct these distortions by combining the two b=0 images using the TOPUP tool. We will then pass the results on to the EDDY tool where it will be applied to the correction of all diffusion data.

# Now we actually preparing to run TOPUP
# FSL tutorial: First you need to merge the AP and PA images into a single image using fslmerge. Again, typing fslmerge into the command line will bring up helpful instructions. Merge the files along the 4th 'timeseries' axis. Call the merged image b0_AP_PA.

# ******************** #
fslmerge -t "$OUTPUT_DIR/${SUBJECT}_b0_AP_PA.nii.gz" "$OUTPUT_DIR/${SUBJECT}_AP_b0.nii.gz" "$OUTPUT_DIR/${SUBJECT}_PA_b0.nii.gz"
# ******************** #

# FSL tutorial: Then create a text file that contains the information with the PE direction, the sign of the AP and PA volumes and some timing information obtained by the acquisition. This file has already been created (acqparams.txt), and is a text-file that contains

####### ===== STEP 2: create acquisition parameters file for TOPUP ===== #######

# ******************** #
echo "creating acquisition parameters file"
cat <<EOT > "$OUTPUT_DIR/acqparams.txt"
0 1 0 0.05
0 -1 0 0.05
EOT
# ******************** #

# FSL tutorial: The first three elements of each line comprise a vector that specifies the direction of the phase encoding. The non-zero number in the second column means that is along the y-direction. A -1 means that k-space was traversed Anterior→Posterior and a 1 that it was traversed Posterior→Anterior. The final column specifies the "total readout time", which is the time (in seconds) between the collection of the centre of the first echo and the centre of the last echo. In the FAQ section of the online help for topup there are instructions for how to find this information for Siemens scanners.

# FSL tutorial: The file should contain as many entries as there are volumes in the image file that is passed to topup.

# We are now ready to run topup which we would do with the command:

####### ===== STEP 3: run TOPUP for distortion correction ===== #######

# ******************** #
echo "running TOPUP: this can take very long - do something else meantime"
topup --imain="$OUTPUT_DIR/${SUBJECT}_b0_AP_PA.nii.gz" \
      --datain="$OUTPUT_DIR/acqparams.txt" \
      --config=b02b0.cnf \
      --out="$OUTPUT_DIR/${SUBJECT}_topup_results" \
      --iout="$OUTPUT_DIR/${SUBJECT}_hifi_b0_tmp.nii.gz"
echo 'TOPUP done'
# FSL tutorial: This will generate a file named hifi_nodif.nii.gz where both input images have been combined into a single distortion-corrected image.
# ******************** #

####### ===== STEP 4: Extract brain from corrected b0 image ===== #######
# FSL tutorial: We will first generate a brain mask using the corrected b0. We compute the average image of the corrected b0 volumes using fslmaths. Figure out the correct command, calling the output file hifi_nodif.
echo "extracting tissue"
fslmaths "$OUTPUT_DIR/${SUBJECT}_hifi_b0_tmp.nii.gz" -Tmean "$OUTPUT_DIR/${SUBJECT}_hifi_b0.nii.gz"
# matlab -nodisplay -nosplash -r "run('/Users/alex/Dropbox/paperwriting/alextools/yy_skullstripping_SPM_20200211.m'); yy_skullstripping_SPM_20200211($OUTPUT_DIR/${SUBJECT}_hifi_b0.nii.gz, $OUTPUT_DIR/${SUBJECT}_nodif_brain_mask.nii.gz); exit;"
bet "$OUTPUT_DIR/${SUBJECT}_hifi_b0.nii.gz" "$OUTPUT_DIR/${SUBJECT}_nodif_brain.nii.gz" -m -f 0.15

# ####### ===== STEP 5: Concatenate DWI data (b1pt0k and b2pt5k from run-01 only) ===== #######
echo "merging DWI data"
fslmerge -t "$OUTPUT_DIR/${SUBJECT}_all_dwi.nii.gz" \
    "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-AP_dwi.nii.gz" \
    "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-PA_dwi.nii.gz" \
    "$DATA_DIR/${SUBJECT}_run-01_b2pt5k-AP_dwi.nii.gz" \
    "$DATA_DIR/${SUBJECT}_run-01_b2pt5k-PA_dwi.nii.gz"

####### ===== STEP 6: Concatenate bvecs and bvals (run-01 only) ===== #######
echo "concatenating bvecs and bvals"
paste -d ' ' "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-AP_dwi.bvec" \
              "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-PA_dwi.bvec" \
              "$DATA_DIR/${SUBJECT}_run-01_b2pt5k-AP_dwi.bvec" \
              "$DATA_DIR/${SUBJECT}_run-01_b2pt5k-PA_dwi.bvec" > "$OUTPUT_DIR/${SUBJECT}_all.bvec"

cat "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-AP_dwi.bval" \
    "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-PA_dwi.bval" \
    "$DATA_DIR/${SUBJECT}_run-01_b2pt5k-AP_dwi.bval" \
    "$DATA_DIR/${SUBJECT}_run-01_b2pt5k-PA_dwi.bval" > "$OUTPUT_DIR/${SUBJECT}_all.bval"
awk '{printf "%s ", $0} END {print ""}' "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-AP_dwi.bval" \
                                        "$DATA_DIR/${SUBJECT}_run-01_b1pt0k-PA_dwi.bval" \
                                        "$DATA_DIR/${SUBJECT}_run-01_b2pt5k-AP_dwi.bval" \
                                        "$DATA_DIR/${SUBJECT}_run-01_b2pt5k-PA_dwi.bval" > "$OUTPUT_DIR/${SUBJECT}_all.bval"
echo "validating concatenated files"
awk '{print NF}' "$OUTPUT_DIR/${SUBJECT}_all.bvec"
awk '{print NF}' "$OUTPUT_DIR/${SUBJECT}_all.bval"
fslval "$OUTPUT_DIR/${SUBJECT}_all_dwi.nii.gz" dim4
##########################################################################


##########################################################################
#     now we run EDDY, which correct for eddy currents in the images     #
##########################################################################

####### ===== STEP 7: Correct for eddy currents and motion ===== #######

# create the index file for EDDY
nvols=$(fslval "$OUTPUT_DIR/${SUBJECT}_all_dwi.nii.gz" dim4) # identify how many vols there are
echo "making index file for EDDY"
for ((i=1; i<=nvols; i++)); do echo "1"; done > "$OUTPUT_DIR/index.txt"

echo "running EDDY"
eddy --imain="$OUTPUT_DIR/${SUBJECT}_all_dwi.nii.gz" \
     --mask="$OUTPUT_DIR/${SUBJECT}_nodif_brain_mask.nii.gz" \
     --acqp="$OUTPUT_DIR/acqparams.txt" \
     --index="$OUTPUT_DIR/index.txt" \
     --bvecs="$OUTPUT_DIR/${SUBJECT}_all.bvec" \
     --bvals="$OUTPUT_DIR/${SUBJECT}_all.bval" \
     --topup="$OUTPUT_DIR/${SUBJECT}_topup_results" \
     --out="$OUTPUT_DIR/${SUBJECT}_eddy_corrected"

echo 'EDDY done'
##########################################################################


##########################################################################
#               run DTIFIT to acquire mean diffusivity data              #
##########################################################################

# FSL tutorial: The directory already contains bvals, bvecs, distortion-corrected data file named data and a brain mask named nodif_brain_mask. These are the four files that a standard FDT directory should be comprised of, before running dtifit or any further data analysis. The files are a sub-set of the data we have been working on so far, comprising only b=0 and b=1500 volumes. Here we select a single shell as the tensor is not a good model for multi-shell data.

# You can run DTIFIT (the FSL diffusion tensor fitting program) in one of three ways, all described below. Choose one of these approaches:

# 1: Run DTIFIT on a FDT directory
# Open the FDT GUI by typing Fdt (or Fdt_gui on a Mac), and select DTIFIT from the main menu (the button in the top that initially says PROBTRACKX).

# You can run DTIFIT on a standard FDT directory by selecting the input directory (subj1 - go up one directory in the file browser to be able to select this) and then pressing Go. NB: When DTIFIT has finished running via the GUI, a small dialogue window will pop up saying Done! You must press Ok to close this window before closing the main FDT GUI otherwise you will recieve an error message (beware: this dialogue can pop up in a completely different and unexpected part of the screen).

# 2: Run DTIFIT by manually specifying the input files
# Open the FDT GUI by typing Fdt (or Fdt_gui on a Mac), and select DTIFIT from the main menu (the button in the top that initially says PROBTRACKX).

# You can select the input files manually by clicking Specify input files manually, then select the following files for the relevant tabs:

# Diffusion weighted data:   data
# BET binary brain mask:   nodif_brain_mask
# Output basename:   dti
# Gradient directions:   bvecs
# b values:   bvals
# When you have entered all of the file name, press Go.

####### ===== STEP 8: fit diffusion tensor ===== #######
echo "fitting diffusion tensor and generating MD..."
# this works, this command line was generated via GUI
dtifit --data="$OUTPUT_DIR/${SUBJECT}_eddy_corrected.nii.gz" \
       --out="$OUTPUT_DIR/${SUBJECT}_dti" \
       --mask="$OUTPUT_DIR/${SUBJECT}_nodif_brain_mask.nii.gz" \
       --bvecs="$OUTPUT_DIR/${SUBJECT}_all_corrected.bvec" \
       --bvals="$OUTPUT_DIR/${SUBJECT}_all_corrected.bval" \
       --sse \
       --save_tensor

# this didn't work. should have known when it took almost 50 hours to run. but why though? bummer...
# dtifit --data="$OUTPUT_DIR/${SUBJECT}_eddy_corrected.nii.gz" \
#        --mask="$OUTPUT_DIR/${SUBJECT}_nodif_brain_mask.nii.gz" \
#        --bvecs="$DATA_DIR/${SUBJECT}_all.bvec" \
#        --bvals="$DATA_DIR/${SUBJECT}_all.bval" \
#        --out="$OUTPUT_DIR/${SUBJECT}_dti"

# outputs from DTIFIT
# ${SUBJECT}_dti_FA.nii.gz - fractional anisotropy
# ${SUBJECT}_dti_MD.nii.gz - mean diffusivity ***
# ${SUBJECT}_dti_L1.nii.gz - first eigenvalue (axial diffusivity) ***
# ${SUBJECT}_dti_L2.nii.gz - second eigenvalue
# ${SUBJECT}_dti_L3.nii.gz - third eigenvalue

########## FSL tutorial ##########

# DTI output
# When you have run dtifit using any of these three ways, load the anisotropy map dti_FA into FSLeyes

# Add the principal eigenvector map to your display: File -> Add overlay from file -> dti_V1

# FSLeyes should open the image as a 3-direction vector image (RGB). Diffusion direction is now coded by colour. For a more interpretable image, we can modulate the colour intensity with the FA map so anisotropic voxels appear bright. In the display panel () change the Modulate by setting to dti_FA. You may wish to adjust the brightness and contrast settings.

# Change the Modulate by setting back to None, and then change the Overlay data type to 3-direction vector image (Line). Zoom in and out of your data. You should see clear white matter pathways through the vector field.

# Finally, change the Overlay data type to 3D/4D volume. The image should now look quite messy - you are looking at the first (X) component (the first volume) of the vector in each voxel. The second and third volumes contain the Y and Z components of the vector.

# Now load the Mean Diffusivity map (dti_MD) into FSLeyes. Change the minimum/maximum display range values to 0 and 0.001 respectively.

# Compare the values of MD and L1 in CSF, white and gray matter.

##########################################################################

