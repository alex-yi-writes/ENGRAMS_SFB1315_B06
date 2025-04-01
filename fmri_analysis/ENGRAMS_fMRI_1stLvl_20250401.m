%% ENGRAMS fMRI 1st-level
%  AUTOBIO
%% prep

clear;

% paths
paths_results   = '/Users/yyi/Desktop/ENGRAMS/analyses/';
paths_fMRI      = '/Users/yyi/Desktop/ENGRAMS/preproc/';
paths_behav     = '/Users/yyi/Desktop/ENGRAMS/raw/';
paths_fx        = '/Users/yyi/Desktop/ENGRAMS/scripts/';

% subjects
ids={'sub-101v2s2'; 'sub-102v2s2'; 'sub-104v2s2'; 'sub-105v2s2'; 'sub-106v2s2'; 'sub-107v2s2'};

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

    expdat{id,1}    = load([paths_behav ids{id}(5:end) '/behav/' ids{id}(5:7) '_autobio.mat']);

    % stimulus vector
    clear tmp 
    tmp             = expdat{id,1}.dat.auto.config.stimlist;
    stimvec{id,1}   = double(cellfun(@ischar,tmp(:,2)));

    % onset
    onset{id,1}=[];

    onset{id,1}.autobio     = expdat{id,1}.dat.auto.results.SOT.AMstart     - expdat{id,1}.dat.auto.results.SOT.trig1;
    onset{id,1}.arithmetic  = expdat{id,1}.dat.auto.results.SOT.MAstart     - expdat{id,1}.dat.auto.results.SOT.trig1;

    onset{id,1}.autobiocue  = expdat{id,1}.dat.auto.results.SOT.AMcue       - expdat{id,1}.dat.auto.results.SOT.trig1;
    
    onset{id,1}.AMrating    = expdat{id,1}.dat.auto.results.SOT.AMratingresp- expdat{id,1}.dat.auto.results.SOT.trig1;
    onset{id,1}.MArating    = expdat{id,1}.dat.auto.results.SOT.MAratingresp- expdat{id,1}.dat.auto.results.SOT.trig1;

    onset{id,1}.fixationX   = expdat{id,1}.dat.auto.results.SOT.fixationX   - expdat{id,1}.dat.auto.results.SOT.trig1;
    

end

%% run 1st-level GLM

for id=1%:length(ids)

    % find files
    clear tmp; tmp=dir([paths_fMRI ids{id} '/func/s1pt2au' ids{id} '_task-autobio_run-*_bold.nii']);
    
    % - fmri
    nvols           = length( spm_vol( [paths_fMRI ids{id} '/func/' tmp.name] ) );
    fMRI=[];
    for cc = 1:nvols
        fMRI{cc,1}  = [paths_fMRI ids{id} '/func/' tmp.name ',' num2str(cc)];
    end

    % - realignment parameters
    clear multireg; multireg=[paths_fMRI ids{id} '/func/rp_' tmp.name(8:end-4) '.txt'];

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
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr([paths_results ids{id} '/func/autobio/SPM.mat']);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('run', matlabbatch) % run batch

end