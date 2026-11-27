#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul 17 14:13:16 2026

@author: yyi
"""

import yabplot as yab
import numpy as np

# check that you have the latest version
print(yab.__version__)

# see available atlases and brain meshes
print(yab.get_available_resources())
# %%

# see the region names for a specific atlas
print(yab.get_atlas_regions(atlas='aseg', category='subcortical'))

# plotting cortical surface regions
atlas = 'aparc'
dmap1 = {'L_lateraloccipital': 0.265, 'L_postcentral': 0.086}
ax = yab.plot_cortical(data=dmap1, atlas=atlas, vminmax=[0.0, 0.3], cmap='viridis',
    bmesh='midthickness', views=['left_lateral', 'left_medial'])

# plotting subcortical regions
atlas = 'aseg'
regs = yab.get_atlas_regions(atlas=atlas, category='subcortical')
data = np.arange(1, len(regs)+1)
ax = yab.plot_subcortical(data=data, atlas=atlas, vminmax=[2, 14], 
    views=['left_lateral', 'superior', 'right_lateral'], 
    bmesh_alpha=0.1, cmap='plasma')

# %%
# plotting volume voxel-wise 
threshold = '99.5%'
nii_path = '/Volumes/korokdorf/REPLAY/2nd/results/nii/spmT_0001_Objects > Control_p001_c38_grey.nii.gz'
ax = yab.plot_voxelwise(nii_path, threshold='0.001%', cmap='Reds',
    views=['left_lateral', 'superior', 'anterior'])

# %%

from nilearn import plotting

nii_path = '/Volumes/korokdorf/REPLAY/2nd/results/nii/spmT_0001_CueCorrectAll > control_p001_c0_Brainstem.nii.gz'

plotting.plot_glass_brain(
    nii_path,
    threshold=3.1,
    cmap='Reds',
    display_mode='lyrz', # Left, Y-sagittal, Right, Z-axial
    plot_abs=False
)