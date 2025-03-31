%% ENGRAMS fMRI preproc

%% prep

% paths
paths_results='/Users/yyi/Desktop/ENGRAMS/analyses/';
paths_source ='/Users/yyi/Desktop/ENGRAMS/preproc/';
paths_fx     ='/Users/yyi/Desktop/ENGRAMS/scripts/';

% subjects
ids={'sub-101v2s2'; 'sub-102v2s2'; 'sub-104v2s2'; 'sub-105v2s2'; 'sub-106v2s2'; 'sub-107v2s2'};

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

    %% autobio

    fprintf('\n****************** \n autobio task \n ******************\n')

    clear fMRI phasemap magnitudemap nvols tmp

    eval(['!gzip -d ' paths_source ids{id} '/func/' ids{id} '_task-autobio_run-*_bold.nii.gz'])

    tmp=dir([paths_source ids{id} '/func/' ids{id} '_task-autobio_run-*_bold.nii']);

    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp.name ',' num2str(cc)];
    end

    % fieldmaps
    try
        phasemap        =  [paths_source ids{id} '/fmap/' ids{id} '_phasediff.nii,1'];
        magnitudemap    =  [paths_source ids{id} '/fmap/' ids{id} '_magnitude1.nii,1'];
        VDM             =  [paths_source ids{id} '/fmap/vdm5_sc' ids{id} '_phasediff.nii,1'];

        eval(['!gzip -d ' paths_source ids{id} '/fmap/' ids{id} '_phasediff.nii.gz'])
        eval(['!gzip -d ' paths_source ids{id} '/fmap/' ids{id} '_magnitude1.nii.gz'])
    catch
        phasemap        =  [paths_source ids{id} '/fmap/' ids{id} '_run-01_phasediff.nii,1'];
        magnitudemap    =  [paths_source ids{id} '/fmap/' ids{id} '_run-01_magnitude1.nii,1'];
        VDM             =  [paths_source ids{id} '/fmap/vdm5_sc' ids{id} '_run-01_phasediff.nii,1'];

        eval(['!gzip -d ' paths_source ids{id} '/fmap/' ids{id} '_run-01_phasediff.nii.gz'])
        eval(['!gzip -d ' paths_source ids{id} '/fmap/' ids{id} '_run-01_magnitude1.nii.gz'])
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
        fMRI{cc,1}  = [paths_source ids{id} '/func/u' tmp.name ',' num2str(cc)];
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
        eval(['!gzip -d ' paths_source ids{id} '/func/' ids{id} '_task-origrec_run-*_bold.nii.gz'])
        tmp=dir([paths_source ids{id} '/func/' ids{id} '_task-origrec_run-*_bold.nii']);

        if length(tmp) ==1

            % fmri
            nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp.name] ) );
            fMRI=[];
            for cc = 1:nvols
                fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp.name ',' num2str(cc)];
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
                fMRI{cc,1}  = [paths_source ids{id} '/func/u' tmp.name ',' num2str(cc)];
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
                nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp(runs).name] ) );
                fMRI=[];
                for cc = 1:nvols
                    fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp(runs).name ',' num2str(cc)];
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
                    fMRI{cc,1}  = [paths_source ids{id} '/func/u' tmp(runs).name ',' num2str(cc)];
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

    %% encoding

    fprintf('\n****************** \n encoding(original) set \n ******************\n')

    clear fMRI nvols tmp

    try

        eval(['!gzip -d ' paths_source ids{id} '/func/' ids{id} '_task-origenc_run-*_bold.nii.gz'])
        tmp=dir([paths_source ids{id} '/func/' ids{id} '_task-origenc_run-*_bold.nii']);

        % fmri
        nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp.name] ) );
        fMRI=[];
        for cc = 1:nvols
            fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp.name ',' num2str(cc)];
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
            fMRI{cc,1}  = [paths_source ids{id} '/func/u' tmp.name ',' num2str(cc)];
        end
        clear matlabbatch
        spm_jobman('initcfg')
        matlabbatch{1}.spm.temporal.st.scans = fMRI;
        matlabbatch{1}.spm.temporal.st.nslices = numSlice;
        matlabbatch{1}.spm.temporal.st.tr = TR;
        matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
        matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
        matlabbatch{1}.spm.temporal.st.refslice = refSlice;
        matlabbatch{1}.spm.temporal.st.prefix = 'a';
        spm_jobman('run',matlabbatch)

    catch
        warning(['no data origenc for ' ids{id}])
    end

    %% housekeeping

    eval(['!gzip ' paths_source ids{id} '/func/mean*.nii'])
    eval(['!gzip ' paths_source ids{id} '/func/usub*.nii'])
    eval(['!gzip ' paths_source ids{id} '/func/sub*.nii'])

    disp('done')

end

%% smoothing


for id=1:length(ids)

    fprintf(['\n****************** \n smooting ' ids{id} '! \n ******************\n'])

    %% autobio
    clear fMRI nvols tmp matlabbatch

    tmp=dir([paths_source ids{id} '/func/au' ids{id} '_task-autobio_run-*_bold.nii']);
    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp.name ',' num2str(cc)];
    end

    spm_jobman('initcfg')

    matlabbatch{1}.spm.spatial.smooth.data = {fMRI};
    matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';

    spm_jobman('run',matlabbatch)


    %% enc

    clear fMRI nvols tmp matlabbatch

    try
        tmp=dir([paths_source ids{id} '/func/au' ids{id} '_task-origenc_run-*_bold.nii']);
        % fmri
        nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp.name] ) );
        fMRI=[];
        for cc = 1:nvols
            fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp.name ',' num2str(cc)];
        end

        spm_jobman('initcfg')

        matlabbatch{1}.spm.spatial.smooth.data = {fMRI};
        matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
        matlabbatch{1}.spm.spatial.smooth.dtype = 0;
        matlabbatch{1}.spm.spatial.smooth.im = 0;
        matlabbatch{1}.spm.spatial.smooth.prefix = 's';

        spm_jobman('run',matlabbatch)

    catch
        warning(['no data origenc for ' ids{id}])
    end

    %% rec

    clear fMRI nvols tmp matlabbatch

    try
        tmp=dir([paths_source ids{id} '/func/au' ids{id} '_task-origrec_run-*_bold.nii']);

        if length(tmp) ==1

            % fmri
            nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp.name] ) );
            fMRI=[];
            for cc = 1:nvols
                fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp.name ',' num2str(cc)];
            end

            spm_jobman('initcfg')

            matlabbatch{1}.spm.spatial.smooth.data = {fMRI};
            matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
            matlabbatch{1}.spm.spatial.smooth.dtype = 0;
            matlabbatch{1}.spm.spatial.smooth.im = 0;
            matlabbatch{1}.spm.spatial.smooth.prefix = 's';

            spm_jobman('run',matlabbatch)
        else

            disp('multiple runs detected')

            for runs=1:length(tmp)

                % fmri
                nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp(runs).name] ) );
                fMRI=[];
                for cc = 1:nvols
                    fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp(runs).name ',' num2str(cc)];
                end

                spm_jobman('initcfg')

                matlabbatch{1}.spm.spatial.smooth.data = {fMRI};
                matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
                matlabbatch{1}.spm.spatial.smooth.dtype = 0;
                matlabbatch{1}.spm.spatial.smooth.im = 0;
                matlabbatch{1}.spm.spatial.smooth.prefix = 's';

                spm_jobman('run',matlabbatch)
            end
        end
    catch
        warning(['no data origrec for ' ids{id}])
    end


    %% housekeeping

    eval(['!gzip ' paths_source ids{id} '/func/au*.nii'])

end