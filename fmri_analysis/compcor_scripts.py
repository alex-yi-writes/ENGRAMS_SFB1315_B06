# CompCor loops
from nipype.algorithms.confounds import CompCor
ID = ["22021","22022","22031","22032","22041","22042","22051","22052","22061","22062","22071","22072","22081","22082","21091","21092","21101","21102","21121","21122","21131","21132","21141","21142","21151","21152","21161","21162","22171","22172","22181","22182","22191","22192","22201","22202","22211","22212","22221","22222","22231","22232","22241","22242","21251","21252","21261","21262"]
parpath = "/Users/Alex/Dropbox/3Tpilot/"
fmri = "/functional.nii.gz"
mask = "/mask.nii.gz"
for x in ID:
    id=x
    fmripath=parpath+id+fmri
    maskpath=parpath+id+mask
    outputpath=parpath+id+'/'+id+'.txt'
    ccinterface = CompCor()
    ccinterface.inputs.realigned_file = fmripath
    ccinterface.inputs.mask_files = maskpath
    ccinterface.inputs.num_components = 3
    ccinterface.inputs.pre_filter = 'polynomial'
    ccinterface.inputs.regress_poly_degree = 2
    ccinterface.inputs.repetition_time = 3.6
    ccinterface.inputs.components_file = outputpath
    ccinterface.run()
