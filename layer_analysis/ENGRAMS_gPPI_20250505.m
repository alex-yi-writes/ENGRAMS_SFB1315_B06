% gPPI layer analysis – Remembered vs Forgotten

clc;clear

addpath(genpath('/Users/yyi//Documents/MATLAB/PPPIv13.1'));   % toolbox v13.1+

basedir  = '/Users/yyi/Desktop/ENGRAMS/analyses/';
spmdir   = '/func/origrec1';                               % contains SPM.mat
roidir   = '/Users/yyi/Desktop/ENGRAMS/analyses/';

subjects = {'sub-202v1s1'};
% seeds    = {'mPFC_sup','mPFC_mid','mPFC_deep', ...
%             'CA1','CA3','DG','Sub'};
% seeds    = {'CA1_L','CA3_L','DG_L','Sub_L'};
seeds    = {'CA1_R','CA3_R','DG_R','Sub_R'};


%% run

for s = 1:numel(subjects)
    spm('Defaults','fMRI'); spm_jobman('initcfg');
    sub = subjects{s};
    load([basedir,sub,spmdir '/SPM.mat'])

    for r = 1:numel(seeds)
        seed          = seeds{r};
        P             = struct();
        P.SPMver      = 12; %%%

        P.subject     = sub;

        P.directory   = fullfile(basedir,sub,spmdir);   % where SPM.mat lives
        P.VOI         = fullfile(roidir,sub,'/anat/roi/',[seed '.nii']);
        P.Region      = seed;

        P.Estimate    = 1; %%%
        P.contrast    = 0; %%%
        P.extract     = 'eig'; %%%

        % --- key lines for remembered vs forgotten -----------------------
        % make sure these names match the condition labels in your SPM.mat
        % inspect SPM.Sess.U of the first-level analyses!
        P.Tasks       = {'0' SPM.Sess.U(1).name{1} SPM.Sess.U(2).name{1} SPM.Sess.U(3).name{1} ...
            SPM.Sess.U(4).name{1} SPM.Sess.U(5).name{1} SPM.Sess.U(6).name{1} ...
            SPM.Sess.U(7).name{1} SPM.Sess.U(8).name{1} SPM.Sess.U(9).name{1} ...
            SPM.Sess.U(10).name{1}};   % 11w = include all task regressors
        P.Weights     = [0 1];            
%         P.Weights     = [1 -1];            % correct > incorrect first-level contrast
        % -----------------------------------------------------------------

        P.analysis    = 'psy';     % physio + psycho (standard gPPI)
        P.method      = 'cond';    % condition-wise regressors

        P.ConcatR     = 0;
        P.preservevarcorr = 1;
        P.WB          = 0;

        P.outdir      = fullfile(basedir,sub,'gPPI',seed);

        P.temporal    = 1;         % deconvolve before interaction
        P.preserve    = 0;         % trim scans outside VOI session
        P.estimation  = 'OLS';     % fast ordinary least squares


        % maybe try some other time: auto-generate both directions of the contrast

        P.CompContrasts          = 1;

        P.Contrasts(1).left      = {'ScenesCorrect', 'ScenesIntFA'};
        P.Contrasts(1).right     = {''};                % No comparison group
        P.Contrasts(1).STAT      = 'T';
        P.Contrasts(1).MinEvents = 2;
        P.Contrasts(1).name      = SPM.xCon(1).name;

        P.Contrasts(2).left      = {'RecogCorrect', 'RecogIntLure'};
        P.Contrasts(2).right     = {''};                % No comparison group
        P.Contrasts(2).STAT      = 'T';
        P.Contrasts(2).MinEvents = 2;
        P.Contrasts(2).name      = SPM.xCon(2).name;

        P.Contrasts(3).left      = {'FBCorrect', 'FBIntLure'};
        P.Contrasts(3).right     = {''};                % No comparison group
        P.Contrasts(3).STAT      = 'T';
        P.Contrasts(3).MinEvents = 2;
        P.Contrasts(3).name      = SPM.xCon(3).name;

        P.Contrasts(4).left      = {'ScenesCorrect', 'ScenesIntFA'};
        P.Contrasts(4).right     = {'FixationX'};
        P.Contrasts(4).STAT      = 'T';
        P.Contrasts(4).MinEvents = 2;
        P.Contrasts(4).name      = SPM.xCon(4).name;

        P.Contrasts(5).left      = {'RecogCorrect', 'RecogIntLure'};
        P.Contrasts(5).right     = {'FixationX'};
        P.Contrasts(5).STAT      = 'T';
        P.Contrasts(5).MinEvents = 2;
        P.Contrasts(5).name      = SPM.xCon(5).name;
        
        P.Contrasts(6).left      = {'FBcorrect', 'FBIntLure'};
        P.Contrasts(6).right     = {'FixationX'};
        P.Contrasts(6).STAT      = 'T';
        P.Contrasts(6).MinEvents = 2;
        P.Contrasts(6).name      = SPM.xCon(6).name;

        P.Contrasts(7).left      = {'ScenesCorrect', 'RecogCorrect', 'FBcorrect'};
        P.Contrasts(7).right     = {'ScenesIntFA', 'RecogIntLure', 'FBIntLure'};
        P.Contrasts(7).STAT      = 'T';
        % P.Contrasts(1).Weighted = 0; %%%
        P.Contrasts(7).MinEvents = 2; %%%
        P.Contrasts(7).name      = SPM.xCon(7).name;

        P.Contrasts(8).left      = {'ScenesCorrect'};
        P.Contrasts(8).right     = {'ScenesIntFA'};
        P.Contrasts(8).STAT      = 'T';
        % P.Contrasts(1).Weighted = 0; %%%
        P.Contrasts(8).MinEvents = 2; %%%
        P.Contrasts(8).name      = SPM.xCon(8).name;

        P.Contrasts(9).left      = {'RecogCorrect'};
        P.Contrasts(9).right     = {'RecogIntLure'};
        P.Contrasts(9).STAT      = 'T';
        % P.Contrasts(1).Weighted = 0; %%%
        P.Contrasts(9).MinEvents = 2; %%%
        P.Contrasts(9).name      = SPM.xCon(9).name;

        P.Contrasts(10).left      = {'FBcorrect'};
        P.Contrasts(10).right     = {'FBIntLure'};
        P.Contrasts(10).STAT      = 'T';
        % P.Contrasts(1).Weighted = 0; %%%
        P.Contrasts(10).MinEvents = 2; %%%
        P.Contrasts(10).name      = SPM.xCon(10).name;
        
        P.Contrasts(11).left      = {'confidenceRate'};
        P.Contrasts(11).right     = {'FixationX'};
        P.Contrasts(11).STAT      = 'T';
        P.Contrasts(11).MinEvents = 2;
        P.Contrasts(11).name      = SPM.xCon(11).name;

        P.Contrasts(12).left      = {'confidenceResp'};
        P.Contrasts(12).right     = {'FixationX'};
        P.Contrasts(12).STAT      = 'T';
        P.Contrasts(12).MinEvents = 2;
        P.Contrasts(12).name      = SPM.xCon(12).name;

        P.Contrasts(13).left      = {'recogResp'};
        P.Contrasts(13).right     = {'FixationX'};
        P.Contrasts(13).STAT      = 'T';
        P.Contrasts(13).MinEvents = 2;
        P.Contrasts(13).name      = SPM.xCon(13).name;
        % -----------------------------------------------------------------


        if ~exist(P.outdir,'dir'), mkdir(P.outdir); end
        cd(P.directory);                        % gPPI needs SPM.mat here
        PPPI(P)
    end
end


%% example code
%
% addpath('D:\spm8')
% addpath('D:\spm8\toolbox\PPPI')
% fmri_dir = 'M:\impexp\fMRI\';
% analysis_dir = 'analysis\Firstlevel_Blocks_normalised_RPsAdapt180_19-Apr-2014'
%
% for isubj = 1:1
%
%     subjects = {'S04'};
%     glm_dir = fullfile(fmri_dir,subjects{isubj},analysis_dir);
%
%     % Files with the actual time courses of your voxels of interest
%     % For now, these were manually extracting using SPM -> results -> eigenvariate
%     regionfile = {'VOI_A1_1.mat' 'VOI_A1_2.mat' 'VOI_A1_3.mat' 'VOI_A1_4.mat' 'VOI_A1_5.mat' 'VOI_A1_6.mat' 'VOI_A1_7.mat' 'VOI_A1_8.mat' 'VOI_A1_9.mat'};
%
%     % Names of these regions
%     region = {'A1_1' 'A1_2' 'A1_3' 'A1_4' 'A1_5' 'A1_6' 'A1_7' 'A1_8' 'A1_9'};
%
%     for ireg=1:numel(regionfile)
%         try
%             % PPPI parameters
%             P.subject = subjects{isubj};
%             P.VOI  = [pwd filesep regionfile{ireg}];
%             P.Region  = region{ireg};
%             P.SPMver = 8;
%             P.directory = glm_dir;
%             P.Estimate = 1;                             % 1: Will estimate PPI model
%             P.Contrast = 'Omnibus F-test for PPI Analyses'; % Adjusted for this effect of interest
%             P.extract = 'mean';
%             P.Tasks = {'1' 'Predictive' 'Non-predictive'};
%             % P.Weights = []; % For traditional PPI, contrast weights are specified here
%             P.analysis = 'psy';
%             P.method = 'cond'                           % 'trad' or 'cond'
%             P.CompContrasts = 1;
%             P.Contrasts(1).left = {'Predictive'};       % LHS of left > right
%             P.Contrasts(1).right = {'Non-predictive'};  % RHS of left > right
%             P.Contrasts(1).STAT = 'T';                  % 'T' or 'F'
%             P.Contrasts(1).Weighted = 0;                % tasks are not weighted by amount of trials
%             P.Contrasts(1).MinEvents = 5;               % Minimum n events to include
%             P.Contrasts(1).name = 'Predictive_vs_Non-predictive';
%
%             save([subjects{isubj} '_PPI_config.mat'],'P');
%             PPPI([subjects{isubj} '_PPI_config.mat'])
%
%         catch
%             disp(['Failed: ' subjects{isubj}]);
%
%         end
%     end
% end
