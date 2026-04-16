# ENGRAMS layer analysis pipeline

**contact:** yeo-jin (alex) yi, yeo-jin.yi@med.ovgu.de

---

## overview

this directory contains scripts for the laminar fMRI analysis of the ENGRAMS study. the goal is to characterise layer-specific functional connectivity between memory-relevant cortical regions (mPFC, RSC, EC) and the hippocampus across different memory consolidation tasks.

the pipeline involves: upsampling and segmenting the T1w, generating equivolumetric layer masks via LayNii, registering brainstem nuclei from MNI space, running whole-brain parcellation via FreeSurfer, moving everything into fMRI task space, cleaning up physiological noise with aCompCor, deveining the fMRI data with LayNii, and finally computing layer-specific connectivity per subject and as well as group-level statistics.

most steps run locally (mac or linux). the one exception is `ENGRAMS_WBseg_reconall_*.sh`, which runs on hydra cluster because recon-all on 0.35mm data takes kind of forever.

also, wildcards are used in the script names here and there because i'm still trying to figure out the ways to optimise the pipeline and analysis workflows. the scripts are version controlled and you can see the history of the deprecated scripts in the [`bin`](./bin/) folder.

**note on fMRI preprocessing:** the fMRI data (TOPUP distortion correction, realignment) must be preprocessed before this pipeline reaches step 10. for the TOPUP preprocessing script, see the [ENGRAMS_SFB1315 repository](https://github.com/alex-yi-writes/ENGRAMS_SFB1315/blob/main/fmri_analysis/ENGRAMS_distortionCorrect_fMRI_Day1.sh). smooth your data only for GLM analyses; use unsmoothed data for everything here.

---
## 🔥🔥🔥 an update (16-04-2026): i have now uploaded a (hopefully) final workflow to this repository. if you order the scripts by filename, you can just run them from top to bottom sequentially.
---

## workflow overview (it's a big one)

```
[local unix]
        |
        v
 (1) preprocess fMRI datasets
        |   TOPUP or fieldmap-based unwarping (external, see fmri_analysis/)
        |   smooth only for GLM; use unsmoothed for layer analysis
        v
 (2) ENGRAMS_prepareLayerMasks.m  [B0-correct T1w]
        |   SPM12 segmentation on upsampled T1w for B0 inhomogeneity correction
        v
 (3) ENGRAMS_prepareLayerMasks.m  [upsample T1w]
        |   ANTs ResampleImage -> 0.35mm iso
        v
 (3b) ENGRAMS_transform_MNI.sh   *** added 20260331 ***
        |   register MNI brainstem ROIs (LC, SN, VTA) to native T1w space
        v
 (3c) ENGRAMS_merge_brainstem_ROIs.m   *** added 20260331 ***
        |   merge brainstem masks into CAT12 GM probability map
        v
 (4) ASHS
        |   segment hippocampal subfields via ASHS (hydra or ASHS DSS whichever)
        v
 (5) ENGRAMS_prepareLayerMasks.m  [segment GM/WM]
        |   CAT12 segmentation -> binarise GM (>0.7) and WM (>0.3)
        v
 (6) ENGRAMS_LAYERS_pipeline_v*.py
        |   generate rim, equivolumetric layers (15 bins -> 3-bin deep/mid/sup)
        |   and column masks via LayNii
        v
 (7) ENGRAMS_prepareLayerMasks.m  [whole-brain mask]
        |   CAT12 skullstrip -> whole-brain binary mask

[hydra cluster]
        |
        v
 (8) ENGRAMS_WBseg_reconall_*.sh
        |   3-stage FreeSurfer recon-all on 0.35mm T1w (hires expert opts)
        |   outputs aparc+aseg parcellation

[back to local unix]
        |
        v
 (9) ENGRAMS_WBseg_postprocessing.sh
        |   convert aparc+aseg to niftii, backtransform to native T1w space
        v
 (10) ENGRAMS_createROImasks_*.m
        |   create layer-specific binary ROI masks (mPFC, RSC, EC per layer)
        |   create dilated coregistration guide masks

[fMRI preprocessing must be completed before step 11]

        v
 (11) ENGRAMS_transform_ROIs_postTOPUP_Day1_v*.sh  (and Day2 equivalent)
        |   move all native ROIs + layer files into each fMRI task space
        |   also moves ASHS hippocampal segmentation into func space
        v
 (12) ENGRAMS_postprocROImasks_*.m  [binarise masks]
        |   binarise layer, HPC, and column masks in fMRI space
        v
 (13) ENGRAMS_postprocROImasks_*.m  [CSF mask]
        |   SPM12 segmentation of mean fMRI -> conservative CSF mask
        v
 (14) ENGRAMS_compcor_CONTROL_postTOPUP.py  OR  ENGRAMS_compcor_EXPERIMENT_postTOPUP.py
        |   run aCompCor (Nipype) to extract CSF/WM noise regressors
        v
 (15) ENGRAMS_layers_connectivity_singleSubs_*_nochunk.m  [save full volumes]
        |   save full 4D fMRI, layer, and column files (uncompressed, for LayNii)
        v
 (16) ENGRAMS_layers_connectivity_singleSubs_*_nochunk.m  [devein]
        |   run ALF then LN2_DEVEIN on full volumes
        v
 (17) ENGRAMS_layers_connectivity_singleSubs_*_nochunk.m  [cleanup]
        |   regress out motion parameters, PhysIO regressors, CSF (aCompCor)
        v
 (18) ENGRAMS_layers_connectivity_singleSubs_*_nochunk.m  [connectivity]
        |   compute layer-specific Pearson correlations, Fisher-z transform, save
        v
 (19) ENGRAMS_layers_connectivity_groupLvl_*.m
        |   group-level connectivity analysis, statistics, and visualisation
```

---

## script refs

---

#### `ENGRAMS_prepareLayerMasks.m` (steps 2, 3, 5, 7)

**role:** the very first step in the pipeline. upsamples the T1w to 0.35mm isotropic (ANTs `ResampleImage`), runs SPM12 segmentation to correct B0 field inhomogeneity (outputs `mSUBJECT_run-01_T1w_0pt35.nii.gz`), then runs CAT12 to produce tissue probability maps. finally binarises the GM (>0.7) and WM (>0.3) probability maps.

**inputs:** raw T1w (`<subject>_run-01_T1w.nii.gz`) from `preproc/<subject>/anat/`

**key outputs** (in `analyses/<subject>/anat/t1/`):
- `m<subject>_run-01_T1w_0pt35.nii.gz`: B0-corrected, upsampled T1w (this is used everywhere downstream)
- `mri/p1m<subject>_run-01_T1w_0pt35.nii.gz`: GM probability map
- `mri/p2m<subject>_run-01_T1w_0pt35.nii.gz`: WM probability map
- `mri/p1m<subject>_run-01_T1w_0pt35_bin.nii.gz`: binarised GM
- `mri/p2m<subject>_run-01_T1w_0pt35_bin.nii.gz`: binarised WM

**note:** update `paths_results`, `paths_source`, and `ids` before running (duh!)

---

#### `ENGRAMS_transform_MNI.sh` (step 3b)

**role:** registers brainstem ROI masks (LC, SN, VTA) from MNI space to native T1w space using ANTs SyN, then resamples them to 0.35mm isotropic to match the upsampled T1w.

**inputs:**
- native T1w (`<subject>_run-01_T1w.nii.gz`) as the registration destination
- MNI template (`mni_icbm152_t1_tal_nlin_asym_09c.nii.gz`) and MNI-space ROI masks (LC, SN, VTA) from `templates/mni_icbm152/`

**outputs** (in `analyses/<subject>/anat/roi/native/`):
- `LC.nii.gz`, `SN.nii.gz`, `VTA.nii.gz` at 0.35mm resolution

---

#### `ENGRAMS_merge_brainstem_ROIs.m` (step 3c)

**role:** adds the brainstem ROI masks (LC, SN, VTA) into the CAT12 GM probability map using SPM12 imcalc. this creates a merged GM map (`p1m<subject>v1s1_run-01_T1w_0pt35_bs.nii.gz`) that is used by the layer generation script to treat brainstem nuclei as cortical GM for the purpose of rim and layer construction.

**inputs:**
- `mri/p1m<subject>_run-01_T1w_0pt35.nii.gz` (CAT12 GM map)
- `LC.nii.gz`, `SN.nii.gz`, `VTA.nii.gz` from previous step

**output:** `mri/p1m<subject>v1s1_run-01_T1w_0pt35_bs.nii.gz` (merged GM+brainstem)

---

#### `ENGRAMS_LAYERS_pipeline_v4.py` (step 6)

**role:** the layer growing script. takes the binarised GM and WM maps (plus brainstem masks on them) and runs the full LayNii pipeline to produce equivolumetric layer and column files. brainstem nuclei are handled as a special case throughout: fake WM cores are added via morphological erosion before rim construction, and brainstem voxels are injected into the midGM and final layers files after each relevant LayNii step. let me know if i'm doing this wrong...

**what it does:**
1. loads CAT12 tissue probability maps (GM with brainstem merged, WM)
2. creates discrete GM=3 / WM=2 labels and rim borders via morphological dilation/erosion
3. adds brainstem nuclei into the rim as GM (label 3)
4. runs `LN2_LAYERS` (3 layers, no smoothing) to generate equivolumetric layer boundaries
5. injects brainstem voxels into midGM file
6. runs `LN2_COLUMNS` (300 columns), `LN_GROW_LAYERS` (N=500, vinc=40), `LN_LEAKY_LAYERS` (500 layers, 100 iterations), then `LN_LOITUMA` to produce final equivolumetric layers (15 bins, FWHM=0.35)
7. bins 15 layers into 3 cortical depth bins: deep (layers 3-6), middle (7-10), superficial (11-14). these boundaries were chosen by visual inspection to approximate cytoarchitectural layers I-VI

**key outputs** (in `analyses/<subject>/anat/t1/`):
- `<subject>_run-01_T1w_0pt35_bs_rim.nii.gz`
- `<subject>_run-01_T1w_0pt35_bs_rim_columns300.nii.gz`
- `<subject>_run-01_T1w_0pt35_bs_equi_volume_layers.nii`
- `<subject>_run-01_T1w_0pt35_bs_equi_volume_layers_bined_3layers.nii` (this is the main one)

**parameter notes:**
- `LN_GROW_LAYERS -N 500` and `-vinc 40` were increased from defaults after testing with 0.2mm LaYNii examples, to deal with the larger 0.35mm voxels
- `LN_LOITUMA -nr_layers 15` was chosen after `13` did not work well; `-FWHM 0.35` matches voxel size to avoid blurring layers together
- layering brainstem nuclei at bin 1 (deep) is a simplification; this is the least wrong option given that LayNii was not designed for brainstem structures... again, let me know if you know any smarter approaches.

---

#### `ENGRAMS_WBseg_reconall_*.sh` (step 8)

**role:** runs FreeSurfer `recon-all` in three stages on the 0.35mm B0-corrected T1w, with hires expert options. this is the only script in this pipeline designed to run on the hydra cluster.

**workflow:**
1. `autorecon1` with `-noskullstrip` and `-hires` to prevent FreeSurfer from mangling the high-res image
2. register the skullstripped T1w (from CAT12 brainmask) to FreeSurfer `orig.mgz` space using ANTs, then place it as `brainmask.mgz`
3. `autorecon2` and `autorecon3` with `-xopts-overwrite` and the hires expert file

**input:** `m<subject>_run-01_T1w_0pt35.nii.gz` (B0-corrected, upsampled T1w)  
**output:** full FreeSurfer subject directory including `aparc+aseg.mgz`

---

#### `ENGRAMS_WBseg_postprocessing.sh` (step 9)

**role:** converts the FreeSurfer `aparc+aseg.mgz` parcellation to niftii and backtransforms it to native T1w space using the inverse of the affine computed during recon-all. this is the final step in the parcellation arm of the pipeline.

**inputs:** FreeSurfer output (`aparc+aseg.mgz`) + affine transform from recon-all (`FStoNat_0GenericAffine.mat`)  
**output:** `aparc+aseg_nat.nii.gz` in native T1w space (this is used by `ENGRAMS_createROImasks_20251103.m` and also by the [`dwi_analysis/`](../dwi_analysis/) pipeline)

---

#### `ENGRAMS_createROImasks_*.m` (step 10)

**role:** intersects the native-space whole-brain parcellation with the 3-bin layer mask to create layer-specific binary ROI masks for each region of interest. also creates dilated coregistration guide masks used by the registration step downstream (but only for the subjects who are resistant to standard rigid or light nonlinear transformations).

**rois created:**
- mPFC (labels 1014, 1026, 2014, 2026), bilateral and per hemisphere
- RSC (1010, 2010), bilateral and per hemisphere
- entorhinal cortex (1006, 2006), bilateral and per hemisphere

**per roi, outputs three masks** (deep, mid, sup) in `analyses/<subject>v1s1/anat/roi/native/`:  
e.g. `mPFC_layer_deep.nii.gz`, `mPFC_layer_mid.nii.gz`, `mPFC_layer_sup.nii.gz`

**also outputs** (in `analyses/<subject>v1s1/anat/roi/regmask/`):
- `<roi>_bin.nii` and `<roi>_dilated.nii.gz`: used as registration masks for fMRI coregistration

**run `ENGRAMS_transform_ROIs_postTOPUP_Day1_v*.sh` next.**

---

#### `ENGRAMS_transform_ROIs_postTOPUP_Day1_v*.sh` (and `_Day2_v*.sh`) (step 11)

**role:** the big registration step. moves all native-space ROIs (layer masks, whole-brain parcellation, binarised GM/WM, layer+column files) from T1w space into each fMRI task space using ANTs rigid registration. also moves the ASHS hippocampal segmentation from T2w space into fMRI space. two scripts cover the two scanning days:
- `Day1`: rest, origenc, origrec1
- `Day2`: origrec2, recombienc, recombirec1

**requires:** skullstripped mean fMRI images (`mean<subject>_task-*_bold_topup_stripped.nii.gz`) per task. these are produced by the fMRI preprocessing pipeline; see the `fmri_analysis/` folder in the [ENGRAMS_SFB1315 repository](https://github.com/alex-yi-writes/ENGRAMS_SFB1315). also, make sure you have my custom function for binarising hippocampal subfields segmentations, `ENGRAMS_binarise_ASHSseg_vf.sh`, somewhere and properly assign this function within this script, for example [here](https://github.com/alex-yi-writes/ENGRAMS_SFB1315_B06/blob/86a17e831a6131bdfbf7963d5a8df103ab09c26b/layer_analysis/ENGRAMS_transform_ROIs_postTOPUP_Day1_v4.sh#L66-68).

**what it registers per task:**
- T1w to fMRI space (rigid): for cortical ROI transforms
- T2w to fMRI space (rigid): for ASHS hippocampal transforms
- applies transforms to: all layer-specific ROI masks, layer file, column file, GM mask, WM mask, whole-brain parcellation

**outputs** (in `analyses/<subject>v1s1/anat/roi/func/<task>/`):
- layer-specific ROI masks in fMRI space (`mPFC_layer_deep.nii.gz`, etc.)
- `equivol_on_<task>.nii.gz`, `rim_columns300_on_<task>.nii.gz`
- `GM.nii.gz`, `WM.nii.gz`
- `hpc_on_func-<task>.nii.gz`

**note for myself:** `MacBookFlag=1` controls which T2w path is used. set to 0 if running on the iMac. if running this on the ✨new MacBook✨, it's 1.

---

#### `ENGRAMS_postprocROImasks_*.m` (steps 12 & 13)

**role:** binarises the layer, HPC, and column masks that were registered into fMRI space. also generates a conservative CSF mask per task by running SPM12 segmentation on the skull-stripped mean fMRI, then thresholding the CSF probability map at >0.6. these CSF masks are the inputs to aCompCor.

**outputs per task:**
- `hpc_on_func-<task>_bin.nii.gz`
- `equi_volume_layers_bined_3layers_on_<task>_bin.nii.gz`
- `rim_columns300_on_<task>_bin.nii.gz`
- `<task>_csf_bin.nii` (in the preproc func folder)

**!run one of the CompCor scripts after this!**

---

#### `ENGRAMS_compcor_CONTROL_postTOPUP.py` and `ENGRAMS_compcor_EXPERIMENT_postTOPUP.py` (step 14)

**role:** runs anatomical CompCor (aCompCor) via Nipype's `CompCor` interface to extract physiological noise regressors from CSF and WM masks. produces a text file of components per task that is used as a confound regressor in the connectivity step. the two scripts differ only in which subjects and tasks they target. use the one matching your own subject group.

**settings:** 3 components per mask, polynomial detrending (degree 2), no bandpass pre-filtering at this stage (TR=2s)

**output:** `compcor_csf_wm_<task>.txt` per subject per task

**note:** aCompCor is based on [this paper](https://doi.org/10.1016/j.neuroimage.2007.04.042) (Behzadi, Restom, Liau, & Liu, 2008).

---

#### `ENGRAMS_layers_connectivity_singleSubs_*_nochunk.m` (steps 15 to 18)

**role:** the main analysis script. runs deveining and computes layer-specific connectivity for each subject and task. this is a no-chunking version of the earlier pipeline (full fMRI volumes are processed in one go rather than being split into segments, which is feasible if you have enough RAM).

**the script runs in three stages:**

1. **save full volumes:** loads fMRI, layer, and column files and saves them as uncompressed niftii files in `analyses/<subject>/func/laminar/GM/`. this is required by `ALF` and `LN2_DEVEIN`.

2. **devein:** runs `ALF_melmac_ENGRAMS.sh` (a local wrapper) to compute the ALF image, then runs `LN2_DEVEIN` to remove large draining vein contributions. renames the output to `func_<task>_deveined.nii.gz`.

3. **compute connectivity:** extracts time series per layer per ROI, applies realignment parameter regression (SPM12 rp files), physiological noise regression (TAPAS PhysIO regressors), and CSF regression (aCompCor output), then computes Pearson correlations between layers. connectivity analyses are defined in blocks (mPFC, RSC, HPC, entorhinal cortex) and saved per subject.

**subject grouping:** subjects `1xx` = control, `2xx`/`3xx` = experimental.

**note:** the top of the script lists all tasks (`rest`, `origenc`, `origrec1`, `origrec2`, `recombienc`, `recombirec1`). tasks 1-3 use `v1s1` session data, tasks 4-6 use `v2s1`. make sure paths match before running.
**note2:** so a little lore of how this script came about is that, previously, none of my machines could handle any of the LayNii steps in a full volume so i had to chuck all images that i use as inputs into 6 chunks and reassemble it before the stats. now, with the new macbook, no chunking is necessary.

---

#### `ENGRAMS_layers_connectivity_groupLvl_*.m` (step 19)

**role:** group-level connectivity analysis. loads the per-subject Fisher-z matrices from step 18 and runs statistics and visualisation across four ROI sets: mPFC layers, RSC layers, mPFC+RSC combined, and HPC subfields (CA1, CA3, DG, Sub).

**what it does:**
1. loads all per-subject `Z_<subject>_<task>.mat` files into a 4D array (subjects x tasks x rois x rois)
2. for each unique ROI pair, plots individual subject trajectories across tasks with group mean ± SEM overlaid
3. runs paired t-tests between all task pairs (rest vs origenc, origenc vs origrec, rest vs origrec) and draws significance bars (* p<0.05, ** p<0.01, *** p<0.001, o p<0.1)
4. computes group-mean Fisher-z matrices per task, thresholds at |r|>0.1 (kept low given the small sample size), and visualises as both a weighted connectivity graph and a heatmap

**outputs** (in `path_par/group_fig/`):
- `<roi_set>_<roi_i>_vs_<roi_j>_sigTest.fig/.jpg`: per-pair trajectory plots with significance bars
- `group_connectivities_<roi_set>_<task>.fig/.jpg`: circular connectivity graph with edge weights and significance labels
- `group_heatmap_<roi_set>_<task>.fig/.jpg`: Fisher-z heatmap per task

**note:** uses a custom `redblue` colormap function by Adam Auton (it looks nicer). make sure it's on your MATLAB path.

---

## dependencies

| tool | version | used in |
|------|---------|---------|
| MATLAB | R2023a | most scripts |
| SPM12 + CAT12 | — | T1w segmentation, CSF mask |
| ANTs | — | registration, upsampling |
| FreeSurfer | 7.1 (cluster) / 7.4.1 (local) | recon-all, mri_binarize, mri_convert |
| ASHS | — | hippocampal subfield segmentation |
| LayNii | v2.9.0 | layer/column generation, deveining |
| Python | 3.x | layer pipeline, CompCor |
| Nipype | — | aCompCor |
| nibabel, numpy, scipy | — | layer pipeline |
| FSL | — | mask operations |
| TAPAS PhysIO | — | physiological noise regressors |

