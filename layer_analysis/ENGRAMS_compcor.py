# CompCor loops
from nipype.algorithms.confounds import CompCor

ID = ["sub-202"]
parpath = "/Users/alex/Dropbox/paperwriting/1315/data/segmentation/"
TR = 2

for x in ID:

    id = x

    fmri        = "v1s1/func/au" + id + "v1s1_task-origenc_run-03_bold.nii"
    mask        = "v1s1/func/origenc_mask.nii.gz"
    csfmask     = "v1s1/func/origenc_csf_bin.nii"
    wmmask      = "v1s1/anat/roi/func/origenc/WM_clean.nii.gz"

    fmripath    = parpath + id + fmri
    csfpath     = parpath + id + csfmask
    wmpath      = parpath + id + wmmask
    # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    outputpath  = parpath + id + "v1s1/func/compcor_csf_wm_origenc.txt"

    ccinterface = CompCor()
    ccinterface.inputs.realigned_file       = fmripath
    ccinterface.inputs.mask_files           = [csfpath, wmpath] # always wrap it
    ccinterface.inputs.merge_method         = 'none'
    ccinterface.inputs.num_components       = 3
    ccinterface.inputs.pre_filter           = 'polynomial'
    ccinterface.inputs.regress_poly_degree  = 2
    ccinterface.inputs.repetition_time      = TR
    ccinterface.inputs.components_file      = outputpath
    ccinterface.run()
