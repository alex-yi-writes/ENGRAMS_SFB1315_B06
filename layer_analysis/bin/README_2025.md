### how i'm doing things at the moment

## to-do list (20250530)
* data is noisy... think about how to scrub those confounds better
* maybe it makes more sense to split `ENGRAMS_layers_connectivity_singleSubs_*.m` into two parts, the first with deveining and the second with actual computation

## requirements
* laynii, freesurfer, spm12 (cat12 too!), fsl, synthstrip, ashs, nipype, ants, tapas physio toolbox

## overview

## pipeline (WIPs, they're subject to change as i go along and figure things out myself)

1. **preprocess fMRI datasets**
   * unwarp with fieldmap (SPM12 for subjects up to 18/May/2025) or TOPUP (FSL from 19/May/2025): [TOPUP preprocessing script]([https://github.com/your-user/other-repo/blob/main/path/to/topup_script.sh](https://github.com/alex-yi-writes/ENGRAMS_SFB1315/blob/main/fmri_analysis/ENGRAMS_distortionCorrect_fMRI_Day1.sh))
   * smooth only for GLM; use unsmoothed data for layer analysis

2. **correct B0-field-inhomogeneity in T1w**
   * run `ENGRAMS_prepareLayerMasks.m` (SPM12)

3. **upsample T1w**
   * upsample to 0.35mm isotropic voxels (ANTs, `ENGRAMS_prepareLayerMasks.m`)

4. **segment T2 TSE**
   * segment hippocampal subfields via ASHS (Hydra/ASHS cloud)

5. **segment GM&WM**
   * segment whole-brain T1w (`ENGRAMS_prepareLayerMasks.m`) and binarise (`ENGRAMS_LAYERS_pipeline_v2.py`; threshold GM>0.7, WM>0.3; CAT12 seems to work the best)

6. **generate layer masks**
   * create rims and layers in `ENGRAMS_LAYERS_pipeline_v2.py` (laynii); outputs 3‑bin layer masks (I–III=superficial, IV=middle, V-VI=deep) and column masks for deveining

7. **whole‑brain mask creation**
   * generate high‑res whole‑brain masks via synthstrip or cat12 (whatever floats your boat - i use cat12) and make a skullstripped image

8. **two‑stage whole‑brain parcellation (`ENGRAMS_WBseg_reconall_102.sh`)**
   * 8-1. run freesurfer recon‑all with `-noskullstrip` and `-autorecon1` (fastsurfer doesn't seem to produce consistent results with highres T1w)
   * 8-2. move skullstripped T1w (from step 7) to orig.mgz space, convert it to mgz, and place in stage‑1 output folder replacing the existing brainmask.mgz image
   * 8-3. run `-autorecon2` and `-autorecon3` with `-xopts-overwrite`

9. **backtransform parcellation**
   * apply inverse transform (acquired from 8-2) on aparc+aseg.mgz to backtransform the whole-brain seg into native space (`ENGRAMS_WBseg_postprocessing.sh`)

10. **create native space ROI masks**
    * make coregistration guide mask and cortical masks (`ENGRAMS_createROImasks.m`)

11. **transform ROIs into fMRI task space**
    * move all native masks (WB & HPC) to each of the fMRI task space (`ENGRAMS_transform_ROIs.sh`)

12. **postprocess ROI masks**
    * binarise layer masks and clean up WM masks to prepare for connectivity analyses (`ENGRAMS_postprocROImasks.m`)

13. **generate CSF mask**
    * make a conservative CSF mask via SPM12 segmentation of mean fMRI per task

14. **run acompcor**
    * run either `ENGRAMS_compcor_CONTROL.py` or `ENGRAMS_compcor_EXPERIMENT.py`

15. **chunk fMRI datasets**
    * split each fMRI dataset into six segments (`ENGRAMS_layers_connectivity_singleSubs_*.m`)

16. **devein**
    * devein chunked fMRI segments and merge outputs once they're done (`ENGRAMS_layers_connectivity_singleSubs_*.m`)

17. **cleanup**
    * clean the data up with realignment parameters from spm12, physiological noise regressors (tapas physio), and CSF regressor (acompcor) (`ENGRAMS_layers_connectivity_singleSubs_*.m`)

18. **single-subject connectivity**
    * compute connectivity metrics (`ENGRAMS_layers_connectivity_singleSubs_*.m`)

19. **group‑level analysis** (WIP... i don't know this yet)
