# CompCor loops
from nipype.algorithms.confounds import CompCor
# from traits.trait_errors import TraitError
import os

ID = ['sub-108']#, "sub-106", "sub-107", "sub-108"]
parpath = "/Volumes/korokdorf/ENGRAMS/preproc/"
TR = 2

for x in ID:

    id = x

    print ("running "+id)

    # print("resting state")

    # fmri        = "v1s1/func/au" + id + "v1s1_task-rest_run-01_bold.nii.gz"
    # mask        = "v1s1/func/rest_mask.nii.gz"
    # csfmask     = "v1s1/func/rest_csf_bin.nii"
    # wmmask      = "v1s1/anat/roi/func/rest/WM_clean.nii.gz"

    # fmripath    = parpath + id + fmri
    # csfpath     = parpath + id + csfmask
    # wmpath      = '/Volumes/korokdorf/ENGRAMS/analyses/' + id + wmmask
    # # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    # outputpath  = parpath + id + "v1s1/func/compcor_csf_wm_rest.txt"

    # if all(os.path.exists(p) for p in [fmripath, csfpath, wmpath]):
    #     ccinterface = CompCor()
    #     ccinterface.inputs.realigned_file       = fmripath
    #     ccinterface.inputs.mask_files           = [csfpath, wmpath] # always wrap it
    #     ccinterface.inputs.merge_method         = 'none'
    #     ccinterface.inputs.num_components       = 3
    #     ccinterface.inputs.pre_filter           = 'polynomial'
    #     ccinterface.inputs.regress_poly_degree  = 2
    #     ccinterface.inputs.repetition_time      = TR
    #     ccinterface.inputs.components_file      = outputpath
    #     ccinterface.run()
    # else:
    #     missingfiles=[]
    #     for path, name in zip([fmripath, csfpath, wmpath], [fmri, csfmask, wmmask]):
    #         if not os.path.exists(path):
    #             missingfiles.append(name)
    #     print(f"missing resting state data for {id}: {', '.join(missingfiles)}") 
    


    print("original encoding")

    fmri        = "v2s2/func/au" + id + "v2s2_task-origenc_run-03_bold.nii.gz"
    mask        = "v2s2/func/origenc_mask.nii.gz"
    csfmask     = "v2s2/func/origenc_csf_bin.nii"
    wmmask      = "v1s1/anat/roi/func/origenc/WM_clean.nii.gz"

    fmripath    = parpath + id + fmri
    csfpath     = parpath + id + csfmask
    wmpath      = '/Volumes/korokdorf/ENGRAMS/analyses/' + id + wmmask
    # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    outputpath  = parpath + id + "v2s2/func/compcor_csf_wm_origenc.txt"

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
        missingfiles=[]
        for path, name in zip([fmripath, csfpath, wmpath], [fmri, csfmask, wmmask]):
            if not os.path.exists(path):
                missingfiles.append(name)
        print(f"missing original encoding data for {id}: {', '.join(missingfiles)}") 



    # print("original recognition")

    # fmri        = "v2s2/func/au" + id + "v2s2_task-origrec_run-04_bold.nii.gz"
    # mask        = "v2s2/func/origrec1_mask.nii.gz"
    # csfmask     = "v2s2/func/origrec1_csf_bin.nii"
    # wmmask      = "v1s1/anat/roi/func/origrec1/WM_clean.nii.gz"

    # fmripath    = parpath + id + fmri
    # csfpath     = parpath + id + csfmask
    # wmpath      = '/Volumes/korokdorf/ENGRAMS/analyses/' + id + wmmask
    # # maskpath   = parpath + id + mask # wb mask needs too much memory for any of my machine to handle
    # outputpath  = parpath + id + "v2s2/func/compcor_csf_wm_origrec1.txt"

    # if all(os.path.exists(p) for p in [fmripath, csfpath, wmpath]):
    #     ccinterface = CompCor()
    #     ccinterface.inputs.realigned_file       = fmripath
    #     ccinterface.inputs.mask_files           = [csfpath, wmpath] # always wrap it
    #     ccinterface.inputs.merge_method         = 'none'
    #     ccinterface.inputs.num_components       = 3
    #     ccinterface.inputs.pre_filter           = 'polynomial'
    #     ccinterface.inputs.regress_poly_degree  = 2
    #     ccinterface.inputs.repetition_time      = TR
    #     ccinterface.inputs.components_file      = outputpath
    #     ccinterface.run()
    # else:
    #     missingfiles=[]
    #     for path, name in zip([fmripath, csfpath, wmpath], [fmri, csfmask, wmmask]):
    #         if not os.path.exists(path):
    #             missingfiles.append(name)
    #     print(f"missing original recognition data for {id}: {', '.join(missingfiles)}") 


print("all done, don't forget to check the output")
