%% ENGRAMS fMRI 1st-level
%% prep

clear;

% paths
paths_results   = '/Users/yyi/Desktop/ENGRAMS/analyses/';
paths_fMRI      = '/Users/yyi/Desktop/ENGRAMS/preproc/';
paths_behav     = '/Users/yyi/Desktop/ENGRAMS/raw/';
paths_fx        = '/Users/yyi/Desktop/ENGRAMS/scripts/';

% subjects
ids={'sub-202'};

% scanning parameters
TR              = 2;
numSlice        = 96;
microtimeOnset  = 1;

flags=[];

%% make behavioural data

expdat=[];

for id=1:length(ids)

    % load everything
    expdat{id,1}.orig.enc            = load([paths_behav ids{id}(5:7) 'v1s1/behav/' ids{id}(5:7) '_enc_orig_1.mat']);
    expdat{id,1}.orig.rcg1           = load([paths_behav ids{id}(5:7) 'v1s1/behav/' ids{id}(5:7) '_rcg_orig_1.mat']);
    expdat{id,1}.orig.rcg3           = load([paths_behav ids{id}(5:7) 'v2s1/behav/' ids{id}(5:7) '_rcg_orig_3.mat']);

    expdat{id,1}.recombi.enc         = load([paths_behav ids{id}(5:7) 'v2s1/behav/' ids{id}(5:7) '_enc_recombi_1.mat']);
    expdat{id,1}.recombi.rcg1        = load([paths_behav ids{id}(5:7) 'v2s1/behav/' ids{id}(5:7) '_rcg_recombi_1.mat']);

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                      RECOGNITION ORIGINAL SET                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                          RECOGNITION EARLY                          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % deal with missed responses
    clear tmp_acc tmp_cnf
    tmp_acc             = expdat{id,1}.orig.rcg1.dat.rcg.results.accuracy;
    missed_acc{id,1}    = isnan(expdat{id,1}.orig.rcg1.dat.rcg.results.accuracy);
    tmp_cnf             = expdat{id,1}.orig.rcg1.dat.rcg.results.confidence;
    missed_cnf{id,1}    = isnan(expdat{id,1}.orig.rcg1.dat.rcg.results.confidence);

    tmp_acc(missed_acc{id,1}==1 | missed_cnf{id,1}==1) = [];
    tmp_cnf(missed_acc{id,1}==1 | missed_cnf{id,1}==1) = [];

    % define correct and incorrect trials
    corrects_orig_rcg_early{id,1}   = tmp_acc==1;
    IntFA_orig_rcg_early{id,1}      = tmp_acc==-1;
    ExtFA_orig_rcg_early{id,1}      = tmp_acc==0;

    % define high and low confidence trials
    highconf_orig_rcg_early{id,1}   = tmp_cnf>=2;
    lowconf_orig_rcg_early{id,1}    = tmp_cnf<2;

    conf_3_orig_rcg_early{id,1}     = tmp_cnf==3;
    conf_2_orig_rcg_early{id,1}     = tmp_cnf==2;
    conf_1_orig_rcg_early{id,1}     = tmp_cnf==1;
    conf_0_orig_rcg_early{id,1}     = tmp_cnf==0;


    % ======= onsets
    onset_orig_rcg_early{id,1} = [];

    % general
    onset_orig_rcg_early{id,1}.scenes       = expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_early{id,1}.objects      = expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ- expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_early{id,1}.confidence   = expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_early{id,1}.feedback     = expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together    - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_early{id,1}.fixationX    = expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.fixationX   - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;

    % responses
    onset_orig_rcg_early{id,1}.objects_resp = expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.resp_RecognitionQ - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_early{id,1}.confidence_resp = expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.resp_confidenceQ - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;

    % accuracy-related onsets

    % corrects
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_corr       = tmp(corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_corr      = tmp(corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_corr   = tmp(corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_corr     = tmp(corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;

    % internal FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_IntFA       = tmp(IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_IntFA      = tmp(IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_IntFA   = tmp(IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_IntFA     = tmp(IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;

    % external FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_ExtFA       = tmp(ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_ExtFA      = tmp(ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_ExtFA   = tmp(ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_ExtFA     = tmp(ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;

    % incorrects together
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_incorr       = tmp(ExtFA_orig_rcg_early{id,1}==1 | IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_incorr      = tmp(ExtFA_orig_rcg_early{id,1}==1 | IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_incorr   = tmp(ExtFA_orig_rcg_early{id,1}==1 | IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_incorr     = tmp(ExtFA_orig_rcg_early{id,1}==1 | IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;



    % confidence-related onsets

    % highconf
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_highConf       = tmp(highconf_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_highConf      = tmp(highconf_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_highConf   = tmp(highconf_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_highConf     = tmp(highconf_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;

    % lowconf
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_lowConf       = tmp(lowconf_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_lowConf      = tmp(lowconf_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_lowConf   = tmp(lowconf_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_lowConf     = tmp(lowconf_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;


    % confidence and accuracy
    
    % highconf correct
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_corr_highConf       = tmp(highconf_orig_rcg_early{id,1}==1 & corrects_orig_rcg_early{id,1}==1) - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_corr_highConf      = tmp(highconf_orig_rcg_early{id,1}==1 & corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_corr_highConf   = tmp(highconf_orig_rcg_early{id,1}==1 & corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_corr_highConf     = tmp(highconf_orig_rcg_early{id,1}==1 & corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;

    % lowconf correct
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_corr_lowConf       = tmp(lowconf_orig_rcg_early{id,1}==1 & corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_corr_lowConf      = tmp(lowconf_orig_rcg_early{id,1}==1 & corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_corr_lowConf   = tmp(lowconf_orig_rcg_early{id,1}==1 & corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_corr_lowConf     = tmp(lowconf_orig_rcg_early{id,1}==1 & corrects_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;


    % highconf internal FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_IntFA_highConf       = tmp(highconf_orig_rcg_early{id,1}==1 & IntFA_orig_rcg_early{id,1}==1) - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_IntFA_highConf      = tmp(highconf_orig_rcg_early{id,1}==1 & IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_IntFA_highConf   = tmp(highconf_orig_rcg_early{id,1}==1 & IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_IntFA_highConf     = tmp(highconf_orig_rcg_early{id,1}==1 & IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;

    % lowconf internal FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_IntFA_lowConf       = tmp(lowconf_orig_rcg_early{id,1}==1 & IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_IntFA_lowConf      = tmp(lowconf_orig_rcg_early{id,1}==1 & IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_IntFA_lowConf   = tmp(lowconf_orig_rcg_early{id,1}==1 & IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_IntFA_lowConf     = tmp(lowconf_orig_rcg_early{id,1}==1 & IntFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;



    % highconf external FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_ExtFA_highConf       = tmp(highconf_orig_rcg_early{id,1}==1 & ExtFA_orig_rcg_early{id,1}==1) - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_ExtFA_highConf      = tmp(highconf_orig_rcg_early{id,1}==1 & ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_ExtFA_highConf   = tmp(highconf_orig_rcg_early{id,1}==1 & ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_ExtFA_highConf     = tmp(highconf_orig_rcg_early{id,1}==1 & ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;

    % lowconf external FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.scenes_ExtFA_lowConf       = tmp(lowconf_orig_rcg_early{id,1}==1 & ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.objects_ExtFA_lowConf      = tmp(lowconf_orig_rcg_early{id,1}==1 & ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.confidence_ExtFA_lowConf   = tmp(lowconf_orig_rcg_early{id,1}==1 & ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_early{id,1}.feedback_ExtFA_lowConf     = tmp(lowconf_orig_rcg_early{id,1}==1 & ExtFA_orig_rcg_early{id,1}==1)       - expdat{id,1}.orig.rcg1.dat.rcg.results.SOT.trig1;



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                          RECOGNITION LATE                           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % deal with missed responses
    clear tmp_acc tmp_cnf
    tmp_acc             = expdat{id,1}.orig.rcg3.dat.rcg.results.accuracy;
    missed_acc{id,1}    = isnan(expdat{id,1}.orig.rcg3.dat.rcg.results.accuracy);
    tmp_cnf             = expdat{id,1}.orig.rcg3.dat.rcg.results.confidence;
    missed_cnf{id,1}    = isnan(expdat{id,1}.orig.rcg3.dat.rcg.results.confidence);

    tmp_acc(missed_acc{id,1}==1 | missed_cnf{id,1}==1) = [];
    tmp_cnf(missed_acc{id,1}==1 | missed_cnf{id,1}==1) = [];

    % define correct and incorrect trials
    corrects_orig_rcg_late{id,1}   = tmp_acc==1;
    IntFA_orig_rcg_late{id,1}      = tmp_acc==-1;
    ExtFA_orig_rcg_late{id,1}      = tmp_acc==0;

    % define high and low confidence trials
    highconf_orig_rcg_late{id,1}   = tmp_cnf>=2;
    lowconf_orig_rcg_late{id,1}    = tmp_cnf<2;

    conf_3_orig_rcg_late{id,1}     = tmp_cnf==3;
    conf_2_orig_rcg_late{id,1}     = tmp_cnf==2;
    conf_1_orig_rcg_late{id,1}     = tmp_cnf==1;
    conf_0_orig_rcg_late{id,1}     = tmp_cnf==0;


    % ======= onsets
    onset_orig_rcg_late{id,1} = [];

    % general
    onset_orig_rcg_late{id,1}.scenes       = expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_late{id,1}.objects      = expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ- expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_late{id,1}.confidence   = expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_late{id,1}.feedback     = expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together    - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_late{id,1}.fixationX    = expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.fixationX   - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;

    % responses
    onset_orig_rcg_late{id,1}.objects_resp = expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.resp_RecognitionQ - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    onset_orig_rcg_late{id,1}.confidence_resp = expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.resp_confidenceQ - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;

    % accuracy-related onsets

    % corrects
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_corr       = tmp(corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_corr      = tmp(corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_corr   = tmp(corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_corr     = tmp(corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;

    % internal FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_IntFA       = tmp(IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_IntFA      = tmp(IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_IntFA   = tmp(IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_IntFA     = tmp(IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;

    % external FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_ExtFA       = tmp(ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_ExtFA      = tmp(ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_ExtFA   = tmp(ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_ExtFA     = tmp(ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;

    % incorrects together
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_incorr       = tmp(ExtFA_orig_rcg_late{id,1}==1 | IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_incorr      = tmp(ExtFA_orig_rcg_late{id,1}==1 | IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_incorr   = tmp(ExtFA_orig_rcg_late{id,1}==1 | IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_incorr     = tmp(ExtFA_orig_rcg_late{id,1}==1 | IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;



    % confidence-related onsets

    % highconf
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_highConf       = tmp(highconf_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_highConf      = tmp(highconf_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_highConf   = tmp(highconf_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_highConf     = tmp(highconf_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;

    % lowconf
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_lowConf       = tmp(lowconf_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_lowConf      = tmp(lowconf_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_lowConf   = tmp(lowconf_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_lowConf     = tmp(lowconf_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;


    % confidence and accuracy
    
    % highconf correct
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_corr_highConf       = tmp(highconf_orig_rcg_late{id,1}==1 & corrects_orig_rcg_late{id,1}==1) - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_corr_highConf      = tmp(highconf_orig_rcg_late{id,1}==1 & corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_corr_highConf   = tmp(highconf_orig_rcg_late{id,1}==1 & corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_corr_highConf     = tmp(highconf_orig_rcg_late{id,1}==1 & corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;

    % lowconf correct
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_corr_lowConf       = tmp(lowconf_orig_rcg_late{id,1}==1 & corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_corr_lowConf      = tmp(lowconf_orig_rcg_late{id,1}==1 & corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_corr_lowConf   = tmp(lowconf_orig_rcg_late{id,1}==1 & corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_corr_lowConf     = tmp(lowconf_orig_rcg_late{id,1}==1 & corrects_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;


    % highconf internal FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_IntFA_highConf       = tmp(highconf_orig_rcg_late{id,1}==1 & IntFA_orig_rcg_late{id,1}==1) - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_IntFA_highConf      = tmp(highconf_orig_rcg_late{id,1}==1 & IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_IntFA_highConf   = tmp(highconf_orig_rcg_late{id,1}==1 & IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_IntFA_highConf     = tmp(highconf_orig_rcg_late{id,1}==1 & IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;

    % lowconf internal FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_IntFA_lowConf       = tmp(lowconf_orig_rcg_late{id,1}==1 & IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_IntFA_lowConf      = tmp(lowconf_orig_rcg_late{id,1}==1 & IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_IntFA_lowConf   = tmp(lowconf_orig_rcg_late{id,1}==1 & IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_IntFA_lowConf     = tmp(lowconf_orig_rcg_late{id,1}==1 & IntFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;



    % highconf external FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_ExtFA_highConf       = tmp(highconf_orig_rcg_late{id,1}==1 & ExtFA_orig_rcg_late{id,1}==1) - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_ExtFA_highConf      = tmp(highconf_orig_rcg_late{id,1}==1 & ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_ExtFA_highConf   = tmp(highconf_orig_rcg_late{id,1}==1 & ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_ExtFA_highConf     = tmp(highconf_orig_rcg_late{id,1}==1 & ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;

    % lowconf external FA
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.scenes_ExtFA_lowConf       = tmp(lowconf_orig_rcg_late{id,1}==1 & ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.objects_ExtFA_lowConf      = tmp(lowconf_orig_rcg_late{id,1}==1 & ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.confidence_ExtFA_lowConf   = tmp(lowconf_orig_rcg_late{id,1}==1 & ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_orig_rcg_late{id,1}.feedback_ExtFA_lowConf     = tmp(lowconf_orig_rcg_late{id,1}==1 & ExtFA_orig_rcg_late{id,1}==1)       - expdat{id,1}.orig.rcg3.dat.rcg.results.SOT.trig1;



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   RECOGNITION RECOMBINATION SET                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % deal with missed responses
    clear tmp_acc tmp_cnf
    tmp_acc             = expdat{id,1}.recombi.rcg1.dat.rcg.results.accuracy;
    missed_acc{id,1}    = isnan(expdat{id,1}.recombi.rcg1.dat.rcg.results.accuracy);
    tmp_cnf             = expdat{id,1}.recombi.rcg1.dat.rcg.results.confidence;
    missed_cnf{id,1}    = isnan(expdat{id,1}.recombi.rcg1.dat.rcg.results.confidence);

    tmp_acc(missed_acc{id,1}==1 | missed_cnf{id,1}==1) = [];
    tmp_cnf(missed_acc{id,1}==1 | missed_cnf{id,1}==1) = [];

    % define correct and incorrect trials
    corrects_recombi_rcg_early{id,1}   = tmp_acc==1;
    IntFA_recombi_rcg_early{id,1}      = tmp_acc==-1;
    ExtFA_recombi_rcg_early{id,1}      = tmp_acc==0;

    % define high and low confidence trials
    highconf_recombi_rcg_early{id,1}   = tmp_cnf>=2;
    lowconf_recombi_rcg_early{id,1}    = tmp_cnf<2;

    conf_3_recombi_rcg_early{id,1}     = tmp_cnf==3;
    conf_2_recombi_rcg_early{id,1}     = tmp_cnf==2;
    conf_1_recombi_rcg_early{id,1}     = tmp_cnf==1;
    conf_0_recombi_rcg_early{id,1}     = tmp_cnf==0;


    % ======= onsets
    onset_recombi_rcg_early{id,1} = [];

    % general
    onset_recombi_rcg_early{id,1}.scenes       = expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    onset_recombi_rcg_early{id,1}.objects      = expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ- expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    onset_recombi_rcg_early{id,1}.confidence   = expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    onset_recombi_rcg_early{id,1}.feedback     = expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together    - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    onset_recombi_rcg_early{id,1}.fixationX    = expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.fixationX   - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;

    % responses
    onset_recombi_rcg_early{id,1}.objects_resp = expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.resp_RecognitionQ - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    onset_recombi_rcg_early{id,1}.confidence_resp = expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.resp_confidenceQ - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;

    % accuracy-related onsets

    % corrects
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_corr       = tmp(corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_corr      = tmp(corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_corr   = tmp(corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_corr     = tmp(corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;

    % internal FA
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_IntFA       = tmp(IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_IntFA      = tmp(IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_IntFA   = tmp(IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_IntFA     = tmp(IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;

    % external FA
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_ExtFA       = tmp(ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_ExtFA      = tmp(ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_ExtFA   = tmp(ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_ExtFA     = tmp(ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;

    % incorrects together
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_incorr       = tmp(ExtFA_recombi_rcg_early{id,1}==1 | IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_incorr      = tmp(ExtFA_recombi_rcg_early{id,1}==1 | IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_incorr   = tmp(ExtFA_recombi_rcg_early{id,1}==1 | IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_incorr     = tmp(ExtFA_recombi_rcg_early{id,1}==1 | IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;



    % confidence-related onsets

    % highconf
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_highConf       = tmp(highconf_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_highConf      = tmp(highconf_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_highConf   = tmp(highconf_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_highConf     = tmp(highconf_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;

    % lowconf
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_lowConf       = tmp(lowconf_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_lowConf      = tmp(lowconf_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_lowConf   = tmp(lowconf_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_lowConf     = tmp(lowconf_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;


    % confidence and accuracy
    
    % highconf correct
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_corr_highConf       = tmp(highconf_recombi_rcg_early{id,1}==1 & corrects_recombi_rcg_early{id,1}==1) - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_corr_highConf      = tmp(highconf_recombi_rcg_early{id,1}==1 & corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_corr_highConf   = tmp(highconf_recombi_rcg_early{id,1}==1 & corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_corr_highConf     = tmp(highconf_recombi_rcg_early{id,1}==1 & corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;

    % lowconf correct
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_corr_lowConf       = tmp(lowconf_recombi_rcg_early{id,1}==1 & corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_corr_lowConf      = tmp(lowconf_recombi_rcg_early{id,1}==1 & corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_corr_lowConf   = tmp(lowconf_recombi_rcg_early{id,1}==1 & corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_corr_lowConf     = tmp(lowconf_recombi_rcg_early{id,1}==1 & corrects_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;


    % highconf internal FA
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_IntFA_highConf       = tmp(highconf_recombi_rcg_early{id,1}==1 & IntFA_recombi_rcg_early{id,1}==1) - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_IntFA_highConf      = tmp(highconf_recombi_rcg_early{id,1}==1 & IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_IntFA_highConf   = tmp(highconf_recombi_rcg_early{id,1}==1 & IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_IntFA_highConf     = tmp(highconf_recombi_rcg_early{id,1}==1 & IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;

    % lowconf internal FA
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_IntFA_lowConf       = tmp(lowconf_recombi_rcg_early{id,1}==1 & IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_IntFA_lowConf      = tmp(lowconf_recombi_rcg_early{id,1}==1 & IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_IntFA_lowConf   = tmp(lowconf_recombi_rcg_early{id,1}==1 & IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_IntFA_lowConf     = tmp(lowconf_recombi_rcg_early{id,1}==1 & IntFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;



    % highconf external FA
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_ExtFA_highConf       = tmp(highconf_recombi_rcg_early{id,1}==1 & ExtFA_recombi_rcg_early{id,1}==1) - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_ExtFA_highConf      = tmp(highconf_recombi_rcg_early{id,1}==1 & ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_ExtFA_highConf   = tmp(highconf_recombi_rcg_early{id,1}==1 & ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_ExtFA_highConf     = tmp(highconf_recombi_rcg_early{id,1}==1 & ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;

    % lowconf external FA
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.scene; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.scenes_ExtFA_lowConf       = tmp(lowconf_recombi_rcg_early{id,1}==1 & ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.RecognitionQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.objects_ExtFA_lowConf      = tmp(lowconf_recombi_rcg_early{id,1}==1 & ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.ConfidenceQ; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.confidence_ExtFA_lowConf   = tmp(lowconf_recombi_rcg_early{id,1}==1 & ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;
    clear tmp
    tmp=expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.together; tmp(missed_acc{id,1}==1 | missed_cnf{id,1}==1)=[];
    onset_recombi_rcg_early{id,1}.feedback_ExtFA_lowConf     = tmp(lowconf_recombi_rcg_early{id,1}==1 & ExtFA_recombi_rcg_early{id,1}==1)       - expdat{id,1}.recombi.rcg1.dat.rcg.results.SOT.trig1;



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                        ENCODING ORIGINAL SET                        %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    onset_orig_enc{id,1} = [];

    % general
    onset_orig_enc{id,1}.scenes       = expdat{id,1}.orig.enc.dat.enc.results.SOT.scene       - expdat{id,1}.orig.enc.dat.enc.results.SOT.trig1;
    onset_orig_enc{id,1}.objects      = expdat{id,1}.orig.enc.dat.enc.results.SOT.object      - expdat{id,1}.orig.enc.dat.enc.results.SOT.trig1;
    onset_orig_enc{id,1}.both         = expdat{id,1}.orig.enc.dat.enc.results.SOT.together    - expdat{id,1}.orig.enc.dat.enc.results.SOT.trig1;
    onset_orig_enc{id,1}.fixationX    = expdat{id,1}.orig.enc.dat.enc.results.SOT.fixationX    - expdat{id,1}.orig.enc.dat.enc.results.SOT.trig1;
    onset_orig_enc{id,1}.resp         = sort([expdat{id,1}.orig.enc.dat.enc.results.SOT.resp_scene; expdat{id,1}.orig.enc.dat.enc.results.SOT.resp_obj]) - expdat{id,1}.orig.enc.dat.enc.results.SOT.trig1;



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                     ENCODING RECOMBINATION SET                      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    onset_recombi_enc{id,1} = [];

    % general
    onset_recombi_enc{id,1}.scenes       = expdat{id,1}.recombi.enc.dat.enc.results.SOT.scene       - expdat{id,1}.recombi.enc.dat.enc.results.SOT.trig1;
    onset_recombi_enc{id,1}.objects      = expdat{id,1}.recombi.enc.dat.enc.results.SOT.object      - expdat{id,1}.recombi.enc.dat.enc.results.SOT.trig1;
    onset_recombi_enc{id,1}.both         = expdat{id,1}.recombi.enc.dat.enc.results.SOT.together    - expdat{id,1}.recombi.enc.dat.enc.results.SOT.trig1;
    onset_recombi_enc{id,1}.fixationX    = expdat{id,1}.recombi.enc.dat.enc.results.SOT.fixationX    - expdat{id,1}.recombi.enc.dat.enc.results.SOT.trig1;
    onset_recombi_enc{id,1}.resp         = sort([expdat{id,1}.recombi.enc.dat.enc.results.SOT.resp_scene; expdat{id,1}.recombi.enc.dat.enc.results.SOT.resp_obj]) - expdat{id,1}.recombi.enc.dat.enc.results.SOT.trig1;

end

disp('**************')
disp('onset prepared')
disp('**************')


%% run 1st-level GLM

for id=1:length(ids) 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                        ENCODING ORIGINAL SET                        %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % find files
    clear tmp_acc; tmp_acc=dir([paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/s1pt2au*' ids{id} '*_task-origenc_run-*_bold.nii']);
    
    % - fmri
    nvols           = length( spm_vol( [paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/' tmp_acc.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/' tmp_acc.name ',' num2str(cc)];
    end

    % make physio + realignment parameters
    clear R realigndata realignFile physiodata physiodata2 physiodata physioFile physioFile2
    
    % read physio parameters
    physioFile  = [paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/physio/multiple_regressors_origenc.txt'];
    physiodata  = importdata(physioFile);

    % read realignment parameters
    realignFile = [paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/rp_' tmp_acc.name(8:end-4) '.txt'];
    realigndata = importdata(realignFile);

    % concatenate and save
    R = [physiodata realigndata];
    save([paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/reg_all_origenc.mat'],'R');

    clear R realigndata realignFile physiodata physiodata physioFile

    multireg=[paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/reg_all_origenc.mat'];

    % setup workspace
    mkdir([paths_results ids{id} 'v1s1/func/origenc/'])

    % model specification
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.stats.fmri_spec.dir = {[paths_results ids{id} 'v1s1/func/origenc/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = numSlice;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = microtimeOnset;

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(fMRI);

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'scenes';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_orig_enc{id,1}.scenes;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'objects';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = onset_orig_enc{id,1}.objects;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'both';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_orig_enc{id,1}.both;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'response';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_orig_enc{id,1}.resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name =  'fixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset =  onset_orig_enc{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(multireg);
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run', matlabbatch)


    %% estimate

    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr([paths_results ids{id} 'v1s1/func/origenc/SPM.mat']);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch) % run batch

    %% statistical inferences

    % here you set up the contrast matrices

    Cognition_vs_Idle       = [1 1 1 1 -4];
    Buttonpress_vs_Idle     = [0 0 0 1 -1];
   
    stim_scenes             = [1];
    stim_objects            = [0 1];
    stim_both               = [0 0 1];

    scene_vs_object         = [1 -1];
    object_vs_scene         = [-1 1];

    scene_vs_fix            = [1 0 0 0 -1];
    object_vs_fix           = [0 1 0 0 -1];
    both_vs_fix             = [0 0 1 0 -1];

    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} 'v1s1/func/origenc/SPM.mat']);

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Cognition vs Idle';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = Cognition_vs_Idle;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Buttonpressb vs Idle';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = Buttonpress_vs_Idle;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Scenes';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = stim_scenes;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Objects';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = stim_objects;
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Scene and Object';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = stim_both;
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'scene vs object';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = scene_vs_object;
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'object vs scene';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = object_vs_scene;
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'scene vs fix';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = scene_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'object vs fix';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = object_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'both vs fix';
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = both_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

end


%% recognition original early

for id=1:length(ids)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                  EARLY RECOGNITION ORIGINAL SET                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % find files
    clear tmp_acc; tmp_acc=dir([paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/s1pt2au*' ids{id} '*_task-origrec_run-*_bold.nii']);
    
    % - fmri
    nvols           = length( spm_vol( [paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/' tmp_acc.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/' tmp_acc.name ',' num2str(cc)];
    end

    % make physio + realignment parameters
    clear R realigndata realignFile physiodata physiodata2 physiodata physioFile physioFile2
    
    % read physio parameters
    physioFile  = [paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/physio/multiple_regressors_origrec1.txt'];
    physiodata  = importdata(physioFile);

    % read realignment parameters
    realignFile = [paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/rp_' tmp_acc.name(8:end-4) '.txt'];
    realigndata = importdata(realignFile);

    % concatenate and save
    R = [physiodata realigndata];
    save([paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/reg_all_origrec1.mat'],'R');

    clear R realigndata realignFile physiodata physiodata physioFile

    multireg=[paths_fMRI 'sub-' ids{id}(5:7) 'v1s1/func/reg_all_origrec1.mat'];

    % setup workspace
    mkdir([paths_results ids{id} 'v1s1/func/origrec1/'])


    % model specification
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.stats.fmri_spec.dir = {[paths_results ids{id} 'v1s1/func/origrec1/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = numSlice;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = microtimeOnset;

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(fMRI);

    if id==1
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'ScenesCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_orig_rcg_early{id,1}.scenes_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'ScenesIntFA';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = onset_orig_rcg_early{id,1}.scenes_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'RecogCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_orig_rcg_early{id,1}.objects_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'RecogIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_orig_rcg_early{id,1}.objects_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'FBcorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset_orig_rcg_early{id,1}.feedback_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'FBIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset_orig_rcg_early{id,1}.feedback_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'confidenceRate';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset_orig_rcg_early{id,1}.confidence;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'confidenceResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = onset_orig_rcg_early{id,1}.confidence_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'recogResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = onset_orig_rcg_early{id,1}.objects_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'FixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = onset_orig_rcg_early{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).orth = 1;


    else
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'ScenesCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_orig_rcg_early{id,1}.scenes_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name =  'ScenesExtFA';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset =  onset_orig_rcg_early{id,1}.scenes_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'ScenesIntFA';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_orig_rcg_early{id,1}.scenes_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'RecogCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_orig_rcg_early{id,1}.objects_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'RecogExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset_orig_rcg_early{id,1}.objects_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'RecogIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset_orig_rcg_early{id,1}.objects_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'FBcorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset_orig_rcg_early{id,1}.feedback_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'FBExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = onset_orig_rcg_early{id,1}.feedback_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'FBIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = onset_orig_rcg_early{id,1}.feedback_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'confidenceRate';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = onset_orig_rcg_early{id,1}.confidence;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).name = 'confidenceResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).onset = onset_orig_rcg_early{id,1}.confidence_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).name = 'recogResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).onset = onset_orig_rcg_early{id,1}.objects_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).orth = 1;

    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).name = 'FixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).onset = onset_orig_rcg_early{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).orth = 1;

    end

    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(multireg);
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run', matlabbatch)

    %% estimate

    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr([paths_results ids{id} 'v1s1/func/origrec1/SPM.mat']);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch) % run batch

    %% statistical inferences

    if id==1

    % here you set up the contrast matrices

    stim_scenes                 = [1 1];
    stim_objects                = [0 0 1 1];
    stim_both                   = [0 0 0 0 1 1];

    scenes_vs_fix               = [1 1  0 0  0 0  0 0 0  -2];
    objects_vs_fix              = [0 0  1 1  0 0  0 0 0  -2];
    both_vs_fix                 = [0 0  0 0  1 1  0 0 0  -2];

    correct_vs_incorrect        = [1 -1  1 -1  1 -1];
    scene__correct_vs_incorrect = [1 -1];
    object__correct_vs_incorrect= [0 0  1 -1];
    fb__correct_vs_incorrect    = [0 0  0 0  1 -1];

    confRating_vs_fix           = [0 0  0 0  0 0  1 0 0 -1];
    confResp_vs_fix             = [0 0  0 0  0 0  0 1 0 -1];
    recogResp_vs_fix            = [0 0  0 0  0 0  0 0 1 -1];


    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} 'v1s1/func/origrec1/SPM.mat']);

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'scenes';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = stim_scenes;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'objects';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = stim_objects;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'both';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = stim_both;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'scenes_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = scenes_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'objects_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = objects_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'both_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = both_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'scene__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = scene__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'object__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = object__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'fb__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = fb__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'confRating_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = confRating_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'confResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = confResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'recogResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = recogResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

    else

    % here you set up the contrast matrices

    stim_scenes                 = [1 1 1];
    stim_objects                = [0 0 0 1 1 1];
    stim_both                   = [0 0 0 0 0 0 1 1 1];

    scenes_vs_fix               = [1 1 1 0 0 0 0 0 0 0 0 0 -3];
    objects_vs_fix              = [0 0 0 1 1 1 0 0 0 0 0 0 -3];
    both_vs_fix                 = [0 0 0 0 0 0 1 1 1 0 0 0 -3];

    correct_vs_incorrect        = [2 -1 -1  2 -1 -1  2 -1 -1];
    scene__correct_vs_incorrect = [2 -1 -1];
    object__correct_vs_incorrect= [0 0 0  2 -1 -1];
    fb__correct_vs_incorrect    = [0 0 0  0 0 0  2 -1 -1];

    correct_vs_internal         = [1 -1 0  1 -1 0  1 -1 0];
    scene__correct_vs_internal  = [1 -1];
    object__correct_vs_internal = [0 0 0  1 -1 0];
    fb__correct_vs_internal     = [0 0 0  0 0 0  1 -1];

    correct_vs_external         = [1 0 -1  1 0 -1  1 0 -1];
    scene__correct_vs_external  = [1 0 -1];
    object__correct_vs_external = [0 0 0  1 0 -1];
    fb__correct_vs_external     = [0 0 0  0 0 0  1 0 -1];

    internal_vs_external         = [0 1 -1  0 1 -1  0 1 -1];
    scene__internal_vs_external  = [0 1 -1];
    object__internal_vs_external = [0 0 0  0 1 -1];
    fb__internal_vs_external     = [0 0 0  0 0 0  0 1 -1];

    confRating_vs_fix           = [0 0 0  0 0 0  0 0 0  1 0 0 -1];
    confResp_vs_fix             = [0 0 0  0 0 0  0 0 0  0 1 0 -1];
    recogResp_vs_fix            = [0 0 0  0 0 0  0 0 0  0 0 1 -1];


    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} 'v1s1/func/origrec1/SPM.mat']);

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'scenes';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = stim_scenes;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'objects';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = stim_objects;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'both';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = stim_both;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'scenes_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = scenes_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'objects_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = objects_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'both_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = both_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'scene__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = scene__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'object__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = object__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'fb__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = fb__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'scene__correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = scene__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'object__correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = object__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = 'fb__correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.weights = fb__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{15}.tcon.name = 'correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{15}.tcon.weights = correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{15}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{16}.tcon.name = 'scene__correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{16}.tcon.weights = scene__correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{16}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{17}.tcon.name = 'object__correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{17}.tcon.weights = object__correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{17}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{18}.tcon.name = 'fb__correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{18}.tcon.weights = fb__correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.consess{19}.tcon.name = 'internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.weights = internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{20}.tcon.name = 'scene__internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{20}.tcon.weights = scene__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{20}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{21}.tcon.name = 'object__internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{21}.tcon.weights = object__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{21}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{22}.tcon.name = 'fb__internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{22}.tcon.weights = fb__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{22}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{23}.tcon.name = 'confRating_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{23}.tcon.weights = confRating_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{23}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{24}.tcon.name = 'confResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{24}.tcon.weights = confResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{24}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{25}.tcon.name = 'recogResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{25}.tcon.weights = recogResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{25}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

    end

end


%% recognition original late

for id=1:length(ids) % id 202 do not have internal lure incorrect

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                  late RECOGNITION ORIGINAL SET                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % find files
    clear tmp_acc; tmp_acc=dir([paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/s1pt2au*' ids{id} '*_task-origrec2_run-*_bold.nii']);
    
    % - fmri
    nvols           = length( spm_vol( [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/' tmp_acc.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/' tmp_acc.name ',' num2str(cc)];
    end

    % make physio + realignment parameters
    clear R realigndata realignFile physiodata physiodata physioFile
    
    % read physio parameters
    physioFile  = [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/physio/multiple_regressors_origrec2.txt'];
    physiodata  = importdata(physioFile);

    % read realignment parameters
    realignFile = [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/rp_' tmp_acc.name(8:end-4) '.txt'];
    realigndata = importdata(realignFile);

    % concatenate and save
    R = [physiodata realigndata];
    save([paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/reg_all_origrec2.mat'],'R');

    clear R realigndata realignFile physiodata physiodata physioFile

    multireg=[paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/reg_all_origrec2.mat'];

    % setup workspace
    mkdir([paths_results ids{id} 'v2s1/func/origrec2/'])


    % model specification
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.stats.fmri_spec.dir = {[paths_results ids{id} 'v2s1/func/origrec2/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = numSlice;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = microtimeOnset;

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(fMRI);

    if id==1
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'ScenesCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_orig_rcg_late{id,1}.scenes_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name =  'ScenesExtFA';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset =  onset_orig_rcg_late{id,1}.scenes_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'RecogCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_orig_rcg_late{id,1}.objects_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'RecogExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_orig_rcg_late{id,1}.objects_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'FBcorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset_orig_rcg_late{id,1}.feedback_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'FBExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset_orig_rcg_late{id,1}.feedback_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'confidenceRate';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset_orig_rcg_late{id,1}.confidence;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'confidenceResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = onset_orig_rcg_late{id,1}.confidence_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'recogResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = onset_orig_rcg_late{id,1}.objects_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).orth = 1;

    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'FixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = onset_orig_rcg_late{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).orth = 1;


    else
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'ScenesCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_orig_rcg_late{id,1}.scenes_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name =  'ScenesExtFA';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset =  onset_orig_rcg_late{id,1}.scenes_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'ScenesIntFA';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_orig_rcg_late{id,1}.scenes_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'RecogCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_orig_rcg_late{id,1}.objects_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'RecogExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset_orig_rcg_late{id,1}.objects_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'RecogIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset_orig_rcg_late{id,1}.objects_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'FBcorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset_orig_rcg_late{id,1}.feedback_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'FBExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = onset_orig_rcg_late{id,1}.feedback_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'FBIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = onset_orig_rcg_late{id,1}.feedback_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'confidenceRate';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = onset_orig_rcg_late{id,1}.confidence;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).name = 'confidenceResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).onset = onset_orig_rcg_late{id,1}.confidence_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).name = 'recogResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).onset = onset_orig_rcg_late{id,1}.objects_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).orth = 1;

    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).name = 'FixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).onset = onset_orig_rcg_late{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).orth = 1;
    end


    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(multireg);
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run', matlabbatch)

    %% estimate

    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr([paths_results ids{id} 'v2s1/func/origrec2/SPM.mat']);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch) % run batch

    %% statistical inferences

    if id==1

    % here you set up the contrast matrices

    stim_scenes                 = [1 1];
    stim_objects                = [0 0 1 1];
    stim_both                   = [0 0 0 0 1 1];

    scenes_vs_fix               = [1 1  0 0  0 0  0 0 0  -2];
    objects_vs_fix              = [0 0  1 1  0 0  0 0 0  -2];
    both_vs_fix                 = [0 0  0 0  1 1  0 0 0  -2];

    correct_vs_incorrect        = [1 -1  1 -1  1 -1];
    scene__correct_vs_incorrect = [1 -1];
    object__correct_vs_incorrect= [0 0  1 -1];
    fb__correct_vs_incorrect    = [0 0  0 0  1 -1];

    confRating_vs_fix           = [0 0  0 0  0 0  1 0 0 -1];
    confResp_vs_fix             = [0 0  0 0  0 0  0 1 0 -1];
    recogResp_vs_fix            = [0 0  0 0  0 0  0 0 1 -1];


    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} 'v2s1/func/origrec2/SPM.mat']);

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'scenes';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = stim_scenes;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'objects';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = stim_objects;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'both';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = stim_both;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'scenes_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = scenes_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'objects_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = objects_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'both_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = both_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'scene__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = scene__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'object__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = object__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'fb__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = fb__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'confRating_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = confRating_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'confResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = confResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'recogResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = recogResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

    else

    % here you set up the contrast matrices

    stim_scenes                 = [1 1 1];
    stim_objects                = [0 0 0 1 1 1];
    stim_both                   = [0 0 0 0 0 0 1 1 1];

    scenes_vs_fix               = [1 1 1 0 0 0 0 0 0 0 0 0 -3];
    objects_vs_fix              = [0 0 0 1 1 1 0 0 0 0 0 0 -3];
    both_vs_fix                 = [0 0 0 0 0 0 1 1 1 0 0 0 -3];

    correct_vs_incorrect        = [2 -1 -1  2 -1 -1  2 -1 -1];
    scene__correct_vs_incorrect = [2 -1 -1];
    object__correct_vs_incorrect= [0 0 0  2 -1 -1];
    fb__correct_vs_incorrect    = [0 0 0  0 0 0  2 -1 -1];

    correct_vs_internal         = [1 -1 0  1 -1 0  1 -1 0];
    scene__correct_vs_internal  = [1 -1];
    object__correct_vs_internal = [0 0 0  1 -1 0];
    fb__correct_vs_internal     = [0 0 0  0 0 0  1 -1];

    correct_vs_external         = [1 0 -1  1 0 -1  1 0 -1];
    scene__correct_vs_external  = [1 0 -1];
    object__correct_vs_external = [0 0 0  1 0 -1];
    fb__correct_vs_external     = [0 0 0  0 0 0  1 0 -1];

    internal_vs_external         = [0 1 -1  0 1 -1  0 1 -1];
    scene__internal_vs_external  = [0 1 -1];
    object__internal_vs_external = [0 0 0  0 1 -1];
    fb__internal_vs_external     = [0 0 0  0 0 0  0 1 -1];

    confRating_vs_fix           = [0 0 0  0 0 0  0 0 0  1 0 0 -1];
    confResp_vs_fix             = [0 0 0  0 0 0  0 0 0  0 1 0 -1];
    recogResp_vs_fix            = [0 0 0  0 0 0  0 0 0  0 0 1 -1];


    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} 'v2s1/func/origrec2/SPM.mat']);

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'scenes';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = stim_scenes;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'objects';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = stim_objects;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'both';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = stim_both;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'scenes_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = scenes_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'objects_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = objects_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'both_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = both_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'scene__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = scene__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'object__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = object__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'fb__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = fb__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'scene__correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = scene__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'object__correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = object__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = 'fb__correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.weights = fb__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{15}.tcon.name = 'correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{15}.tcon.weights = correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{15}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{16}.tcon.name = 'scene__correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{16}.tcon.weights = scene__correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{16}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{17}.tcon.name = 'object__correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{17}.tcon.weights = object__correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{17}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{18}.tcon.name = 'fb__correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{18}.tcon.weights = fb__correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.consess{19}.tcon.name = 'internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.weights = internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{20}.tcon.name = 'scene__internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{20}.tcon.weights = scene__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{20}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{21}.tcon.name = 'object__internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{21}.tcon.weights = object__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{21}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{22}.tcon.name = 'fb__internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{22}.tcon.weights = fb__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{22}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{23}.tcon.name = 'confRating_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{23}.tcon.weights = confRating_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{23}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{24}.tcon.name = 'confResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{24}.tcon.weights = confResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{24}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{25}.tcon.name = 'recogResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{25}.tcon.weights = recogResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{25}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

    end

end


%% run 1st-level GLM

for id=1:length(ids) 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   ENCODING RECOMBINATION SET                        %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % find files
    clear tmp_acc; tmp_acc=dir([paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/s1pt2au*' ids{id} '*_task-recombienc_run-*_bold.nii']);
    
    % - fmri
    nvols           = length( spm_vol( [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/' tmp_acc.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/' tmp_acc.name ',' num2str(cc)];
    end

    % make physio + realignment parameters
    clear R realigndata realignFile physiodata physiodata2 physiodata physioFile physioFile2
    
    % read physio parameters
    physioFile  = [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/physio/multiple_regressors_recombienc.txt'];
    physiodata  = importdata(physioFile);

    % read realignment parameters
    realignFile = [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/rp_' tmp_acc.name(8:end-4) '.txt'];
    realigndata = importdata(realignFile);

    % concatenate and save
    R = [physiodata realigndata];
    save([paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/reg_all_recombienc.mat'],'R');

    clear R realigndata realignFile physiodata physiodata physioFile

    multireg=[paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/reg_all_recombienc.mat'];

    % setup workspace
    mkdir([paths_results ids{id} 'v2s1/func/recombienc/'])

    % model specification
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.stats.fmri_spec.dir = {[paths_results ids{id} 'v2s1/func/recombienc/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = numSlice;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = microtimeOnset;

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(fMRI);

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'scenes';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_orig_enc{id,1}.scenes;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'objects';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = onset_orig_enc{id,1}.objects;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'both';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_orig_enc{id,1}.both;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'response';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_orig_enc{id,1}.resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name =  'fixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset =  onset_orig_enc{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(multireg);
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run', matlabbatch)


    %% estimate

    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr([paths_results ids{id} 'v2s1/func/recombienc/SPM.mat']);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch) % run batch

    %% statistical inferences

    % here you set up the contrast matrices

    Cognition_vs_Idle       = [1 1 1 1 -4];
    Buttonpress_vs_Idle     = [0 0 0 1 -1];
   
    stim_scenes             = [1];
    stim_objects            = [0 1];
    stim_both               = [0 0 1];

    scene_vs_object         = [1 -1];
    object_vs_scene         = [-1 1];

    scene_vs_fix            = [1 0 0 0 -1];
    object_vs_fix           = [0 1 0 0 -1];
    both_vs_fix             = [0 0 1 0 -1];

    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} 'v2s1/func/recombienc/SPM.mat']);

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Cognition vs Idle';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = Cognition_vs_Idle;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Buttonpressb vs Idle';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = Buttonpress_vs_Idle;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Scenes';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = stim_scenes;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Objects';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = stim_objects;
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Scene and Object';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = stim_both;
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'scene vs object';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = scene_vs_object;
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'object vs scene';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = object_vs_scene;
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'scene vs fix';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = scene_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'object vs fix';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = object_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'both vs fix';
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = both_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

end


%% recognition RECOMBINATION early

for id=1:length(ids)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                  RECOGNITION RECOMBINATION SET                      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % find files
    clear tmp_acc; tmp_acc=dir([paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/s1pt2au*' ids{id} '*_task-recombirec_run-*_bold.nii']);
    
    % - fmri
    nvols           = length( spm_vol( [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/' tmp_acc.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/' tmp_acc.name ',' num2str(cc)];
    end

    % make physio + realignment parameters
    clear R realigndata realignFile physiodata physiodata2 physiodata physioFile physioFile2
    
    % read physio parameters
    physioFile  = [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/physio/multiple_regressors_recombirec.txt'];
    physiodata  = importdata(physioFile);

    % read realignment parameters
    realignFile = [paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/rp_' tmp_acc.name(8:end-4) '.txt'];
    realigndata = importdata(realignFile);

    % concatenate and save
    R = [physiodata realigndata];
    save([paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/reg_all_recombirec.mat'],'R');

    clear R realigndata realignFile physiodata physiodata physioFile

    multireg=[paths_fMRI 'sub-' ids{id}(5:7) 'v2s1/func/reg_all_recombirec.mat'];

    % setup workspace
    mkdir([paths_results ids{id} 'v2s1/func/recombirec/'])


    % model specification
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.stats.fmri_spec.dir = {[paths_results ids{id} 'v2s1/func/recombirec/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = numSlice;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = microtimeOnset;

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(fMRI);

    if id==1 % id 202 has no external FA
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'ScenesCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_orig_rcg_early{id,1}.scenes_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'ScenesIntFA';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = onset_orig_rcg_early{id,1}.scenes_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'RecogCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_orig_rcg_early{id,1}.objects_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'RecogIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_orig_rcg_early{id,1}.objects_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'FBcorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset_orig_rcg_early{id,1}.feedback_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'FBIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset_orig_rcg_early{id,1}.feedback_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'confidenceRate';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset_orig_rcg_early{id,1}.confidence;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'confidenceResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = onset_orig_rcg_early{id,1}.confidence_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'recogResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = onset_orig_rcg_early{id,1}.objects_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).orth = 1;

    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'FixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = onset_orig_rcg_early{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).orth = 1;

    else

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'ScenesCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset_orig_rcg_early{id,1}.scenes_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name =  'ScenesExtFA';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset =  onset_orig_rcg_early{id,1}.scenes_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'ScenesIntFA';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset_orig_rcg_early{id,1}.scenes_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'RecogCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset_orig_rcg_early{id,1}.objects_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'RecogExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset_orig_rcg_early{id,1}.objects_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'RecogIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset_orig_rcg_early{id,1}.objects_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'FBcorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset_orig_rcg_early{id,1}.feedback_corr;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'FBExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = onset_orig_rcg_early{id,1}.feedback_ExtFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'FBIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = onset_orig_rcg_early{id,1}.feedback_IntFA;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'confidenceRate';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = onset_orig_rcg_early{id,1}.confidence;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).name = 'confidenceResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).onset = onset_orig_rcg_early{id,1}.confidence_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).name = 'recogResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).onset = onset_orig_rcg_early{id,1}.objects_resp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).orth = 1;

    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).name = 'FixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).onset = onset_orig_rcg_early{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).orth = 1;

    end


    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(multireg);
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run', matlabbatch)

    %% estimate

    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr([paths_results ids{id} 'v2s1/func/recombirec/SPM.mat']);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch) % run batch

    %% statistical inferences

    if id==1

    % here you set up the contrast matrices

    stim_scenes                 = [1 1];
    stim_objects                = [0 0 1 1];
    stim_both                   = [0 0 0 0 1 1];

    scenes_vs_fix               = [1 1  0 0  0 0  0 0 0  -2];
    objects_vs_fix              = [0 0  1 1  0 0  0 0 0  -2];
    both_vs_fix                 = [0 0  0 0  1 1  0 0 0  -2];

    correct_vs_incorrect        = [1 -1  1 -1  1 -1];
    scene__correct_vs_incorrect = [1 -1];
    object__correct_vs_incorrect= [0 0  1 -1];
    fb__correct_vs_incorrect    = [0 0  0 0  1 -1];

    confRating_vs_fix           = [0 0  0 0  0 0  1 0 0 -1];
    confResp_vs_fix             = [0 0  0 0  0 0  0 1 0 -1];
    recogResp_vs_fix            = [0 0  0 0  0 0  0 0 1 -1];


    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} 'v2s1/func/recombirec/SPM.mat']);

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'scenes';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = stim_scenes;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'objects';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = stim_objects;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'both';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = stim_both;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'scenes_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = scenes_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'objects_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = objects_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'both_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = both_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'scene__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = scene__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'object__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = object__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'fb__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = fb__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'confRating_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = confRating_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'confResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = confResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'recogResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = recogResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

    else

    % here you set up the contrast matrices

    stim_scenes                 = [1 1 1];
    stim_objects                = [0 0 0 1 1 1];
    stim_both                   = [0 0 0 0 0 0 1 1 1];

    scenes_vs_fix               = [1 1 1 0 0 0 0 0 0 0 0 0 -3];
    objects_vs_fix              = [0 0 0 1 1 1 0 0 0 0 0 0 -3];
    both_vs_fix                 = [0 0 0 0 0 0 1 1 1 0 0 0 -3];

    correct_vs_incorrect        = [2 -1 -1  2 -1 -1  2 -1 -1];
    scene__correct_vs_incorrect = [2 -1 -1];
    object__correct_vs_incorrect= [0 0 0  2 -1 -1];
    fb__correct_vs_incorrect    = [0 0 0  0 0 0  2 -1 -1];

    correct_vs_internal         = [1 -1 0  1 -1 0  1 -1 0];
    scene__correct_vs_internal  = [1 -1];
    object__correct_vs_internal = [0 0 0  1 -1 0];
    fb__correct_vs_internal     = [0 0 0  0 0 0  1 -1];

    correct_vs_external         = [1 0 -1  1 0 -1  1 0 -1];
    scene__correct_vs_external  = [1 0 -1];
    object__correct_vs_external = [0 0 0  1 0 -1];
    fb__correct_vs_external     = [0 0 0  0 0 0  1 0 -1];

    internal_vs_external         = [0 1 -1  0 1 -1  0 1 -1];
    scene__internal_vs_external  = [0 1 -1];
    object__internal_vs_external = [0 0 0  0 1 -1];
    fb__internal_vs_external     = [0 0 0  0 0 0  0 1 -1];

    confRating_vs_fix           = [0 0 0  0 0 0  0 0 0  1 0 0 -1];
    confResp_vs_fix             = [0 0 0  0 0 0  0 0 0  0 1 0 -1];
    recogResp_vs_fix            = [0 0 0  0 0 0  0 0 0  0 0 1 -1];


    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} 'v2s1/func/recombirec/SPM.mat']);

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'scenes';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = stim_scenes;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'objects';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = stim_objects;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'both';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = stim_both;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'scenes_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = scenes_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'objects_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = objects_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'both_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = both_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'scene__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = scene__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'object__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = object__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{10}.tcon.name = 'fb__correct_vs_incorrect';
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.weights = fb__correct_vs_incorrect;
    matlabbatch{1}.spm.stats.con.consess{10}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'scene__correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = scene__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'object__correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = object__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = 'fb__correct_vs_internal';
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.weights = fb__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{15}.tcon.name = 'correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{15}.tcon.weights = correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{15}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{16}.tcon.name = 'scene__correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{16}.tcon.weights = scene__correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{16}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{17}.tcon.name = 'object__correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{17}.tcon.weights = object__correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{17}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{18}.tcon.name = 'fb__correct_vs_external';
    matlabbatch{1}.spm.stats.con.consess{18}.tcon.weights = fb__correct_vs_external;
    matlabbatch{1}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.consess{19}.tcon.name = 'internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.weights = internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{20}.tcon.name = 'scene__internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{20}.tcon.weights = scene__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{20}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{21}.tcon.name = 'object__internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{21}.tcon.weights = object__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{21}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{22}.tcon.name = 'fb__internal_vs_external';
    matlabbatch{1}.spm.stats.con.consess{22}.tcon.weights = fb__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{22}.tcon.sessrep = 'none';


    matlabbatch{1}.spm.stats.con.consess{23}.tcon.name = 'confRating_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{23}.tcon.weights = confRating_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{23}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{24}.tcon.name = 'confResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{24}.tcon.weights = confResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{24}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{25}.tcon.name = 'recogResp_vs_fix';
    matlabbatch{1}.spm.stats.con.consess{25}.tcon.weights = recogResp_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{25}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

    end

end

