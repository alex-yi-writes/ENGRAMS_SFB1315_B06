import os
import subprocess
import nibabel as nb
import numpy as np
from scipy.ndimage import morphology, generate_binary_structure

# ----------------------------------------------------------------------------- #
# work log:
# 29-04-2025: 
#   - alex started working on this pipeline (to-do: include coregistration step)
#   - decided to write a separate pipeline for coregistration. perhaps it's 
#     better to include a little bit of manual registration with itk-snap        
# ----------------------------------------------------------------------------- #


# ----------------------------------------------------------------------------- #
# prep
# ----------------------------------------------------------------------------- #

path_analysis = "/Volumes/korokdorf/ENGRAMS/preproc/"
laynii_path = "/Users/alex/LayNii_v2.7.0_Mac_M/"

# subjects = [
#     "sub-102v1s1",
#     "sub-104v1s1",
#     "sub-105v1s1",
#     "sub-106v1s1",
#     "sub-107v1s1",
#     "sub-108v1s1",
#     "sub-109v1s1",
#     "sub-202v1s1"
# ]
subjects = [
    "sub-202v1s1",
]

# ----------------------------------------------------------------------------- #
# pipeline
# ----------------------------------------------------------------------------- #

# make sure laynii is visible
os.environ["PATH"] = laynii_path + ":" + os.environ["PATH"]

for subject in subjects:
    try:
        print(f"--- processing {subject} ---")

        path_subject = f"{subject}/anat/"
        IMG_stem = f"{subject}_run-01_T1w_0pt35"

        # ----------------------------------------------------------------------------- #
        # STEP 1: load tissue classes
        # ----------------------------------------------------------------------------- #
        c1_file = path_analysis + path_subject + "p1" + IMG_stem + ".nii.gz" # GM
        c2_file = path_analysis + path_subject + "p2" + IMG_stem + ".nii.gz" # WM

        THRESHOLD_GM = 0.3
        THRESHOLD_WM = 0.7 

        c1_img = nb.load(c1_file)
        c2_img = nb.load(c2_file)
        c1_data = c1_img.get_fdata()  
        c2_data = c2_img.get_fdata()  

        # ----------------------------------------------------------------------------- #
        # STEP 2: create discrete GM=3, WM=2 labels for the masks
        # ----------------------------------------------------------------------------- #
        wm_mask = (c2_data > THRESHOLD).astype(np.int32)
        gm_mask = (c1_data > THRESHOLD).astype(np.int32)

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
        rim_inner = rim_inner - rim_wm # border region (this can produce -1 in places if we don't cast carefully)

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
        # STEP 5: save rims
        # ----------------------------------------------------------------------------- #
        out_fname = path_analysis + path_subject + IMG_stem + "_rim.nii.gz"
        rim_img = nb.Nifti1Image(rim, affine=c1_img.affine, header=c1_img.header)
        nb.save(rim_img, out_fname)

        # where are the files then?
        print(f"Saved rims to: {out_fname}")

        # ----------------------------------------------------------------------------- #
        # STEP 6: equi-voluming starts (takes super long)
        # ----------------------------------------------------------------------------- #
        rim_file = out_fname
        layers_file = rim_file.replace("_rim.nii.gz", "_rim_layers.nii.gz")
        leaky_layers_file = rim_file.replace("_rim.nii.gz", "_rim_leaky_layers.nii.gz")
        final_output_name = out_fname = path_analysis + path_subject + IMG_stem

        cmds = [
            ["LN_GROW_LAYERS", "-rim", rim_file, "-N", "500", "-vinc", "40", "-threeD"],
            ["LN_LEAKY_LAYERS", "-rim", rim_file, "-nr_layers", "500", "-iterations", "100"],
            ["LN_LOITUMA", "-equidist", layers_file, "-leaky", leaky_layers_file, "-FWHM", "0.5", "-nr_layers", "13", "-output", final_output_name]
        ]
        # why those parameters:
        # after multiple testings with various values and seeing the test dataset provided by laynii (with 0.2mm isotropic voxel sizes), i needed to adjust (1) LN_GROW_LAYERS -N into 500, because it made rims too thin and noisy; (2) LN_GROW_LAYERS -vinc to 40 because i have bigger voxel dimensions; (3) LN_LOITUMA -FWHM to 0.7 to avoid blurring layers together; and (4) LN_LOITUMA -nr_layers to 13 because sharoh et al also used 13

        for cmd in cmds:
            subprocess.run(cmd, check=True)

        print(f"layers generated for: {subject}")

        # ----------------------------------------------------------------------------- #
        # STEP 7: combine layers into 3 bins (deep/mid/superficial, like sharoh et al. [2019, PNAS] did) 
        # ----------------------------------------------------------------------------- #
        print(f"binning layers into 3 bins for: {subject}")

        # # approach 1
        # layer_img = nb.load(layers_file)
        # layer_data = layer_img.get_fdata()

        # n_layers = np.max(layer_data)
        # deep_threshold = n_layers // 3
        # middle_threshold = 2 * n_layers // 3

        # binned_layers = np.zeros_like(layer_data, dtype=np.int8)
        # binned_layers[(layer_data > 0) & (layer_data <= deep_threshold)] = 1  # Deep
        # binned_layers[(layer_data > deep_threshold) & (layer_data <= middle_threshold)] = 2  # Middle
        # binned_layers[(layer_data > middle_threshold)] = 3  # Superficial

        # out_file = layers_file.replace("_layers.nii.gz", "_bined_3layers.nii")
        # binned_img = nb.Nifti1Image(binned_layers, affine=layer_img.affine, header=layer_img.header)
        # nb.save(binned_img, out_file)

        # approach 2
        layers_file = final_output_name + "_equi_volume_layers.nii"
        layer_img = nb.load(layers_file)
        layer_data = layer_img.get_fdata()

        # combine into 3 bins
        # how i selected these thresholds: visually inspect, and bin layer I, II, and III into superficial layer; IV into middle layer; and V and VI into deep layer
        binned_layers = np.zeros_like(layer_data, dtype=np.int8)
        # binned_layers[(layer_data >= 4) & (layer_data <= 5)] = 1  # deep
        binned_layers[(layer_data >= 4) & (layer_data <= 6)] = 1  # deep: this one looks too conservative but it is less wrong than the other option
        binned_layers[(layer_data >= 7) & (layer_data <= 10)] = 2  # middle
        binned_layers[(layer_data >= 11) & (layer_data <= 12)] = 3  # superficial

        # save
        out_file = layers_file.replace(".nii", "_bined_3layers.nii")
        nb.save(nb.Nifti1Image(binned_layers, layer_img.affine, layer_img.header), out_file)

        print(f"saved layers to: {out_file}")

    except Exception as e:
        print(f"!!! error with {subject}: {e}") # catch in case something goes wrong but proceed to the next subject anyway
        continue
