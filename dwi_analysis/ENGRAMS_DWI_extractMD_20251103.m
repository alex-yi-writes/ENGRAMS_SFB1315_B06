%% prep

clc;clear
ids = {'sub-108','sub-109','sub-110','sub-207','sub-302','sub-303','sub-304'};
phases = {'bsl','origE','origL','recombi'};
phasesLab = {'BSL','Early RCG','Late RCG','Recombi RCG'};
path_par= '/Volumes/korokdorf/ENGRAMS/analyses/';


% colourmaps
subject_colours = [];
for s = 1:length(ids)
    subject_colours = [subject_colours; getSubjectColour(ids{s})];
end

%% define rois

rois = {
    % memory consolidation network
    'mPFC', [1014,1026,2014,2026];
    'RSC', [1010,2010];
    'Hippocampus', [17,53];
    'Entorhinal', [1006,2006];
    
    % % thalamic relay
    % 'Thalamus', [10,49];

    % % default mode network components
    % 'PCC', [1023,2023];
    'Precuneus', [1025,2025];

    % visual/object recognition
    % 'Fusiform', [1007,2007];
    'Parahippocampal', [1016,2016];
    'InferiorTemporal', [1009,2009];
    'LateralOccipital', [1011,2011];
};

%% preassign storage matrices

% store MD values: subjects * phases * ROIs
md_values = NaN(length(ids), length(phases), size(rois, 1));
md_changes = NaN(length(ids), length(phases)-1, size(rois, 1)); % phase-to-phase changes

%% extract MD values for each subject, phase, and ROI

for s = 1:length(ids)

    subj = ids{s};
    fprintf('Processing %s\n', subj);
    
    for p = 1:length(phases)
        phase = phases{p};
        
        % dtifit results (temp)
        if strcmp('bsl',phase)
            md_file = [path_par subj 'v1s1/dwi/' subj 'v1s1_dti_MD.nii.gz'];
            clear tmp; tmp=dir(md_file); if isempty(tmp), md_file = [path_par subj 'v1s1/dwi/' subj 'v1s1_dti_MD.nii.gz'];end
        elseif strcmp('origE',phase)
            md_file = [path_par subj 'v1s2/dwi/' subj 'v1s2_dti_MD.nii.gz'];
            clear tmp; tmp=dir(md_file); if isempty(tmp), md_file = [path_par subj 'v1s2/dwi/' subj 'v1s2_dti_MD.nii.gz'];end
        elseif strcmp('origL',phase)
            md_file = [path_par subj 'v2s1/dwi/' subj 'v2s1_dti_MD.nii.gz'];
            clear tmp; tmp=dir(md_file); if isempty(tmp), md_file = [path_par subj 'v2s1/dwi/' subj 'v2s1_dti_MD.nii.gz'];end
        elseif strcmp('recombi',phase)
            md_file = [path_par subj 'v2s2/dwi/' subj 'v2s2_dti_MD.nii.gz'];
            clear tmp; tmp=dir(md_file); if isempty(tmp), md_file = [path_par subj 'v2s2/dwi/' subj 'v2s2_dti_MD.nii.gz'];end
        end
        aparc_file = [path_par subj 'v1s1/anat/roi_dwi/aparc_on_' phase '.nii.gz'];
        
        if ~exist(md_file, 'file') || ~exist(aparc_file, 'file')
            warning('  warning: missing files for %s %s\n', subj, phase);
            continue;
        end
        
        % read in MD map and parcellation
        md_map = niftiread(md_file);
        aparc = niftiread(aparc_file);
        
        % extract MD for each roi
        for r = 1:size(rois, 1)
            roi_name = rois{r,1};
            roi_labels = rois{r,2};
            
            % create ROI mask
            roi_mask = ismember(aparc, roi_labels);
            
            if sum(roi_mask(:)) > 0
                % extract MD values within ROI
                md_roi = md_map(roi_mask);
                
                % remove outliers and calculate robust mean
                % md_roi_clean = md_roi(md_roi > 0 & md_roi < 0.003);
                md_roi_clean = md_roi(md_roi > -10 & md_roi < 10);
                if ~isempty(md_roi_clean)
                    md_values(s, p, r) = median(md_roi_clean);
                end
            end
        end
    end
    
    % calc within-subject changes
    for p = 1:(length(phases)-1)
        md_changes(s, p, :) = md_values(s, p+1, :) - md_values(s, p, :);
    end
end

disp('done')

%% stat analysis and plotting
fprintf('\n***** MD Changes Analysis *****\n');

% def phase comparisons
phase_comparisons = {
    'bsl -> origE', 1;
    'origE -> origL', 2;
    'origL -> recombi', 3;
};

%% plot
for FoldCode=1
close all

figure('Position', [100, 100, 1400, 900]);

% plot 1: mean MD values across phases for each ROI
subplot(2,3,[1,2]);
roi_names = rois(:,1);
phase_means = squeeze(nanmean(md_values, 1))'; % ROIs x Phases

imagesc(phase_means);
colorbar;
xlabel('Phase');
ylabel('ROI');
title('Mean MD across consolidation phases');
set(gca, 'XTick', 1:length(phases), 'XTickLabel', phases);
set(gca, 'YTick', 1:size(rois, 1), 'YTickLabel', roi_names);
colormap('parula');

% plot 2: MD changes for key memory regions
subplot(2,3,3);
key_rois = [1:size(rois, 1)];
key_changes = squeeze(nanmean(md_changes(:,1,:), 1)); % bsl -> enc

bar(key_changes(key_rois));
xlabel('ROI');
ylabel('ΔMD (×10^{-3} mm²/s)');
title('MD change: Baseline → Encoding');
set(gca, 'XTickLabel', roi_names(key_rois));
xtickangle(45);

% plot 3: indiv subject trajectories for hippocampus
subplot(2,3,4);
hippo_idx = 3;
hippo_data = squeeze(md_values(:, :, hippo_idx))';

hold on;
for s = 1:length(ids)
    plot(1:length(phases), hippo_data(:, s), 'o-', 'LineWidth', 1.5, ...
         'Color', subject_colours(s, :), 'MarkerSize', 6);
end
xlabel('Phase');
ylabel('MD (×10^{-3} mm²/s)');
title('Hippocampus MD trajectories');
set(gca, 'XTick', 1:length(phases), 'XTickLabel', phases);
grid on;
hold off;

% plot 4: corr matrix between ROI changes
subplot(2,3,5);
changes_matrix = reshape(md_changes(:,1,:), length(ids), size(rois, 1));
corr_matrix = corrcoef(changes_matrix, 'Rows', 'complete');

imagesc(corr_matrix);
colorbar;
caxis([-1, 1]);
title('ROI change correlations');
xlabel('ROI');
ylabel('ROI');
set(gca, 'XTick', 1:size(rois, 1), 'XTickLabel', roi_names);
set(gca, 'YTick', 1:size(rois, 1), 'YTickLabel', roi_names);
xtickangle(45);
colormap('jet');

% plot 5: stat sig of changes
subplot(2,3,6);
p_values = zeros(size(rois, 1), length(phases)-1);
t_stats = zeros(size(rois, 1), length(phases)-1);

for r = 1:size(rois, 1)
    for p = 1:(length(phases)-1)
        changes = md_changes(:, p, r);
        changes_clean = changes(~isnan(changes));
        
        if length(changes_clean) > 2
            [~, p_val, ~, stats] = ttest(changes_clean);
            p_values(r, p) = p_val;
            t_stats(r, p) = stats.tstat;
        end
    end
end

% plot sig
sig_map = -log10(p_values);
imagesc(sig_map);
colorbar;
xlabel('Phase transition');
ylabel('ROI');
title('-log10(p-value) for MD changes');
set(gca, 'XTick', 1:(length(phases)-1), 'XTickLabel', {'bsl→E', 'E→L', 'L→R'});
set(gca, 'YTick', 1:size(rois, 1), 'YTickLabel', roi_names);
hold on;
% annotate significant changes (p<0.05)
[sig_r, sig_c] = find(p_values < 0.05);
plot(sig_c, sig_r, 'w*', 'MarkerSize', 8);

%% export results
results_table = table();
for r = 1:size(rois, 1)
    for p = 1:(length(phases)-1)
        row_data = struct();
        row_data.ROI = roi_names{r};
        row_data.Phase_Transition = phase_comparisons{p,1};
        row_data.Mean_Change = nanmean(md_changes(:, p, r));
        row_data.SEM = nanstd(md_changes(:, p, r)) / sqrt(sum(~isnan(md_changes(:, p, r))));
        row_data.t_statistic = t_stats(r, p);
        row_data.p_value = p_values(r, p);
        
        results_table = [results_table; struct2table(row_data)];
    end
end

% save
writetable(results_table, [path_par 'MD_changes_statistics.csv']);

%% more analysis: focus on memory consolidation network
fprintf('\n***** Memory Consolidation Network Analysis *****\n');

% select core memory network rois
memory_network_indices = [1:size(rois,1)];

figure('Position', [100, 100, 800, 600]);

% create network-wide average
network_md = nanmean(md_values(:, :, memory_network_indices), 3);
network_change = nanmean(md_changes(:, :, memory_network_indices), 3);

subplot(2,1,1);
errorbar(1:length(phases), nanmean(network_md), nanstd(network_md)/sqrt(length(ids)), ...
    'o-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Phase');
ylabel('Network-averaged MD');
title('Memory network microstructural changes');
set(gca, 'XTick', 1:length(phases), 'XTickLabel', phases);
grid on;

subplot(2,1,2);
boxplot(network_change, 'Labels', phase_comparisons(1:3,1));
ylabel('ΔMD (×10^{-3} mm²/s)');
title('Distribution of network-wide MD changes');
yline(0, '--', 'Color', 'r', 'LineWidth', 1);

fprintf('\nAnalysis complete!\n');
end

%% plot MD for each roi separately with bsl normalisation

close all

% c normalized MD values (each phase divided by bsl)
md_normalized = NaN(size(md_values));
for s = 1:length(ids)
    for r = 1:size(rois, 1)
        baseline_md = md_values(s, 1, r); % bsl phase
        if ~isnan(baseline_md)
            for p = 1:length(phases)
                if ~isnan(md_values(s, p, r))
                    md_normalized(s, p, r) = md_values(s, p, r) / baseline_md;
                end
            end
        end
    end
end

% figure for normalized MD plots
figure('Position', [100, 100, 1600, 1200]);
num_rois = size(rois, 1);
rows = ceil(sqrt(num_rois));
cols = ceil(num_rois / rows);

for r = 1:num_rois
    subplot(rows, cols, r);
    
    % data for this ROI
    roi_data = squeeze(md_normalized(:, :, r));
    
    % plot each subject as separate line
    hold on;
    for s = 1:length(ids)
        plot(1:length(phases), roi_data(s, :), 'o-', 'LineWidth', 2, ...
             'MarkerSize', 6, 'DisplayName', ids{s}, 'Color', subject_colours(s, :));
    end
    
    xlabel('Phase');
    ylabel('MD (Normalised to Baseline)');
    title([rois{r,1}]);
    set(gca, 'XTick', 1:length(phases), 'XTickLabel', phasesLab);
    grid on;
    
    % horz line at 1 (bsl)
    yline(1, '--', 'Baseline', 'Color', 'k', 'LineWidth', 1, ...
          'LabelHorizontalAlignment', 'left');
    box on
    xlim([0.5 4.5])
    
    % legend only on the last subplot
    if r==num_rois
        legend('Location', 'eastoutside', 'NumColumns', 2);
    else
        legend off;
    end
end

sgtitle('MD Values Normalised to Baseline (Phase 1) for Each ROI');

%% plot MD for each roi separately with bsl normalisation (second attempt)
close all

md_normalized = NaN(size(md_values));
for s = 1:length(ids)
    for r = 1:size(rois, 1)
        baseline_md = md_values(s, 1, r); % bsl phase
        if ~isnan(baseline_md)
            for p = 1:length(phases)
                if ~isnan(md_values(s, p, r))
                    md_normalized(s, p, r) = md_values(s, p, r) / baseline_md;
                end
            end
        end
    end
end

figure('Position', [100, 100, 1600, 1200]);
num_rois = size(rois, 1);
rows = 4;
cols = 2;

for r = 1:num_rois
    subplot(rows, cols, r);
    
    roi_data = squeeze(md_normalized(:, :, r));
    
    hold on;
    for s = 1:length(ids)
        plot(1:length(phases), roi_data(s, :), '-', 'LineWidth', 0.5, ...
            'MarkerSize', 4, 'DisplayName', ids{s}, 'Color', subject_colours(s, :));
    end
    
    mean_data = nanmean(roi_data, 1);
    se_data = nanstd(roi_data, 1) / sqrt(sum(~isnan(roi_data), 1));
    
    plot(1:length(phases), mean_data, '-', 'LineWidth', 3, 'Color', 'k');
    
    errorbar(1:length(phases), mean_data, se_data, 'LineStyle', 'none', ...
        'Color', 'k', 'MarkerSize', 6, 'Marker', 'o', 'MarkerFaceColor', 'k', ...
        'DisplayName', 'Mean', 'CapSize', 4, 'LineWidth', 1.5);
    
    title([rois{r,1}],'FontSize',14,'FontWeight','bold');
    set(gca, 'XTick', 1:length(phases), 'XTickLabel', phasesLab);
    grid on;
    
    yline(1, '--','Color', 'k', 'LineWidth', 1, ...
        'LabelHorizontalAlignment', 'left');
    box on
    xlim([0.5 4.5])
    
    if r==num_rois
        legend('Location', 'best', 'NumColumns', 2);
    else
        legend off;
    end
end

sgtitle('MD Values Normalised to Baseline for Each ROI');

%% ver3

close all

md_normalized = NaN(size(md_values));
for s = 1:length(ids)
    for r = 1:size(rois, 1)
        baseline_md = md_values(s, 1, r); % bsl phase
        if ~isnan(baseline_md)
            for p = 1:length(phases)
                if ~isnan(md_values(s, p, r))
                    md_normalized(s, p, r) = md_values(s, p, r) / baseline_md;
                end
            end
        end
    end
end

figure('Position', [100, 100, 1600, 1200]);
num_rois = size(rois, 1);
rows = 4;
cols = 2;

for r = 1:num_rois
    subplot(rows, cols, r);
    
    roi_data = squeeze(md_normalized(:, :, r));
    
    hold on;
    for s = 1:length(ids)
        plot(1:length(phases), roi_data(s, :), '-', 'LineWidth', 0.5, ...
            'MarkerSize', 4, 'DisplayName', ids{s}, 'Color', subject_colours(s, :));
    end
    
    % id control vs experimental subjects
    control_idx = [];
    experimental_idx = [];
    for s = 1:length(ids)
        num_str = strrep(ids{s}, 'sub-', '');
        num = str2double(num_str);
        first_digit = floor(num / 100);
        
        if first_digit == 1
            control_idx = [control_idx, s];
        else
            experimental_idx = [experimental_idx, s];
        end
    end
    
    % calc means and SE for each group
    control_data = roi_data(control_idx, :);
    experimental_data = roi_data(experimental_idx, :);
    
    control_mean = nanmean(control_data, 1);
    control_se = nanstd(control_data, 1) / sqrt(sum(~isnan(control_data), 1));
    
    experimental_mean = nanmean(experimental_data, 1);
    experimental_se = nanstd(experimental_data, 1) / sqrt(sum(~isnan(experimental_data), 1));
    
    % control mean line (dashed)
    plot(1:length(phases), control_mean, '--', 'LineWidth', 3, 'Color', [0.4, 0.4, 0.4]);
    errorbar(1:length(phases), control_mean, control_se, 'LineStyle', 'none', ...
        'Color', [0.4, 0.4, 0.4], 'MarkerSize', 6, 'Marker', 's', 'MarkerFaceColor', [0.4, 0.4, 0.4], ...
        'DisplayName', 'Control', 'CapSize', 4, 'LineWidth', 1.5);
    
    % experimental mean line (solid)
    plot(1:length(phases), experimental_mean, '-', 'LineWidth', 3, 'Color', [0.2, 0.2, 0.2]);
    errorbar(1:length(phases), experimental_mean, experimental_se, 'LineStyle', 'none', ...
        'Color', [0.2, 0.2, 0.2], 'MarkerSize', 6, 'Marker', 'o', 'MarkerFaceColor', [0.2, 0.2, 0.2], ...
        'DisplayName', 'Experimental', 'CapSize', 4, 'LineWidth', 1.5);
    
    title([rois{r,1}],'FontSize',14,'FontWeight','bold');
    set(gca, 'XTick', 1:length(phases), 'XTickLabel', phasesLab);
    grid on;
    
    yline(1, '--','Color', 'k', 'LineWidth', 1, ...
        'LabelHorizontalAlignment', 'left');
    box on
    xlim([0.5 4.5])
    
    if r==num_rois
        legend('Location', 'southoutside', 'NumColumns', 2);
    else
        legend off;
    end
end

sgtitle('MD Values Normalised to Baseline for Each ROI');

%% export normalised MD data to CSV for R

export_data = table();

for s = 1:length(ids)
    for p = 1:length(phases)
        for r = 1:size(rois, 1)
            if ~isnan(md_normalized(s, p, r))
                num_str = strrep(ids{s}, 'sub-', '');
                num = str2double(num_str);
                first_digit = floor(num / 100);
                
                if first_digit == 1
                    condition = 'Control';
                else
                    condition = 'Experimental';
                end
                
                % Create row with proper string/cell formatting
                row = table({ids{s}}, {rois{r,1}}, {phases{p}}, {phasesLab{p}}, ...
                           md_normalized(s, p, r), {condition}, ...
                           'VariableNames', {'Subject', 'ROI', 'Phase', 'Phase_Label', ...
                                             'MD_Normalised', 'Condition'});
                export_data = [export_data; row];
            end
        end
    end
end
writetable(export_data,'/Users/alex/Dropbox/paperwriting/1315/data/MD_normalised_for_plotting.csv');

%% helpers

function colour = getSubjectColour(subj_id)
    num_str = strrep(subj_id, 'sub-', '');
    num = str2double(num_str);
    
    first_digit = floor(num / 100);
    last_digit = mod(num, 2);
    
    if first_digit == 1
        grey_levels = [0.3, 0.5, 0.7];
        idx = mod(num, 3) + 1;
        colour = [grey_levels(idx), grey_levels(idx), grey_levels(idx)];
    elseif first_digit == 2 || first_digit == 3
        if last_digit == 1
            warm_colours = [1.0, 0.4, 0.2;   % orange-red
                           1.0, 0.6, 0.0;   % orange
                           1.0, 0.8, 0.0];  % yellow-orange
            idx = mod(num, 3) + 1;
            colour = warm_colours(idx, :);
        else
            cold_colours = [0.0, 0.4, 1.0;   % bright blue
                           0.0, 0.7, 1.0;   % light blue
                           0.0, 1.0, 1.0];  % cyan
            idx = mod(num, 3) + 1;
            colour = cold_colours(idx, :);
        end
    else
        colour = [0.5, 0.5, 0.5]; % default grey
    end
end

