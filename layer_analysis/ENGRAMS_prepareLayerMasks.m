%% prepare layer imaging

clc;clear

paths_results='/Users/yyi/Desktop/ENGRAMS/analyses/';
paths_source ='/Users/yyi/Desktop/ENGRAMS/preproc/';

% load('/Users/yyi/Desktop/ENGRAMS/ids_engrams.mat');
ids={'sub-101v1s1';'sub-102v1s1';'sub-104v1s1';'sub-105v1s1';'sub-106v1s1';'sub-107v1s1'}; % 'sub-109v1s1',

%% first, b0 inhomogeneity correct

for id=1:length(ids)

    gunzip([ paths_source ids{id} '/anat/' ids{id} '_run-01_T1w.nii.gz' ])

    clear segmentbatch
    segmentbatch{1}.spm.spatial.preproc.channel.vols = {[paths_source ids{id} '/anat/' ids{id} '_run-01_T1w.nii,1']};
    segmentbatch{1}.spm.spatial.preproc.channel.biasreg = 0.0001;
    segmentbatch{1}.spm.spatial.preproc.channel.biasfwhm = 30;
    segmentbatch{1}.spm.spatial.preproc.channel.write = [0 1];
    segmentbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/Applications/spm12/tpm/TPM.nii,1'};
    segmentbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    segmentbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/Applications/spm12/tpm/TPM.nii,2'};
    segmentbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    segmentbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/Applications/spm12/tpm/TPM.nii,3'};
    segmentbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    segmentbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/Applications/spm12/tpm/TPM.nii,4'};
    segmentbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    segmentbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/Applications/spm12/tpm/TPM.nii,5'};
    segmentbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    segmentbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/Applications/spm12/tpm/TPM.nii,6'};
    segmentbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    segmentbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    segmentbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
    segmentbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    segmentbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    segmentbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    segmentbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    segmentbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    segmentbatch{1}.spm.spatial.preproc.warp.samp = 3;
    segmentbatch{1}.spm.spatial.preproc.warp.write = [0 0];
    segmentbatch{1}.spm.spatial.preproc.warp.vox = NaN;
    segmentbatch{1}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
        NaN NaN NaN];

    spm_jobman('run',segmentbatch)

end

%% resample image

setenv('PATH', [getenv('PATH') ':/Applications/freesurfer/mni/bin:/usr/local/bin']);
setenv('ANTSPATH','/usr/local/bin')

for id=1:length(ids)

    mkdir([paths_results ids{id} '/anat/t1/'])

    eval(['!ResampleImage 3 ' paths_source ids{id} '/anat/m' ids{id} '_run-01_T1w.nii ' paths_results ids{id} '/anat/t1/mT1_0pt35.nii 0.35 0.35 0.35  4'])
    disp('resampled')

end

%% CAT12

for id=1:length(ids)

    eval(['!gzip -d ' paths_results ids{id} '/anat/t1/m' ids{id} '_run-01_T1w_0pt35.nii.gz'])

    clear cat12batch
    cat12batch{1}.spm.tools.cat.estwrite.data = {[paths_results ids{id} '/anat/t1/m' ids{id} '_run-01_T1w_0pt35.nii,1']};
    cat12batch{1}.spm.tools.cat.estwrite.data_wmh = {''};
    cat12batch{1}.spm.tools.cat.estwrite.nproc = 8;
    cat12batch{1}.spm.tools.cat.estwrite.useprior = '';
    cat12batch{1}.spm.tools.cat.estwrite.opts.tpm = {'/Applications/spm12/tpm/TPM.nii'};
    cat12batch{1}.spm.tools.cat.estwrite.opts.affreg = 'mni';
    cat12batch{1}.spm.tools.cat.estwrite.opts.biasacc = 0.5;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.restypes.native = [];
    cat12batch{1}.spm.tools.cat.estwrite.extopts.setCOM = 1;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.APP = 1070;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.affmod = 0;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.LASstr = 0.5;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.LASmyostr = 0;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.gcutstr = 2;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.WMHC = 2;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.registration.shooting.shootingtpm = {'/Applications/spm12/toolbox/cat12/templates_MNI152NLin2009cAsym/Template_0_GS.nii'};
    cat12batch{1}.spm.tools.cat.estwrite.extopts.registration.shooting.regstr = 0.5;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.vox = 1.5;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.bb = 12;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.SRP = 22;
    cat12batch{1}.spm.tools.cat.estwrite.extopts.ignoreErrors = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.BIDS.BIDSno = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.surface = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.surf_measures = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.neuromorphometrics = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.lpba40 = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.cobra = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.hammers = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.thalamus = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.thalamic_nuclei = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.suit = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.ibsr = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.ownatlas = {''};
    cat12batch{1}.spm.tools.cat.estwrite.output.GM.native = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.GM.mod = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.GM.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.WM.native = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.WM.mod = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.WM.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.CSF.native = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.CSF.warped = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.CSF.mod = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.CSF.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.ct.native = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.ct.warped = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.ct.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.pp.native = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.pp.warped = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.pp.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.WMH.native = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.WMH.warped = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.WMH.mod = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.WMH.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.SL.native = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.SL.warped = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.SL.mod = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.SL.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.TPMC.native = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.TPMC.warped = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.TPMC.mod = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.TPMC.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.atlas.native = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.label.native = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.label.warped = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.label.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.labelnative = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.bias.warped = 1;
    cat12batch{1}.spm.tools.cat.estwrite.output.las.native = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.las.warped = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.las.dartel = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.jacobianwarped = 0;
    cat12batch{1}.spm.tools.cat.estwrite.output.warps = [0 0];
    cat12batch{1}.spm.tools.cat.estwrite.output.rmat = 0;
    spm_jobman('run',cat12batch)

    eval(['!gzip ' paths_results ids{id} '/anat/t1/m' ids{id} '_run-01_T1w_0pt35.nii'])

end


%% binarise GM/WM

for id=1:length(ids)

    clear binbatch
    try
        gunzip([ paths_results ids{id} '/anat/t1/mri/p1mT1_0pt5.nii.gz'])
    catch
        disp('already decompressed')
    end
    binbatch{1}.spm.util.imcalc.input = {[ paths_results ids{id} '/anat/t1/mri/p1m' ids{id} '_run-01_T1w_0pt35.nii,1']};
    binbatch{1}.spm.util.imcalc.output = ['p1m' ids{id} '_run-01_T1w_0pt35_bin'];
    binbatch{1}.spm.util.imcalc.outdir = {[ paths_results ids{id} '/anat/t1/mri/']};
    binbatch{1}.spm.util.imcalc.expression = 'i1>0.7';
    binbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    binbatch{1}.spm.util.imcalc.options.dmtx = 0;
    binbatch{1}.spm.util.imcalc.options.mask = 0;
    binbatch{1}.spm.util.imcalc.options.interp = 1;
    binbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run',binbatch)

    clear binbatch
    try
        gunzip([ paths_results ids{id} '/anat/t1/mri/p2mT1_0pt5.nii.gz'])
    catch
        disp('already decompressed')
    end
    binbatch{1}.spm.util.imcalc.input = {[ paths_results ids{id} '/anat/t1/mri/p2m' ids{id} '_run-01_T1w_0pt35.nii,1']};
    binbatch{1}.spm.util.imcalc.output = ['p2m' ids{id} '_run-01_T1w_0pt35_bin'];
    binbatch{1}.spm.util.imcalc.outdir = {[ paths_results ids{id} '/anat/t1/mri/']};
    binbatch{1}.spm.util.imcalc.expression = 'i1>0.3';
    binbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    binbatch{1}.spm.util.imcalc.options.dmtx = 0;
    binbatch{1}.spm.util.imcalc.options.mask = 0;
    binbatch{1}.spm.util.imcalc.options.interp = 1;
    binbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run',binbatch)

end

eval(['!gzip ' paths_results '*/anat/t1/mri/*.nii -f'])


%% housekeeping

for id=1:length(ids)

    eval(['!gzip ' paths_source ids{id} '/anat/*.nii -f'])
    eval(['!gzip ' paths_results ids{id} '/anat/t1/*.nii -f'])
    eval(['!gzip ' paths_results ids{id} '/anat/t1/*/*.nii -f'])    

end

%% make brain tissue mask for whole-brain segmentation: try using synthstrip

% setenv('PATH', [getenv('PATH') ':/Applications/freesurfer/mni/bin:/usr/local/bin:/usr/local/fsl']);
% setenv('ANTSPATH','/usr/local/bin')
% setenv('FSLDIR','/usr/local/fsl');  % this to tell where FSL folder is
% setenv('FSLOUTPUTTYPE', 'NIFTI'); % this to tell what the output type would be
% 
% for id=1:length(ids)
% 
% 
% %     eval(['!gzip -d ' paths_results ids{id} '/anat/t1/m' ids{id} '_run-01_T1w_0pt35.nii.gz -f'])
% % 
% %     clear matlabbatch
% %     spm_jobman('initcfg')
% %     matlabbatch{1}.spm.spatial.preproc.channel.vols = {[ paths_results ids{id} '/anat/t1/m' ids{id} '_run-01_T1w_0pt35.nii,1']};
% %     matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
% %     matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
% %     matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/Applications/spm12/tpm/TPM.nii,1'};
% %     matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
% %     matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/Applications/spm12/tpm/TPM.nii,2'};
% %     matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
% %     matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/Applications/spm12/tpm/TPM.nii,3'};
% %     matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
% %     matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/Applications/spm12/tpm/TPM.nii,4'};
% %     matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
% %     matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/Applications/spm12/tpm/TPM.nii,5'};
% %     matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
% %     matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/Applications/spm12/tpm/TPM.nii,6'};
% %     matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
% %     matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
% %     matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
% %     matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
% %     matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
% %     matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
% %     matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
% %     matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
% %     matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
% %     matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];
% %     matlabbatch{1}.spm.spatial.preproc.warp.vox = NaN;
% %     matlabbatch{1}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
% %         NaN NaN NaN];
% %     matlabbatch{2}.spm.util.imcalc.input(1) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
% %     matlabbatch{2}.spm.util.imcalc.input(2) = cfg_dep('Segment: c2 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','c', '()',{':'}));
% %     matlabbatch{2}.spm.util.imcalc.input(3) = cfg_dep('Segment: c3 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{3}, '.','c', '()',{':'}));
% %     matlabbatch{2}.spm.util.imcalc.output = 'brainmask_binary';
% %     matlabbatch{2}.spm.util.imcalc.outdir = {[ paths_results ids{id} '/anat/t1/']};
% %     matlabbatch{2}.spm.util.imcalc.expression = '(i1+i2+i3)>0';
% %     matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
% %     matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
% %     matlabbatch{2}.spm.util.imcalc.options.mask = 0;
% %     matlabbatch{2}.spm.util.imcalc.options.interp = 1;
% %     matlabbatch{2}.spm.util.imcalc.options.dtype = 4;
% % 
% %     spm_jobman('run',matlabbatch)
% 
%     eval(['!gzip -d ' paths_results ids{id} '/anat/t1/mri/p0m' ids{id} '_run-01_T1w_0pt35.nii.gz -f'])
% 
%     clear binbatch
%     spm_jobman('initcfg')
% 
%     binbatch{1}.spm.util.imcalc.input = {[ paths_results ids{id} '/anat/t1/mri/p0m' ids{id} '_run-01_T1w_0pt35.nii,1']};
%     binbatch{1}.spm.util.imcalc.output = ['brainmask_binary'];
%     binbatch{1}.spm.util.imcalc.outdir = {[ paths_results ids{id} '/anat/t1/']};
%     binbatch{1}.spm.util.imcalc.expression = 'i1>0';
%     binbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
%     binbatch{1}.spm.util.imcalc.options.dmtx = 0;
%     binbatch{1}.spm.util.imcalc.options.mask = 0;
%     binbatch{1}.spm.util.imcalc.options.interp = 1;
%     binbatch{1}.spm.util.imcalc.options.dtype = 4;
%     spm_jobman('run',binbatch)
% 
%     clear matlabbatch
%     spm_jobman('initcfg')
%     matlabbatch{1}.spm.util.imcalc.input = {
%         [ paths_results ids{id} '/anat/t1/brainmask_binary.nii,1' ]
%         [  paths_results ids{id} '/anat/t1/m' ids{id} '_run-01_T1w_0pt35.nii,1' ]
%         };
%     matlabbatch{1}.spm.util.imcalc.output = 'brainmask';
%     matlabbatch{1}.spm.util.imcalc.outdir = {[ paths_results ids{id} '/anat/t1/']};
%     matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
%     matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
%     matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
%     matlabbatch{1}.spm.util.imcalc.options.mask = 0;
%     matlabbatch{1}.spm.util.imcalc.options.interp = 1;
%     matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
% 
%     spm_jobman('run',matlabbatch)
% 
%     eval(['!gzip ' paths_results ids{id} '/anat/t1/c*m' ids{id} '_run-01_T1w_0pt35.nii -f'])
%     eval(['!gzip ' paths_results ids{id} '/anat/t1/m' ids{id} '_run-01_T1w_0pt35.nii -f'])
% 
% 
% end
