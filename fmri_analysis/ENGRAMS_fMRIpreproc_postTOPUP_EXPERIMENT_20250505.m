%% ENGRAMS fMRI preproc

%% prep

clear;

% paths
paths_results='/Users/yyi/Desktop/ENGRAMS/analyses/';
paths_source ='/Users/yyi/Desktop/ENGRAMS/preproc/';
paths_fx     ='/Users/yyi/Desktop/ENGRAMS/scripts/';

% subjects
ids={'sub-306'};

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

%      %% resting state
% 
%     fprintf('\n****************** \n resting state \n ******************\n')
% 
%     clear fMRI nvols tmp
% 
%     % fmri
%     eval(['!gzip -f -d ' paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-rest_run-*_topup.nii.gz'])
%     tmp=dir([paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-rest_run-*_topup.nii']);
% 
%     % fmri
%     nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp.name] ) );
%     fMRI=[];
%     for cc = 1:nvols
%         fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp.name ',' num2str(cc)];
%     end
% 
%     clear matlabbatch
%     spm_jobman('initcfg')
%     % unwarping is now replaced with just realignment
%     matlabbatch{1}.spm.spatial.realign.estwrite.data = {fMRI};
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 2;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 3;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 4;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
%     spm_jobman('run',matlabbatch)
% 
%     % slice-time correction
%     fMRI=[];
%     for cc = 1:nvols
%         fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/r' tmp.name ',' num2str(cc)];
%     end
%     flags{id,1}.rest.SOcorr=0;
%     clear matlabbatch
%     spm_jobman('initcfg')
%     matlabbatch{1}.spm.temporal.st.scans = {fMRI};
%     matlabbatch{1}.spm.temporal.st.nslices = numSlice;
%     matlabbatch{1}.spm.temporal.st.tr = TR;
%     matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
%     matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
%     matlabbatch{1}.spm.temporal.st.refslice = refSlice;
%     matlabbatch{1}.spm.temporal.st.prefix = 'a';
%     spm_jobman('run',matlabbatch)
%     flags{id,1}.rest.SOcorr=1;
% 
%     %% original encoding
% 
%     fprintf('\n****************** \n first encoding \n ******************\n')
% 
%     clear fMRI phasemap magnitudemap nvols tmp
% 
%     eval(['!gzip -f -d ' paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-origenc_run-*_topup.nii.gz'])
% 
%     tmp=dir([paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-origenc_run-*_topup.nii']);
% 
%     % fmri
%     nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp.name] ) );
%     fMRI=[];
%     for cc = 1:nvols
%         fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp.name ',' num2str(cc)];
%     end
% 
%     clear matlabbatch
%     spm_jobman('initcfg')
%     % unwarping is now replaced with just realignment
%     matlabbatch{1}.spm.spatial.realign.estwrite.data = {fMRI};
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 2;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 3;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 4;
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
%     matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
%     matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
%     spm_jobman('run',matlabbatch)
% 
%     % slice-time correction
%     fMRI=[];
%     for cc = 1:nvols
%         fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/r' tmp.name ',' num2str(cc)];
%     end
%     flags{id,1}.origenc.SOcorr=0;
%     clear matlabbatch
%     spm_jobman('initcfg')
%     matlabbatch{1}.spm.temporal.st.scans = {fMRI};
%     matlabbatch{1}.spm.temporal.st.nslices = numSlice;
%     matlabbatch{1}.spm.temporal.st.tr = TR;
%     matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
%     matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
%     matlabbatch{1}.spm.temporal.st.refslice = refSlice;
%     matlabbatch{1}.spm.temporal.st.prefix = 'a';
%     spm_jobman('run',matlabbatch)
%     flags{id,1}.origenc.SOcorr=1;
% 
% 
%     %% recognition
% 
%     fprintf('\n****************** \n recognition(original) set \n ******************\n')
% 
%     clear fMRI nvols tmp
% 
%     try
%         eval(['!gzip -f -d ' paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-origrec1_run-*_topup.nii.gz'])
%         tmp=dir([paths_source ids{id} 'v1s1/func/' ids{id} 'v1s1_task-origrec1_run-*_topup.nii']);
% 
%         if length(tmp) ==1
% 
%             % fmri
%             nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp.name] ) );
%             fMRI=[];
%             for cc = 1:nvols
%                 fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp.name ',' num2str(cc)];
%             end
% 
%             % run
%             clear matlabbatch
%             spm_jobman('initcfg')
%             % unwarping is now replaced with just realignment
%             matlabbatch{1}.spm.spatial.realign.estwrite.data = {fMRI};
%             matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
%             matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 2;
%             matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 3;
%             matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
%             matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 4;
%             matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
%             matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
%             matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
%             matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
%             matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
%             matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
%             matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
%             spm_jobman('run',matlabbatch)
% 
%             fMRI=[];
%             for cc = 1:nvols
%                 fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/r' tmp.name ',' num2str(cc)];
%             end
%             flags{id,1}.origrec1.SOcorr=0;
%             clear matlabbatch
%             spm_jobman('initcfg')
%             matlabbatch{1}.spm.temporal.st.scans = {fMRI};
%             matlabbatch{1}.spm.temporal.st.nslices = numSlice;
%             matlabbatch{1}.spm.temporal.st.tr = TR;
%             matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
%             matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
%             matlabbatch{1}.spm.temporal.st.refslice = refSlice;
%             matlabbatch{1}.spm.temporal.st.prefix = 'a';
%             spm_jobman('run',matlabbatch)
%             flags{id,1}.origrec1.SOcorr=1;
% 
%         else
%             disp('multiple runs detected')
% 
%             for runs=1:length(tmp)
% 
%                 % fmri
%                 nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp(runs).name] ) );
%                 fMRI=[];
%                 for cc = 1:nvols
%                     fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp(runs).name ',' num2str(cc)];
%                 end
% 
%                 % run
%                 clear matlabbatch
%                 spm_jobman('initcfg')
%                 % unwarping is now replaced with just realignment
%                 matlabbatch{1}.spm.spatial.realign.estwrite.data = {fMRI};
%                 matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
%                 matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 2;
%                 matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 3;
%                 matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
%                 matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 4;
%                 matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
%                 matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
%                 matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
%                 matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
%                 matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
%                 matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
%                 matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
%                 spm_jobman('run',matlabbatch)
% 
%                 fMRI=[];
%                 for cc = 1:nvols
%                     fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/r' tmp(runs).name ',' num2str(cc)];
%                 end
%                 flags{id,1}.origrec1.SOcorr=0;
%                 clear matlabbatch
%                 spm_jobman('initcfg')
%                 matlabbatch{1}.spm.temporal.st.scans = {fMRI};
%                 matlabbatch{1}.spm.temporal.st.nslices = numSlice;
%                 matlabbatch{1}.spm.temporal.st.tr = TR;
%                 matlabbatch{1}.spm.temporal.st.ta = TR-(TR/numSlice);
%                 matlabbatch{1}.spm.temporal.st.so = ENGRAMS_SliceOrder;
%                 matlabbatch{1}.spm.temporal.st.refslice = refSlice;
%                 matlabbatch{1}.spm.temporal.st.prefix = 'a';
%                 spm_jobman('run',matlabbatch)
%                 flags{id,1}.origrec1.SOcorr=1;
% 
%             end
%         end
%     catch
%         warning(['no data origrec for ' ids{id}])
%     end
% 
    %% recognition 2nd (original)

    fprintf('\n****************** \n 2nd recognition original set \n ******************\n')

    clear fMRI phasemap magnitudemap nvols tmp

    eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-origrec2_run-*_topup.nii.gz'])

    tmp=dir([paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-origrec2_run-*_topup.nii']);

    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
    end

    clear matlabbatch
    spm_jobman('initcfg')
    % unwarping is now replaced with just realignment
    matlabbatch{1}.spm.spatial.realign.estwrite.data = {fMRI};
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 2;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 3;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    spm_jobman('run',matlabbatch)
    
    % slice-time correction
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/r' tmp.name ',' num2str(cc)];
    end
    flags{id,1}.origrec2.SOcorr=0;
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
%     flags{id,1}.origrec2.SOcorr=1;


    % encoding recombination

    fprintf('\n****************** \n encoding recombination set \n ******************\n')

    clear fMRI nvols tmp
    eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-recombienc_run-*_topup.nii.gz'])
    tmp=dir([paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-recombienc_run-*_topup.nii']);

    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
    end

    % run
    clear matlabbatch
    spm_jobman('initcfg')
    % unwarping is now replaced with just realignment
    matlabbatch{1}.spm.spatial.realign.estwrite.data = {fMRI};
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 2;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 3;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    spm_jobman('run',matlabbatch)

    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/r' tmp.name ',' num2str(cc)];
    end
    flags{id,1}.recombienc.SOcorr=0;
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
    flags{id,1}.recombienc.SOcorr=1;


    % recognition recombination

    fprintf('\n****************** \n recognition recombination set \n ******************\n')

    clear fMRI nvols tmp
    eval(['!gzip -f -d ' paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-recombirec1_run-*_topup.nii.gz'])
    tmp=dir([paths_source ids{id} 'v2s1/func/' ids{id} 'v2s1_task-recombirec1_run-*_topup.nii']);

    % fmri
    nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
    end

    % run
    clear matlabbatch
    spm_jobman('initcfg')
    % unwarping is now replaced with just realignment
    matlabbatch{1}.spm.spatial.realign.estwrite.data = {fMRI};
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 2;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 3;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    spm_jobman('run',matlabbatch)

    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/r' tmp.name ',' num2str(cc)];
    end
    flags{id,1}.recombirec.SOcorr=0;
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
    flags{id,1}.recombirec.SOcorr=1;

    % housekeeping

    eval(['!gzip -f ' paths_source ids{id} 'v2s1/func/mean*.nii'])
    eval(['!gzip -f ' paths_source ids{id} 'v2s1/func/rsub*.nii'])
    eval(['!gzip -f ' paths_source ids{id} 'v2s1/func/sub*.nii'])
    
    eval(['!gzip -f ' paths_source ids{id} 'v1s1/func/mean*.nii'])
    eval(['!gzip -f ' paths_source ids{id} 'v1s1/func/rsub*.nii'])
    eval(['!gzip -f ' paths_source ids{id} 'v1s1/func/sub*.nii'])

    disp('done')

end


%% copy files to qumulo


% temporary (20251006)

for id=1:length(ids)

    mkdir(['/Volumes/IKND/AG_Haemmerer/Alex-Qumulo/ENGRAMS/preproc/' ids{id} 'v1s1/func/'])

    clear tmp
    tmp=dir([paths_source ids{id} 'v1s1/func/rsub*topup*.nii*']);
    for t1=1:length(tmp)
        copyfile([paths_source ids{id} 'v1s1/func/' tmp(t1).name],...
            ['/Volumes/IKND/AG_Haemmerer/Alex-Qumulo/ENGRAMS/preproc/' ids{id} 'v1s1/func/' tmp(t1).name])
%         eval(['!rm ' paths_source ids{id} 'v1s1/func/' tmp(t1).name])
    end

    clear tmp
    tmp=dir([paths_source ids{id} 'v1s1/func/arsub*topup*.nii*']);
    for t1=1:length(tmp)
        copyfile([paths_source ids{id} 'v1s1/func/' tmp(t1).name],...
            ['/Volumes/IKND/AG_Haemmerer/Alex-Qumulo/ENGRAMS/preproc/' ids{id} 'v1s1/func/' tmp(t1).name])
%         eval(['!rm ' paths_source ids{id} 'v1s1/func/' tmp(t1).name])
    end

    clear tmp
    tmp=dir([paths_source ids{id} 'v1s1/func/sub*topup*.nii*']);
    for t1=1:length(tmp)
        copyfile([paths_source ids{id} 'v1s1/func/' tmp(t1).name],...
            ['/Volumes/IKND/AG_Haemmerer/Alex-Qumulo/ENGRAMS/preproc/' ids{id} 'v1s1/func/' tmp(t1).name])
%         eval(['!rm ' paths_source ids{id} 'v1s1/func/' tmp(t1).name])


    end
end


%% smoothing

% 
% for id=1:length(ids)
% 
%     fprintf(['\n****************** \n smooting ' ids{id} '! \n ******************\n'])
% 
%     %% origenc
%     clear fMRI nvols tmp matlabbatch
% 
%     tmp=dir([paths_source ids{id} 'v1s1/func/au' ids{id} 'v1s1_task-origenc_run-*_bold.nii']);
%     % fmri
%     nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp.name] ) );
%     fMRI=[];
%     for cc = 1:nvols
%         fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp.name ',' num2str(cc)];
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
% 
% 
%     %% origrec
% 
%     clear fMRI nvols tmp matlabbatch
% 
%     try
%         tmp=dir([paths_source ids{id} 'v1s1/func/au' ids{id} 'v1s1_task-origrec_run-*_bold.nii']);
%         % fmri
%         nvols           = length( spm_vol( [paths_source ids{id} 'v1s1/func/' tmp.name] ) );
%         fMRI=[];
%         for cc = 1:nvols
%             fMRI{cc,1}  = [paths_source ids{id} 'v1s1/func/' tmp.name ',' num2str(cc)];
%         end
% 
%         spm_jobman('initcfg')
% 
%         matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
%         matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
%         matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%         matlabbatch{1}.spm.spatial.smooth.im = 0;
%         matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';
% 
%         spm_jobman('run',matlabbatch)
% 
%     catch
%         warning(['no data origenc for ' ids{id}])
%     end
% 
%     %% origrec2
% 
%     clear fMRI nvols tmp matlabbatch
% 
%     try
%         tmp=dir([paths_source ids{id} 'v2s1/func/au' ids{id} 'v2s1_task-origrec2_run-*_bold.nii']);
% 
%         if length(tmp) ==1
% 
%             % fmri
%             nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
%             fMRI=[];
%             for cc = 1:nvols
%                 fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
%             end
% 
%             spm_jobman('initcfg')
% 
%             matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
%             matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
%             matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%             matlabbatch{1}.spm.spatial.smooth.im = 0;
%             matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';
% 
%             spm_jobman('run',matlabbatch)
%         else
% 
%             disp('multiple runs detected')
% 
%             for runs=1:length(tmp)
% 
%                 % fmri
%                 nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp(runs).name] ) );
%                 fMRI=[];
%                 for cc = 1:nvols
%                     fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp(runs).name ',' num2str(cc)];
%                 end
% 
%                 spm_jobman('initcfg')
% 
%                 matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
%                 matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
%                 matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%                 matlabbatch{1}.spm.spatial.smooth.im = 0;
%                 matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';
% 
%                 spm_jobman('run',matlabbatch)
%             end
%         end
%     catch
%         warning(['no data origrec for ' ids{id}])
%     end
% 
%     %% recombienc
% 
%     clear fMRI nvols tmp matlabbatch
% 
%     try
%         tmp=dir([paths_source ids{id} 'v2s1/func/au' ids{id} 'v2s1_task-recombienc_run-*_bold.nii']);
% 
%         if length(tmp) ==1
% 
%             % fmri
%             nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
%             fMRI=[];
%             for cc = 1:nvols
%                 fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
%             end
% 
%             spm_jobman('initcfg')
% 
%             matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
%             matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
%             matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%             matlabbatch{1}.spm.spatial.smooth.im = 0;
%             matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';
% 
%             spm_jobman('run',matlabbatch)
%         else
% 
%             disp('multiple runs detected')
% 
%             for runs=1:length(tmp)
% 
%                 % fmri
%                 nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp(runs).name] ) );
%                 fMRI=[];
%                 for cc = 1:nvols
%                     fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp(runs).name ',' num2str(cc)];
%                 end
% 
%                 spm_jobman('initcfg')
% 
%                 matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
%                 matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
%                 matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%                 matlabbatch{1}.spm.spatial.smooth.im = 0;
%                 matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';
% 
%                 spm_jobman('run',matlabbatch)
%             end
%         end
%     catch
%         warning(['no data origrec for ' ids{id}])
%     end
% 
%     %% recombirec
%     
%     clear fMRI nvols tmp matlabbatch
% 
%     try
%         tmp=dir([paths_source ids{id} 'v2s1/func/au' ids{id} 'v2s1_task-recombirec_run-*_bold.nii']);
% 
%         if length(tmp) ==1
% 
%             % fmri
%             nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp.name] ) );
%             fMRI=[];
%             for cc = 1:nvols
%                 fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp.name ',' num2str(cc)];
%             end
% 
%             spm_jobman('initcfg')
% 
%             matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
%             matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
%             matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%             matlabbatch{1}.spm.spatial.smooth.im = 0;
%             matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';
% 
%             spm_jobman('run',matlabbatch)
%         else
% 
%             disp('multiple runs detected')
% 
%             for runs=1:length(tmp)
% 
%                 % fmri
%                 nvols           = length( spm_vol( [paths_source ids{id} 'v2s1/func/' tmp(runs).name] ) );
%                 fMRI=[];
%                 for cc = 1:nvols
%                     fMRI{cc,1}  = [paths_source ids{id} 'v2s1/func/' tmp(runs).name ',' num2str(cc)];
%                 end
% 
%                 spm_jobman('initcfg')
% 
%                 matlabbatch{1}.spm.spatial.smooth.data = cellstr(fMRI);
%                 matlabbatch{1}.spm.spatial.smooth.fwhm = [smoothingKernel smoothingKernel smoothingKernel];
%                 matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%                 matlabbatch{1}.spm.spatial.smooth.im = 0;
%                 matlabbatch{1}.spm.spatial.smooth.prefix = 's1pt2';
% 
%                 spm_jobman('run',matlabbatch)
%             end
%         end
%     catch
%         warning(['no data origrec for ' ids{id}])
%     end
% 
% 
%     %% housekeeping
% 
%     eval(['!gzip -f ' paths_source ids{id} 'v2s1/func/au*.nii'])
%     eval(['!gzip -f ' paths_source ids{id} 'v1s1/func/au*.nii'])
%    
% end