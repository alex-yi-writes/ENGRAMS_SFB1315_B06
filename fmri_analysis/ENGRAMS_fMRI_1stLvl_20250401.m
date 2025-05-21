%% ENGRAMS fMRI 1st-level
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%               AUTOBIO
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% prep

clear;

% paths
paths_results   = '/Users/yyi/Desktop/ENGRAMS/analyses/';
paths_fMRI      = '/Users/yyi/Desktop/ENGRAMS/preproc/';
paths_behav     = '/Users/yyi/Desktop/ENGRAMS/raw/';
paths_fx        = '/Users/yyi/Desktop/ENGRAMS/scripts/';

% subjects
ids={'sub-109v2s2'};%{'sub-108v2s2'; 'sub-109v2s2'};

% scanning parameters
TR              = 2;
numSlice        = 96;
microtimeOnset  = 1;
AMcondDuration  = 8;
MAcondDuration  = 10;

flags=[];

%% make behavioural data

expdat=[];

for id=1:length(ids)

    expdat{id,1}            = load([paths_behav ids{id}(5:end) '/behav/' ids{id}(5:7) '_autobio.mat']);

    % stimulus vector
    clear tmp 
    tmp                     = expdat{id,1}.dat.auto.config.stimlist;
    stimvec{id,1}           = double(cellfun(@ischar,tmp(:,2)));
    % sort high mem and low mem
    AMratings{id,1}         = expdat{id,1}.dat.auto.results.AM.ratings(stimvec{id,1}==1);
    ind_AMhigh{id,1}        = AMratings{id,1}>1;
    ind_AMlow{id,1}         = AMratings{id,1}<=1;

    % onset
    onset{id,1}             = [];

    onset{id,1}.autobio     = expdat{id,1}.dat.auto.results.SOT.AMstart     - expdat{id,1}.dat.auto.results.SOT.trig1+TR;
    onset{id,1}.autobio_hi  = onset{id,1}.autobio(ind_AMhigh{id,1}==1)      - expdat{id,1}.dat.auto.results.SOT.trig1+TR;
    onset{id,1}.autobio_lo  = onset{id,1}.autobio(ind_AMlow{id,1}==1)       - expdat{id,1}.dat.auto.results.SOT.trig1+TR;

    onset{id,1}.arithmetic  = expdat{id,1}.dat.auto.results.SOT.MAstart     - expdat{id,1}.dat.auto.results.SOT.trig1+TR;

    onset{id,1}.autobiocue  = expdat{id,1}.dat.auto.results.SOT.AMcue       - expdat{id,1}.dat.auto.results.SOT.trig1+TR;
    
    onset{id,1}.AMrating    = expdat{id,1}.dat.auto.results.SOT.AMratingresp- expdat{id,1}.dat.auto.results.SOT.trig1+TR;
    onset{id,1}.MArating    = expdat{id,1}.dat.auto.results.SOT.MAratingresp- expdat{id,1}.dat.auto.results.SOT.trig1+TR;

    onset{id,1}.fixationX   = expdat{id,1}.dat.auto.results.SOT.fixationX   - expdat{id,1}.dat.auto.results.SOT.trig1+TR;

end

%% run 1st-level GLM

for id=1:length(ids) % try 3 again

    % find files
    clear tmp; tmp=dir([paths_fMRI ids{id} '/func/s1pt2au' ids{id} '_task-autobio_run-*_bold.nii']);
    
    % - fmri
    nvols           = length( spm_vol( [paths_fMRI ids{id} '/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_fMRI ids{id} '/func/' tmp.name ',' num2str(cc)];
    end

    % make physio + realignment parameters
    clear R realigndata realignFile physiodata physiodata2 physiodata physioFile physioFile2
    
    % read physio parameters
    physioFile  = [paths_behav ids{id}(5:end) '/physio/multiple_regressors_auto.txt'];
    physiodata  = importdata(physioFile);

    % read realignment parameters
    realignFile = [paths_fMRI ids{id} '/func/rp_' tmp.name(8:end-4) '.txt'];
    realigndata = importdata(realignFile);

    % concatenate and save
    R = [physiodata realigndata];
    save([paths_fMRI ids{id} '/func/reg_all_autobio.mat'],'R');

    clear R realigndata realignFile physiodata physiodata physioFile

    multireg=[paths_fMRI ids{id}  '/func/reg_all_autobio.mat'];

%     % - realignment parameters
%     clear multireg; multireg=[paths_fMRI ids{id} '/func/rp_' tmp.name(8:end-4) '.txt'];

    % setup workspace
    mkdir([paths_results ids{id} '/func/autobio/'])


    % model specification
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.stats.fmri_spec.dir = {[paths_results ids{id} '/func/autobio/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = numSlice;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = microtimeOnset;

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(fMRI);

    if id==3
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'autobiographical';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset{id,1}.autobio;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = AMcondDuration;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'arithmetic';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = onset{id,1}.arithmetic;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = MAcondDuration;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'autobiocue';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset{id,1}.autobiocue;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'AMrating';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset{id,1}.AMrating;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'MArating';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset{id,1}.MArating;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'fixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;

    else
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'autobiographical_high';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset{id,1}.autobio_hi;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = AMcondDuration;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'autobiographical_lo';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = onset{id,1}.autobio_lo;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = AMcondDuration;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'arithmetic';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset{id,1}.arithmetic;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = MAcondDuration;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'autobiocue';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset{id,1}.autobiocue;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'AMrating';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset{id,1}.AMrating;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'MArating';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset{id,1}.MArating;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'fixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset{id,1}.fixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

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
    matlabbatch{1}.spm.stats.fmri_spec.mask = {[paths_fMRI ids{id} '/func/autobio_mask.nii,1']};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run', matlabbatch)

    % manually set my own explicit mask
    load([paths_results ids{id} '/func/autobio/SPM.mat'])
    SPM.xM.VM=spm_vol([paths_fMRI ids{id} '/func/autobio_mask.nii']);
    SPM.xM.TH=v2s2-Inf*ones(size(SPM.xY.P,1),1);
    save([paths_results ids{id} '/func/autobio/SPM.mat'],'SPM')

    %% estimate

    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr([paths_results ids{id} '/func/autobio/SPM.mat']);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch) % run batch

    %% statistical inferences

    % here you set up the contrast matrices

    if id==3
    Cognition_vs_Idle       = [1 1 1 1 1 -5];
    Buttonpress_vs_Idle     = [0 0 0 1 1 -2];

    Autobio_vs_Arithmetic   = [1 -1];

    Autobio_vs_Fixation     = [1 0 0 0 0 -1];
    Arithmetic_vs_Fixation  = [0 0 1 0 0 0 -1];

    AutobioCue_vs_Fixation  = [0 0 1 0 0 -1];

    else
    Cognition_vs_Idle       = [1 1 1 1 1 1 -6];
    Buttonpress_vs_Idle     = [0 0 0 0 1 1 -2];

    Autobio_vs_Arithmetic   = [1 1 -2];

    Autobio_vs_Fixation     = [1 1 0 0 0 0 -2];
    Arithmetic_vs_Fixation  = [0 0 1 0 0 0 -1];

    AutobioCue_vs_Fixation  = [0 0 0 1 0 0 -1];

    AutobioHigh_vs_AutobioLow = [1 -1];
    AutobioLow_vs_AutobioHigh = [-1 1];

    AutobioHigh_vs_Arithmetic = [1 0 -1];

    end


    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} '/func/autobio/SPM.mat']);

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Cognition vs Idle';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = Cognition_vs_Idle;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Buttonpressb vs Idle';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = Buttonpress_vs_Idle;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Autobio vs Arithmetic';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = Autobio_vs_Arithmetic;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Autobio vs Fixation';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = Autobio_vs_Fixation;
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Arithmetic vs Fixation';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = Arithmetic_vs_Fixation;
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'AutobioCue vs Fixation';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = AutobioCue_vs_Fixation;
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

    if id~=3
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'AutobioHigh vs AutobioLow';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = AutobioHigh_vs_AutobioLow;
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'AutobioLow vs AutobioHigh';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = AutobioLow_vs_AutobioHigh;
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'AutobioHigh vs Arithmetic';
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = AutobioHigh_vs_Arithmetic;
    matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    end

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%               Memory
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% prep

clear;

% paths
paths_results   = '/Users/yyi/Desktop/ENGRAMS/analyses/';
paths_fMRI      = '/Users/yyi/Desktop/ENGRAMS/preproc/';
paths_behav     = '/Users/yyi/Desktop/ENGRAMS/raw/';
paths_fx        = '/Users/yyi/Desktop/ENGRAMS/scripts/';

% subjects
ids={'sub-109v2s2'};

% scanning parameters
TR              = 2;
numSlice        = 96;
microtimeOnset  = 1;
AMcondDuration  = 8;
MAcondDuration  = 10;

flags=[];

%% make behavioural data

expdat_enc=[];
expdat_rec=[];

for id=1:length(ids)

    expdat_enc{id,1}        = load([paths_behav ids{id}(5:end) '/behav/' ids{id}(5:7) '_enc_orig_1.mat']);
    expdat_rcg{id,1}        = load([paths_behav ids{id}(5:end) '/behav/' ids{id}(5:7) '_rcg_orig_1.mat']);

    onset{id,1}             = [];

    % ------- encoding ------- %
    onset{id,1}.enc.scenes  = expdat_enc{id,1}.dat.enc.results.SOT.scene    - expdat_enc{id,1}.dat.enc.results.SOT.trig1;
    onset{id,1}.enc.objects = expdat_enc{id,1}.dat.enc.results.SOT.object   - expdat_enc{id,1}.dat.enc.results.SOT.trig1;
    onset{id,1}.enc.both    = expdat_enc{id,1}.dat.enc.results.SOT.together - expdat_enc{id,1}.dat.enc.results.SOT.trig1;

    onset{id,1}.enc.valenceRate_scene = expdat_enc{id,1}.dat.enc.results.SOT.ValenceQ_scene - expdat_enc{id,1}.dat.enc.results.SOT.trig1;
    onset{id,1}.enc.valenceRate_obj   = expdat_enc{id,1}.dat.enc.results.SOT.ValenceQ_obj   - expdat_enc{id,1}.dat.enc.results.SOT.trig1;

    onset{id,1}.enc.valenceResp_scene = expdat_enc{id,1}.dat.enc.results.SOT.resp_scene     - expdat_enc{id,1}.dat.enc.results.SOT.trig1;
    onset{id,1}.enc.valenceResp_obj   = expdat_enc{id,1}.dat.enc.results.SOT.resp_obj       - expdat_enc{id,1}.dat.enc.results.SOT.trig1;

    onset{id,1}.enc.FixationX = expdat_enc{id,1}.dat.enc.results.SOT.fixationX              - expdat_enc{id,1}.dat.enc.results.SOT.trig1;

    % ------- recognition ------- %
    
    clear acc
    
    % remove missed responses
    acc = expdat_rcg{id,1}.dat.rcg.results.accuracy;
    ind_missed{id,1}        = isnan(acc);

    % tag responses
    ind_ExternalLure{id,1}  = acc==0;
    ind_InternalLure{id,1}  = acc==-1;
    ind_Correct{id,1}       = acc==1;

    onset{id,1}.rcg.scenes  = expdat_rcg{id,1}.dat.rcg.results.SOT.scene            - expdat_rcg{id,1}.dat.rcg.results.SOT.trig1; 
    onset{id,1}.rcg.recogQ  = expdat_rcg{id,1}.dat.rcg.results.SOT.RecognitionQ     - expdat_rcg{id,1}.dat.rcg.results.SOT.trig1; 
    onset{id,1}.rcg.feedback= expdat_rcg{id,1}.dat.rcg.results.SOT.together         - expdat_rcg{id,1}.dat.rcg.results.SOT.trig1; 

    % accuracy
    onset{id,1}.rcg.scenes_correct =  onset{id,1}.rcg.scenes(ind_Correct{id,1});
    onset{id,1}.rcg.scenes_ExtLure =  onset{id,1}.rcg.scenes(ind_ExternalLure{id,1});
    onset{id,1}.rcg.scenes_IntLure =  onset{id,1}.rcg.scenes(ind_InternalLure{id,1});

    onset{id,1}.rcg.recog_correct =  onset{id,1}.rcg.recogQ(ind_Correct{id,1});
    onset{id,1}.rcg.recog_ExtLure =  onset{id,1}.rcg.recogQ(ind_ExternalLure{id,1});
    onset{id,1}.rcg.recog_IntLure =  onset{id,1}.rcg.recogQ(ind_InternalLure{id,1});

    onset{id,1}.rcg.FB_correct =  onset{id,1}.rcg.feedback(ind_Correct{id,1});
    onset{id,1}.rcg.FB_ExtLure =  onset{id,1}.rcg.feedback(ind_ExternalLure{id,1});
    onset{id,1}.rcg.FB_IntLure =  onset{id,1}.rcg.feedback(ind_InternalLure{id,1});

    % buttons
    onset{id,1}.rcg.confidenceRate = expdat_rcg{id,1}.dat.rcg.results.SOT.ConfidenceQ       - expdat_rcg{id,1}.dat.rcg.results.SOT.trig1;
    onset{id,1}.rcg.confidenceResp = expdat_rcg{id,1}.dat.rcg.results.SOT.resp_confidenceQ  - expdat_rcg{id,1}.dat.rcg.results.SOT.trig1;
    onset{id,1}.rcg.recogResp = expdat_rcg{id,1}.dat.rcg.results.SOT.resp_RecognitionQ      - expdat_rcg{id,1}.dat.rcg.results.SOT.trig1;

    onset{id,1}.rcg.FixationX = expdat_rcg{id,1}.dat.rcg.results.SOT.fixationX      - expdat_rcg{id,1}.dat.rcg.results.SOT.trig1;

    % remove missed responses
    onset{id,1}.rcg.scenes(ind_missed{id,1})=[];
    onset{id,1}.rcg.recogQ(ind_missed{id,1})=[];
    onset{id,1}.rcg.feedback(ind_missed{id,1})=[];
        
end

%% run 1st-level GLM

for id=1:length(ids) 

    % find files
    clear tmp; tmp=dir([paths_fMRI ids{id} '/func/s1pt2au' ids{id} '_task-origenc_run-*_bold.nii']);
    
    % - fmri
    nvols           = length( spm_vol( [paths_fMRI ids{id} '/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_fMRI ids{id} '/func/' tmp.name ',' num2str(cc)];
    end

    % make physio + realignment parameters
    clear R realigndata realignFile physiodata physiodata2 physiodata physioFile physioFile2
    
    % read physio parameters
    physioFile  = [paths_behav ids{id}(5:end) '/physio/multiple_regressors_origenc.txt'];
    physiodata  = importdata(physioFile);

    % read realignment parameters
    realignFile = [paths_fMRI ids{id} '/func/rp_' tmp.name(8:end-4) '.txt'];
    realigndata = importdata(realignFile);

    % concatenate and save
    R = [physiodata realigndata];
    save([paths_fMRI ids{id} '/func/reg_all_origenc.mat'],'R');

    clear R realigndata realignFile physiodata physiodata physioFile

    multireg=[paths_fMRI ids{id}  '/func/reg_all_origenc.mat'];

%     % - realignment parameters
%     clear multireg; multireg=[paths_fMRI ids{id} '/func/rp_' tmp.name(8:end-4) '.txt'];

    % setup workspace
    mkdir([paths_results ids{id} '/func/origenc/'])


    % model specification
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.stats.fmri_spec.dir = {[paths_results ids{id} '/func/origenc/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = numSlice;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = microtimeOnset;

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(fMRI);

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'scenes';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset{id,1}.enc.scenes;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'objects';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = onset{id,1}.enc.objects;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'both';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset{id,1}.enc.both;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'valence rating scene';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset{id,1}.enc.valenceRate_scene;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name =  'valence rating object';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset =  onset{id,1}.enc.valenceRate_obj;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'valence response scene';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset{id,1}.enc.valenceResp_scene;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'valence response object';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset{id,1}.enc.valenceResp_obj;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'fixation';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = onset{id,1}.enc.FixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(multireg);
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0;
    matlabbatch{1}.spm.stats.fmri_spec.mask =  {[paths_fMRI ids{id} '/func/origenc_mask.nii,1']}; % this ain't working
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run', matlabbatch)

    % manually set my own explicit mask
    load([paths_results ids{id} '/func/origenc/SPM.mat'])
    SPM.xM.VM=spm_vol([paths_fMRI ids{id} '/func/origenc_mask.nii']);
    SPM.xM.TH=-Inf*ones(size(SPM.xY.P,1),1);
    save([paths_results ids{id} '/func/origenc/SPM.mat'],'SPM')


    %% estimate

    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr([paths_results ids{id} '/func/origenc/SPM.mat']);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch) % run batch

    %% statistical inferences

    % here you set up the contrast matrices

    Cognition_vs_Idle       = [1 1 1 1 1 1 1 -8];
    Buttonpress_vs_Idle     = [0 0 0 0 0 1 1 -2];
   
    stim_scenes             = [1];
    stim_objects            = [0 1];
    stim_both               = [0 0 1];

    scene_vs_object         = [1 -1];
    object_vs_scene         = [-1 1];

    scene_vs_fix            = [1 0 0 0 0 0 0 -1];
    object_vs_fix           = [0 1 0 0 0 0 0 -1];
    both_vs_fix             = [0 0 1 0 0 0 0 -1];

    ratings_vs_fix          = [0 0 0 1 1 0 -2];
    ratings_scene_vs_fix    = [0 0 0 1 0 0 -1];
    ratings_object_vs_fix   = [0 0 0 0 1 0 -1];

    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} '/func/origenc/SPM.mat']);

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

    matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'ratings vs fix';
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = ratings_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'ratings_scene vs fix';
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = ratings_scene_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'ratings_object vs fix';
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = ratings_object_vs_fix;
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    

    matlabbatch{1}.spm.stats.con.delete = 1;    % 1 means delete, 0 means append

    spm_jobman('run', matlabbatch) % run batch

end


% recognition


for id=1:length(ids) % try 2 again

    % find files
    clear tmp; tmp=dir([paths_fMRI ids{id} '/func/s1pt2au' ids{id} '_task-origrec_run-*_bold.nii']);
    
    % - fmri
    nvols           = length( spm_vol( [paths_fMRI ids{id} '/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_fMRI ids{id} '/func/' tmp.name ',' num2str(cc)];
    end

    % make physio + realignment parameters
    clear R realigndata realignFile physiodata physiodata2 physiodata physioFile physioFile2
    
    % read physio parameters
    physioFile  = [paths_behav ids{id}(5:end) '/physio/multiple_regressors_origrec.txt'];
    physiodata  = importdata(physioFile);

    % read realignment parameters
    realignFile = [paths_fMRI ids{id} '/func/rp_' tmp.name(8:end-4) '.txt'];
    realigndata = importdata(realignFile);

    % concatenate and save
    R = [physiodata realigndata];
    save([paths_fMRI ids{id} '/func/reg_all_origrec.mat'],'R');

    clear R realigndata realignFile physiodata physiodata physioFile

    multireg=[paths_fMRI ids{id}  '/func/reg_all_origrec.mat'];

%     % - realignment parameters
%     clear multireg; multireg=[paths_fMRI ids{id} '/func/rp_' tmp.name(8:end-4) '.txt'];

    % setup workspace
    mkdir([paths_results ids{id} '/func/origrec/'])


    % model specification
    clear matlabbatch
    spm_jobman('initcfg')
    matlabbatch{1}.spm.stats.fmri_spec.dir = {[paths_results ids{id} '/func/origrec/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = numSlice;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = microtimeOnset;

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(fMRI);

    if id==999
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'ScenesCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset{id,1}.rcg.scenes_correct;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name =  'ScenesExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset =  onset{id,1}.rcg.scenes_ExtLure;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'NullSceneInternalLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'RecogCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset{id,1}.rcg.recog_correct;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'RecogExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset{id,1}.rcg.recog_ExtLure;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'NullObjectInternalLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = 3;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'FBcorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset{id,1}.rcg.FB_correct;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'FBExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = onset{id,1}.rcg.FB_ExtLure;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'NullFBtInternalLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = 1.5;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'confidenceRate';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = onset{id,1}.rcg.confidenceRate;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).name = 'confidenceResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).onset = onset{id,1}.rcg.confidenceResp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).name = 'recogResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).onset = onset{id,1}.rcg.recogResp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).orth = 1;

    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).name = 'FixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).onset = onset{id,1}.rcg.FixationX;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).orth = 1;

    else
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'ScenesCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = onset{id,1}.rcg.scenes_correct;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name =  'ScenesExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset =  onset{id,1}.rcg.scenes_ExtLure;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'ScenesIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = onset{id,1}.rcg.scenes_IntLure;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).name = 'RecogCorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).onset = onset{id,1}.rcg.recog_correct;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).name = 'RecogExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).onset = onset{id,1}.rcg.recog_ExtLure;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(5).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).name = 'RecogIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).onset = onset{id,1}.rcg.recog_IntLure;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(6).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).name = 'FBcorrect';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).onset = onset{id,1}.rcg.FB_correct;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(7).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).name = 'FBExtLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).onset = onset{id,1}.rcg.FB_ExtLure;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(8).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).name = 'FBIntLure';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).onset = onset{id,1}.rcg.FB_IntLure;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(9).orth = 1;


    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).name = 'confidenceRate';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).onset = onset{id,1}.rcg.confidenceRate;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(10).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).name = 'confidenceResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).onset = onset{id,1}.rcg.confidenceResp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(11).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).name = 'recogResp';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).onset = onset{id,1}.rcg.recogResp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(12).orth = 1;

    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).name = 'FixationX';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(13).onset = onset{id,1}.rcg.FixationX;
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
    matlabbatch{1}.spm.stats.fmri_spec.mask = {[paths_fMRI ids{id} '/func/origrec_mask.nii,1']};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    spm_jobman('run', matlabbatch)

    % manually set my own explicit mask
    load([paths_results ids{id} '/func/origrec/SPM.mat'])
    SPM.xM.VM=spm_vol([paths_fMRI ids{id} '/func/origrec_mask.nii']);
    SPM.xM.TH=-Inf*ones(size(SPM.xY.P,1),1);
    save([paths_results ids{id} '/func/origrec/SPM.mat'],'SPM')

    %% estimate

    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr([paths_results ids{id} '/func/origrec/SPM.mat']);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch) % run batch

    %% statistical inferences

    % here you set up the contrast matrices
   
    stim_scenes                 = [1 1 1];
    stim_objects                = [0 0 0 1 1 1];
    stim_both                   = [0 0 0 0 0 0 1 1 1];

    scenes_vs_fix               = [1 1 1 0 0 0 0 0 0 0 0 0 -3];
    objects_vs_fix              = [0 0 0 1 1 1 0 0 0 0 0 0 -3];
    both_vs_fix                 = [0 0 0 0 0 0 1 1 1 0 0 0 -3];

    if id==999
        correct_vs_incorrect        = [1 0 -1  1 0 -1  1 0 -1];
        scene__correct_vs_incorrect = [1 0 -1];
        object__correct_vs_incorrect= [0 0 0  1 0 -1];
        fb__correct_vs_incorrect    = [0 0 0  0 0 0  1 0 -1];

        correct_vs_internal         = [1];
        scene__correct_vs_internal  = [1];
        object__correct_vs_internal = [1];
        fb__correct_vs_internal     = [1];

        correct_vs_external         = [1 0 -1  1 0 -1  1 0 -1];
        scene__correct_vs_external  = [1 0 -1];
        object__correct_vs_external = [0 0 0  1 0 -1];
        fb__correct_vs_external     = [0 0 0  0 0 0  1 0 -1];

        internal_vs_external         = [1];
        scene__internal_vs_external  = [1];
        object__internal_vs_external = [1];
        fb__internal_vs_external     = [1];


    else
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
    end

    confRating_vs_fix           = [0 0 0  0 0 0  0 0 0  1 0 0 -1];
    confResp_vs_fix             = [0 0 0  0 0 0  0 0 0  0 1 0 -1];
    recogResp_vs_fix            = [0 0 0  0 0 0  0 0 0  0 0 1 -1];
    

    % batch setup
    clear matlabbatch
    spm_jobman('initcfg');      % initiate job manager

    matlabbatch{1}.spm.stats.con.spmmat = cellstr([paths_results ids{id} '/func/origrec/SPM.mat']);

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


    if id==999
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'nullcontrast';
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.weights = correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'nullcontrast';
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.weights = scene__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'nullcontrast';
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.weights = object__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = 'nullcontrast';
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.weights = fb__correct_vs_internal;
    matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';

    else
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
    end


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
    

    if id==999
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.name = 'nullcontrast';
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.weights = internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{19}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{20}.tcon.name = 'nullcontrast';
    matlabbatch{1}.spm.stats.con.consess{20}.tcon.weights = scene__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{20}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{21}.tcon.name = 'nullcontrast';
    matlabbatch{1}.spm.stats.con.consess{21}.tcon.weights = object__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{21}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{22}.tcon.name = 'nullcontrast';
    matlabbatch{1}.spm.stats.con.consess{22}.tcon.weights = fb__internal_vs_external;
    matlabbatch{1}.spm.stats.con.consess{22}.tcon.sessrep = 'none';
    else
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
    end


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