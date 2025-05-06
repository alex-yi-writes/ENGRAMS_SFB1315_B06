%% ENGRAMS fMRI preproc

%% prep

clear;

% paths
paths_results='/Users/yyi/Desktop/ENGRAMS/analyses/';
paths_source ='/Users/yyi/Desktop/ENGRAMS/preproc/';
paths_fx     ='/Users/yyi/Desktop/ENGRAMS/scripts/';

% subjects
ids={'sub-202'};

% load slice order
load('/Users/yyi/Desktop/ENGRAMS/scripts/ENGRAMS_SliceOrder.mat')

% scanning parameters
TR=2;
numSlice=96;
refSlice=0; % simplest
smoothingKernel=1.2;

flags=[];

%% Memory: realign, unwarp, and SOcorrect


for id=1:length(ids)

    fprintf(['\n****************** \n processing ' ids{id} '! \n ******************\n'])

    %% original encoding

    fprintf('\n****************** \n first encoding \n ******************\n')

    clear fMRI phasemap magnitudemap nvols tmp

    eval(['!gzip -f -d ' paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-origenc_run-*_bold.nii.gz'])

    tmp=dir([paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-origenc_run-*_bold.nii']);

    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp.name ',' num2str(cc)];
    end

    % fieldmaps
    if id == 1
        phasemap        =  [paths_source ids{id} 'v1s1/fmap/' ids{id} 'v1s1_run-01_phasediff.nii,1'];
        magnitudemap    =  [paths_source ids{id} 'v1s1/fmap/' ids{id} 'v1s1_run-01_magnitude1.nii,1'];
        VDM             =  [paths_source ids{id} 'v1s1/fmap/vdm5_sc' ids{id} 'v1s1_run-01_phasediff.nii,1'];

        eval(['!gzip -f -d ' paths_source ids{id} 'v1s1/fmap/' ids{id} 'v1s1_run-01_phasediff.nii.gz'])
        eval(['!gzip -f -d ' paths_source ids{id} 'v1s1/fmap/' ids{id} 'v1s1_run-01_magnitude1.nii.gz'])

    else
        phasemap        =  [paths_source ids{id} 'v1s1/fmap/' ids{id} 'v1s1_phasediff.nii,1'];
        magnitudemap    =  [paths_source ids{id} 'v1s1/fmap/' ids{id} 'v1s1_magnitude1.nii,1'];
        VDM             =  [paths_source ids{id} 'v1s1/fmap/vdm5_sc' ids{id} 'v1s1_phasediff.nii,1'];

        eval(['!gzip -f -d ' paths_source ids{id} 'v1s1/fmap/' ids{id} 'v1s1_phasediff.nii.gz'])
        eval(['!gzip -f -d ' paths_source ids{id} 'v1s1/fmap/' ids{id} 'v1s1_magnitude1.nii.gz'])
        
    end


    % run
    clear matlabbatch
    spm_jobman('initcfg')
    % estimate realignment parameters
    matlabbatch{1}.spm.spatial.realign.estimate.data = {fMRI};
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 1;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 2;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
    spm_jobman('run',matlabbatch)

    % calc vdm
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.phase = {phasemap};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.magnitude = {magnitudemap};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsfile = {'/Users/yyi/Desktop/ENGRAMS/scripts/pm_defaults_ENGRAMS.m'};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = fMRI(1);
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 0;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = '';
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;
    spm_jobman('run',matlabbatch)

    % unwarp
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = fMRI;
    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = cellstr(VDM);
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    spm_jobman('run',matlabbatch)


    % slice-time correction
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/u' tmp.name ',' num2str(cc)];
    end
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.temporal.st.scans = {fMRI};
    matlabbatch{1}.spm.temporal.st.nslices = numSlice;
    matlabbatch{1}.spm.temporal.st.tr = TR;
    matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
    matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
    matlabbatch{1}.spm.temporal.st.refslice = refSlice;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    spm_jobman('run',matlabbatch)


    %% recognition

    fprintf('\n****************** \n recognition(original) set \n ******************\n')

    clear fMRI nvols tmp

    try
        eval(['!gzip -f -d ' paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-origrec_run-*_bold.nii.gz'])
        tmp=dir([paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-origrec_run-*_bold.nii']);

        if length(tmp) ==1

            % fmri
            nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp.name] ) );
            fMRI=[];
            for cc = 1:nvols
                fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp.name ',' num2str(cc)];
            end

            % run
            clear matlabbatch
            spm_jobman('initcfg')
            matlabbatch{1}.spm.spatial.realign.estimate.data = {fMRI};
            matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
            matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 1;
            matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 2;
            matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;
            matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 4;
            matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
            matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
            spm_jobman('run',matlabbatch)

            clear matlabbatch
            spm_jobman('initcfg')
            matlabbatch{1}.spm.spatial.realignunwarp.data.scans = fMRI;
            matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = cellstr(VDM);
            matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
            matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 1;
            matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 2;
            matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
            matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 4;
            matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
            matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
            matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
            matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
            matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
            matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
            matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
            matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
            spm_jobman('run',matlabbatch)

            fMRI=[];
            for cc = 1:nvols
                fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/u' tmp.name ',' num2str(cc)];
            end
            clear matlabbatch
            spm_jobman('initcfg')
            matlabbatch{1}.spm.temporal.st.scans = {fMRI};
            matlabbatch{1}.spm.temporal.st.nslices = numSlice;
            matlabbatch{1}.spm.temporal.st.tr = TR;
            matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
            matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
            matlabbatch{1}.spm.temporal.st.refslice = refSlice;
            matlabbatch{1}.spm.temporal.st.prefix = 'a';
            spm_jobman('run',matlabbatch)

        else
            disp('multiple runs detected')

            for runs=1:length(tmp)

                % fmri
                nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp(runs).name] ) );
                fMRI=[];
                for cc = 1:nvols
                    fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp(runs).name ',' num2str(cc)];
                end

                % run
                clear matlabbatch
                spm_jobman('initcfg')
                matlabbatch{1}.spm.spatial.realign.estimate.data = {fMRI};
                matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
                matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 1;
                matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 2;
                matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;
                matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 4;
                matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
                matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
                spm_jobman('run',matlabbatch)

                clear matlabbatch
                spm_jobman('initcfg')
                matlabbatch{1}.spm.spatial.realignunwarp.data.scans = fMRI;
                matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = cellstr(VDM);
                matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
                matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 1;
                matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 2;
                matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
                matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 4;
                matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
                matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
                matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
                matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
                matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
                matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
                matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
                matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
                spm_jobman('run',matlabbatch)

                fMRI=[];
                for cc = 1:nvols
                    fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/u' tmp(runs).name ',' num2str(cc)];
                end
                clear matlabbatch
                spm_jobman('initcfg')
                matlabbatch{1}.spm.temporal.st.scans = {fMRI};
                matlabbatch{1}.spm.temporal.st.nslices = numSlice;
                matlabbatch{1}.spm.temporal.st.tr = TR;
                matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
                matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
                matlabbatch{1}.spm.temporal.st.refslice = refSlice;
                matlabbatch{1}.spm.temporal.st.prefix = 'a';
                spm_jobman('run',matlabbatch)

            end
        end
    catch
        warning(['no data origrec for ' ids{id}])
    end

    %% recognition 2nd (original)

    fprintf('\n****************** \n 2nd recognition original set \n ******************\n')

    clear fMRI phasemap magnitudemap nvols tmp

    eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-origrec2_run-*_bold.nii.gz'])

    tmp=dir([paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-origrec2_run-*_bold.nii']);

    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
    end

    % fieldmaps
    if id == 3
        phasemap        =  [paths_source ids{id} 'v2s1/fmap/' ids{id} 'v2s1_run-01_phasediff.nii,1'];
        magnitudemap    =  [paths_source ids{id} 'v2s1/fmap/' ids{id} 'v2s1_run-01_magnitude1.nii,1'];
        VDM             =  [paths_source ids{id} 'v2s1/fmap/vdm5_sc' ids{id} 'v2s1_run-01_phasediff.nii,1'];

        eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/fmap/' ids{id} 'v2s1_run-01_phasediff.nii.gz'])
        eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/fmap/' ids{id} 'v2s1_run-01_magnitude1.nii.gz'])

    else
        phasemap        =  [paths_source ids{id} 'v2s1/fmap/' ids{id} 'v2s1_phasediff.nii,1'];
        magnitudemap    =  [paths_source ids{id} 'v2s1/fmap/' ids{id} 'v2s1_magnitude1.nii,1'];
        VDM             =  [paths_source ids{id} 'v2s1/fmap/vdm5_sc' ids{id} 'v2s1_phasediff.nii,1'];

        eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/fmap/' ids{id} 'v2s1_phasediff.nii.gz'])
        eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/fmap/' ids{id} 'v2s1_magnitude1.nii.gz'])
        
    end


    % run
    clear matlabbatch
    spm_jobman('initcfg')
    % estimate realignment parameters
    matlabbatch{1}.spm.spatial.realign.estimate.data = {fMRI};
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 1;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 2;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
    spm_jobman('run',matlabbatch)

    % calc vdm
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.phase = {phasemap};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.magnitude = {magnitudemap};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsfile = {'/Users/yyi/Desktop/ENGRAMS/scripts/pm_defaults_ENGRAMS.m'};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = fMRI(1);
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 0;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = '';
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;
    spm_jobman('run',matlabbatch)

    % unwarp
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = fMRI;
    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = cellstr(VDM);
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    spm_jobman('run',matlabbatch)


    % slice-time correction
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/u' tmp.name ',' num2str(cc)];
    end
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.temporal.st.scans = {fMRI};
    matlabbatch{1}.spm.temporal.st.nslices = numSlice;
    matlabbatch{1}.spm.temporal.st.tr = TR;
    matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
    matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
    matlabbatch{1}.spm.temporal.st.refslice = refSlice;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    spm_jobman('run',matlabbatch)


    %% encoding recombination

    fprintf('\n****************** \n encoding recombination set \n ******************\n')

    clear fMRI nvols tmp
    eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-recombienc_run-*_bold.nii.gz'])
    tmp=dir([paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-recombienc_run-*_bold.nii']);

    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
    end

    % run
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.spatial.realign.estimate.data = {fMRI};
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 1;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 2;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
    spm_jobman('run',matlabbatch)

    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = fMRI;
    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = cellstr(VDM);
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    spm_jobman('run',matlabbatch)

    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/u' tmp.name ',' num2str(cc)];
    end
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.temporal.st.scans = {fMRI};
    matlabbatch{1}.spm.temporal.st.nslices = numSlice;
    matlabbatch{1}.spm.temporal.st.tr = TR;
    matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
    matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
    matlabbatch{1}.spm.temporal.st.refslice = refSlice;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    spm_jobman('run',matlabbatch)


    %% recognition recombination

    fprintf('\n****************** \n recognition recombination set \n ******************\n')

    clear fMRI nvols tmp
    eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-recombirec_run-*_bold.nii.gz'])
    tmp=dir([paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-recombirec_run-*_bold.nii']);

    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
    end

    % run
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.spatial.realign.estimate.data = {fMRI};
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 1;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 2;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
    spm_jobman('run',matlabbatch)

    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = fMRI;
    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = cellstr(VDM);
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    spm_jobman('run',matlabbatch)

    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/u' tmp.name ',' num2str(cc)];
    end
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.temporal.st.scans = {fMRI};
    matlabbatch{1}.spm.temporal.st.nslices = numSlice;
    matlabbatch{1}.spm.temporal.st.tr = TR;
    matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
    matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
    matlabbatch{1}.spm.temporal.st.refslice = refSlice;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    spm_jobman('run',matlabbatch)

    %% housekeeping

    eval(['!gzip -f ' paths_source ids{id} 'v2s1/func/mean*.nii'])
    eval(['!gzip -f ' paths_source ids{id} 'v2s1/func/usub*.nii'])
    eval(['!gzip -f ' paths_source ids{id} 'v2s1/func/sub*.nii'])
    
    eval(['!gzip -f ' paths_source ids{id} 'v1s1/func/mean*.nii'])
    eval(['!gzip -f ' paths_source ids{id} 'v1s1/func/usub*.nii'])
    eval(['!gzip -f ' paths_source ids{id} 'v1s1/func/sub*.nii'])

    disp('done')

end

%% smoothing


for id=1:length(ids)

    fprintf(['\n****************** \n smooting ' ids{id} '! \n ******************\n'])

    %% origenc
    clear fMRI nvols tmp matlabbatch

    tmp=dir([paths_source ids{id} 'v1s1/func/au' ids{id} 'v1s1_task-origenc_run-*_bold.nii']);
    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp.name ',' num2str(cc)];
    end

    spm_jobman('initcfg')

    matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

    spm_jobman('run',matlabbatch)


    %% origrec

    clear fMRI nvols tmp matlabbatch

    try
        tmp=dir([paths_source ids{id} 'v1s1/func/au' ids{id} 'v1s1_task-origrec_run-*_bold.nii']);
        % fmri
        nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp.name] ) );
        fMRI=[];
        for cc = 1:nvols
            fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp.name ',' num2str(cc)];
        end

        spm_jobman('initcfg')

        matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
        matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
        matlabbatch{1}.spm.spatial.smooth.dtype = 0;
        matlabbatch{1}.spm.spatial.smooth.im = 0;
        matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

        spm_jobman('run',matlabbatch)

    catch
        warning(['no data origenc for ' ids{id}])
    end

    %% origrec2

    clear fMRI nvols tmp matlabbatch

    try
        tmp=dir([paths_source ids{id} 'v2s1/func/au' ids{id} 'v2s1_task-origrec2_run-*_bold.nii']);

        if length(tmp) ==1

            % fmri
            nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
            fMRI=[];
            for cc = 1:nvols
                fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
            end

            spm_jobman('initcfg')

            matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
            matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
            matlabbatch{1}.spm.spatial.smooth.dtype = 0;
            matlabbatch{1}.spm.spatial.smooth.im = 0;
            matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

            spm_jobman('run',matlabbatch)
        else

            disp('multiple runs detected')

            for runs=1:length(tmp)

                % fmri
                nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp(runs).name] ) );
                fMRI=[];
                for cc = 1:nvols
                    fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp(runs).name ',' num2str(cc)];
                end

                spm_jobman('initcfg')

                matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
                matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
                matlabbatch{1}.spm.spatial.smooth.dtype = 0;
                matlabbatch{1}.spm.spatial.smooth.im = 0;
                matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

                spm_jobman('run',matlabbatch)
            end
        end
    catch
        warning(['no data origrec for ' ids{id}])
    end

    %% recombienc

    clear fMRI nvols tmp matlabbatch

    try
        tmp=dir([paths_source ids{id} 'v2s1/func/au' ids{id} 'v2s1_task-recombienc_run-*_bold.nii']);

        if length(tmp) ==1

            % fmri
            nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
            fMRI=[];
            for cc = 1:nvols
                fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
            end

            spm_jobman('initcfg')

            matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
            matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
            matlabbatch{1}.spm.spatial.smooth.dtype = 0;
            matlabbatch{1}.spm.spatial.smooth.im = 0;
            matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

            spm_jobman('run',matlabbatch)
        else

            disp('multiple runs detected')

            for runs=1:length(tmp)

                % fmri
                nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp(runs).name] ) );
                fMRI=[];
                for cc = 1:nvols
                    fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp(runs).name ',' num2str(cc)];
                end

                spm_jobman('initcfg')

                matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
                matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
                matlabbatch{1}.spm.spatial.smooth.dtype = 0;
                matlabbatch{1}.spm.spatial.smooth.im = 0;
                matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

                spm_jobman('run',matlabbatch)
            end
        end
    catch
        warning(['no data origrec for ' ids{id}])
    end

    %% recombirec
    
    clear fMRI nvols tmp matlabbatch

    try
        tmp=dir([paths_source ids{id} 'v2s1/func/au' ids{id} 'v2s1_task-recombirec_run-*_bold.nii']);

        if length(tmp) ==1

            % fmri
            nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
            fMRI=[];
            for cc = 1:nvols
                fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
            end

            spm_jobman('initcfg')

            matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
            matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
            matlabbatch{1}.spm.spatial.smooth.dtype = 0;
            matlabbatch{1}.spm.spatial.smooth.im = 0;
            matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

            spm_jobman('run',matlabbatch)
        else

            disp('multiple runs detected')

            for runs=1:length(tmp)

                % fmri
                nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp(runs).name] ) );
                fMRI=[];
                for cc = 1:nvols
                    fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp(runs).name ',' num2str(cc)];
                end

                spm_jobman('initcfg')

                matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
                matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
                matlabbatch{1}.spm.spatial.smooth.dtype = 0;
                matlabbatch{1}.spm.spatial.smooth.im = 0;
                matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

                spm_jobman('run',matlabbatch)
            end
        end
    catch
        warning(['no data origrec for ' ids{id}])
    end


    %% housekeeping

    eval(['!gzip -f ' paths_source ids{id} 'v2s1/func/au*.nii'])
    eval(['!gzip -f ' paths_source ids{id} 'v1s1/func/au*.nii'])

end