import os
import nibabel as nb
import numpy as np
from scipy.ndimage import morphology, generate_binary_structure

# ----------------------------------------------------------------------------- #
# 0) preparation
# ----------------------------------------------------------------------------- #

path_analysis = "/Users/yyi/Desktop/ENGRAMS/analyses/"
path_subject = "sub-102v1s1/102_dwi/"
IMG_stem = "mT1_0pt5" # what are the input image name stem? need this for saving the outputs later

# ----------------------------------------------------------------------------- # 
# STEP 1: run CAT12 first and then load probabilistic tissue classes (need two):
#    p1* = GM
#    p2* = WM
# * note: originally, i ran spm12 segment for this step, but the performance was
#        suboptimal - cat12 takes much longer, but performs better
# ----------------------------------------------------------------------------- #
#c1_file = path_analysis + path_subject + "c1" + IMG_stem + ".nii" # GM
# c2_file = path_analysis + path_subject + "c2" + IMG_stem + ".nii" # WM
c1_file = path_analysis + path_subject + "mri/p1" + IMG_stem + ".nii" # GM
c2_file = path_analysis + path_subject + "mri/p2" + IMG_stem + ".nii" # WM

# probability threshold for binarisation
THRESHOLD = 0.3 

c1_img = nb.load(c1_file)
c2_img = nb.load(c2_file)
c1_data = c1_img.get_fdata()  
c2_data = c2_img.get_fdata()  

# ----------------------------------------------------------------------------- #
# STEP 2: create discrete GM=3, WM=2 labels for the masks
# ----------------------------------------------------------------------------- #
wm_mask = (c2_data > THRESHOLD).astype(np.int32)  # was label=1 here initially
gm_mask = (c1_data > THRESHOLD).astype(np.int32)  # was label=1 here initially

wm_mask[wm_mask == 1] = 2
gm_mask[gm_mask == 1] = 3

# ----------------------------------------------------------------------------- #
# STEP 3: morphological ops to define rim borders
# ----------------------------------------------------------------------------- #
# WM mask for morphological ops
rim_wm = np.zeros_like(wm_mask)
rim_wm[wm_mask == 2] = 1

struct = generate_binary_structure(3, 3)
rim_inner = morphology.binary_erosion(rim_wm, structure=struct, iterations=2)
rim_inner = rim_inner - rim_wm  # border region (this can produce -1 in places if we don't cast carefully)

# GM mask
rim_gm = np.zeros_like(gm_mask)
rim_gm[gm_mask == 3] = 3

# outer GM border (dilation)
rim_out = morphology.binary_dilation(rim_gm, structure=struct, iterations=2)

# ----------------------------------------------------------------------------- #
# STEP 4: assemble everything into one file:
#    rim_out = 1
#    rim_inner = 2
#    rim_gm = 3
# ----------------------------------------------------------------------------- #
rim = np.zeros_like(c1_data, dtype=np.int32)
rim[rim_out != 0] = 1
rim[rim_inner != 0] = 2
rim[rim_gm != 0] = 3

# ----------------------------------------------------------------------------- #
# 5) save
# ----------------------------------------------------------------------------- #
out_fname = path_analysis + path_subject + IMG_stem + "_rim.nii.gz"
rim_img = nb.Nifti1Image(rim, affine=c1_img.affine, header=c1_img.header)
nb.save(rim_img, out_fname)

# where are the files then?
print(f"saved rims to: {out_fname}")
