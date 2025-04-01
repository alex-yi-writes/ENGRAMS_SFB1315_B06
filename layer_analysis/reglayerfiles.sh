#!/bin/bash



antsRegistrationSyN.sh -d 3 -f /Users/yyi/Desktop/ENGRAMS/analyses/sub-102v1s1/102_dwi/MD.nii.gz -m /Users/yyi/Desktop/ENGRAMS/analyses/sub-102v1s1/102_dwi/mT1_0pt5.nii.gz -o /Users/yyi/Desktop/ENGRAMS/analyses/sub-102v1s1/102_dwi/mT1_0pt5_on_dwi.nii.gz -t r -n 4

antsApplyTransforms -d 3 -n NearestNeighbor -i /Users/yyi/Desktop/ENGRAMS/analyses/sub-102v1s1/102_dwi/mT1_0pt5_rim_layers_equidist.nii.gz -r /Users/yyi/Desktop/ENGRAMS/analyses/sub-102v1s1/102_dwi/MD.nii.gz -o /Users/yyi/Desktop/ENGRAMS/analyses/sub-102v1s1/102_dwi/mT1_0pt5_rim_layers_equidist_on_dwi.nii.gz -t /Users/yyi/Desktop/ENGRAMS/analyses/sub-102v1s1/102_dwi/mT1_0pt5_on_dwi.nii.gz0GenericAffine.mat