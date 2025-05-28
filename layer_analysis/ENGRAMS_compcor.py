# CompCor loops
from nipype.algorithms.confounds import CompCor

ID = ["sub-109"]
parpath = "/Users/alex/Dropbox/paperwriting/1315/data/segmentation/"
TR = 2

for x in ID:
    id = x
    fmri       = "v1s1/func/au" + id + "v2s2_task-origrec_run-04_bold.nii"
    mask       = "v1s1/func/origrec_mask.nii.gz"
    fmripath   = parpath + id + fmri
    maskpath   = parpath + id + mask
    outputpath = parpath + id + "/" + id + "_origenc.txt"

    ccinterface = CompCor()
    ccinterface.inputs.realigned_file       = fmripath
    ccinterface.inputs.mask_files           = [maskpath]
    ccinterface.inputs.num_components       = 3
    ccinterface.inputs.pre_filter           = 'polynomial'
    ccinterface.inputs.regress_poly_degree  = 2
    ccinterface.inputs.repetition_time      = TR
    ccinterface.inputs.components_file      = outputpath
    ccinterface.run()
