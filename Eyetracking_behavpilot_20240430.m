%% Pupillometric data preprocessing: encoding phase
%  1315 eyedata

%% preparation

clear;clc;close all;
warning off

pathdat = '/Users/alex/Desktop/firstpilot/First_pilot/';
path_enc = '/Users/alex/Desktop/firstpilot/First_pilot/emotional_ratings/';
path_rcg = '/Users/alex/Desktop/firstpilot/First_pilot/recognition_data/';

% path setup
addpath('/Users/alex/Documents/MATLAB/fieldtrip-20230118') % change those two
addpath(genpath('/Users/alex/Documents/MATLAB/pupil_func/'))
addpath(genpath('/Users/alex/Dropbox/paperwriting/1315/script'))

ids = {'01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12';'13';'14';'15';'16';'17';'18';'19';'20';...
    '21';'22';'23';'24';'25';'26';'27';'28';'29';'30';'31';'32';'33';'34';'35';'36';'37';'38';'39';'40';'41';'42';'43';'44'};
cond = [1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1]'; % emo=1, neu=2

fprintf('\n Preparation done \n')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%             ENCODING

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% import eyetracker data, encoding

close all

for id=1:length(ids)
    
    if cond(id)==1
    filename = [ ids{id} 'eme1.asc' ];
    elseif cond(id)==2
    filename = [ ids{id} 'nme1.asc' ];
    end
    name=filename;
    
    %%%%%%%%%%%%% alex added this bit to solve the problem where this function
    %%%%%%%%%%%%% could not read in the calibration bit altogether
    
    cd(fullfile(path_enc))
    copyfile(fullfile(path_enc,filename), ['backup_' name]); % back up the original file
    
    fid =fopen(name); % read in the raw data with calibration info
    C=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    i1 = 0; i3 = 0; clear startline endline
    for k=1:numel(C{1,1})
        tmp1 = regexp(C{1,1}(k),'CAMERA_CONFIG'); % find where header ends
        if ~isemptycell(tmp1)
            i1 = i1+1;
            startline(i1) = k+2; % mark the start of lines deleted
        end
        tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 R'); % find where the recording starts
        if ~isemptycell(tmp2)
            i3 = i3+1;
            endline(i3) = k-1; % mark the end of lines deleted
        else
            tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 L');
            if ~isemptycell(tmp2)
                i3 = i3+1;
                endline(i3) = k-1; % mark the end of lines deleted
            end
        end
        
    end
    
    fprintf('\n importing done \n')
    
    newtext = [];
    if ~isempty(startline) && ~isempty(endline)
        
        newtext{1,1} = [C{1,1}(1:startline-1);C{1,1}(endline+1:end)];
        
        fprintf('\n file modified \n')
        
        % print new file
        fName = filename;
        fid = fopen(fName,'w'); % open the file
        for k=1:numel(newtext{1,1})
            fprintf(fid,'%s\r\n',newtext{1,1}{k,1});
        end
        fclose(fid);
        fprintf('\n saved \n')
        clear C newtext
    else
        clear C newtext
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    eyeAdjustTrigNam([path_enc filename],'MSG','INPUT');
    [type] = ft_filetype([path_enc '/' filename]);
    
end


%% delete the line that makes the code bug

for id=1:length(ids)
    
    if cond(id)==1
        filename = [ ids{id} 'eme1.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nme1.asc' ];
    end
    new_filename = ['new_' filename];
    tempfile = 'temp.asc';
    line_to_remove = 'TRIAL_RESULT 0';
    
    % Flag to check whether the line exists
    line_exists = false;
    
    fid1 = fopen(filename, 'r');
    fid2 = fopen(tempfile, 'w');
    
    while ~feof(fid1)
        tline = fgetl(fid1);
        if contains(tline, line_to_remove)
            line_exists = true;
        else
            fprintf(fid2, '%s\n', tline);
        end
    end
    
    fclose(fid1);
    fclose(fid2);
    
    % If the line exists, replace the original file
    if line_exists
        movefile(tempfile, new_filename);
    else
        % If line doesn't exist, remove the temporary file
        delete(tempfile);
    end
    
end

%% now segment

for id=1:length(ids)
    
    if cond(id)==1
        filename = [ ids{id} 'eme1.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nme1.asc' ];
    end
    
    % scene segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_enc'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_enc 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 3.5;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1 (2.5s)
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_object_start -- 3 (2.5s)
    % #_object_stop -- 4
    % ---------------------------------------------
    % #_em_rating_1_start -- 5
    % #_em_rating_1_resp -- 6
    % ---------------------------------------------
    % #_em_rating_2_start -- 7
    % #_em_rating_2_resp -- 8
    % ---------------------------------------------
    % #_start_inter_trial_fix -- 9
    % #_end_inter_trial_fix -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 1;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_enc_scene           = ft_preprocessing(cfg);
    
    
    
    % obj segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_enc'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_enc 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 2.5;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1 (2.5s)
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_object_start -- 3 (2.5s)
    % #_object_stop -- 4
    % ---------------------------------------------
    % #_em_rating_1_start -- 5
    % #_em_rating_1_resp -- 6
    % ---------------------------------------------
    % #_em_rating_2_start -- 7
    % #_em_rating_2_resp -- 8
    % ---------------------------------------------
    % #_start_inter_trial_fix -- 9
    % #_end_inter_trial_fix -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 3;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_enc_object          = ft_preprocessing(cfg);
    
    %% pupil data
    
    fname_StimSeg = [path_enc '/' ids{id} 'enc_scene_eyedat_new.mat'];
    save([path_enc '/' ids{id} 'enc_scene_eyedat_new.mat'],'eye_enc_scene');
    
    fname_StimSeg = [path_enc '/' ids{id} 'enc_obj_eyedat_new.mat'];
    save([path_enc '/' ids{id} 'enc_obj_eyedat_new.mat'],'eye_enc_object');
    
    close all
    
end

%% clean

% scene

for id=19:length(ids)

% eyeinterp = eye_enc_scene;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = path_enc;

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 3.5];

segfilename = [ids{id} 'enc_scene_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_enc,segfilename)])
datatemp = cell2mat(eye_enc_scene.trial');
samples = [samples;eye_enc_scene.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_enc_scene.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;
eyeinterp.time       = eye_enc_scene.time;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_enc_scene;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_scene
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_scene.trial))+(min(cellfun(@min,eye_enc_scene.trial)))*.1 max(cellfun(@max,eye_enc_scene.trial))+(max(cellfun(@max,eye_enc_scene.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_scene)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end

% obj
for id=1:length(ids)

% eyeinterp = eye_enc_scene;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = path_enc;

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 2.5];

segfilename = [ids{id} 'enc_obj_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_enc,segfilename)])
datatemp = cell2mat(eye_enc_object.trial');
samples = [samples;eye_enc_object.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_enc_object.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_enc_object;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_scene
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_scene.trial))+(min(cellfun(@min,eye_enc_scene.trial)))*.1 max(cellfun(@max,eye_enc_scene.trial))+(max(cellfun(@max,eye_enc_scene.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_scene)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


%% visualise

figure;

for id=1:length(ids)
    
    if cond(id)==1
        colour1='r';
        colour2='r-o';
    else
        colour1='b';
        colour2='b-o';
    end
    
    clear PD_raw meanPD SE_PD eyeinterp
    
    load([path_enc ids{id} 'enc_obj_eyedat_cln_new.mat'])
    
    PD_raw = eyeinterp.dat.datai;
    meanPD = nanmean(PD_raw);
    SE_PD = std(PD_raw) / sqrt(size(PD_raw,1));
    
    maxy = 3; miny = -3;
    
    shadedErrorBar(1:2701,meanPD,SE_PD,'lineprops',{colour2,'markerfacecolor',colour1}); hold on;
    % H1 = ttest2(plotdat_preproc.stim.rew,plotdat_preproc.stim.pun); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
    % xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
    xlabel('time(msec)','Fontsize',20,'Fontweight','bold');
    ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
    title('emotional: red / neutral: blue','Fontsize',20,'Fontweight','bold')
    clear H sigbar

end


%% separately


% objects

close all

PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_enc ids{id} 'enc_obj_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_enc ids{id} 'enc_obj_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:2701,meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:2701,meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
title('Encoding, objects: emotional - red / neutral - blue','Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



% scenes

% close all

PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_enc ids{id} 'enc_scene_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_enc ids{id} 'enc_scene_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:2701,meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:2701,meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
title('Encoding, scenes: emotional - red / neutral - blue','Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%           Recognition

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% import eyetracker data, encoding

close all

for id=39:length(ids)
    
    if cond(id)==1
    filename = [ ids{id} 'emr1.asc' ];
    elseif cond(id)==2
    filename = [ ids{id} 'nmr1.asc' ];
    end
    name=filename;
    
    %%%%%%%%%%%%% alex added this bit to solve the problem where this function
    %%%%%%%%%%%%% could not read in the calibration bit altogether
    
    cd(fullfile(path_rcg))
    copyfile(fullfile(path_rcg,filename), ['backup_' name]); % back up the original file
    
    fid =fopen(name); % read in the raw data with calibration info
    C=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    i1 = 0; i3 = 0; clear startline endline
    for k=1:numel(C{1,1})
        tmp1 = regexp(C{1,1}(k),'CAMERA_CONFIG'); % find where header ends
        if ~isemptycell(tmp1)
            i1 = i1+1;
            startline(i1) = k+2; % mark the start of lines deleted
        end
        tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 R'); % find where the recording starts
        if ~isemptycell(tmp2)
            i3 = i3+1;
            endline(i3) = k-1; % mark the end of lines deleted
        else
            tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 L');
            if ~isemptycell(tmp2)
                i3 = i3+1;
                endline(i3) = k-1; % mark the end of lines deleted
            end
        end
        
    end
    
    fprintf('\n importing done \n')
    
    newtext = [];
    if ~isempty(startline) && ~isempty(endline)
        
        newtext{1,1} = [C{1,1}(1:startline-1);C{1,1}(endline+1:end)];
        
        fprintf('\n file modified \n')
        
        % print new file
        fName = filename;
        fid = fopen(fName,'w'); % open the file
        for k=1:numel(newtext{1,1})
            fprintf(fid,'%s\r\n',newtext{1,1}{k,1});
        end
        fclose(fid);
        fprintf('\n saved \n')
        clear C newtext
    else
        clear C newtext
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    eyeAdjustTrigNam([path_rcg filename],'MSG','INPUT');
    [type] = ft_filetype([path_rcg '/' filename]);
    
end


%% delete the line that makes the code bug

for id=39:length(ids)
    
    if cond(id)==1
        filename = [ ids{id} 'emr1.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nmr1.asc' ];
    end
    new_filename = ['new_' filename];
    tempfile = 'temp.asc';
    line_to_remove = 'TRIAL_RESULT 0';
    
    % Flag to check whether the line exists
    line_exists = false;
    
    fid1 = fopen(filename, 'r');
    fid2 = fopen(tempfile, 'w');
    
    while ~feof(fid1)
        tline = fgetl(fid1);
        if contains(tline, line_to_remove)
            line_exists = true;
        else
            fprintf(fid2, '%s\n', tline);
        end
    end
    
    fclose(fid1);
    fclose(fid2);
    
    % If the line exists, replace the original file
    if line_exists
        movefile(tempfile, new_filename);
    else
        % If line doesn't exist, remove the temporary file
        delete(tempfile);
    end
    
end

%% now segment

for id=1:length(ids)
    
    if cond(id)==1
        filename = [ ids{id} 'emr1.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nmr1.asc' ];
    end
    
    % scene segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_rec'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_rcg 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 3.5;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_objects_start -- 3
    % #_mem_resp -- 4
    % ---------------------------------------------
    % #_conf_rating_start -- 5
    % #_conf_resp -- 6
    % ---------------------------------------------
    % #_solution_start -- 7
    % #_solution_stop -- 8
    % ---------------------------------------------
    % #_inter_trial_fix_start -- 9
    % #_inter_trial_fix_stop -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 1;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_rcg_scene            = ft_preprocessing(cfg);
    
    
    
    % obj segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_rec'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_rcg 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 2;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_objects_start -- 3
    % #_mem_resp -- 4
    % ---------------------------------------------
    % #_conf_rating_start -- 5
    % #_conf_resp -- 6
    % ---------------------------------------------
    % #_solution_start -- 7
    % #_solution_stop -- 8
    % ---------------------------------------------
    % #_inter_trial_fix_start -- 9
    % #_inter_trial_fix_stop -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 3;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_rcg_object          = ft_preprocessing(cfg);
    
    
    % both segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_rec'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_rcg 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 2;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_objects_start -- 3
    % #_mem_resp -- 4
    % ---------------------------------------------
    % #_conf_rating_start -- 5
    % #_conf_resp -- 6
    % ---------------------------------------------
    % #_solution_start -- 7
    % #_solution_stop -- 8
    % ---------------------------------------------
    % #_inter_trial_fix_start -- 9
    % #_inter_trial_fix_stop -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 7;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_rcg_both          = ft_preprocessing(cfg);
    
    %% pupil data
    
    fname_StimSeg = [path_rcg '/' ids{id} 'rcg_scene_eyedat_new.mat'];
    save([path_rcg '/' ids{id} 'rcg_scene_eyedat_new.mat'],'eye_rcg_scene');
    
    fname_StimSeg = [path_rcg '/' ids{id} 'rcg_obj_eyedat_new.mat'];
    save([path_rcg '/' ids{id} 'rcg_obj_eyedat_new.mat'],'eye_rcg_object');
    
    fname_StimSeg = [path_rcg '/' ids{id} 'rcg_both_eyedat_new.mat'];
    save([path_rcg '/' ids{id} 'rcg_both_eyedat_new.mat'],'eye_rcg_both');
    
    close all
    
end

%% clean

% scene
for id=1:length(ids)

% eyeinterp = eye_enc_scene;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = path_rcg;

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 3.5];

segfilename = [ids{id} 'rcg_scene_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_rcg,segfilename)])
datatemp = cell2mat(eye_rcg_scene.trial');
samples = [samples;eye_rcg_scene.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_rcg_scene.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_rcg_scene;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_scene
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_scene.trial))+(min(cellfun(@min,eye_enc_scene.trial)))*.1 max(cellfun(@max,eye_enc_scene.trial))+(max(cellfun(@max,eye_enc_scene.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_scene)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


% obj
for id=1:length(ids)

% eyeinterp = eye_enc_obj;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = path_rcg;

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 2.5];

segfilename = [ids{id} 'rcg_obj_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_rcg,segfilename)])
datatemp = cell2mat(eye_rcg_object.trial');
samples = [samples;eye_rcg_object.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_rcg_object.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_rcg_object;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_obj
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_obj.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_obj.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_obj.trial))+(min(cellfun(@min,eye_enc_obj.trial)))*.1 max(cellfun(@max,eye_enc_obj.trial))+(max(cellfun(@max,eye_enc_obj.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_obj)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


% both
for id=1:length(ids)

% eyeinterp = eye_enc_both;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = path_rcg;

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 2.5];

segfilename = [ids{id} 'rcg_both_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_rcg,segfilename)])
datatemp = cell2mat(eye_rcg_both.trial');
samples = [samples;eye_rcg_both.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_rcg_both.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_rcg_both;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_both
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_both.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_both.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_both.trial))+(min(cellfun(@min,eye_enc_both.trial)))*.1 max(cellfun(@max,eye_enc_both.trial))+(max(cellfun(@max,eye_enc_both.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_both)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


%% visualise

figure;

for id=1:length(ids)
    
    if cond(id)==1
        colour1='r';
        colour2='r-o';
    else
        colour1='b';
        colour2='b-o';
    end
    
    clear PD_raw meanPD SE_PD eyeinterp
    
    load([path_rcg ids{id} 'rcg_both_eyedat_cln_new.mat'])
    
    PD_raw = eyeinterp.dat.datai;
    meanPD = nanmean(PD_raw);
    SE_PD = std(PD_raw) / sqrt(size(PD_raw,1));
    
    maxy = 3; miny = -3;
    
    shadedErrorBar(1:length(meanPD),meanPD,SE_PD,'lineprops',{colour2,'markerfacecolor',colour1}); hold on;
    % H1 = ttest2(plotdat_preproc.stim.rew,plotdat_preproc.stim.pun); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
    % xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
    xlabel('time(msec)','Fontsize',20,'Fontweight','bold');
    ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
    title('Recognition, Scene and object: emotional - red / neutral - blue','Fontsize',20,'Fontweight','bold'); grid on
    clear H sigbar

end


%% separately

% objects

close all

PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_obj_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_obj_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:length(meanPD_emo),meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanPD_emo),meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title('Recognition, objects: emotional - red / neutral - blue','Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar




% scenes

PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_scene_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_scene_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:length(meanPD_emo),meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanPD_emo),meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title('Recognition, Scenes: emotional - red / neutral - blue','Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar




% both


PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_both_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_both_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:length(meanPD_emo),meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanPD_emo),meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
xlim([0 1400])
% xticklabels(-200:200:1400)
title('Recognition, Scene and object: emotional - red / neutral - blue','Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



%% accuracy-based

load('/Users/alex/Dropbox/paperwriting/1315/behavdat_pilot_origsession.mat')

close all

% scenes

PD_raw_corr=[]; PD_raw_incorr=[];
for id=1:length(ids)
    clear eyeinterp acc raus
    load([path_rcg ids{id} 'rcg_scene_eyedat_cln_new.mat'])
    
    acc=accuracies_dat{id,1};
    acc=acc==1;
    raus=eyeinterp.dat.trl_raus;
    acc(raus==1)=[];
    
    PD_raw_corr = [PD_raw_corr; eyeinterp.dat.datai(acc==1,:)];
    PD_raw_incorr = [PD_raw_incorr; eyeinterp.dat.datai(acc==0,:)];
    
end

meanPD_corr = nanmean(PD_raw_corr);
SE_PD_corr = std(PD_raw_corr) / sqrt(size(PD_raw_corr,1));

meanPD_incorr = nanmean(PD_raw_incorr);
SE_PD_incorr = std(PD_raw_incorr) / sqrt(size(PD_raw_incorr,1));

figure;

shadedErrorBar(1:length(meanPD_corr),meanPD_corr,SE_PD_corr,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanPD_incorr),meanPD_incorr,SE_PD_incorr,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(PD_raw_corr,PD_raw_incorr); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title('Recognition, scenes: incorrect - red / correct - green','Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



% objects

PD_raw_corr=[]; PD_raw_incorr=[];
for id=1:length(ids)
    clear eyeinterp acc raus
    load([path_rcg ids{id} 'rcg_obj_eyedat_cln_new.mat'])
    
    acc=accuracies_dat{id,1};
    acc=acc==1;
    raus=eyeinterp.dat.trl_raus;
    acc(raus==1)=[];
    
    PD_raw_corr = [PD_raw_corr; eyeinterp.dat.datai(acc==1,:)];
    PD_raw_incorr = [PD_raw_incorr; eyeinterp.dat.datai(acc==0,:)];
    
end

meanPD_corr = nanmean(PD_raw_corr);
SE_PD_corr = std(PD_raw_corr) / sqrt(size(PD_raw_corr,1));

meanPD_incorr = nanmean(PD_raw_incorr);
SE_PD_incorr = std(PD_raw_incorr) / sqrt(size(PD_raw_incorr,1));

figure;

shadedErrorBar(1:length(meanPD_corr),meanPD_corr,SE_PD_corr,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanPD_incorr),meanPD_incorr,SE_PD_incorr,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(PD_raw_corr,PD_raw_incorr); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title('Recognition, objects: incorrect - red / correct - green','Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



% both

PD_raw_corr=[]; PD_raw_incorr=[];
for id=1:length(ids)
    clear eyeinterp acc raus
    load([path_rcg ids{id} 'rcg_both_eyedat_cln_new.mat'])
    
    acc=accuracies_dat{id,1};
    acc=acc==1;
    raus=eyeinterp.dat.trl_raus;
    acc(raus==1)=[];
    
    PD_raw_corr = [PD_raw_corr; eyeinterp.dat.datai(acc==1,:)];
    PD_raw_incorr = [PD_raw_incorr; eyeinterp.dat.datai(acc==0,:)];
    
end

meanPD_corr = nanmean(PD_raw_corr);
SE_PD_corr = std(PD_raw_corr) / sqrt(size(PD_raw_corr,1));

meanPD_incorr = nanmean(PD_raw_incorr);
SE_PD_incorr = std(PD_raw_incorr) / sqrt(size(PD_raw_incorr,1));

figure;

shadedErrorBar(1:length(meanPD_corr),meanPD_corr,SE_PD_corr,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanPD_incorr),meanPD_incorr,SE_PD_incorr,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(PD_raw_corr,PD_raw_incorr); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
xlim([0 1400])
title('Recognition, scenes and objects: incorrect - red / correct - green','Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%      Recognition Retest

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% import eyetracker data

close all

for id=1%39:length(ids)
    
    if cond(id)==1
    filename = [ ids{id} 'emrt.asc' ];
    elseif cond(id)==2
    filename = [ ids{id} 'nmrt.asc' ];
    end
    name=filename;
    
    %%%%%%%%%%%%% alex added this bit to solve the problem where this function
    %%%%%%%%%%%%% could not read in the calibration bit altogether
    
    cd(fullfile(path_rcg))
    copyfile(fullfile(path_rcg,filename), ['backup_' name]); % back up the original file
    
    fid =fopen(name); % read in the raw data with calibration info
    C=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    i1 = 0; i3 = 0; clear startline endline
    for k=1:numel(C{1,1})
        tmp1 = regexp(C{1,1}(k),'CAMERA_CONFIG'); % find where header ends
        if ~isemptycell(tmp1)
            i1 = i1+1;
            startline(i1) = k+2; % mark the start of lines deleted
        end
        tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 R'); % find where the recording starts
        if ~isemptycell(tmp2)
            i3 = i3+1;
            endline(i3) = k-1; % mark the end of lines deleted
        else
            tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 L');
            if ~isemptycell(tmp2)
                i3 = i3+1;
                endline(i3) = k-1; % mark the end of lines deleted
            end
        end
        
    end
    
    fprintf('\n importing done \n')
    
    newtext = [];
    if ~isempty(startline) && ~isempty(endline)
        
        newtext{1,1} = [C{1,1}(1:startline-1);C{1,1}(endline+1:end)];
        
        fprintf('\n file modified \n')
        
        % print new file
        fName = filename;
        fid = fopen(fName,'w'); % open the file
        for k=1:numel(newtext{1,1})
            fprintf(fid,'%s\r\n',newtext{1,1}{k,1});
        end
        fclose(fid);
        fprintf('\n saved \n')
        clear C newtext
    else
        clear C newtext
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    eyeAdjustTrigNam([path_rcg filename],'MSG','INPUT');
    [type] = ft_filetype([path_rcg '/' filename]);
    
end


%% delete the line that makes the code bug

for id=1%39:length(ids)
    
    if cond(id)==1
        filename = [ ids{id} 'emrt.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nmrt.asc' ];
    end
    new_filename = ['new_' filename];
    tempfile = 'temp.asc';
    line_to_remove = 'TRIAL_RESULT 0';
    
    % Flag to check whether the line exists
    line_exists = false;
    
    fid1 = fopen(filename, 'r');
    fid2 = fopen(tempfile, 'w');
    
    while ~feof(fid1)
        tline = fgetl(fid1);
        if contains(tline, line_to_remove)
            line_exists = true;
        else
            fprintf(fid2, '%s\n', tline);
        end
    end
    
    fclose(fid1);
    fclose(fid2);
    
    % If the line exists, replace the original file
    if line_exists
        movefile(tempfile, new_filename);
    else
        % If line doesn't exist, remove the temporary file
        delete(tempfile);
    end
    
end

%% now segment

for id=1:length(ids)
    
    if cond(id)==1
        filename = [ ids{id} 'emrt.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nmrt.asc' ];
    end
    
    % scene segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_rec'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_rcg 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 3.5;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_objects_start -- 3
    % #_mem_resp -- 4
    % ---------------------------------------------
    % #_conf_rating_start -- 5
    % #_conf_resp -- 6
    % ---------------------------------------------
    % #_solution_start -- 7
    % #_solution_stop -- 8
    % ---------------------------------------------
    % #_inter_trial_fix_start -- 9
    % #_inter_trial_fix_stop -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 1;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_rcg_scene            = ft_preprocessing(cfg);
    
    
    
    % obj segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_rec'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_rcg 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 2;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_objects_start -- 3
    % #_mem_resp -- 4
    % ---------------------------------------------
    % #_conf_rating_start -- 5
    % #_conf_resp -- 6
    % ---------------------------------------------
    % #_solution_start -- 7
    % #_solution_stop -- 8
    % ---------------------------------------------
    % #_inter_trial_fix_start -- 9
    % #_inter_trial_fix_stop -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 3;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_rcg_object          = ft_preprocessing(cfg);
    
    
    % both segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_rec'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_rcg 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 2;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_objects_start -- 3
    % #_mem_resp -- 4
    % ---------------------------------------------
    % #_conf_rating_start -- 5
    % #_conf_resp -- 6
    % ---------------------------------------------
    % #_solution_start -- 7
    % #_solution_stop -- 8
    % ---------------------------------------------
    % #_inter_trial_fix_start -- 9
    % #_inter_trial_fix_stop -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 7;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_rcg_both          = ft_preprocessing(cfg);
    
    %% pupil data
    
    fname_StimSeg = [path_rcg '/' ids{id} 'rcg_retest_scene_eyedat_new.mat'];
    save([path_rcg '/' ids{id} 'rcg_retest_scene_eyedat_new.mat'],'eye_rcg_scene');
    
    fname_StimSeg = [path_rcg '/' ids{id} 'rcg_retest_obj_eyedat_new.mat'];
    save([path_rcg '/' ids{id} 'rcg_retest_obj_eyedat_new.mat'],'eye_rcg_object');
    
    fname_StimSeg = [path_rcg '/' ids{id} 'rcg_retest_both_eyedat_new.mat'];
    save([path_rcg '/' ids{id} 'rcg_retest_both_eyedat_new.mat'],'eye_rcg_both');
    
    close all
    
end

%% clean

% scene
for id=1:length(ids)

% eyeinterp = eye_enc_scene;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = path_rcg;

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 3.5];

segfilename = [ids{id} 'rcg_retest_scene_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_rcg,segfilename)])
datatemp = cell2mat(eye_rcg_scene.trial');
samples = [samples;eye_rcg_scene.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_rcg_scene.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_rcg_scene;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_scene
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_scene.trial))+(min(cellfun(@min,eye_enc_scene.trial)))*.1 max(cellfun(@max,eye_enc_scene.trial))+(max(cellfun(@max,eye_enc_scene.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_scene)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


% obj
for id=1:length(ids)

% eyeinterp = eye_enc_obj;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = path_rcg;

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 2.5];

segfilename = [ids{id} 'rcg_retest_obj_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_rcg,segfilename)])
datatemp = cell2mat(eye_rcg_object.trial');
samples = [samples;eye_rcg_object.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_rcg_object.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_rcg_object;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_obj
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_obj.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_obj.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_obj.trial))+(min(cellfun(@min,eye_enc_obj.trial)))*.1 max(cellfun(@max,eye_enc_obj.trial))+(max(cellfun(@max,eye_enc_obj.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_obj)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


% both
for id=1:length(ids)

% eyeinterp = eye_enc_both;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = path_rcg;

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 2.5];

segfilename = [ids{id} 'rcg_retest_both_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_rcg,segfilename)])
datatemp = cell2mat(eye_rcg_both.trial');
samples = [samples;eye_rcg_both.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_rcg_both.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_rcg_both;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_both
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_both.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_both.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_both.trial))+(min(cellfun(@min,eye_enc_both.trial)))*.1 max(cellfun(@max,eye_enc_both.trial))+(max(cellfun(@max,eye_enc_both.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_both)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


%% visualise

figure;

for id=1:length(ids)
    
    if cond(id)==1
        colour1='r';
        colour2='r-o';
    else
        colour1='b';
        colour2='b-o';
    end
    
    clear PD_raw meanPD SE_PD eyeinterp
    
    load([path_rcg ids{id} 'rcg_retest_scene_eyedat_cln_new.mat'])
    
    PD_raw = eyeinterp.dat.datai;
    meanPD = nanmean(PD_raw);
    SE_PD = std(PD_raw) / sqrt(size(PD_raw,1));
    
    maxy = 3; miny = -3;
    
    shadedErrorBar(1:length(meanPD),meanPD,SE_PD,'lineprops',{colour2,'markerfacecolor',colour1}); hold on;
    % H1 = ttest2(plotdat_preproc.stim.rew,plotdat_preproc.stim.pun); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
    % xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
    xlabel('time(msec)','Fontsize',20,'Fontweight','bold');
    ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
    title('Recognition Retest, Scene and object: emotional - red / neutral - blue','Fontsize',20,'Fontweight','bold'); grid on
    clear H sigbar

end


%% separately

% objects

close all

PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_retest_obj_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_retest_obj_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:length(meanPD_emo),meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanPD_neu),meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_emo)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title({'Recognition Retest, objects: emotional - red / neutral - blue','Retest'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar




% scenes

PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_retest_scene_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_retest_scene_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:length(meanPD_emo),meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanPD_neu),meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_emo)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title({'Recognition Retest, Scenes: emotional - red / neutral - blue','Retest'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar




% both


PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_retest_both_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_rcg ids{id} 'rcg_retest_both_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:length(meanPD_emo),meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanPD_neu),meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_neu)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
xlim([0 1400])
% xticklabels(-200:200:1400)
title({'Recognition Retest, Scene and object: emotional - red / neutral - blue','Retest'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar


%% accuracy-based

load('/Users/alex/Dropbox/paperwriting/1315/behavdat_pilot_secondsession.mat')

close all

% scenes

PD_raw_corr=[]; PD_raw_incorr=[];
for id=1:length(ids)
    clear eyeinterp acc raus
    load([path_rcg ids{id} 'rcg_retest_scene_eyedat_cln_new.mat'])
    
    acc=accuracies_origretest_dat{id,1};
    acc=acc==1;
    raus=eyeinterp.dat.trl_raus;
    acc(raus==1)=[];
    
    PD_raw_corr = [PD_raw_corr; eyeinterp.dat.datai(acc==1,:)];
    PD_raw_incorr = [PD_raw_incorr; eyeinterp.dat.datai(acc==0,:)];
    
end

meanPD_corr = nanmean(PD_raw_corr);
SE_PD_corr = std(PD_raw_corr) / sqrt(size(PD_raw_corr,1));

meanPD_incorr = nanmean(PD_raw_incorr);
SE_PD_incorr = std(PD_raw_incorr) / sqrt(size(PD_raw_incorr,1));

figure;

shadedErrorBar(1:length(meanPD_corr),meanPD_corr,SE_PD_corr,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanPD_incorr),meanPD_incorr,SE_PD_incorr,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(PD_raw_corr,PD_raw_incorr); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_incorr)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title({'Recognition Retest, scenes: incorrect - red / correct - green','Retest'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



% objects

PD_raw_corr=[]; PD_raw_incorr=[];
for id=1:length(ids)
    clear eyeinterp acc raus
    load([path_rcg ids{id} 'rcg_retest_obj_eyedat_cln_new.mat'])
    
    acc=accuracies_origretest_dat{id,1};
    acc=acc==1;
    raus=eyeinterp.dat.trl_raus;
    acc(raus==1)=[];
    
    PD_raw_corr = [PD_raw_corr; eyeinterp.dat.datai(acc==1,:)];
    PD_raw_incorr = [PD_raw_incorr; eyeinterp.dat.datai(acc==0,:)];
    
end

meanPD_corr = nanmean(PD_raw_corr);
SE_PD_corr = std(PD_raw_corr) / sqrt(size(PD_raw_corr,1));

meanPD_incorr = nanmean(PD_raw_incorr);
SE_PD_incorr = std(PD_raw_incorr) / sqrt(size(PD_raw_incorr,1));

figure;

shadedErrorBar(1:length(meanPD_corr),meanPD_corr,SE_PD_corr,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanPD_incorr),meanPD_incorr,SE_PD_incorr,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(PD_raw_corr,PD_raw_incorr); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_incorr)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title({'Recognition Retest, objects: incorrect - red / correct - green','Retest'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



% both

PD_raw_corr=[]; PD_raw_incorr=[];
for id=1:length(ids)
    clear eyeinterp acc raus
    load([path_rcg ids{id} 'rcg_retest_both_eyedat_cln_new.mat'])
    
    acc=accuracies_origretest_dat{id,1};
    acc=acc==1;
    raus=eyeinterp.dat.trl_raus;
    acc(raus==1)=[];
    
    PD_raw_corr = [PD_raw_corr; eyeinterp.dat.datai(acc==1,:)];
    PD_raw_incorr = [PD_raw_incorr; eyeinterp.dat.datai(acc==0,:)];
    
end

meanPD_corr = nanmean(PD_raw_corr);
SE_PD_corr = std(PD_raw_corr) / sqrt(size(PD_raw_corr,1));

meanPD_incorr = nanmean(PD_raw_incorr);
SE_PD_incorr = std(PD_raw_incorr) / sqrt(size(PD_raw_incorr,1));

figure;

shadedErrorBar(1:length(meanPD_corr),meanPD_corr,SE_PD_corr,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanPD_incorr),meanPD_incorr,SE_PD_incorr,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(PD_raw_corr,PD_raw_incorr); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_incorr)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
xlim([0 1400])
title({'Recognition Retest, scenes and objects: incorrect - red / correct - green','Retest'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar


%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%         RECOMBI : ENCODING

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% import eyetracker data, encoding

close all

for id=1:length(ids)
    
    if cond(id)==1
    filename = [ ids{id} 'ere1.asc' ];
    elseif cond(id)==2
    filename = [ ids{id} 'nre1.asc' ];
    end
    name=filename;
    
    %%%%%%%%%%%%% alex added this bit to solve the problem where this function
    %%%%%%%%%%%%% could not read in the calibration bit altogether
    
    cd(fullfile(path_enc))
    copyfile(fullfile(path_enc,filename), ['backup_' name]); % back up the original file
    
    fid =fopen(name); % read in the raw data with calibration info
    C=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    i1 = 0; i3 = 0; clear startline endline
    for k=1:numel(C{1,1})
        tmp1 = regexp(C{1,1}(k),'CAMERA_CONFIG'); % find where header ends
        if ~isemptycell(tmp1)
            i1 = i1+1;
            startline(i1) = k+2; % mark the start of lines deleted
        end
        tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 R'); % find where the recording starts
        if ~isemptycell(tmp2)
            i3 = i3+1;
            endline(i3) = k-1; % mark the end of lines deleted
        else
            tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 L');
            if ~isemptycell(tmp2)
                i3 = i3+1;
                endline(i3) = k-1; % mark the end of lines deleted
            end
        end
        
    end
    
    fprintf('\n importing done \n')
    
    newtext = [];
    if ~isempty(startline) && ~isempty(endline)
        
        newtext{1,1} = [C{1,1}(1:startline-1);C{1,1}(endline+1:end)];
        
        fprintf('\n file modified \n')
        
        % print new file
        fName = filename;
        fid = fopen(fName,'w'); % open the file
        for k=1:numel(newtext{1,1})
            fprintf(fid,'%s\r\n',newtext{1,1}{k,1});
        end
        fclose(fid);
        fprintf('\n saved \n')
        clear C newtext
    else
        clear C newtext
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    eyeAdjustTrigNam([path_enc filename],'MSG','INPUT');
    [type] = ft_filetype([path_enc '/' filename]);
    
end


%% delete the line that makes the code bug

for id=[1 9:length(ids)]
    
    if cond(id)==1
        filename = [ ids{id} 'ere1.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nre1.asc' ];
    end
    new_filename = ['new_' filename];
    tempfile = 'temp.asc';
    line_to_remove = 'TRIAL_RESULT 0';
    
    % Flag to check whether the line exists
    line_exists = false;
    
    fid1 = fopen(filename, 'r');
    fid2 = fopen(tempfile, 'w');
    
    while ~feof(fid1)
        tline = fgetl(fid1);
        if contains(tline, line_to_remove)
            line_exists = true;
        else
            fprintf(fid2, '%s\n', tline);
        end
    end
    
    fclose(fid1);
    fclose(fid2);
    
    % If the line exists, replace the original file
    if line_exists
        movefile(tempfile, new_filename);
    else
        % If line doesn't exist, remove the temporary file
        delete(tempfile);
    end
    
end

%% now segment

for id=1:length(ids)
    
    if cond(id)==1
        filename = [ ids{id} 'ere1.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nre1.asc' ];
    end
    
    % scene segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_enc'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_enc 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 3.5;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1 (2.5s)
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_object_start -- 3 (2.5s)
    % #_object_stop -- 4
    % ---------------------------------------------
    % #_em_rating_1_start -- 5
    % #_em_rating_1_resp -- 6
    % ---------------------------------------------
    % #_em_rating_2_start -- 7
    % #_em_rating_2_resp -- 8
    % ---------------------------------------------
    % #_start_inter_trial_fix -- 9
    % #_end_inter_trial_fix -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 1;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_enc_scene           = ft_preprocessing(cfg);
    
    
    
    % obj segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_enc'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_enc 'new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 2.5;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1 (2.5s)
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_object_start -- 3 (2.5s)
    % #_object_stop -- 4
    % ---------------------------------------------
    % #_em_rating_1_start -- 5
    % #_em_rating_1_resp -- 6
    % ---------------------------------------------
    % #_em_rating_2_start -- 7
    % #_em_rating_2_resp -- 8
    % ---------------------------------------------
    % #_start_inter_trial_fix -- 9
    % #_end_inter_trial_fix -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 3;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_enc_object          = ft_preprocessing(cfg);
    
    %% pupil data
    
    fname_StimSeg = [path_enc ids{id} 'enc_recombi_scene_eyedat_new.mat'];
    save([path_enc ids{id} 'enc_recombi_scene_eyedat_new.mat'],'eye_enc_scene');
    
    fname_StimSeg = [path_enc ids{id} 'enc_recombi_obj_eyedat_new.mat'];
    save([path_enc ids{id} 'enc_recombi_obj_eyedat_new.mat'],'eye_enc_object');
    
    close all
    
end

%% clean

% scene
for id=1:length(ids)

% eyeinterp = eye_enc_scene;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = [path_enc ];

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 3.5];

segfilename = [ids{id} 'enc_recombi_scene_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_enc,segfilename)])
datatemp = cell2mat(eye_enc_scene.trial');
samples = [samples;eye_enc_scene.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_enc_scene.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_enc_scene;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_scene
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_scene.trial))+(min(cellfun(@min,eye_enc_scene.trial)))*.1 max(cellfun(@max,eye_enc_scene.trial))+(max(cellfun(@max,eye_enc_scene.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_scene)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end

% obj
for id=1:length(ids)

% eyeinterp = eye_enc_scene;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = [path_enc ];

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 2.5];

segfilename = [ids{id} 'enc_recombi_obj_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_enc,segfilename)])
datatemp = cell2mat(eye_enc_object.trial');
samples = [samples;eye_enc_object.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_enc_object.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_enc_object;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_scene
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_scene.trial))+(min(cellfun(@min,eye_enc_scene.trial)))*.1 max(cellfun(@max,eye_enc_scene.trial))+(max(cellfun(@max,eye_enc_scene.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_scene)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


%% visualise

figure;

for id=1:length(ids)
    
    if cond(id)==1
        colour1='r';
        colour2='r-o';
    else
        colour1='b';
        colour2='b-o';
    end
    
    clear PD_raw meanPD SE_PD eyeinterp
    
    load([path_enc 'Recombination_encoding/' ids{id} 'enc_obj_eyedat_cln_new.mat'])
    
    PD_raw = eyeinterp.dat.datai;
    meanPD = nanmean(PD_raw);
    SE_PD = std(PD_raw) / sqrt(size(PD_raw,1));
    
    maxy = 3; miny = -3;
    
    shadedErrorBar(1:2701,meanPD,SE_PD,'lineprops',{colour2,'markerfacecolor',colour1}); hold on;
    % H1 = ttest2(plotdat_preproc.stim.rew,plotdat_preproc.stim.pun); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
    % xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
    xlabel('time(msec)','Fontsize',20,'Fontweight','bold');
    ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
    title('emotional: red / neutral: blue','Fontsize',20,'Fontweight','bold')
    clear H sigbar

end


%% separately

% objects

close all

PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_enc ids{id} 'enc_recombi_obj_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_enc ids{id} 'enc_recombi_obj_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:2701,meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:2701,meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
title({'Encoding, objects: emotional - red / neutral - blue','Recombination'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



% scenes


PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_enc ids{id} 'enc_recombi_scene_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_enc ids{id} 'enc_recombi_scene_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:2701,meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:2701,meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
title({'Encoding, scenes: emotional - red / neutral - blue','Recombination'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%      Recognition Recombi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% import eyetracker data, encoding

close all

for id=1:length(ids)
    
    if cond(id)==1
    filename = [ ids{id} 'err1.asc' ];
    elseif cond(id)==2
    filename = [ ids{id} 'nrr1.asc' ];
    end
    name=filename;
    
    %%%%%%%%%%%%% alex added this bit to solve the problem where this function
    %%%%%%%%%%%%% could not read in the calibration bit altogether
    
    cd(fullfile(path_rcg,'Recombination_recognition'))
    copyfile(fullfile(path_rcg,'Recombination_recognition',filename), ['backup_' name]); % back up the original file
    
    fid =fopen(name); % read in the raw data with calibration info
    C=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    
    i1 = 0; i3 = 0; clear startline endline
    for k=1:numel(C{1,1})
        tmp1 = regexp(C{1,1}(k),'CAMERA_CONFIG'); % find where header ends
        if ~isemptycell(tmp1)
            i1 = i1+1;
            startline(i1) = k+2; % mark the start of lines deleted
        end
        tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 R'); % find where the recording starts
        if ~isemptycell(tmp2)
            i3 = i3+1;
            endline(i3) = k-1; % mark the end of lines deleted
        else
            tmp2 = regexp(C{1,1}(k),'RECORD CR 1000 0 0 L');
            if ~isemptycell(tmp2)
                i3 = i3+1;
                endline(i3) = k-1; % mark the end of lines deleted
            end
        end
        
    end
    
    fprintf('\n importing done \n')
    
    newtext = [];
    if ~isempty(startline) && ~isempty(endline)
        
        newtext{1,1} = [C{1,1}(1:startline-1);C{1,1}(endline+1:end)];
        
        fprintf('\n file modified \n')
        
        % print new file
        fName = filename;
        fid = fopen(fName,'w'); % open the file
        for k=1:numel(newtext{1,1})
            fprintf(fid,'%s\r\n',newtext{1,1}{k,1});
        end
        fclose(fid);
        fprintf('\n saved \n')
        clear C newtext
    else
        clear C newtext
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    eyeAdjustTrigNam([path_rcg 'Recombination_recognition/' filename],'MSG','INPUT');
    [type] = ft_filetype([path_rcg  'Recombination_recognition/' filename]);
    
end


%% delete the line that makes the code bug

for id=[1 39:length(ids)]
    
    if cond(id)==1
        filename = [ ids{id} 'err1.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nrr1.asc' ];
    end
    new_filename = ['new_' filename];
    tempfile = 'temp.asc';
    line_to_remove = 'TRIAL_RESULT 0';
    
    % Flag to check whether the line exists
    line_exists = false;
    
    fid1 = fopen(filename, 'r');
    fid2 = fopen(tempfile, 'w');
    
    while ~feof(fid1)
        tline = fgetl(fid1);
        if contains(tline, line_to_remove)
            line_exists = true;
        else
            fprintf(fid2, '%s\n', tline);
        end
    end
    
    fclose(fid1);
    fclose(fid2);
    
    % If the line exists, replace the original file
    if line_exists
        movefile(tempfile, new_filename);
    else
        % If line doesn't exist, remove the temporary file
        delete(tempfile);
    end
    
end

%% now segment

for id=1:length(ids)
    
    if cond(id)==1
        filename = [ ids{id} 'err1.asc' ];
    elseif cond(id)==2
        filename = [ ids{id} 'nrr1.asc' ];
    end
    
    % scene segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_rec'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_rcg  'Recombination_recognition/new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 3.5;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_objects_start -- 3
    % #_mem_resp -- 4
    % ---------------------------------------------
    % #_conf_rating_start -- 5
    % #_conf_resp -- 6
    % ---------------------------------------------
    % #_solution_start -- 7
    % #_solution_stop -- 8
    % ---------------------------------------------
    % #_inter_trial_fix_start -- 9
    % #_inter_trial_fix_stop -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 1;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_rcg_scene            = ft_preprocessing(cfg);
    
    
    
    % obj segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_rec'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_rcg  'Recombination_recognition/new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 2;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_objects_start -- 3
    % #_mem_resp -- 4
    % ---------------------------------------------
    % #_conf_rating_start -- 5
    % #_conf_resp -- 6
    % ---------------------------------------------
    % #_solution_start -- 7
    % #_solution_stop -- 8
    % ---------------------------------------------
    % #_inter_trial_fix_start -- 9
    % #_inter_trial_fix_stop -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 3;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_rcg_object          = ft_preprocessing(cfg);
    
    
    % both segment
    cfg                     = [];
    cfg.trialfun            = 'my_trialfunction_eyetracker_engrams_rec'; % for the second pilot, which didn't have feedbacks
    cfg.dataset             = [path_rcg  'Recombination_recognition/new_' filename]; % ascii converted eyelink filename
    cfg.headerformat        = 'eyelink_asc';
    cfg.dataformat          = 'eyelink_asc';
    cfg.trialdef.eventtype  = 'MSG';
    cfg.trialdef.eventvalue = [1 2 3 4 5 6 7 8 9 10]; % event per trial
    cfg.trialdef.prestim    = 0.2; % add start trigger fixation cross before the whole thing starts
    cfg.trialdef.poststim   = 2;
    cfg.channel             = {'4'}; % channel 2 is the x-coordinate
    % Baseline-correction options
    cfg.demean              = 'no';
    cfg.baselinewindow      = [-0.2 0];
    
    % ---------------------------------------------
    % #_scene_start -- 1
    % #_scene_stop -- 2
    % ---------------------------------------------
    % #_objects_start -- 3
    % #_mem_resp -- 4
    % ---------------------------------------------
    % #_conf_rating_start -- 5
    % #_conf_resp -- 6
    % ---------------------------------------------
    % #_solution_start -- 7
    % #_solution_stop -- 8
    % ---------------------------------------------
    % #_inter_trial_fix_start -- 9
    % #_inter_trial_fix_stop -- 10
    % ---------------------------------------------
    
    cfg.segmentIdx          = 7;
    % channel 3 is the y-coordinate
    % channel 4 is the pupil dilation
    cfg.dataformat          = 'eyelink_asc';
    cfg.headerformat        = 'eyelink_asc';
    
    cfg                     = ft_definetrial(cfg);
    eye_rcg_both          = ft_preprocessing(cfg);
    
    %% pupil data
    
    fname_StimSeg = [path_rcg  'Recombination_recognition/' ids{id} 'rcg_recombi_scene_eyedat_new.mat'];
    save([path_rcg  'Recombination_recognition/' ids{id} 'rcg_recombi_scene_eyedat_new.mat'],'eye_rcg_scene');
    
    fname_StimSeg = [path_rcg  'Recombination_recognition/' ids{id} 'rcg_recombi_obj_eyedat_new.mat'];
    save([path_rcg  'Recombination_recognition/' ids{id} 'rcg_recombi_obj_eyedat_new.mat'],'eye_rcg_object');
    
    fname_StimSeg = [path_rcg  'Recombination_recognition/' ids{id} 'rcg_recombi_both_eyedat_new.mat'];
    save([path_rcg  'Recombination_recognition/' ids{id} 'rcg_recombi_both_eyedat_new.mat'],'eye_rcg_both');
    
    close all
    
end

%% clean

% scene
for id=1:length(ids)

% eyeinterp = eye_enc_scene;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = [path_rcg  'Recombination_recognition/'];

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 3.5];

segfilename = [ids{id} 'rcg_recombi_scene_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_rcg,'Recombination_recognition/',segfilename)])
datatemp = cell2mat(eye_rcg_scene.trial');
samples = [samples;eye_rcg_scene.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_rcg_scene.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_rcg_scene;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_scene
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_scene.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_scene.trial))+(min(cellfun(@min,eye_enc_scene.trial)))*.1 max(cellfun(@max,eye_enc_scene.trial))+(max(cellfun(@max,eye_enc_scene.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_scene)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


% obj
for id=1:length(ids)

% eyeinterp = eye_enc_obj;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = [path_rcg 'Recombination_recognition/'];

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 2.5];

segfilename = [ids{id} 'rcg_recombi_obj_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_rcg,'Recombination_recognition/',segfilename)])
datatemp = cell2mat(eye_rcg_object.trial');
samples = [samples;eye_rcg_object.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_rcg_object.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_rcg_object;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_obj
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_obj.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_obj.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_obj.trial))+(min(cellfun(@min,eye_enc_obj.trial)))*.1 max(cellfun(@max,eye_enc_obj.trial))+(max(cellfun(@max,eye_enc_obj.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_obj)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


% both
for id=1:length(ids)

% eyeinterp = eye_enc_both;

% make data structure new, all three runs together, and baselinecorrect
%
% for tr = 1: size(dataiall,1)
%
%     temp    = zscore(dataiall(tr,:));
%     basel   = nanmean(temp(1:200)); % 200 ms before stim onset
%     eyeinterp.trial{1,tr}   = temp-basel; clear temp
%     eyeinterp.time{1,tr}    = eye_enc_scene.time{1};
%
% end

savepathdat = [path_rcg 'Recombination_recognition/'];

perc_cutoff = 30; % if more than perc_cutoff% interpolated per trial, remove whole trial
rejectlatency = [-.2 2.5];

segfilename = [ids{id} 'rcg_recombi_both_eyedat_new.mat'];

data = []; trls = []; samples = [];

load([strcat(path_rcg,'Recombination_recognition/',segfilename)])
datatemp = cell2mat(eye_rcg_both.trial');
samples = [samples;eye_rcg_both.sampleinfo+1*1*10^8];%%% newly added, should be done with all future datasets
trls = [trls;eye_rcg_both.cfg.trl+1*1*10^8];%%% newly added, should be done with all future datasets
data = [data; datatemp];clear datatemp

eyeinterp.cfg.trl    = trls;
eyeinterp.sampleinfo = samples;


% cleaning according to Mathot's paper
dat = f_Clean_Mathots_way_v2(data,perc_cutoff);

datai = dat.datai; % interpolated automatically cleaned data
datac = dat.removed; % documentation of removed artefacts per trial

% trl_raus1 == autom. approach
trl_raus = dat.trl_raus; %% 1=rejected trials, 0=selected trials
auto_select = dat.auto_select; %% Index of selected trails from automatic correction

%% %%%%%%%%%%% can be commented out, is just showing old (blue) and red (interpolated) data
%  figure

% datai == selected data !!!

%     for i = 1:size(datai,1)
%         subplot(15,15,i);plot(data(i,:));hold on
%         plot(datai(i,:),'r');hold off
%     end

%%%%%%%plot Start
for i = 1:size(auto_select,1)
    subplot(10,9,i);plot(data(auto_select(i),:));hold on
    plot(datai(i,:),'r');hold off
    if i == 90
        break;
    end
end
%%%%%%%plot end
h = gcf;set(h,'Position',[100 400 1300 800]);
%%%%%%%%%%%%% can be commented out

% make new data structure from interpolated data for manual rejection
eyeinterp = eye_rcg_both;

%%Deleting rejected trails' info

eyeinterp.trial(find(trl_raus==1)) = [];
eyeinterp.time(find(trl_raus==1)) = [];
eyeinterp.trl_raus = trl_raus;
eyeinterp.dat = dat;
eyeinterp.data_before_corr = data;

%%Save the corrected data
%mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data

save([strcat(savepathdat,replace(segfilename,".mat","_cln_new.mat"))],'eyeinterp'); % save cleaned data and behavioral data
%     clear eye_enc_both
%     clear eyeinterp

%% plot


threshold = 2; % Z-score threshold for identifying outliers

% Loop through each cell to remove outliers
for i = 1:length(eyeinterp.trial)
    data = eyeinterp.trial{i};
    z_scores = zscore(data);
    
    % Identify indices of outliers
    outliers = abs(z_scores) > threshold;
    
    % Replace outliers with NaN
    data(outliers) = NaN;
    
    % Update the cell
    eyeinterp.trial{i} = data;
end

close all
clear means
means = nanmean(cell2mat(eyeinterp.trial'),1);
stderr = nanstd(cell2mat(eyeinterp.trial'), [], 1) / sqrt(size(cell2mat(eyeinterp.trial'), 1));
ylimvec = [min(means)-100, max(means)+100];

figure;
plot(cell2mat(eyeinterp.trial')','LineWidth',1); ylim(ylimvec); xlim([0 length(eyeinterp.trial{1})])
xline(200,'--k'); text(230, ylimvec(1)+50, 'Onset', 'Rotation', 90, 'Color', 'r','FontWeight','bold');
hold on
plot(means,'LineWidth',3,'Color','k')
% Add the standard error shaded area
x = 1:length(means);
fill([x, fliplr(x)], [means + stderr, fliplr(means - stderr)], 'k', 'FaceAlpha', 0.3, 'EdgeAlpha', 0);

% Define the baseline indices and the step for subsequent ticks
baseline_end = 200;
step = 200;

% Get the length of the data
data_length = length(means);

% Create x-ticks and labels dynamically
xticks([1, baseline_end:step:data_length]);
xticklabels(arrayfun(@num2str, [-200, 0:step:(data_length-baseline_end)], 'UniformOutput', false));

% Other axis properties
xlabel('Time (ms)')
ylabel('Pupil Diameter (AU)')
title(segfilename,'FontSize',30,'FontWeight','bold','Interpreter','none');


    
    %% reject individual trials manually
    %
    %     % make data structure new, and baseline correct before rejection trials
    %     % individually
    %     for tr = 1: size(datai,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp;clear temp
    %         eyeinterp.time{1,tr} = eye_enc_both.time{1};
    %     end
    %     for tr = 1: size(auto_select,1)
    %         temp = zscore(datai(tr,:)); % z-scoring
    %         eyeinterp.trial{1,tr} = temp ; clear temp %atai(tr,:);%clear temp
    %         eyeinterp.time{1,tr} = eye_enc_both.time{1};
    %     end
    %     eyeinterp.cfg.trl = trls;
    %     eyeinterp.sampleinfo = samples;
    %
    %     eyeinterp.cfg.trl(find(trl_raus == 1),:)=[];
    %     eyeinterp.sampleinfo(find(trl_raus == 1),:)=[];
    %
    %     clear eye
    %
    %     cfg.method = 'trial'; % then individual trials excluded manually
    %     cfg.ylim = [min(cellfun(@min,eye_enc_both.trial))+(min(cellfun(@min,eye_enc_both.trial)))*.1 max(cellfun(@max,eye_enc_both.trial))+(max(cellfun(@max,eye_enc_both.trial)))*.1]; % scaling in z range
    %     cfg.latency = rejectlatency;
    %     eye_rv = ft_rejectvisual(cfg, eye_enc_both)
    %
    %     % determine which trials out based on manual rejection
    %     trlnew = eye_rv.sampleinfo(:,1);
    %     trlold = eye_rv.cfg.previous.trl(:,1);
    %
    %     % trl_raus == add manual
    %     trl_raus_manu = ~ismember(trlold,trlnew);%  - index based on whole dataset
    %
    %     ['trials removed = ' num2str(sum(trl_raus))]
    %
    %     trl_raus = [trl_raus trl_raus]; %1st col = automatic ; 2nd col = Manual
    %     trl_raus(auto_select(find(trl_raus_manu==1)),2) = 1;
    %     %% load behavioral dataset, and add behavioral data to cleaned pupil data (keep behavioral data in for deleted trials, but add which trials have been excluded)
    %     pics = []; rts = []; resp = [];
    %     for p = 1:2
    %         load([pathdat num2str(ids(n)) '/faces_' num2str(ids(n)) '_' num2str(p) '_behav.mat']);
    %         pics = [pics exp.dat.picnums];
    %         rts = [rts exp.dat.RT];
    %         resp = [resp exp.dat.responsequest];
    %     end
    %
    %     eye_rv.sex = exp.dat.sex;
    %     eye_rv.age = exp.dat.age;
    %
    %     eye_rv.trlraus = trl_raus; % 2 columns: 1 = auto, 2 = auto+manual; 1 if trial excluded, 0 if in
    %     eye_rv.trlnum = 1:length(pics); % just consecutive trial number
    %     eye_rv.rts = rts; % clear rts
    %     eye_rv.resp = resp; % clear resp
    %     eye_rv.pics = pics; % clear resp
    %     eye_rv.intpupil_final = datai(find(trl_raus_manu==0),:);
    %
    %
    %     mkdir([pathdat num2str(ids(n)) '/cleaned']); % make directory to save cleaned data
    %     save([pathdat  num2str(ids(n)) '/cleaned/' num2str(ids(n)) '_eye_cleaned.mat'],'eye_rv'); % save cleaned data and behavioral data
    %
    %     keep pathdat n ids rejectlatency
    %     close all

    
end


%% visualise

figure;

for id=1:length(ids)
    
    if cond(id)==1
        colour1='r';
        colour2='r-o';
    else
        colour1='b';
        colour2='b-o';
    end
    
    clear PD_raw meanPD SE_PD eyeinterp
    
    load([path_rcg ids{id} 'rcg_recombi_scene_eyedat_cln_new.mat'])
    
    PD_raw = eyeinterp.dat.datai;
    meanPD = nanmean(PD_raw);
    SE_PD = std(PD_raw) / sqrt(size(PD_raw,1));
    
    maxy = 3; miny = -3;
    
    shadedErrorBar(1:length(meanPD),meanPD,SE_PD,'lineprops',{colour2,'markerfacecolor',colour1}); hold on;
    % H1 = ttest2(plotdat_preproc.stim.rew,plotdat_preproc.stim.pun); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
    % xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
    xlabel('time(msec)','Fontsize',20,'Fontweight','bold');
    ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
    title({'Recognition, Scene and object: emotional - red / neutral - blue','Recombination'},'Fontsize',20,'Fontweight','bold'); grid on
    clear H sigbar

end


%% separately

% objects

close all

PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_rcg 'Recombination_recognition/' ids{id} 'rcg_recombi_obj_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_rcg 'Recombination_recognition/' ids{id} 'rcg_recombi_obj_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:length(meanPD_emo),meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanPD_emo),meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_emo)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title({'Recognition, objects: emotional - red / neutral - blue','Recombination'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar




% scenes

PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_rcg 'Recombination_recognition/' ids{id} 'rcg_recombi_scene_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_rcg 'Recombination_recognition/' ids{id} 'rcg_recombi_scene_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:length(meanPD_emo),meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanPD_emo),meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_emo)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title({'Recognition, Scenes: emotional - red / neutral - blue','Recombination'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar




% both


PD_raw_emo=[];
for id=1:2:length(ids)
    clear eyeinterp
    load([path_rcg 'Recombination_recognition/' ids{id} 'rcg_recombi_both_eyedat_cln_new.mat'])
    PD_raw_emo = [PD_raw_emo; eyeinterp.dat.datai];
end

PD_raw_neu=[];
for id=2:2:length(ids)
    clear eyeinterp
    load([path_rcg 'Recombination_recognition/' ids{id} 'rcg_recombi_both_eyedat_cln_new.mat'])
    PD_raw_neu = [PD_raw_neu; eyeinterp.dat.datai];
end

meanPD_emo = nanmean(PD_raw_emo);
SE_PD_emo = std(PD_raw_emo) / sqrt(size(PD_raw_emo,1));

meanPD_neu = nanmean(PD_raw_neu);
SE_PD_neu = std(PD_raw_neu) / sqrt(size(PD_raw_neu,1));

figure;

shadedErrorBar(1:length(meanPD_emo),meanPD_emo,SE_PD_emo,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanPD_emo),meanPD_neu,SE_PD_neu,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(PD_raw_emo,PD_raw_neu); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_emo)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
xlim([0 1400])
% xticklabels(-200:200:1400)
title({'Recognition, Scene and object: emotional - red / neutral - blue','Retest'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar


%% accuracy-based

load('/Users/alex/Dropbox/paperwriting/1315/behavdat_pilot_secondsession.mat')

close all

% scenes

PD_raw_corr=[]; PD_raw_incorr=[];
for id=1:length(ids)
    clear eyeinterp acc raus
    load([path_rcg 'Recombination_recognition/' ids{id} 'rcg_recombi_scene_eyedat_cln_new.mat'])
    
    acc=accuracies_recombi_dat{id,1};
    acc=acc==1;
    raus=eyeinterp.dat.trl_raus;
    acc(raus==1)=[];
    
    PD_raw_corr = [PD_raw_corr; eyeinterp.dat.datai(acc==1,:)];
    PD_raw_incorr = [PD_raw_incorr; eyeinterp.dat.datai(acc==0,:)];
    
end

meanPD_corr = nanmean(PD_raw_corr);
SE_PD_corr = std(PD_raw_corr) / sqrt(size(PD_raw_corr,1));

meanPD_incorr = nanmean(PD_raw_incorr);
SE_PD_incorr = std(PD_raw_incorr) / sqrt(size(PD_raw_incorr,1));

figure;

shadedErrorBar(1:length(meanPD_corr),meanPD_corr,SE_PD_corr,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanPD_incorr),meanPD_incorr,SE_PD_incorr,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(PD_raw_corr,PD_raw_incorr); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_corr)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title({'Recognition, scenes: incorrect - red / correct - green','Recombi'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



% objects

PD_raw_corr=[]; PD_raw_incorr=[];
for id=1:length(ids)
    clear eyeinterp acc raus
    load([path_rcg 'Recombination_recognition/' ids{id} 'rcg_recombi_obj_eyedat_cln_new.mat'])
    
    acc=accuracies_recombi_dat{id,1};
    acc=acc==1;
    raus=eyeinterp.dat.trl_raus;
    acc(raus==1)=[];
    
    PD_raw_corr = [PD_raw_corr; eyeinterp.dat.datai(acc==1,:)];
    PD_raw_incorr = [PD_raw_incorr; eyeinterp.dat.datai(acc==0,:)];
    
end

meanPD_corr = nanmean(PD_raw_corr);
SE_PD_corr = std(PD_raw_corr) / sqrt(size(PD_raw_corr,1));

meanPD_incorr = nanmean(PD_raw_incorr);
SE_PD_incorr = std(PD_raw_incorr) / sqrt(size(PD_raw_incorr,1));

figure;

shadedErrorBar(1:length(meanPD_corr),meanPD_corr,SE_PD_corr,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanPD_incorr),meanPD_incorr,SE_PD_incorr,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(PD_raw_corr,PD_raw_incorr); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_corr)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
title({'Recognition, objects: incorrect - red / correct - green','Recombination'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



% both

PD_raw_corr=[]; PD_raw_incorr=[];
for id=1:length(ids)
    clear eyeinterp acc raus
    load([path_rcg 'Recombination_recognition/' ids{id} 'rcg_recombi_both_eyedat_cln_new.mat'])
    
    acc=accuracies_recombi_dat{id,1};
    acc=acc==1;
    raus=eyeinterp.dat.trl_raus;
    acc(raus==1)=[];
    
    PD_raw_corr = [PD_raw_corr; eyeinterp.dat.datai(acc==1,:)];
    PD_raw_incorr = [PD_raw_incorr; eyeinterp.dat.datai(acc==0,:)];
    
end

meanPD_corr = nanmean(PD_raw_corr);
SE_PD_corr = std(PD_raw_corr) / sqrt(size(PD_raw_corr,1));

meanPD_incorr = nanmean(PD_raw_incorr);
SE_PD_incorr = std(PD_raw_incorr) / sqrt(size(PD_raw_incorr,1));

figure;

shadedErrorBar(1:length(meanPD_corr),meanPD_corr,SE_PD_corr,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanPD_incorr),meanPD_incorr,SE_PD_incorr,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(PD_raw_corr,PD_raw_incorr); sigbar1 = H1*-0.9; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
% xlim([1 length(time{1,1})]); ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 length(meanPD_corr)])
ylabel('PD(AU)','Fontsize',20,'Fontweight','bold');
% xticklabels(-200:200:2000)
xlim([0 1400])
title({'Recognition, scenes and objects: incorrect - red / correct - green','Recombination'},'Fontsize',20,'Fontweight','bold'); grid on
clear H sigbar



%%
function E = isemptycell(C)
% ISEMPTYCELL Apply the isempty function to each element of a cell array
% E = isemptycell(C)
%
% This is equivalent to E = cellfun('isempty', C),
% where cellfun is a function built-in to matlab version 5.3 or newer.

if 0 % all(version('-release') >= 12)
    E = cellfun('isempty', C);
else
    E = zeros(size(C));
    for i=1:prod(size(C))
        E(i) = isempty(C{i});
    end
    E = logical(E);
end

end
