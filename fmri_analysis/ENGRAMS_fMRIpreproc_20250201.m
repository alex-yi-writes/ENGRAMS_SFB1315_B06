%% ENGRAMS fMRI preproc

%% prep

clear;

% paths
paths_results='/Users/yyi/Desktop/ENGRAMS/analyses/';
paths_source ='/Users/yyi/Desktop/ENGRAMS/preproc/';
paths_fx     ='/Users/yyi/Desktop/ENGRAMS/scripts/';

% subjects
ids={'sub-109v1s1'; 'sub-101v1s1'; 'sub-102v1s1'; 'sub-104v1s1'; 'sub-105v1s1'; 'sub-106v1s1'; 'sub-107v1s1'; 'sub-108v1s1'};
ids2={'sub-109v2s2'; 'sub-101v2s2'; 'sub-102v2s2'; 'sub-104v2s2'; 'sub-105v2s2'; 'sub-106v2s2'; 'sub-107v2s2'; 'sub-108v2s2'};


% load slice order
load('/Users/yyi/Desktop/ENGRAMS/scripts/ENGRAMS_SliceOrder.mat')

% scanning parameters
TR=2;
numSlice=96;
refSlice=0; % simplest
smoothingKernel=1.2;

flags=[];

%% Memory: realign, unwarp, and SOcorrect


for id=4:length(ids) % do 2:3 again

    fprintf(['\n****************** \n processing ' ids{id} '! \n ******************\n'])

    %% autobio

    fprintf('\n****************** \n autobio task \n ******************\n')

    clear fMRI phasemap magnitudemap nvols tmp

    eval(['!gzip -f -d ' paths_source ids2{id} '/func/' ids2{id} '_task-autobio_run-*_bold.nii.gz'])

    tmp=dir([paths_source ids2{id} '/func/' ids2{id} '_task-autobio_run-*_bold.nii']);

    % fmri
    nvols           = length( spm_vol( [paths_source ids2{id} '/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids2{id} '/func/' tmp.name ',' num2str(cc)];
    end

    % fieldmaps
    if id == 3
        phasemap        =  [paths_source ids2{id} '/fmap/' ids2{id} '_run-01_phasediff.nii,1'];
        magnitudemap    =  [paths_source ids2{id} '/fmap/' ids2{id} '_run-01_magnitude1.nii,1'];
        VDM             =  [paths_source ids2{id} '/fmap/vdm5_sc' ids2{id} '_run-01_phasediff.nii,1'];

        eval(['!gzip -f -d ' paths_source ids2{id} '/fmap/' ids2{id} '_run-01_phasediff.nii.gz'])
        eval(['!gzip -f -d ' paths_source ids2{id} '/fmap/' ids2{id} '_run-01_magnitude1.nii.gz'])

    else
        phasemap        =  [paths_source ids2{id} '/fmap/' ids2{id} '_phasediff.nii,1'];
        magnitudemap    =  [paths_source ids2{id} '/fmap/' ids2{id} '_magnitude1.nii,1'];
        VDM             =  [paths_source ids2{id} '/fmap/vdm5_sc' ids2{id} '_phasediff.nii,1'];

        eval(['!gzip -f -d ' paths_source ids2{id} '/fmap/' ids2{id} '_phasediff.nii.gz'])
        eval(['!gzip -f -d ' paths_source ids2{id} '/fmap/' ids2{id} '_magnitude1.nii.gz'])

    end


    % run

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
        fMRI{cc,1}  = [paths_source ids2{id} '/func/u' tmp.name ',' num2str(cc)];
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

    if strcmp('sub-105v1s1',ids{id})
        warning(['no memory tests for ' ids2{id}])
    else
        fprintf('\n****************** \n recognition(original) set \n ******************\n')

        clear fMRI nvols tmp

        try
            eval(['!gzip -f -d ' paths_source ids2{id} '/func/' ids2{id} '_task-origrec_run-*_bold.nii.gz'])
            tmp=dir([paths_source ids2{id} '/func/' ids2{id} '_task-origrec_run-*_bold.nii']);

            if length(tmp) ==1

                % fmri
                nvols           = length( spm_vol( [paths_source ids2{id} '/func/' tmp.name] ) );
                fMRI=[];
                for cc = 1:nvols
                    fMRI{cc,1}  = [paths_source ids2{id} '/func/' tmp.name ',' num2str(cc)];
                end

                % run
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
                    fMRI{cc,1}  = [paths_source ids2{id} '/func/u' tmp.name ',' num2str(cc)];
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
                    nvols           = length( spm_vol( [paths_source ids2{id} '/func/' tmp(runs).name] ) );
                    fMRI=[];
                    for cc = 1:nvols
                        fMRI{cc,1}  = [paths_source ids2{id} '/func/' tmp(runs).name ',' num2str(cc)];
                    end

                    % run

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
                        fMRI{cc,1}  = [paths_source ids2{id} '/func/u' tmp(runs).name ',' num2str(cc)];
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
            warning(['no data origrec for ' ids2{id}])
        end

        %% encoding

        fprintf('\n****************** \n encoding(original) set \n ******************\n')

        clear fMRI nvols tmp

        try

            eval(['!gzip -f -d ' paths_source ids2{id} '/func/' ids2{id} '_task-origenc_run-*_bold.nii.gz'])
            tmp=dir([paths_source ids2{id} '/func/' ids2{id} '_task-origenc_run-*_bold.nii']);

            % fmri
            nvols           = length( spm_vol( [paths_source ids2{id} '/func/' tmp.name] ) );
            fMRI=[];
            for cc = 1:nvols
                fMRI{cc,1}  = [paths_source ids2{id} '/func/' tmp.name ',' num2str(cc)];
            end

            % run

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
                fMRI{cc,1}  = [paths_source ids2{id} '/func/u' tmp.name ',' num2str(cc)];
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

        catch
            warning(['no data origenc for ' ids2{id}])
        end
    end


    %% resting state

    fprintf('\n****************** \n resting state \n ******************\n')

    clear fMRI nvols tmp

    if strcmp('sub-101v1s1',ids{id}) || strcmp('sub-102v1s1',ids{id})

        % fmri
        eval(['!gzip -f -d ' paths_source ids{id} '/func/' ids{id} '_task-rest_run-*_bold.nii.gz'])
        tmp=dir([paths_source ids{id} '/func/' ids{id} '_task-rest_run-*_bold.nii']);

        % fmri
        nvols           = length( tmp );
        fMRI=[];
        for cc = 1:nvols
            fMRI{cc,1}  = [paths_source ids{id} '/func/' ids{id} '_task-rest_run-' sprintf('%02i',cc) '_bold.nii,1'];
        end

    else

        % fmri
        eval(['!gzip -f -d ' paths_source ids{id} '/func/' ids{id} '_task-rest_run-*_bold.nii.gz'])
        tmp=dir([paths_source ids{id} '/func/' ids{id} '_task-rest_run-*_bold.nii']);

        % fmri
        nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp.name] ) );
        fMRI=[];
        for cc = 1:nvols
            fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp.name ',' num2str(cc)];
        end

    end

    % fieldmaps
    if strcmp('sub-999v1s1',ids{id})
        phasemap        =  [paths_source ids{id} '/fmap/' ids{id} '_run-01_phasediff.nii,1'];
        magnitudemap1   =  [paths_source ids{id} '/fmap/' ids{id} '_run-01_magnitude1.nii,1'];
        magnitudemap2   =  [paths_source ids{id} '/fmap/' ids{id} '_run-01_magnitude2.nii,1'];
        %         magnitudemap    =  [paths_source ids{id} '/fmap/' ids{id} '_run-01_magnitude1.nii,1'];
        VDM             =  [paths_source ids{id} '/fmap/vdm5_sc' ids{id} '_run-01_phasediff.nii,1'];

        eval(['!gzip -f -d ' paths_source ids{id} '/fmap/' ids{id} '_run-01_phasediff.nii.gz'])
        eval(['!gzip -f -d ' paths_source ids{id} '/fmap/' ids{id} '_run-01_magnitude1.nii.gz'])

    else
        phasemap        =  [paths_source ids{id} '/fmap/' ids{id} '_phasediff.nii,1'];
        magnitudemap1   =  [paths_source ids{id} '/fmap/' ids{id} '_magnitude1.nii,1'];
        magnitudemap2   =  [paths_source ids{id} '/fmap/' ids{id} '_magnitude2.nii,1'];
        %         magnitudemap    =  [paths_source ids{id} '/fmap/' ids{id} '_magnitude1.nii,1'];
        VDM             =  [paths_source ids{id} '/fmap/vdm5_sc' ids{id} '_phasediff.nii,1'];

        eval(['!gzip -f -d ' paths_source ids{id} '/fmap/' ids{id} '_phasediff.nii.gz'])
        eval(['!gzip -f -d ' paths_source ids{id} '/fmap/' ids{id} '_magnitude1.nii.gz'])

    end


    % run

    % calc vdm
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.phase = {phasemap};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.magnitude = ...
        {magnitudemap1
        magnitudemap2};%{magnitudemap};
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
    if strcmp('sub-101v1s1',ids{id}) || strcmp('sub-102v1s1',ids{id}) % TR=2.5 for rest
        matlabbatch{1}.spm.temporal.st.tr = 2.5;
        matlabbatch{1}.spm.temporal.st.ta = 2.5-(2.5/numSlice);
    else
        matlabbatch{1}.spm.temporal.st.tr = TR;
        matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
    end
    matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
    matlabbatch{1}.spm.temporal.st.refslice = refSlice;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    spm_jobman('run',matlabbatch)

    %% housekeeping

    eval(['!gzip -f ' paths_source ids{id} '/func/mean*.nii'])
    eval(['!gzip -f ' paths_source ids{id} '/func/usub*.nii'])
    eval(['!gzip -f ' paths_source ids{id} '/func/sub*.nii'])

    eval(['!gzip -f ' paths_source ids2{id} '/func/mean*.nii'])
    eval(['!gzip -f ' paths_source ids2{id} '/func/usub*.nii'])
    eval(['!gzip -f ' paths_source ids2{id} '/func/sub*.nii'])

    disp('done')

end

%% smoothing


for id=1%:length(ids)

    fprintf(['\n****************** \n smooting ' ids2{id} '! \n ******************\n'])

%     % autobio
%     clear fMRI nvols tmp matlabbatch
% 
%     tmp=dir([paths_source ids2{id} '/func/au' ids2{id} '_task-autobio_run-*_bold.nii']);
%     fmri
%     nvols           = length( spm_vol( [paths_source ids2{id} '/func/' tmp.name] ) );
%     fMRI=[];
%     for cc = 1:nvols
%         fMRI{cc,1}  = [paths_source ids2{id} '/func/' tmp.name ',' num2str(cc)];
%     end
% 
%     spm_jobman('initcfg')
% 
%     matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
%     matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
%     matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%     matlabbatch{1}.spm.spatial.smooth.im = 0;
%     matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';
% 
%     spm_jobman('run',matlabbatch)


    %% enc

    clear fMRI nvols tmp matlabbatch

    try
        tmp=dir([paths_source ids2{id} '/func/au' ids2{id} '_task-origenc_run-*_bold.nii']);
        % fmri
        nvols           = length( spm_vol( [paths_source ids2{id} '/func/' tmp.name] ) );
        fMRI=[];
        for cc = 1:nvols
            fMRI{cc,1}  = [paths_source ids2{id} '/func/' tmp.name ',' num2str(cc)];
        end

        spm_jobman('initcfg')

        matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
        matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
        matlabbatch{1}.spm.spatial.smooth.dtype = 0;
        matlabbatch{1}.spm.spatial.smooth.im = 0;
        matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

        spm_jobman('run',matlabbatch)

    catch
        warning(['no data origenc for ' ids2{id}])
    end

    %% rec

    clear fMRI nvols tmp matlabbatch

    try
        tmp=dir([paths_source ids2{id} '/func/au' ids2{id} '_task-origrec_run-*_bold.nii']);

        if length(tmp) ==1

            % fmri
            nvols           = length( spm_vol( [paths_source ids2{id} '/func/' tmp.name] ) );
            fMRI=[];
            for cc = 1:nvols
                fMRI{cc,1}  = [paths_source ids2{id} '/func/' tmp.name ',' num2str(cc)];
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
                nvols           = length( spm_vol( [paths_source ids2{id} '/func/' tmp(runs).name] ) );
                fMRI=[];
                for cc = 1:nvols
                    fMRI{cc,1}  = [paths_source ids2{id} '/func/' tmp(runs).name ',' num2str(cc)];
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
        warning(['no data origrec for ' ids2{id}])
    end

    %% rest

    clear fMRI nvols tmp matlabbatch

    try
        tmp=dir([paths_source ids{id} '/func/au' ids{id} '_task-rest_run-*_bold.nii']);
        % fmri
        nvols           = length( spm_vol( [paths_source ids{id} '/func/' tmp.name] ) );
        fMRI=[];
        for cc = 1:nvols
            fMRI{cc,1}  = [paths_source ids{id} '/func/' tmp.name ',' num2str(cc)];
        end

        spm_jobman('initcfg')

        matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
        matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
        matlabbatch{1}.spm.spatial.smooth.dtype = 0;
        matlabbatch{1}.spm.spatial.smooth.im = 0;
        matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';

        spm_jobman('run',matlabbatch)

    catch
        warning(['no data rest for ' ids{id}])
    end

    %% housekeeping

    eval(['!gzip -f ' paths_source ids{id} '/func/au*.nii'])

end