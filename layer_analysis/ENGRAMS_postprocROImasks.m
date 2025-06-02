%% post process the ROI masks to prepare for the connectivity analysis
%  run this after the ENGRAMS_transform_ROIs.sh script
%% prep

clc;clear
ids     = {'sub-106'}; % do 'sub-106' later
tasks   = {'rest','origenc','origrec'};
path_par = '/Users/alex/Dropbox/paperwriting/1315/data/segmentation/';

% set environments for the bash tools
setenv('PATH', [getenv('PATH') ':/Library/Apple/usr/bin:/Users/alex/LayNii_v2.9.0_Mac_M']);
setenv('PATH', [getenv('PATH') ':/Applications/freesurfer/7.4.1/bin:/Applications/freesurfer/7.4.1/fsfast/bin:/Users/alex/fsl/bin:/Users/alex/fsl/share/fsl/bin:/Applications/freesurfer/7.4.1/mni/bin:/Applications/freesurfer/7.4.1:/usr/local/bin/python3/:/Library/Frameworks/Python.framework/Versions/3.12/bin:/Users/alex/fsl/share/fsl/bin:/Users/alex/fsl/share/fsl/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/alex/ants/bin/:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/X11/bin']);
setenv('ANTSPATH','/Users/alex/ants/bin/')
setenv('FS_LICENSE','/Applications/freesurfer/7.4.1/license.txt')
setenv('FREESURFER_HOME','/Applications/freesurfer/7.4.1')
!source /Applications/freesurfer/7.4.1/SetUpFreeSurfer.sh
setenv( 'FSLDIR', '/Users/alex/fsl' );
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
fsldir = getenv('FSLDIR');
fsldirmpath = sprintf('%s/etc/matlab',fsldir);
path(path, fsldirmpath);
clear fsldir fsldirmpath;

%% mask postproc

for id=1:length(ids)

    %%%%%%%%%%%%%%%
    subj = ids{id};
    disp(['mask postproc ' subj])
    %%%%%%%%%%%%%%%

    for t1=1:numel(tasks)

        path_roi = [path_par subj 'v1s1/anat/roi/func/' tasks{t1} '/'];
        path_func =[path_par subj 'v1s1/func/'];

        % before starting, make a GM ribbon and other inclusive binary ROI masks
        % then postprocess the masks so that there's no overlapping voxels
        % across them

        eval(['!mri_binarize --i ' path_par subj...
            'v1s1/anat/roi/hpc_on_func-' tasks{t1} '.nii.gz '...
            '--o ' path_par subj...
            'v1s1/anat/roi/hpc_on_func-' tasks{t1} '_bin.nii.gz --min 0.1 --max 114'])
        eval(['!mri_binarize --i ' path_par subj...
            'v1s1/anat/roi/equi_volume_layers_bined_3layers_on_' tasks{t1} '.nii.gz '...
            '--o ' path_par subj...
            'v1s1/anat/roi/equi_volume_layers_bined_3layers_on_' tasks{t1} '_bin.nii.gz --min 0.1 --max 5'])
        eval(['!mri_binarize --i ' path_par subj...
            'v1s1/anat/roi/func/' tasks{t1} '/rim_columns300_on_' tasks{t1} '.nii.gz '...
            '--o ' path_par subj...
            'v1s1/anat/roi/func/' tasks{t1} '/rim_columns300_on_' tasks{t1} '_bin.nii.gz --min 0.0001 --max 300'])
        % WM
        eval(['!fslmaths ' ...
            path_par ids{id} 'v1s1/anat/roi/func/' tasks{t1} '/WM.nii.gz '...
            '-sub ' path_par ids{id} 'v1s1/anat/roi/hpc_on_func-' tasks{t1} '_bin.nii.gz '...
            '-thr 0 -bin ' ...
            path_par ids{id} 'v1s1/anat/roi/func/' tasks{t1} '/WM_clean.nii.gz'])

        postproc_rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','CA1','CA3','DG','Sub',...
            'RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};

        for rp1=1:length(postproc_rois)
            eval(['!fslmaths ' path_roi postproc_rois{rp1} '.nii.gz -mas '...
                path_par subj 'v1s1/anat/roi/func/' tasks{t1} '/rim_columns300_on_' tasks{t1} '_bin.nii.gz ' ...
                path_roi postproc_rois{rp1} '_GMmasked.nii.gz'])
        end
    end
end

%% CSF mask for CompCor

for id=1:length(ids)

    %%%%%%%%%%%%%%%
    subj = ids{id};
    disp(['CSF mask ' subj])
    %%%%%%%%%%%%%%%

    for t1=1:numel(tasks)

        % CSF
        clear matlabbatch tmp
        tmp=dir([ path_par subj 'v1s1/func/meanu' subj '*_task-' tasks{t1} '_run-0*_bold_stripped.nii']);
        if isempty(tmp)
        tmp=dir([ path_par subj 'v1s1/func/meanu' subj '*_task-' tasks{t1} '_run-0*_bold_stripped.nii.gz']);
        eval(['!gzip -d ' fullfile(tmp.folder, tmp.name)])
        meanepi=[tmp.folder '/' tmp.name(1:end-3)];
        else
        meanepi=[tmp.folder '/' tmp.name];
        end
        spm_jobman('initcfg')
        matlabbatch{1}.spm.spatial.preproc.channel.vols = {[ meanepi ',1']};
        matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
        matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
        matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/Users/alex/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
        matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
        matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/Users/alex/Documents/MATLAB/spm12/tpm/TPM.nii,2'};
        matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
        matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/Users/alex/Documents/MATLAB/spm12/tpm/TPM.nii,3'};
        matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
        matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/Users/alex/Documents/MATLAB/spm12/tpm/TPM.nii,4'};
        matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
        matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/Users/alex/Documents/MATLAB/spm12/tpm/TPM.nii,5'};
        matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
        matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/Users/alex/Documents/MATLAB/spm12/tpm/TPM.nii,6'};
        matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
        matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
        matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
        matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
        matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
        matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
        matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
        matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];
        matlabbatch{1}.spm.spatial.preproc.warp.vox = NaN;
        matlabbatch{1}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
            NaN NaN NaN];
        matlabbatch{2}.spm.util.imcalc.input(1) = cfg_dep('Segment: c3 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','c', '()',{':'}));
        matlabbatch{2}.spm.util.imcalc.output = [tasks{t1} '_csf_bin'];
        matlabbatch{2}.spm.util.imcalc.outdir = {[tmp.folder]};
        matlabbatch{2}.spm.util.imcalc.expression = 'i1>0.6';
        matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{2}.spm.util.imcalc.options.mask = 0;
        matlabbatch{2}.spm.util.imcalc.options.interp = 1;
        matlabbatch{2}.spm.util.imcalc.options.dtype = 4;

        spm_jobman('run',matlabbatch)

        eval(['!gzip -f ' tmp.folder '/*_stripped.nii'])

       
    end
    
end

%% after this, run CompCor