# CompCor loops
from nipype.algorithms.confounds import CompCor
# from traits.trait_errors import TraitError
import os

ID = ["sub-301"]#, "sub-303", "sub-304", "sub-306", "sub-202"]
parpath = "/Users/yyi/Desktop/ENGRAMS/"
TR = 2

for x in ID:

    id = x

    print ("running "+id)

    print("resting state")

    fmri        = "v1s1/func/ar" + id + "v1s1_task-rest_run-01_bold_topup.nii.gz"
    mask        = "v1s1/func/rest_mask.nii.gz"
    csfmask     = "v1s1/func/rest_csf_bin.nii"
    wmmask      = "v1s1/anat/roi/func/rest/WM_clean.nii.gz"

    fmripath    = parpath + "preproc/" + id + fmri
    csfpath     = parpath + "preproc/" + id + csfmask
    wmpath      = parpath + "analyses/" + id + wmmask
    # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    outputpath  = parpath + "preproc/" + id + "v1s1/func/compcor_csf_wm_rest.txt"

    if all(os.path.exists(p) for p in [fmripath, csfpath, wmpath]):
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
    else:
        missing = []
        if not os.path.exists(fmripath):
            missing.append(f"fMRI: {fmripath}")
        if not os.path.exists(csfpath):
            missing.append(f"CSF mask: {csfpath}")
        if not os.path.exists(wmpath):
            missing.append(f"WM mask: {wmpath}")
        print(f"Skipping resting state for {id}. Missing files:")
        for m in missing:
            print(f"  {m}") 
    


    print("original encoding")

    fmri        = "v1s1/func/ar" + id + "v1s1_task-origenc_run-03_bold_topup.nii.gz"
    mask        = "v1s1/func/origenc_mask.nii.gz"
    csfmask     = "v1s1/func/origenc_csf_bin.nii"
    wmmask      = "v1s1/anat/roi/func/origenc/WM_clean.nii.gz"

    fmripath    = parpath + "preproc/" + id + fmri
    csfpath     = parpath + "preproc/" + id + csfmask
    wmpath      = parpath + "analyses/" + id + wmmask
    # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    outputpath  = parpath + "preproc/" + id + "v1s1/func/compcor_csf_wm_origenc.txt"

    if all(os.path.exists(p) for p in [fmripath, csfpath, wmpath]):
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
    else:
        missing = []
        if not os.path.exists(fmripath):
            missing.append(f"fMRI: {fmripath}")
        if not os.path.exists(csfpath):
            missing.append(f"CSF mask: {csfpath}")
        if not os.path.exists(wmpath):
            missing.append(f"WM mask: {wmpath}")
        print(f"Skipping original encoding for {id}. Missing files:")
        for m in missing:
            print(f"  {m}") 


    print("original recognition early")

    fmri        = "v1s1/func/ar" + id + "v1s1_task-origrec1_run-04_bold_topup.nii.gz"
    mask        = "v1s1/func/origrec1_mask.nii.gz"
    csfmask     = "v1s1/func/origrec1_csf_bin.nii"
    wmmask      = "v1s1/anat/roi/func/origrec1/WM_clean.nii.gz"

    fmripath    = parpath + "preproc/" + id + fmri
    csfpath     = parpath + "preproc/" + id + csfmask
    wmpath      = parpath + "analyses/" + id + wmmask
    # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    outputpath  = parpath + "preproc/" + id + "v1s1/func/compcor_csf_wm_origrec1.txt"

    if all(os.path.exists(p) for p in [fmripath, csfpath, wmpath]):
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
    else:
        missing = []
        if not os.path.exists(fmripath):
            missing.append(f"fMRI: {fmripath}")
        if not os.path.exists(csfpath):
            missing.append(f"CSF mask: {csfpath}")
        if not os.path.exists(wmpath):
            missing.append(f"WM mask: {wmpath}")
        print(f"Skipping original recognition early for {id}. Missing files:")
        for m in missing:
            print(f"  {m}")  


    print("original recognition late")

    fmri        = "v2s1/func/ar" + id + "v2s1_task-origrec2_run-05_bold_topup.nii.gz"
    mask        = "v2s1/func/origrec2_mask.nii.gz"
    csfmask     = "v2s1/func/origrec2_csf_bin.nii"
    wmmask      = "v1s1/anat/roi/func/origrec2/WM_clean.nii.gz"

    fmripath    = parpath + "preproc/" + id + fmri
    csfpath     = parpath + "preproc/" + id + csfmask
    wmpath      = parpath + "analyses/" + id + wmmask
    # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    outputpath  = parpath + "preproc/" + id + "v2s1/func/compcor_csf_wm_origrec2.txt"

    if all(os.path.exists(p) for p in [fmripath, csfpath, wmpath]):
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
    else:
        missing = []
        if not os.path.exists(fmripath):
            missing.append(f"fMRI: {fmripath}")
        if not os.path.exists(csfpath):
            missing.append(f"CSF mask: {csfpath}")
        if not os.path.exists(wmpath):
            missing.append(f"WM mask: {wmpath}")
        print(f"Skipping original recognition late for {id}. Missing files:")
        for m in missing:
            print(f"  {m}") 


    print("recombination encoding")

    fmri        = "v2s1/func/ar" + id + "v2s1_task-recombienc_run-03_bold_topup.nii.gz"
    mask        = "v2s1/func/recombienc_mask.nii.gz"
    csfmask     = "v2s1/func/recombienc_csf_bin.nii"
    wmmask      = "v1s1/anat/roi/func/recombienc/WM_clean.nii.gz"

    fmripath    = parpath + "preproc/" + id + fmri
    csfpath     = parpath + "preproc/" + id + csfmask
    wmpath      = parpath + "analyses/" + id + wmmask
    # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    outputpath  = parpath + "preproc/" + id + "v2s1/func/compcor_csf_wm_recombienc.txt"

    if all(os.path.exists(p) for p in [fmripath, csfpath, wmpath]):
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
    else:
        missing = []
        if not os.path.exists(fmripath):
            missing.append(f"fMRI: {fmripath}")
        if not os.path.exists(csfpath):
            missing.append(f"CSF mask: {csfpath}")
        if not os.path.exists(wmpath):
            missing.append(f"WM mask: {wmpath}")
        print(f"Skipping recombi encoding for {id}. Missing files:")
        for m in missing:
            print(f"  {m}") 


    print("recombination recognition")

    fmri        = "v2s1/func/ar" + id + "v2s1_task-recombirec1_run-04_bold_topup.nii.gz"
    mask        = "v2s1/func/recombirec_mask.nii.gz"
    csfmask     = "v2s1/func/recombirec1_csf_bin.nii"
    wmmask      = "v1s1/anat/roi/func/recombirec/WM_clean.nii.gz"

    fmripath    = parpath + "preproc/" + id + fmri
    csfpath     = parpath + "preproc/" + id + csfmask
    wmpath      = parpath + "analyses/" + id + wmmask
    # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    outputpath  = parpath + "preproc/" + id + "v2s1/func/compcor_csf_wm_recombirec.txt"

    if all(os.path.exists(p) for p in [fmripath, csfpath, wmpath]):
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
    else:
        missing = []
        if not os.path.exists(fmripath):
            missing.append(f"fMRI: {fmripath}")
        if not os.path.exists(csfpath):
            missing.append(f"CSF mask: {csfpath}")
        if not os.path.exists(wmpath):
            missing.append(f"WM mask: {wmpath}")
        print(f"Skipping recombi recognition for {id}. Missing files:")
        for m in missing:
            print(f"  {m}") 


print("all done, don't forget to check the output")
