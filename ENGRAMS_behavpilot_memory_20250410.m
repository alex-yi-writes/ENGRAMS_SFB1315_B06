%% behavioural pilot analysis script
%% preparation

clc;clear;close all

path_data = '/Users/alex/Dropbox/paperwriting/1315/data/pilotdata/';

ids_neu = {'61';'63';'80';'81';'82';'83';'84';'85';'86';'87';'88';'89'};
ids_emo = {'71';'73';'90';'93';'94';'95';'96';'97';'98';'99'};

encoding_neu=[]; recognition_neu=[];
for id=1:length(ids_neu)
    encoding_neu{id,1}      = load([path_data ids_neu{id,1} '_enc_orig_1.mat']);
    recognition_neu{id,1}   = load([path_data ids_neu{id,1} '_rcg_orig_1.mat']);
end

encoding_emo=[]; recognition_emo=[];
for id=1:length(ids_emo)
    encoding_emo{id,1} = load([path_data ids_emo{id,1} '_enc_orig_1.mat']);
    recognition_emo{id,1} = load([path_data ids_emo{id,1} '_rcg_orig_1.mat']);
end

%% extract info: encoding

% neutral, valence ratings
valence_neu_scenes=[]; valence_neu_objects=[];
for id=1:length(ids_neu)

    valence_neu_scenes{id,1}          = encoding_neu{id,1}.dat.enc.results.ValenceRatings.scene;
    valence_neu_objects{id,1}         = encoding_neu{id,1}.dat.enc.results.ValenceRatings.object;

    ind_valence_neu_scenes_high{id,1} = valence_neu_scenes{id,1}>=2;
    ind_valence_neu_scenes_low{id,1}  = valence_neu_scenes{id,1}<=1;

    mean_valence_neu_scene(id,1)      = nanmean(valence_neu_scenes{id,1});
    mean_valence_neu_objects(id,1)    = nanmean(valence_neu_objects{id,1});

    presentation_enc_neu_scenes{id,1} = cellfun(@(x) x(25:end),encoding_neu{id,1}.dat.enc.config.stimlist.Picture_top,'UniformOutput',false);
    presentation_enc_neu_objects{id,1}= cellfun(@(x) x(26:end),encoding_neu{id,1}.dat.enc.config.stimlist.Picture_bottom,'UniformOutput',false);


    RT_enc_neu_scenes{id,1}               = encoding_neu{id,1}.dat.enc.results.RT.ValenceQ_scene;
    RT_enc_neu_objects{id,1}              = encoding_neu{id,1}.dat.enc.results.RT.ValenceQ_object;

    mean_RT_enc_neu_scenes(id,1)          = nanmean(encoding_neu{id,1}.dat.enc.results.RT.ValenceQ_scene);
    mean_RT_enc_neu_objects(id,1)         = nanmean(encoding_neu{id,1}.dat.enc.results.RT.ValenceQ_object);

    mean_RT_enc_scenes = nanmean(RT_enc_neu_scenes{id,1});
    std_RT_enc_scenes = nanstd(RT_enc_neu_scenes{id,1});

    mean_RT_enc_objects = nanmean(RT_enc_neu_objects{id,1});
    std_RT_enc_objects = nanstd(RT_enc_neu_objects{id,1});

    Z_RT_enc_neu_scenes{id,1} = (RT_enc_neu_scenes{id,1} - mean_RT_enc_scenes) / std_RT_enc_scenes;
    Z_RT_enc_neu_objects{id,1} = (RT_enc_neu_objects{id,1} - mean_RT_enc_objects) / std_RT_enc_objects;
end


% emotional, valence ratings
valence_emo_scenes=[]; valence_emo_objects=[];
for id=1:length(ids_emo)

    valence_emo_scenes{id,1}          = encoding_emo{id,1}.dat.enc.results.ValenceRatings.scene;
    valence_emo_objects{id,1}         = encoding_emo{id,1}.dat.enc.results.ValenceRatings.object;

    ind_valence_emo_scenes_high{id,1} = valence_emo_scenes{id,1}>=2;
    ind_valence_emo_scenes_low{id,1}  = valence_emo_scenes{id,1}<=1;

    mean_valence_emo_scene(id,1)      = nanmean(valence_emo_scenes{id,1});
    mean_valence_emo_objects(id,1)    = nanmean(valence_emo_objects{id,1});

    presentation_enc_emo_scenes{id,1} = cellfun(@(x) x(25:end),encoding_emo{id,1}.dat.enc.config.stimlist.Picture_top,'UniformOutput',false);
    presentation_enc_emo_objects{id,1}= cellfun(@(x) x(26:end),encoding_emo{id,1}.dat.enc.config.stimlist.Picture_bottom,'UniformOutput',false);


    RT_enc_emo_scenes{id,1}               = encoding_emo{id,1}.dat.enc.results.RT.ValenceQ_scene;
    RT_enc_emo_objects{id,1}              = encoding_emo{id,1}.dat.enc.results.RT.ValenceQ_object;

    mean_RT_enc_emo_scenes(id,1)          = nanmean(encoding_emo{id,1}.dat.enc.results.RT.ValenceQ_scene);
    mean_RT_enc_emo_objects(id,1)         = nanmean(encoding_emo{id,1}.dat.enc.results.RT.ValenceQ_object);

    mean_RT_enc_scenes = nanmean(RT_enc_emo_scenes{id,1});
    std_RT_enc_scenes = nanstd(RT_enc_emo_scenes{id,1});

    mean_RT_enc_objects = nanmean(RT_enc_emo_objects{id,1});
    std_RT_enc_objects = nanstd(RT_enc_emo_objects{id,1});

    Z_RT_enc_emo_scenes{id,1} = (RT_enc_emo_scenes{id,1} - mean_RT_enc_scenes) / std_RT_enc_scenes;
    Z_RT_enc_emo_objects{id,1} = (RT_enc_emo_objects{id,1} - mean_RT_enc_objects) / std_RT_enc_objects;

end

%% extract info: recognition

% neutral
for id=1:length(ids_neu)

    % scenes
    clear numresponded adjusted_hits adjusted_FA_internal adjusted_FA_external Z_hits Z_FA_internal Z_FA_external

    accuracy_neu_scenes{id,1}          = recognition_neu{id,1}.dat.rcg.results.accuracy;

    numresponded = sum(~isnan(accuracy_neu_scenes{id,1}));
    ind_neu_scenes_correct{id,1}                  = accuracy_neu_scenes{id,1}==1;
    ind_neu_scenes_incorrect_InternalLure{id,1}   = accuracy_neu_scenes{id,1}==-1;
    ind_neu_scenes_incorrect_ExternalLure{id,1}   = accuracy_neu_scenes{id,1}==0;

    hits_neu_scene(id,1)               = nansum(ind_neu_scenes_correct{id,1})/numresponded;
    FA_internal_neu_scenes(id,1)       = nansum(ind_neu_scenes_incorrect_InternalLure{id,1})/numresponded;
    FA_external_neu_scenes(id,1)       = nansum(ind_neu_scenes_incorrect_ExternalLure{id,1})/numresponded;

    adjusted_hits = (hits_neu_scene(id,1) + 0.5) / (numresponded + 1);
    adjusted_FA_internal = (FA_internal_neu_scenes(id,1) + 0.5) / (numresponded + 1);
    adjusted_FA_external = (FA_external_neu_scenes(id,1) + 0.5) / (numresponded + 1);

    Z_hits = norminv(adjusted_hits);
    Z_FA_internal = norminv(adjusted_FA_internal);
    Z_FA_external = norminv(adjusted_FA_external);

    Dprime_neu_scenes_internal(id,1) = Z_hits - Z_FA_internal;
    Dprime_neu_scenes_external(id,1) = Z_hits - Z_FA_external;

    confidence_neu_scenes{id,1}     = recognition_neu{id,1}.dat.rcg.results.confidence;
    ind_neu_scenes_highconf{id,1}   = confidence_neu_scenes{id,1}>=2;
    ind_neu_scenes_lowconf{id,1}    = confidence_neu_scenes{id,1}<=1;

    presentation_rcg_neu_scenes{id,1} = cellfun(@(x) x(25:end),recognition_neu{id,1}.dat.rcg.config.stimlist.all.Picture_Recognition,'UniformOutput',false);

    RT_rcg_neu{id,1}               = recognition_neu{id,1}.dat.rcg.results.RT.RecognitionQ;

    mean_RT_rcg_neu(id,1)          = nanmean(recognition_neu{id,1}.dat.rcg.results.RT.RecognitionQ);

    mean_RT_rcg = nanmean(RT_rcg_neu{id,1});
    std_RT_rcg = nanstd(RT_rcg_neu{id,1});

    Z_RT_rcg_neu{id,1} = (RT_rcg_neu{id,1} - mean_RT_rcg) / std_RT_rcg;


    % objects
    clear numresponded adjusted_hits adjusted_FA_internal adjusted_FA_external Z_hits Z_FA_internal Z_FA_external

    accuracy_neu_objects{id,1}          = recognition_neu{id,1}.dat.rcg.results.accuracy;

    numresponded = sum(~isnan(accuracy_neu_objects{id,1}));
    ind_neu_objects_correct{id,1}                  = accuracy_neu_objects{id,1}==1;
    ind_neu_objects_incorrect_InternalLure{id,1}   = accuracy_neu_objects{id,1}==-1;
    ind_neu_objects_incorrect_ExternalLure{id,1}   = accuracy_neu_objects{id,1}==0;

    hits_neu_scene(id,1)               = nansum(ind_neu_objects_correct{id,1})/numresponded;
    FA_internal_neu_objects(id,1)       = nansum(ind_neu_objects_incorrect_InternalLure{id,1})/numresponded;
    FA_external_neu_objects(id,1)       = nansum(ind_neu_objects_incorrect_ExternalLure{id,1})/numresponded;

    adjusted_hits = (hits_neu_scene(id,1) + 0.5) / (numresponded + 1);
    adjusted_FA_internal = (FA_internal_neu_objects(id,1) + 0.5) / (numresponded + 1);
    adjusted_FA_external = (FA_external_neu_objects(id,1) + 0.5) / (numresponded + 1);

    Z_hits = norminv(adjusted_hits);
    Z_FA_internal = norminv(adjusted_FA_internal);
    Z_FA_external = norminv(adjusted_FA_external);

    Dprime_neu_objects_internal(id,1) = Z_hits - Z_FA_internal;
    Dprime_neu_objects_external(id,1) = Z_hits - Z_FA_external;

    confidence_neu_objects{id,1}     = recognition_neu{id,1}.dat.rcg.results.confidence;
    ind_neu_objects_highconf{id,1}   = confidence_neu_objects{id,1}>=2;
    ind_neu_objects_lowconf{id,1}    = confidence_neu_objects{id,1}<=1;

    presentation_rcg_neu_objects{id,1} = cellfun(@(x) x(26:end),recognition_neu{id,1}.dat.rcg.config.stimlist.all.Picture_Recognition_2,'UniformOutput',false);

end


% emotional
for id=1:length(ids_emo)

    % scenes
    clear numresponded adjusted_hits adjusted_FA_internal adjusted_FA_external Z_hits Z_FA_internal Z_FA_external

    accuracy_emo_scenes{id,1}          = recognition_emo{id,1}.dat.rcg.results.accuracy;

    numresponded = sum(~isnan(accuracy_emo_scenes{id,1}));
    ind_emo_scenes_correct{id,1}                  = accuracy_emo_scenes{id,1}==1;
    ind_emo_scenes_incorrect_InternalLure{id,1}   = accuracy_emo_scenes{id,1}==-1;
    ind_emo_scenes_incorrect_ExternalLure{id,1}   = accuracy_emo_scenes{id,1}==0;

    hits_emo_scene(id,1)               = nansum(ind_emo_scenes_correct{id,1})/numresponded;
    FA_internal_emo_scenes(id,1)       = nansum(ind_emo_scenes_incorrect_InternalLure{id,1})/numresponded;
    FA_external_emo_scenes(id,1)       = nansum(ind_emo_scenes_incorrect_ExternalLure{id,1})/numresponded;

    adjusted_hits = (hits_emo_scene(id,1) + 0.5) / (numresponded + 1);
    adjusted_FA_internal = (FA_internal_emo_scenes(id,1) + 0.5) / (numresponded + 1);
    adjusted_FA_external = (FA_external_emo_scenes(id,1) + 0.5) / (numresponded + 1);

    Z_hits = norminv(adjusted_hits);
    Z_FA_internal = norminv(adjusted_FA_internal);
    Z_FA_external = norminv(adjusted_FA_external);

    Dprime_emo_scenes_internal(id,1) = Z_hits - Z_FA_internal;
    Dprime_emo_scenes_external(id,1) = Z_hits - Z_FA_external;

    confidence_emo_scenes{id,1}     = recognition_emo{id,1}.dat.rcg.results.confidence;
    ind_emo_scenes_highconf{id,1}   = confidence_emo_scenes{id,1}>=2;
    ind_emo_scenes_lowconf{id,1}    = confidence_emo_scenes{id,1}<=1;

    presentation_rcg_emo_scenes{id,1} = cellfun(@(x) x(25:end),recognition_emo{id,1}.dat.rcg.config.stimlist.all.Picture_Recognition,'UniformOutput',false);

    % objects
    clear numresponded adjusted_hits adjusted_FA_internal adjusted_FA_external Z_hits Z_FA_internal Z_FA_external

    accuracy_emo_objects{id,1}          = recognition_emo{id,1}.dat.rcg.results.accuracy;

    numresponded = sum(~isnan(accuracy_emo_objects{id,1}));
    ind_emo_objects_correct{id,1}                  = accuracy_emo_objects{id,1}==1;
    ind_emo_objects_incorrect_InternalLure{id,1}   = accuracy_emo_objects{id,1}==-1;
    ind_emo_objects_incorrect_ExternalLure{id,1}   = accuracy_emo_objects{id,1}==0;

    hits_emo_scene(id,1)               = nansum(ind_emo_objects_correct{id,1})/numresponded;
    FA_internal_emo_objects(id,1)       = nansum(ind_emo_objects_incorrect_InternalLure{id,1})/numresponded;
    FA_external_emo_objects(id,1)       = nansum(ind_emo_objects_incorrect_ExternalLure{id,1})/numresponded;

    adjusted_hits = (hits_emo_scene(id,1) + 0.5) / (numresponded + 1);
    adjusted_FA_internal = (FA_internal_emo_objects(id,1) + 0.5) / (numresponded + 1);
    adjusted_FA_external = (FA_external_emo_objects(id,1) + 0.5) / (numresponded + 1);

    Z_hits = norminv(adjusted_hits);
    Z_FA_internal = norminv(adjusted_FA_internal);
    Z_FA_external = norminv(adjusted_FA_external);

    Dprime_emo_objects_internal(id,1) = Z_hits - Z_FA_internal;
    Dprime_emo_objects_external(id,1) = Z_hits - Z_FA_external;

    confidence_emo_objects{id,1}     = recognition_emo{id,1}.dat.rcg.results.confidence;
    ind_emo_objects_highconf{id,1}   = confidence_emo_objects{id,1}>=2;
    ind_emo_objects_lowconf{id,1}    = confidence_emo_objects{id,1}<=1;

    presentation_rcg_emo_objects{id,1} = cellfun(@(x) x(26:end),recognition_emo{id,1}.dat.rcg.config.stimlist.all.Picture_Recognition_2,'UniformOutput',false);

    RT_rcg_emo{id,1}               = recognition_emo{id,1}.dat.rcg.results.RT.RecognitionQ;

    mean_RT_rcg_emo(id,1)          = nanmean(recognition_emo{id,1}.dat.rcg.results.RT.RecognitionQ);

    mean_RT_rcg = nanmean(RT_rcg_emo{id,1});
    std_RT_rcg = nanstd(RT_rcg_emo{id,1});

    Z_RT_rcg_emo{id,1} = (RT_rcg_emo{id,1} - mean_RT_rcg) / std_RT_rcg;

end

%% valence ratings for each stim

neu_scene_names = {};
neu_scene_ratings = [];
neu_object_names = {};
neu_object_ratings = [];
emo_scene_names = {};
emo_scene_ratings = [];
emo_object_names = {};
emo_object_ratings = [];

for id = 1:length(ids_neu)
    % neutral scenes
    neu_scene_names = [neu_scene_names; presentation_enc_neu_scenes{id,1}];
    neu_scene_ratings = [neu_scene_ratings; valence_neu_scenes{id,1}];
    % neutral objects
    neu_object_names = [neu_object_names; presentation_enc_neu_objects{id,1}];
    neu_object_ratings = [neu_object_ratings; valence_neu_objects{id,1}];
end

for id = 1:length(ids_emo)
    % emotional scenes
    emo_scene_names = [emo_scene_names; presentation_enc_emo_scenes{id,1}];
    emo_scene_ratings = [emo_scene_ratings; valence_emo_scenes{id,1}];
    % emotional objects
    emo_object_names = [emo_object_names; presentation_enc_emo_objects{id,1}];
    emo_object_ratings = [emo_object_ratings; valence_emo_objects{id,1}];
end

% neutral scenes
neu_scene_unique = unique(neu_scene_names);
neu_scene_means = zeros(length(neu_scene_unique), 1);
for i = 1:length(neu_scene_unique)
    indices = strcmp(neu_scene_names, neu_scene_unique{i});
    neu_scene_means(i) = nanmean(neu_scene_ratings(indices));
end

% neutral objects
neu_object_unique = unique(neu_object_names);
neu_object_means = zeros(length(neu_object_unique), 1);
for i = 1:length(neu_object_unique)
    indices = strcmp(neu_object_names, neu_object_unique{i});
    neu_object_means(i) = nanmean(neu_object_ratings(indices));
end

% emotional scenes
emo_scene_unique = unique(emo_scene_names);
emo_scene_means = zeros(length(emo_scene_unique), 1);
for i = 1:length(emo_scene_unique)
    indices = strcmp(emo_scene_names, emo_scene_unique{i});
    emo_scene_means(i) = nanmean(emo_scene_ratings(indices));
end

% emotional objects
emo_object_unique = unique(emo_object_names);
emo_object_means = zeros(length(emo_object_unique), 1);
for i = 1:length(emo_object_unique)
    indices = strcmp(emo_object_names, emo_object_unique{i});
    emo_object_means(i) = nanmean(emo_object_ratings(indices));
end

neu_scenes_table = table(neu_scene_unique, neu_scene_means, 'VariableNames', {'Stimulus', 'MeanValence'});
neu_objects_table = table(neu_object_unique, neu_object_means, 'VariableNames', {'Stimulus', 'MeanValence'});
emo_scenes_table = table(emo_scene_unique, emo_scene_means, 'VariableNames', {'Stimulus', 'MeanValence'});
emo_objects_table = table(emo_object_unique, emo_object_means, 'VariableNames', {'Stimulus', 'MeanValence'});


disp('Neutral scenes');
disp(neu_scenes_table);
disp('Neutral objects');
disp(neu_objects_table);
disp('Emotional scenes');
disp(emo_scenes_table);
disp('Emotional objects');
disp(emo_objects_table);

% plot
figure;
set(gcf, 'Position', [100, 100, 1024, 768]);

subplot(2,2,1); % pos 1 in a 2x2 grid
bar(neu_scene_means, 'FaceColor', [0 0.5 0.5]);
title('Neutral scenes');
set(gca, 'XTickLabel', neu_scene_unique, 'XTick',1:numel(neu_scene_unique), 'XTickLabelRotation', 45);
ylim([0 3]); 
ylabel('Mean Valence Rating'); grid on

subplot(2,2,2); % pos 2 in a 2x2 grid
bar(neu_object_means, 'FaceColor', [0.5 0 0.5]);
title('Neutral objects');
set(gca, 'XTickLabel', neu_object_unique, 'XTick',1:numel(neu_object_unique), 'XTickLabelRotation', 45);
ylim([0 3]); 
ylabel('Mean Valence Rating'); grid on

subplot(2,2,3); % pos 3 in a 2x2 grid
bar(emo_scene_means, 'FaceColor', [0.5 0.5 0]);
title('Emotional scenes');
set(gca, 'XTickLabel', emo_scene_unique, 'XTick',1:numel(emo_scene_unique), 'XTickLabelRotation', 45);
ylim([0 3]); 
ylabel('Mean Valence Rating'); grid on

subplot(2,2,4); % pos 4 in a 2x2 grid
bar(emo_object_means, 'FaceColor', [0 0.5 0]);
title('Emotional objects');
set(gca, 'XTickLabel', emo_object_unique, 'XTick',1:numel(emo_object_unique), 'XTickLabelRotation', 45);
ylim([0 3]); 
ylabel('Mean Valence Rating'); grid on

sgtitle('Mean Valence Ratings by Stimulus Type'); 
xlabel('Stimulus Name');


%% RT (z-scored), encoding

neu_scene_names = {};
neu_scene_ratings = [];
neu_object_names = {};
neu_object_ratings = [];
emo_scene_names = {};
emo_scene_ratings = [];
emo_object_names = {};
emo_object_ratings = [];

for id = 1:length(ids_neu)
    % neutral scenes
    neu_scene_names = [neu_scene_names; presentation_enc_neu_scenes{id,1}];
    neu_scene_ratings = [neu_scene_ratings; Z_RT_enc_neu_scenes{id,1}];
    % neutral objects
    neu_object_names = [neu_object_names; presentation_enc_neu_objects{id,1}];
    neu_object_ratings = [neu_object_ratings; Z_RT_enc_neu_objects{id,1}];
end

for id = 1:length(ids_emo)
    % emotional scenes
    emo_scene_names = [emo_scene_names; presentation_enc_emo_scenes{id,1}];
    emo_scene_ratings = [emo_scene_ratings; Z_RT_enc_emo_scenes{id,1}];
    % emotional objects
    emo_object_names = [emo_object_names; presentation_enc_emo_objects{id,1}];
    emo_object_ratings = [emo_object_ratings; Z_RT_enc_emo_objects{id,1}];
end

% neutral scenes
neu_scene_unique = unique(neu_scene_names);
neu_scene_means = zeros(length(neu_scene_unique), 1);
for i = 1:length(neu_scene_unique)
    indices = strcmp(neu_scene_names, neu_scene_unique{i});
    neu_scene_means(i) = nanmean(neu_scene_ratings(indices));
end

% neutral objects
neu_object_unique = unique(neu_object_names);
neu_object_means = zeros(length(neu_object_unique), 1);
for i = 1:length(neu_object_unique)
    indices = strcmp(neu_object_names, neu_object_unique{i});
    neu_object_means(i) = nanmean(neu_object_ratings(indices));
end

% emotional scenes
emo_scene_unique = unique(emo_scene_names);
emo_scene_means = zeros(length(emo_scene_unique), 1);
for i = 1:length(emo_scene_unique)
    indices = strcmp(emo_scene_names, emo_scene_unique{i});
    emo_scene_means(i) = nanmean(emo_scene_ratings(indices));
end

% emotional objects
emo_object_unique = unique(emo_object_names);
emo_object_means = zeros(length(emo_object_unique), 1);
for i = 1:length(emo_object_unique)
    indices = strcmp(emo_object_names, emo_object_unique{i});
    emo_object_means(i) = nanmean(emo_object_ratings(indices));
end

neu_scenes_table = table(neu_scene_unique, neu_scene_means, 'VariableNames', {'Stimulus', 'MeanValence'});
neu_objects_table = table(neu_object_unique, neu_object_means, 'VariableNames', {'Stimulus', 'MeanValence'});
emo_scenes_table = table(emo_scene_unique, emo_scene_means, 'VariableNames', {'Stimulus', 'MeanValence'});
emo_objects_table = table(emo_object_unique, emo_object_means, 'VariableNames', {'Stimulus', 'MeanValence'});


disp('Neutral scenes');
disp(neu_scenes_table);
disp('Neutral objects');
disp(neu_objects_table);
disp('Emotional scenes');
disp(emo_scenes_table);
disp('Emotional objects');
disp(emo_objects_table);

% plot
figure;
set(gcf, 'Position', [100, 100, 1024, 768]);

subplot(2,2,1); % pos 1 in a 2x2 grid
bar(neu_scene_means, 'FaceColor', [0 0.5 0.5]);
title('Neutral scenes');
set(gca, 'XTickLabel', neu_scene_unique, 'XTick',1:numel(neu_scene_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Z-scored)'); grid on

subplot(2,2,2); % pos 2 in a 2x2 grid
bar(neu_object_means, 'FaceColor', [0.5 0 0.5]);
title('Neutral objects');
set(gca, 'XTickLabel', neu_object_unique, 'XTick',1:numel(neu_object_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Z-scored)'); grid on

subplot(2,2,3); % pos 3 in a 2x2 grid
bar(emo_scene_means, 'FaceColor', [0.5 0.5 0]);
title('Emotional scenes');
set(gca, 'XTickLabel', emo_scene_unique, 'XTick',1:numel(emo_scene_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Z-scored)'); grid on

subplot(2,2,4); % pos 4 in a 2x2 grid
bar(emo_object_means, 'FaceColor', [0 0.5 0]);
title('Emotional objects');
set(gca, 'XTickLabel', emo_object_unique, 'XTick',1:numel(emo_object_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Z-scored)'); grid on

sgtitle('Mean RT (Z-scored) by Stimulus Type'); 
xlabel('Stimulus Name');

%% RT (raw)

neu_scene_names = {};
neu_scene_ratings = [];
neu_object_names = {};
neu_object_ratings = [];
emo_scene_names = {};
emo_scene_ratings = [];
emo_object_names = {};
emo_object_ratings = [];

for id = 1:length(ids_neu)
    % neutral scenes
    neu_scene_names = [neu_scene_names; presentation_enc_neu_scenes{id,1}];
    neu_scene_ratings = [neu_scene_ratings; RT_enc_neu_scenes{id,1}];
    % neutral objects
    neu_object_names = [neu_object_names; presentation_enc_neu_objects{id,1}];
    neu_object_ratings = [neu_object_ratings; RT_enc_neu_objects{id,1}];
end

for id = 1:length(ids_emo)
    % emotional scenes
    emo_scene_names = [emo_scene_names; presentation_enc_emo_scenes{id,1}];
    emo_scene_ratings = [emo_scene_ratings; RT_enc_emo_scenes{id,1}];
    % emotional objects
    emo_object_names = [emo_object_names; presentation_enc_emo_objects{id,1}];
    emo_object_ratings = [emo_object_ratings; RT_enc_emo_objects{id,1}];
end

% neutral scenes
neu_scene_unique = unique(neu_scene_names);
neu_scene_means = zeros(length(neu_scene_unique), 1);
for i = 1:length(neu_scene_unique)
    indices = strcmp(neu_scene_names, neu_scene_unique{i});
    neu_scene_means(i) = nanmean(neu_scene_ratings(indices));
end

% neutral objects
neu_object_unique = unique(neu_object_names);
neu_object_means = zeros(length(neu_object_unique), 1);
for i = 1:length(neu_object_unique)
    indices = strcmp(neu_object_names, neu_object_unique{i});
    neu_object_means(i) = nanmean(neu_object_ratings(indices));
end

% emotional scenes
emo_scene_unique = unique(emo_scene_names);
emo_scene_means = zeros(length(emo_scene_unique), 1);
for i = 1:length(emo_scene_unique)
    indices = strcmp(emo_scene_names, emo_scene_unique{i});
    emo_scene_means(i) = nanmean(emo_scene_ratings(indices));
end

% emotional objects
emo_object_unique = unique(emo_object_names);
emo_object_means = zeros(length(emo_object_unique), 1);
for i = 1:length(emo_object_unique)
    indices = strcmp(emo_object_names, emo_object_unique{i});
    emo_object_means(i) = nanmean(emo_object_ratings(indices));
end

neu_scenes_table = table(neu_scene_unique, neu_scene_means, 'VariableNames', {'Stimulus', 'MeanValence'});
neu_objects_table = table(neu_object_unique, neu_object_means, 'VariableNames', {'Stimulus', 'MeanValence'});
emo_scenes_table = table(emo_scene_unique, emo_scene_means, 'VariableNames', {'Stimulus', 'MeanValence'});
emo_objects_table = table(emo_object_unique, emo_object_means, 'VariableNames', {'Stimulus', 'MeanValence'});


disp('Neutral scenes');
disp(neu_scenes_table);
disp('Neutral objects');
disp(neu_objects_table);
disp('Emotional scenes');
disp(emo_scenes_table);
disp('Emotional objects');
disp(emo_objects_table);

% plot
figure;
set(gcf, 'Position', [100, 100, 1024, 768]);

subplot(2,2,1); % pos 1 in a 2x2 grid
bar(neu_scene_means, 'FaceColor', [0 0.5 0.5]);
title('Neutral scenes');
set(gca, 'XTickLabel', neu_scene_unique, 'XTick',1:numel(neu_scene_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Raw)'); grid on

subplot(2,2,2); % pos 2 in a 2x2 grid
bar(neu_object_means, 'FaceColor', [0.5 0 0.5]);
title('Neutral objects');
set(gca, 'XTickLabel', neu_object_unique, 'XTick',1:numel(neu_object_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Raw)'); grid on

subplot(2,2,3); % pos 3 in a 2x2 grid
bar(emo_scene_means, 'FaceColor', [0.5 0.5 0]);
title('Emotional scenes');
set(gca, 'XTickLabel', emo_scene_unique, 'XTick',1:numel(emo_scene_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Raw)'); grid on

subplot(2,2,4); % pos 4 in a 2x2 grid
bar(emo_object_means, 'FaceColor', [0 0.5 0]);
title('Emotional objects');
set(gca, 'XTickLabel', emo_object_unique, 'XTick',1:numel(emo_object_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Raw)'); grid on

sgtitle('Mean RT (Raw) by Stimulus Type'); 
xlabel('Stimulus Name');

%% prepare to plot accuracy per stimulus

uniqueNeuScenes = {};
uniqueNeuObjects = {};
uniqueEmoScenes = {};
uniqueEmoObjects = {};


accuracyMatrixNeuScenes = [];
accuracyMatrixNeuObjects = [];
accuracyMatrixEmoScenes = [];
accuracyMatrixEmoObjects = [];

for id = 1:length(ids_neu)

    % neutral scenes
    for i = 1:length(presentation_rcg_neu_scenes{id})
        sceneName = presentation_rcg_neu_scenes{id}{i};
        index = find(strcmp(uniqueNeuScenes, sceneName));
        if isempty(index)
            uniqueNeuScenes{end+1} = sceneName;
            index = length(uniqueNeuScenes);
            accuracyMatrixNeuScenes(index, length(ids_neu)) = 0; % Preallocate space
        end
        accuracyMatrixNeuScenes(index, id) = accuracy_neu_scenes{id}(i);
    end

    % neutral objects
    for i = 1:length(presentation_rcg_neu_objects{id})
        objectName = presentation_rcg_neu_objects{id}{i};
        index = find(strcmp(uniqueNeuObjects, objectName));
        if isempty(index)
            uniqueNeuObjects{end+1} = objectName;
            index = length(uniqueNeuObjects);
            accuracyMatrixNeuObjects(index, length(ids_neu)) = 0; % Preallocate space
        end
        accuracyMatrixNeuObjects(index, id) = accuracy_neu_objects{id}(i);
    end


end

for id = 1:length(ids_emo)

    % emotional scenes
    for i = 1:length(presentation_rcg_emo_scenes{id})
        sceneName = presentation_rcg_emo_scenes{id}{i};
        index = find(strcmp(uniqueEmoScenes, sceneName));
        if isempty(index)
            uniqueEmoScenes{end+1} = sceneName;
            index = length(uniqueEmoScenes);
            accuracyMatrixEmoScenes(index, length(ids_emo)) = 0; % Preallocate space
        end
        accuracyMatrixEmoScenes(index, id) = accuracy_emo_scenes{id}(i);
    end

    % emotional objects
    for i = 1:length(presentation_rcg_emo_objects{id})
        objectName = presentation_rcg_emo_objects{id}{i};
        index = find(strcmp(uniqueEmoObjects, objectName));
        if isempty(index)
            uniqueEmoObjects{end+1} = objectName;
            index = length(uniqueEmoObjects);
            accuracyMatrixEmoObjects(index, length(ids_emo)) = 0; % Preallocate space
        end
        accuracyMatrixEmoObjects(index, id) = accuracy_emo_objects{id}(i);
    end
end

accuracyMatrixEmoObjects(find(accuracyMatrixEmoObjects==-1))=0;
accuracyEmoObjects = nanmean(accuracyMatrixEmoObjects,2).*100;

accuracyMatrixEmoScenes(find(accuracyMatrixEmoScenes==-1))=0;
accuracyEmoScenes = nanmean(accuracyMatrixEmoScenes,2).*100;

accuracyMatrixNeuObjects(find(accuracyMatrixNeuObjects==-1))=0;
accuracyNeuObjects = nanmean(accuracyMatrixNeuObjects,2).*100;

accuracyMatrixNeuScenes(find(accuracyMatrixNeuScenes==-1))=0;
accuracyNeuScenes = nanmean(accuracyMatrixNeuScenes,2).*100;


% plot
figure;
set(gcf, 'Position', [100, 100, 1024, 768]);

subplot(2,1,1); % pos 1 in a 2x2 grid
bar(accuracyNeuScenes, 'FaceColor', [0 0.5 0.5]);
title('Neutral Condition');
set(gca, 'XTickLabel', uniqueNeuScenes, 'XTick',1:numel(uniqueNeuScenes), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Recognition Accuracy (%)'); grid on

subplot(2,1,2); % pos 3 in a 2x2 grid
bar(accuracyEmoScenes, 'FaceColor', [0.5 0.5 0]);
title('Emotional Condition');
set(gca, 'XTickLabel', uniqueEmoScenes, 'XTick',1:numel(uniqueEmoScenes), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Recognition Accuracy (%)'); grid on

sgtitle('Mean Recognition Accuracy (%) by Condition'); 
xlabel('Scene Name');

%% RT (z-scored), recognition

neu_scene_names = {};
neu_scene_ratings = [];
emo_scene_names = {};
emo_scene_ratings = [];

for id = 1:length(ids_neu)
    % neutral scenes
    neu_scene_names = [neu_scene_names; presentation_rcg_neu_scenes{id,1}];
    neu_scene_ratings = [neu_scene_ratings; Z_RT_rcg_neu{id,1}];
end

for id = 1:length(ids_emo)
    % emotional scenes
    emo_scene_names = [emo_scene_names; presentation_rcg_emo_scenes{id,1}];
    emo_scene_ratings = [emo_scene_ratings; Z_RT_rcg_emo{id,1}];
end

% neutral scenes
neu_scene_unique = unique(neu_scene_names);
neu_scene_means = zeros(length(neu_scene_unique), 1);
for i = 1:length(neu_scene_unique)
    indices = strcmp(neu_scene_names, neu_scene_unique{i});
    neu_scene_means(i) = nanmean(neu_scene_ratings(indices));
end

% emotional scenes
emo_scene_unique = unique(emo_scene_names);
emo_scene_means = zeros(length(emo_scene_unique), 1);
for i = 1:length(emo_scene_unique)
    indices = strcmp(emo_scene_names, emo_scene_unique{i});
    emo_scene_means(i) = nanmean(emo_scene_ratings(indices));
end

neu_scenes_table = table(neu_scene_unique, neu_scene_means, 'VariableNames', {'Stimulus', 'MeanValence'});
emo_scenes_table = table(emo_scene_unique, emo_scene_means, 'VariableNames', {'Stimulus', 'MeanValence'});


disp('Neutral scenes');
disp(neu_scenes_table);
disp('Emotional scenes');
disp(emo_scenes_table);

% plot
figure;
set(gcf, 'Position', [100, 100, 1024, 768]);

subplot(2,1,1);
bar(neu_scene_means, 'FaceColor', [0 0.5 0.5]);
title('Neutral Condition');
set(gca, 'XTickLabel', neu_scene_unique, 'XTick',1:numel(neu_scene_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Z-scored)'); grid on

subplot(2,1,2); 
bar(emo_scene_means, 'FaceColor', [0.5 0.5 0]);
title('Emotional Condition');
set(gca, 'XTickLabel', emo_scene_unique, 'XTick',1:numel(emo_scene_unique), 'XTickLabelRotation', 45);
% ylim([0 3]); 
ylabel('Mean RT (Z-scored)'); grid on

sgtitle('Mean Recognition RT (Z-scored) by Condition'); 
xlabel('Stimulus Name');


%% plotting type 1

metrics = {'Valence', 'RT', 'DprimeInternal', 'DprimeExternal', 'Confidence'};
types = {'Scenes', 'Objects'};
dataMeans = struct();
dataSE = struct();

dataNeu = struct();
dataEmo = struct();

for id = 1:length(ids_neu)
    dataNeu.Scenes.Valence(id) = nanmean(valence_neu_scenes{id});
    dataNeu.Scenes.RT(id) = nanmean(RT_enc_neu_scenes{id});
    dataNeu.Scenes.DprimeInternal(id) = Dprime_neu_scenes_internal(id);
    dataNeu.Scenes.DprimeExternal(id) = Dprime_neu_scenes_external(id);
    dataNeu.Scenes.Confidence(id) = nanmean(confidence_neu_scenes{id});

    dataNeu.Objects.Valence(id) = nanmean(valence_neu_objects{id});
    dataNeu.Objects.RT(id) = nanmean(RT_enc_neu_objects{id});
    dataNeu.Objects.DprimeInternal(id) = Dprime_neu_objects_internal(id);
    dataNeu.Objects.DprimeExternal(id) = Dprime_neu_objects_external(id);
    dataNeu.Objects.Confidence(id) = nanmean(confidence_neu_objects{id});
end

for id = 1:length(ids_emo)
    dataEmo.Scenes.Valence(id) = nanmean(valence_emo_scenes{id});
    dataEmo.Scenes.RT(id) = nanmean(RT_enc_emo_scenes{id});
    dataEmo.Scenes.DprimeInternal(id) = Dprime_emo_scenes_internal(id);
    dataEmo.Scenes.DprimeExternal(id) = Dprime_emo_scenes_external(id);
    dataEmo.Scenes.Confidence(id) = nanmean(confidence_emo_scenes{id});

    dataEmo.Objects.Valence(id) = nanmean(valence_emo_objects{id});
    dataEmo.Objects.RT(id) = nanmean(RT_enc_emo_objects{id});
    dataEmo.Objects.DprimeInternal(id) = Dprime_emo_objects_internal(id);
    dataEmo.Objects.DprimeExternal(id) = Dprime_emo_objects_external(id);
    dataEmo.Objects.Confidence(id) = nanmean(confidence_emo_objects{id});
end

for type = types
    for metric = metrics
        dataMeans.Neutral.(type{1}).(metric{1}) = nanmean(dataNeu.(type{1}).(metric{1}));
        dataSE.Neutral.(type{1}).(metric{1}) = nanstd(dataNeu.(type{1}).(metric{1})) / sqrt(length(dataNeu.(type{1}).(metric{1})));

        dataMeans.Emotional.(type{1}).(metric{1}) = nanmean(dataEmo.(type{1}).(metric{1}));
        dataSE.Emotional.(type{1}).(metric{1}) = nanstd(dataEmo.(type{1}).(metric{1})) / sqrt(length(dataEmo.(type{1}).(metric{1})));
    end
end

% plot
figure;
for t = 1:length(types)
    for m = 1:length(metrics)
        subplot(length(types), length(metrics), (t-1)*length(metrics) + m);
        bar([1, 2], [dataMeans.Neutral.(types{t}).(metrics{m}), dataMeans.Emotional.(types{t}).(metrics{m})]);
        hold on;
        errorbar([1, 2], [dataMeans.Neutral.(types{t}).(metrics{m}), dataMeans.Emotional.(types{t}).(metrics{m})], ...
            [dataSE.Neutral.(types{t}).(metrics{m}), dataSE.Emotional.(types{t}).(metrics{m})], 'k', 'linestyle', 'none');
        title(sprintf('%s - %s', metrics{m}, types{t}));
        set(gca, 'XTickLabel', {'Neutral', 'Emotional'}, 'XTick', 1:2);
        ylabel(metrics{m}); grid on
    end
end
sgtitle('Comparison of Neutral vs Emotional Conditions');



%% plotting type 2

metrics = {'Valence', 'RT', 'DprimeInternal', 'DprimeExternal', 'Confidence', 'HitRate', 'FAInternal', 'FAExternal'};
types = {'Scenes', 'Objects'};
dataMeans = struct();
dataSE = struct();

dataNeu = struct();
dataEmo = struct();

for id = 1:length(ids_neu)
    dataNeu.Scenes.Valence(id) = nanmean(valence_neu_scenes{id});
    dataNeu.Scenes.RT(id) = nanmean(Z_RT_rcg_neu{id}); disp([ids_neu{id} ': ' num2str(nanmean(Z_RT_rcg_neu{id})) ])
    dataNeu.Scenes.DprimeInternal(id) = Dprime_neu_scenes_internal(id);
    dataNeu.Scenes.DprimeExternal(id) = Dprime_neu_scenes_external(id);
    dataNeu.Scenes.Confidence(id) = nanmean(confidence_neu_scenes{id});
    dataNeu.Scenes.HitRate(id) = hits_neu_scene(id);
    dataNeu.Scenes.FAInternal(id) = FA_internal_neu_scenes(id);
    dataNeu.Scenes.FAExternal(id) = FA_external_neu_scenes(id);

    dataNeu.Objects.Valence(id) = nanmean(valence_neu_objects{id});
    dataNeu.Objects.RT(id) = nanmean(RT_enc_neu_objects{id});
    dataNeu.Objects.DprimeInternal(id) = Dprime_neu_objects_internal(id);
    dataNeu.Objects.DprimeExternal(id) = Dprime_neu_objects_external(id);
    dataNeu.Objects.Confidence(id) = nanmean(confidence_neu_objects{id});
    dataNeu.Objects.HitRate(id) = hits_neu_scene(id) / numresponded;  % Assuming same hits and numresponded logic for objects
    dataNeu.Objects.FAInternal(id) = FA_internal_neu_objects(id);
    dataNeu.Objects.FAExternal(id) = FA_external_neu_objects(id);
end

for id = 1:length(ids_emo)
    dataEmo.Scenes.Valence(id) = nanmean(valence_emo_scenes{id});
    dataEmo.Scenes.RT(id) = nanmean(Z_RT_rcg_emo{id}); disp([ids_emo{id} ': ' num2str(nanmean(Z_RT_rcg_neu{id}))])
    dataEmo.Scenes.DprimeInternal(id) = Dprime_emo_scenes_internal(id);
    dataEmo.Scenes.DprimeExternal(id) = Dprime_emo_scenes_external(id);
    dataEmo.Scenes.Confidence(id) = nanmean(confidence_emo_scenes{id});
    dataEmo.Scenes.HitRate(id) = hits_emo_scene(id);
    dataEmo.Scenes.FAInternal(id) = FA_internal_emo_scenes(id);
    dataEmo.Scenes.FAExternal(id) = FA_external_emo_scenes(id);

    dataEmo.Objects.Valence(id) = nanmean(valence_emo_objects{id});
    dataEmo.Objects.RT(id) = nanmean(RT_enc_emo_objects{id});
    dataEmo.Objects.DprimeInternal(id) = Dprime_emo_objects_internal(id);
    dataEmo.Objects.DprimeExternal(id) = Dprime_emo_objects_external(id);
    dataEmo.Objects.Confidence(id) = nanmean(confidence_emo_objects{id});
    dataEmo.Objects.HitRate(id) = hits_emo_scene(id);  % Assuming same hits and numresponded logic for objects
    dataEmo.Objects.FAInternal(id) = FA_internal_emo_objects(id);
    dataEmo.Objects.FAExternal(id) = FA_external_emo_objects(id);
end

for type = types
    for metric = metrics
        dataMeans.Neutral.(type{1}).(metric{1}) = nanmean(dataNeu.(type{1}).(metric{1}));
        dataSE.Neutral.(type{1}).(metric{1}) = nanstd(dataNeu.(type{1}).(metric{1})) / sqrt(length(dataNeu.(type{1}).(metric{1})));

        dataMeans.Emotional.(type{1}).(metric{1}) = nanmean(dataEmo.(type{1}).(metric{1}));
        dataSE.Emotional.(type{1}).(metric{1}) = nanstd(dataEmo.(type{1}).(metric{1})) / sqrt(length(dataEmo.(type{1}).(metric{1})));
    end
end

% % plotting
% figure;
% for t = 1:length(types)
%     for m = 1:length(metrics)
%         subplot(length(types), length(metrics), (t-1)*length(metrics) + m);
%         b = bar([1, 2], [dataMeans.Neutral.(types{t}).(metrics{m}), dataMeans.Emotional.(types{t}).(metrics{m})], 'FaceColor', 'flat');
%         b.CData(1,:) = [0.8 0.8 0.8];  % Grey for Neutral
%         b.CData(2,:) = [1 0 0];  % Red for Emotional
%         hold on;
%         errorbar([1, 2], [dataMeans.Neutral.(types{t}).(metrics{m}), dataMeans.Emotional.(types{t}).(metrics{m})], ...
%             [dataSE.Neutral.(types{t}).(metrics{m}), dataSE.Emotional.(types{t}).(metrics{m})], 'k', 'linestyle', 'none');
%         title(sprintf('%s - %s', metrics{m}, types{t}));
%         set(gca, 'XTickLabel', {'Neutral', 'Emotional'}, 'XTick', 1:2);
%         ylabel(metrics{m}); grid on
%     end
% end
% sgtitle('Comparison of Neutral vs Emotional Conditions');


%%
% % only plot metrics that exist for each type
metrics_scenes = {'Valence', 'RT', 'DprimeInternal', 'DprimeExternal', 'Confidence', 'HitRate', 'FAInternal', 'FAExternal'};
metrics_objects = {'Valence'};

% % plotting
% figure;
% totalPlots = max(length(metrics_scenes), length(metrics_objects));
% 
% for m = 1:totalPlots
%     if m <= length(metrics_scenes)
%         subplot(2, totalPlots, m);
%         b = bar([1, 2], [dataMeans.Neutral.Scenes.(metrics_scenes{m}), dataMeans.Emotional.Scenes.(metrics_scenes{m})], 'FaceColor', 'flat');
%         b.CData(1,:) = [0.8 0.8 0.8];  % Grey
%         b.CData(2,:) = [1 0 0];        % Red
%         hold on;
%         errorbar([1, 2], [dataMeans.Neutral.Scenes.(metrics_scenes{m}), dataMeans.Emotional.Scenes.(metrics_scenes{m})], ...
%             [dataSE.Neutral.Scenes.(metrics_scenes{m}), dataSE.Emotional.Scenes.(metrics_scenes{m})], 'k', 'linestyle', 'none');
%         title(sprintf('Scenes - %s', metrics_scenes{m}));
%         set(gca, 'XTickLabel', {'Neutral', 'Emotional'}, 'XTick', 1:2);
% % ax = gca;
% % ax.YAxis.Exponent = 0;
%         ylabel(metrics_scenes{m}); grid on
%     end
% 
%     if m <= length(metrics_objects)
%         subplot(2, totalPlots, totalPlots + m);
%         b = bar([1, 2], [dataMeans.Neutral.Objects.(metrics_objects{m}), dataMeans.Emotional.Objects.(metrics_objects{m})], 'FaceColor', 'flat');
%         b.CData(1,:) = [0.8 0.8 0.8];  % Grey
%         b.CData(2,:) = [1 0 0];        % Red
%         hold on;
%         errorbar([1, 2], [dataMeans.Neutral.Objects.(metrics_objects{m}), dataMeans.Emotional.Objects.(metrics_objects{m})], ...
%             [dataSE.Neutral.Objects.(metrics_objects{m}), dataSE.Emotional.Objects.(metrics_objects{m})], 'k', 'linestyle', 'none');
%         title(sprintf('Objects - %s', metrics_objects{m}));
%         set(gca, 'XTickLabel', {'Neutral', 'Emotional'}, 'XTick', 1:2);
% % ax = gca;
% % ax.YAxis.Exponent = 0;
%         ylabel(metrics_objects{m}); grid on
%     end
% end
% 
% sgtitle(' Neutral vs Emotional');

%%

% combine metrics
metrics_all = [metrics_scenes, metrics_objects];
labels_all = [strcat(repmat({'Scenes - '}, 1, length(metrics_scenes)), metrics_scenes), ...
              strcat(repmat({'Objects - '}, 1, length(metrics_objects)), metrics_objects)];

% total number of metrics
nMetrics = length(metrics_all);

% plot
figure;
cols = ceil(nMetrics / 2);
rows = 2;

for m = 1:nMetrics
    subplot(rows, cols, m);
    if m <= length(metrics_scenes)
        dNeutral = dataMeans.Neutral.Scenes.(metrics_scenes{m});
        dEmo = dataMeans.Emotional.Scenes.(metrics_scenes{m});
        errNeutral = dataSE.Neutral.Scenes.(metrics_scenes{m}); 
        errEmo = dataSE.Emotional.Scenes.(metrics_scenes{m});
    else
        idx = m - length(metrics_scenes);
        dNeutral = dataMeans.Neutral.Objects.(metrics_objects{idx});
        dEmo = dataMeans.Emotional.Objects.(metrics_objects{idx});
        errNeutral = dataSE.Neutral.Objects.(metrics_objects{idx});
        errEmo = dataSE.Emotional.Objects.(metrics_objects{idx});
    end

    b = bar([1, 2], [dNeutral, dEmo], 'FaceColor', 'flat');
    b.CData(1,:) = [0.8 0.8 0.8];  % Grey
    b.CData(2,:) = [1 0 0];        % Red
    hold on;
    errorbar([1, 2], [dNeutral, dEmo], [errNeutral, errEmo], 'k', 'linestyle', 'none');
    title(labels_all{m});
    set(gca, 'XTickLabel', {'Neutral', 'Emotional'}, 'XTick', 1:2);
    % ax = gca; ax.YAxis.Exponent = 0;
    ylabel(metrics_all{m}); grid on
end

sgtitle('Neutral vs Emotional');


