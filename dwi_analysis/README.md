# ENGRAMS dMRI Analysis Pipeline

**contact:**  yeo-jin (alex) yi, yeo-jin.yi@med.ovgu.de  

---

## overview

this directory contains scripts for processing 7T multi-shell diffusion-weighted MRI data from the ENGRAMS study. the pipeline covers (almost😉) everything from raw data denoising through to roi-level MD extraction and stats. there are two computational environments engaged in my workflow: the Superdome Flex (SDFlex) cluster at DZNE for preprocessing (denoising and so on... anything that takes godforsakenly long time), and a local unix environment for postprocessing, roi transformation, and statistical analysis.

the primary hypothesis and goal are to track microstructural changes (indexed by MD from dMRI) across four memory consolidation time points: baseline (BSL), early recognition (Early RCG), late recognition (Late RCG), and recognition after recombination of consolidated representations (Recombi RCG).

before you go in, (1) make sure your files structures are BIDS validated (all codes written here are based on that so having your data BIDS-validated will make your life so much easier), and (2) some steps, whole-brain parcellation to be specific, require outputs from the layer-specific fMRI pipeline; see [`layer_analysis/`](../layer_analysis/) for those scripts.

---

## workflow overview

```
[SDFlex cluster]
        |
        v
 (0) generate_parallel_commands.sh
        |   generates per-subject command files for GNU parallel
        v
 (0b) run_pipeline_parallel.sh
        |   dispatches jobs via GNU parallel
        v
 for each subj:
 (1) ENGRAMS_full_pipeline_wrapper.sh
        |
        |---> STEP 1: ENGRAMS_denoise_NORDIC_compiled.m
        |             NORDIC denoising of raw 7T DWI
        |
        +---> STEP 2: ENGRAMS_DWIpipeline_postNORDIC_SDflex.sh
                      Gibbs -> TOPUP -> EDDY -> N4 -> dtifit

[local unix (macbook, imac, linux, whatever)]
        |
        v
 (2) ENGRAMS_regWBseg_to_DWI_20251022.sh
        |   ANTs registration of T1w/T2w parcellations into DWI space
        v
 (3) ENGRAMS_DWI_postprocROImasks_20251022.m
        |   extract individual binary ROI masks from registered parcellation
        v
 (4) ENGRAMS_DWI_extractMD_20251103.m
        |   extract median MD per ROI per timepoint, normalise to baseline
        |   export to CSV
        v
 (5) ENGRAMS_plot_md_complete_ver2_WITH_SE.R
        |   final plots with significance testing (it's messy-looking, just for diagnostics)
```

---

## script refs

### cluster computing scripts (SDFlex)

---

#### `generate_parallel_commands.sh`

**role:** preparation step. reads a subject list (`subjects.txt`) and writes command files for GNU parallel. the subject file, you have to make it yourself in whatever way you want.  
**outputs:** `nordic_commands.txt`, `pipeline_commands.txt`, `full_pipeline_commands.txt`  
**run before:** `run_pipeline_parallel.sh`

```bash
./generate_parallel_commands.sh [temporal_phase_value]
# temporal_phase_value: 1 (minimal), 2 (intermediate), 3 (aggressive; default)
```

config at the top of this script **must match** `ENGRAMS_full_pipeline_wrapper.sh` exactly! the subject list lives at `$SCRIPTS_DIR/subjects.txt`, one subject ID per line (e.g. `sub-001`).

---

#### `run_pipeline_parallel.sh`

**role:** just a thin dispatcher... calls `generate_parallel_commands.sh` and then launches the full pipeline across subjects using GNU parallel.  
**tips:** the `temporal_phase` argument is currently hard-coded as `3`, which is a placeholder; update before running if you wish. i recommend 3 for now. as you can see in [this diagnostics graph](diagnostics_GM.png), there is no statistical differences across each temporal phase setting. be that as it may, theoretically, if you want to examine microstrctural changes, 3 makes sesne here.

```bash
./run_pipeline_parallel.sh
```

SDFlex has 224 threads. Each job uses `OMP_NUM_THREADS=24` internally, so `--jobs 4` keeps total thread usage under the recommended 100-thread ceiling. The `--delay 300` (5-minute stagger) reduces I/O contention. (thanks hartmut for the tips!)

---

#### `ENGRAMS_full_pipeline_wrapper.sh`

**role:** single-subject wrapper that runs NORDIC denoising followed by the post-NORDIC preprocessing pipeline. checks for completion markers to avoid re-running completed subjects.

```bash
./ENGRAMS_full_pipeline_wrapper.sh <subject_id> [temporal_phase_value]
# e.g.: ./ENGRAMS_full_pipeline_wrapper.sh sub-207v1s1 3
```

logs to `$BASE_DIR/analyses/<subject>/dwi/<subject>_full_pipeline.log`.  
writes a completion marker `<subject>_pipeline_complete.txt` on success. delete this file to brute force a re-run.

**internally calls (in order):**
1. `ENGRAMS_denoise_NORDIC_compiled` (compiled MATLAB or MATLAB batch mode)
2. `ENGRAMS_DWIpipeline_postNORDIC_SDflex.sh`

---

#### `ENGRAMS_denoise_NORDIC_compiled.m`

**Role:** MATLAB function implementing NORDIC denoising of raw dMRI. designed to run as a compiled executable on SDFlex (no MATLAB licence required via MCR, the compiled function is in [this file](compiled_Linux_MATLAB_R2022a.zip)).

**input:** raw mag and phase niftii files for four acquisitions in `$BASE_DIR/preproc/<subject>/dwi/`:
- `<subject>_b1pt0k-AP_dwi.nii.gz` + `_ph.nii.gz`
- `<subject>_b1pt0k-PA_dwi.nii.gz` + `_ph.nii.gz`
- `<subject>_b2pt5k-AP_dwi.nii.gz` + `_ph.nii.gz`
- `<subject>_b2pt5k-PA_dwi.nii.gz` + `_ph.nii.gz`

**what it does:**
1. checks all input files exist and counts volumes per acquisition
2. saves volume counts to `<subject>_volume_info.txt` (used by the downstream bash script)
3. concatenates all mag and phase data in a fixed order: `b1pt0k-AP > b1pt0k-PA > b2pt5k-AP > b2pt5k-PA`
4. runs `NIFTI_NORDIC` on the concatenated data with configurable `temporal_phase` (default: 3)
5. cleans up temporary merged files
6. writes a completion flag `<subject>_nordic_complete.txt`

**output:** `$BASE_DIR/analyses/<subject>/dwi/nordic/<subject>_all_nordic.nii.gz`

**key parameter:**  
`temporal_phase`: controls NORDIC phase correction aggressiveness. as i already mentioned above, `3` (aggressive) is recommended for looking at microstructural changes but you can change this param based on your hypotheses.

---

#### `ENGRAMS_DWIpipeline_postNORDIC_SDflex.sh`

**role:** full post-NORDIC preprocessing pipeline for a single subject, running on SDFlex. all tools are called via singularity containers. if you need anything else, ask hartmut. this pipeline is very faithful to the FSL diffusion toolbox tutorial. please refer to [this page](https://fsl.fmrib.ox.ac.uk/fslcourse/2019_Beijing/lectures/FDT/fdt1.html) for more details on the steps

**requires:** NORDIC output (`<subject>_all_nordic.nii.gz`) and `<subject>_volume_info.txt` from the MATLAB step above.

**pipeline details:**

| step | tool | description |
|------|------|-------------|
| 0 | — | verify NORDIC output and volume counts |
| 1 | MRtrix `mrdegibbs` | gibbs ringing removal |
| 2 | `paste` / `cat` | concatenate bvecs and bvals (matching MATLAB concatenation order) |
| 3 | FSL `fslroi` | extract AP and PA b=0 images |
| 4 | FSL `fslmerge` | merge AP/PA b0 images |
| 5 | — | Create `acqparams.txt` (phase encoding directions and total readout time) |
| 6 | FSL `topup` | susceptibility-induced distortion correction |
| 7 | FreeSurfer `mri_synthstrip` | skull stripping on TOPUP-corrected b0 |
| 8 | — | create EDDY index file |
| 9 | FSL `eddy_openmp` | eddy current and motion correction |
| 10 | MRtrix `dwibiascorrect ants` | N4 bias field correction |
| 11 | FSL `dtifit` | DTI model fitting (outputs FA, MD, tensor) |
| 12 | — | QA summary (WIP) |

**key outputs** (in `$BASE_DIR/analyses/<subject>/dwi/`):
- `<subject>_preprocessed.nii.gz` — fully preprocessed DWI
- `<subject>_dti_FA.nii.gz` — fractional anisotropy map
- `<subject>_dti_MD.nii.gz` — mean diffusivity map
- `<subject>_hifi_b0_brain_mask.nii.gz` — brain mask
- `<subject>_qa_summary.txt` — QA log

**footnote on `acqparams.txt`:** the total readout time is currently set to `0.0464791` s, extracted from sequence json sidecar parametres (echo spacing 0.56 ms, GRAPPA factor 3, partial Fourier 6/8, base resolution 250). verify against the `TotalReadoutTime` field in the BIDS json sidecar if available.

---

### analysis scripts on local computer (post-processing)

---

#### `ENGRAMS_regWBseg_to_DWI_20251022.sh`

**role:** registers structural parcellations (T1w-based FreeSurfer `aparc+aseg` and T2w-based ASHS hippocampal segmentation) into dMRI space for each of the four time points. uses ANTs rigid registration (`antsRegistrationSyN.sh -t r`).

**paths:** hard-coded to `/Volumes/korokdorf/ENGRAMS/`. update `ID` list and paths at the top of the script before running.

**requires (per subject):**
- `aparc+aseg_nat.nii.gz` (FreeSurfer whole-brain parcellation in T1w space, generated from `ENGRAMS_WBseg_reconall_102.sh` found [here](../layer_analysis/))
- ASHS hippocampal segmentation (`layer_002*`)
- resampled, B0-inhomogeneity-corrected T1w (`m<subject>_run-01_T1w_0pt35.nii.gz`) and T2w (`<subject>_T2w.nii.gz`)
- `hifi_b0_brain.nii.gz` from dMRI preprocessing (all four experimental phases)

**outputs** (in `<subject>v1s1/anat/roi_dwi/`):
- `aparc_on_bsl.nii.gz`, `aparc_on_origE.nii.gz`, `aparc_on_origL.nii.gz`, `aparc_on_recombi.nii.gz`
- `hpc_on_bsl.nii.gz`, `hpc_on_origE.nii.gz`, etc.
- binarised subfield masks (via external `ENGRAMS_binarise_ASHSseg_vf.sh`, found [here](../layer_analysis/))

---

#### `ENGRAMS_DWI_postprocROImasks_20251022.m`

**role:** extracts individual binary roi masks from the registered whole-brain parcellations for downstream MD extraction. run in MATLAB on the local computer after `ENGRAMS_regWBseg_to_DWI_20251022.sh`.

**roi extracted** (from FreeSurfer label codes, you can add how many ever you want):
- mPFC (labels 1014, 1026, 2014, 2026)
- RSC (1010, 2010)
- Parahippocampal (1016, 2016)
- Entorhinal (1006, 2006)
- Fusiform (1007, 2007)
- Precuneus (1025, 2025)
- Inferior Temporal (1009, 2009)

**outputs:** binary niftii masks in `<subject>v1s1/anat/roi_dwi/<phase>/`, one file per roi per time point.

---

#### `ENGRAMS_DWI_extractMD_20251103.m`

**role:** primary analysis script. reads dtifit MD maps and ROI masks, extracts median MD per roi per time point per subject, normalises to baseline, runs preliminary statistics, and exports data to CSV for R plotting.

**inputs:**
- DTI MD maps from all four sessions per subject
- registered `aparc+aseg` parcellations in DWI space

**outputs:**
- `MD_changes_statistics.csv`: MD changes across memory phases with t-statistics and p-values 
- `MD_normalised_for_plotting.csv`: normalised MD values for all subjects, rois, and phases (input to R script, which has nicer plots)
- initial exploratory/diagnostic figures in MATLAB (MD heatmaps, trajectory plots, correlation matrices, significance maps)

**subject grouping:** subjects are grouped by the first digit of their ID: `1xx` = control, `2xx`/`3xx` = experimental; within each experimental group, odd IDs = emo, even IDs = neu.

---

#### `ENGRAMS_plot_md_complete_ver2_WITH_SE.R`

**role:** final plotting in R. reads the CSV exported from `ENGRAMS_DWI_extractMD_20251103.m` and produces faceted plots with group means +- SE and significance annotations.

**requirements:** `tidyverse`, `ggplot2`

**input:** `MD_normalised_for_plotting.csv` (path hard-coded... have a look before running)

**what it does:**
1. categorises subjects into control, emotional, and neutral subtypes
2. runs two-sample t-tests (control vs experimental) at each phase and roi
3. plots group mean trajectories ± SE with significance symbols (* p<0.05, ** p<0.01, o p<0.1)
4. facets by roi with shared phase axis

**outputs:**
- `MD_normalised_combined.png` 
- `MD_normalised_combined.pdf`

---

## tree

```
$BASE_DIR/
├── preproc/
│   └── <subject>/
│       └── dwi/
│           ├── <subject>_b1pt0k-AP_dwi.nii.gz
│           ├── <subject>_b1pt0k-AP_dwi_ph.nii.gz
│           └── ... (all four acquisitions, magnitude + phase)
├── analyses/
│   └── <subject>/
│       ├── anat/
│       │   └── roi_dwi/
│       │       ├── aparc_on_bsl.nii.gz
│       │       └── <phase>/  (binary ROI masks)
│       └── dwi/
│           ├── nordic/
│           │   ├── <subject>_all_nordic.nii.gz
│           │   └── <subject>_volume_info.txt
│           ├── <subject>_dti_MD.nii.gz
│           ├── <subject>_dti_FA.nii.gz
│           └── <subject>_preprocessed.nii.gz
└── scripts/
    ├── subjects.txt
    ├── compiled/
    │   └── run_ENGRAMS_denoise_NORDIC_compiled.sh
    └── MATLAB_Runtime_R2022a_Update_9_glnxa64/
        └── v912/
```

---

## dependencies

| tool | version | used in |
|------|---------|---------|
| NORDIC | — | `ENGRAMS_denoise_NORDIC_compiled.m` |
| MATLAB | R2022a (compiled) / R2023a | NORDIC, ROI masks, MD extraction |
| MATLAB Runtime (MCR) | R2022a v9.12 | Compiled NORDIC on SDFlex |
| FSL | 6 (Singularity) | TOPUP, EDDY, dtifit |
| MRtrix | 3.0.7 (Singularity) | Gibbs removal, bias correction |
| ANTs | — | Registration, N4 |
| FreeSurfer | 8.1 / 7.4.1 | SynthStrip, parcellations |
| ASHS | — | Hippocampal subfield segmentation |
| GNU parallel | — | Multi-subject job dispatch |
| R | — | Final plotting |
| tidyverse / ggplot2 | — | R plotting |
