%% prep

clc;clear
tasks   = {'rest','origenc','origrec1','origrec2','recombienc','recombirec1'};
ids     = {'sub-101','sub-104','sub-106','sub-107','sub-108','sub-109','sub-110','sub-111','sub-205',...
    'sub-202','sub-207','sub-302','sub-303','sub-304'};

% Define subjects with limited phases
limited_ids = {'sub-101','sub-104','sub-106','sub-107','sub-108','sub-109','sub-110','sub-111','sub-205'};
limited_tasks = {'rest','origenc','origrec1'};

phaseticks   = {'Rest','ENC(Orig)','RCG(O-Early)','RCG(O-Late)','ENC(Recombi)','RCG(Recombi)'};

path_par= '/Volumes/korokdorf/ENGRAMS/analyses/';

%% ========== OUTLIER DETECTION SETTINGS ========== %
% Set these parameters to control outlier detection

REMOVE_OUTLIERS = true;  % Set to false to disable outlier removal

% Choose outlier detection method:
% 'mad'     - Median Absolute Deviation (recommended, robust to outliers)
% 'zscore'  - Z-score based (classic method)
% 'iqr'     - Interquartile Range (removes extreme tails)
OUTLIER_METHOD = 'mad';

% Set threshold for outlier detection
% For 'mad':    3.0 = moderate (recommended), 2.5 = stricter, 3.5 = lenient
% For 'zscore': 3.0 = moderate (recommended), 2.5 = stricter, 3.5 = lenient
% For 'iqr':    1.5 = moderate (recommended), 1.0 = stricter, 2.0 = lenient
OUTLIER_THRESHOLD = 3;

% Apply outlier detection per phase or across all phases?
% 'per_phase'  - Detect outliers within each phase separately (recommended)
% 'all_phases' - Detect outliers across all phases for each connection
OUTLIER_SCOPE = 'all_phases';

% Display outlier report?
SHOW_OUTLIER_REPORT = true;

%% with significance bar

for a1 = 5%1:5
    close all

    if a1 == 1
        % ========== mPFC ========== %
        rois        = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup'};
        layerFlag   = 1;
        folderlabel = 'mPFC';
    elseif a1 == 2
        % =========== RSC ========== %
        rois        = {'RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        layerFlag   = 1;
        folderlabel = 'RSC';
    elseif a1 == 3
        % ====== all cortices ====== %
        rois        = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        layerFlag   = 1;
        folderlabel = 'all';
    elseif a1 == 4
        % =========== HPC ========== %
        rois        = {'CA1','CA3','DG','Sub'};
        layerFlag   = 0;
        folderlabel = 'HPC';
    elseif a1 == 5
        % ====== all cortices ====== %
        rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup','EC_layer_deep','EC_layer_mid','EC_layer_sup','CA1','CA3','DG','Sub',...
            'ErC','SN','LC','VTA'};
        layerFlag=1;
        folderlabel = 'all_bs';
    end

    % preallocate
    Z_all = nan(numel(ids), numel(tasks), numel(rois), numel(rois));

    % load all Zs into a 4D array - with file existence checking
    for id = 1:numel(ids)
        subj = ids{id};
        % Determine which tasks are available for this subject
        if ismember(subj, limited_ids)
            available_tasks = limited_tasks;
        else
            available_tasks = tasks;
        end

        for t1 = 1:numel(tasks)
            % Check if this task is available for this subject
            if ismember(tasks{t1}, available_tasks)
                fn  = fullfile(path_par, [subj 'v1s1'], 'func' ,'laminar', folderlabel, ...
                    sprintf('Z_%s_%s.mat', subj, tasks{t1}));
                if exist(fn, 'file')
                    try
                        tmp = load(fn, 'Z');
                        % Handle size mismatch - pad smaller matrices
                        loaded_size = size(tmp.Z, 1);
                        expected_size = numel(rois);
                        
                        if loaded_size < expected_size
                            % Pad with NaN to match expected size
                            Z_temp = nan(expected_size, expected_size);
                            Z_temp(1:loaded_size, 1:loaded_size) = tmp.Z;
                            Z_all(id, t1, :, :) = Z_temp;
                        else
                            Z_all(id, t1, :, :) = tmp.Z;
                        end
                    catch ME
                        warning('Failed to load %s: %s', fn, ME.message);
                    end
                else
                    warning('File does not exist: %s', fn);
                end
            end
        end
        
        % for t1 = 1:numel(tasks)
        %     % Check if this task is available for this subject
        %     if ismember(tasks{t1}, available_tasks)
        %         fn  = fullfile(path_par, [subj 'v1s1'], 'func' ,'laminar', folderlabel, ...
        %             sprintf('Z_%s_%s.mat', subj, tasks{t1}));
        %         if exist(fn, 'file')
        %             try
        %                 tmp = load(fn, 'Z');
        %                 Z_all(id, t1, :, :) = tmp.Z;
        %             catch ME
        %                 warning('Failed to load %s: %s', fn, ME.message);
        %             end
        %         else
        %             warning('File does not exist: %s', fn);
        %         end
        %     end
        %     % If task not available or file doesn't exist, Z_all remains NaN
        % end
    end


    % DEBUG: Check what was actually loaded
    idx_mPFC_mid = find(strcmp(rois, 'mPFC_layer_mid'));
    idx_RSC_mid = find(strcmp(rois, 'RSC_layer_mid'));
    fprintf('\n=== DEBUG: mPFC-mid & RSC-mid Loading ===\n');
    for id = 1:numel(ids)
        non_nan = sum(~isnan(squeeze(Z_all(id, :, idx_mPFC_mid, idx_RSC_mid))));
        fprintf('%s: %d non-NaN values loaded\n', ids{id}, non_nan);
    end
    fprintf('======================================\n\n');

    
    %% ========== OUTLIER REMOVAL ========== %%
    
    % % First: Remove extreme values (absolute threshold)
    EXTREME_THRESHOLD = 2;  % Remove any |z| > 1.5
    % extreme_count = sum(abs(Z_all(:)) > EXTREME_THRESHOLD, 'omitnan');
    % Z_all(abs(Z_all) > EXTREME_THRESHOLD) = NaN;
    % if extreme_count > 0
    %     fprintf('\n=== EXTREME VALUE REMOVAL ===\n');
    %     fprintf('Removed %d extreme values (|z| > %.1f)\n', extreme_count, EXTREME_THRESHOLD);
    %     fprintf('=============================\n');
    % end
    

    % First: Remove extreme values (absolute threshold) - only if enabled
    if isfinite(EXTREME_THRESHOLD)
        extreme_count = sum(abs(Z_all(:)) > EXTREME_THRESHOLD, 'omitnan');
        Z_all(abs(Z_all) > EXTREME_THRESHOLD) = NaN;
        if extreme_count > 0
            fprintf('\n=== EXTREME VALUE REMOVAL ===\n');
            fprintf('Removed %d extreme values (|z| > %.1f)\n', extreme_count, EXTREME_THRESHOLD);
            fprintf('=============================\n');
        end
    end

    % Second: Statistical outlier detection
    if REMOVE_OUTLIERS
        fprintf('\n=== OUTLIER DETECTION ===\n');
        fprintf('Method: %s\n', upper(OUTLIER_METHOD));
        fprintf('Threshold: %.2f\n', OUTLIER_THRESHOLD);
        fprintf('Scope: %s\n', OUTLIER_SCOPE);
        fprintf('========================\n\n');
        
        Z_all_original = Z_all;  % Keep original for comparison
        outlier_count = 0;
        total_values = 0;
        
        % Get all unique pairs
        pairs = nchoosek(1:numel(rois), 2);
        
        for p = 1:size(pairs, 1)
            i = pairs(p, 1);
            j = pairs(p, 2);
            
            if strcmp(OUTLIER_SCOPE, 'per_phase')
                % Detect outliers per phase
                for t = 1:numel(tasks)
                    data = squeeze(Z_all(:, t, i, j));
                    valid_data = data(~isnan(data));
                    
                    if numel(valid_data) >= 4  % Need at least 4 points for outlier detection
                        total_values = total_values + numel(valid_data);
                        outliers = detect_outliers(valid_data, OUTLIER_METHOD, OUTLIER_THRESHOLD);
                        
                        if any(outliers)
                            % Mark outliers as NaN
                            valid_idx = find(~isnan(data));
                            outlier_subjects = valid_idx(outliers);
                            Z_all(outlier_subjects, t, i, j) = NaN;
                            outlier_count = outlier_count + sum(outliers);
                            
                            if SHOW_OUTLIER_REPORT
                                fprintf('  %s-%s, %s: removed %d outlier(s)\n', ...
                                    rois{i}, rois{j}, tasks{t}, sum(outliers));
                            end
                        end
                    end
                end
            else
                % Detect outliers across all phases
                data = squeeze(Z_all(:, :, i, j));
                valid_data = data(~isnan(data));
                
                if numel(valid_data) >= 4
                    total_values = total_values + numel(valid_data);
                    outliers = detect_outliers(valid_data, OUTLIER_METHOD, OUTLIER_THRESHOLD);
                    
                    if any(outliers)
                        % Mark outliers as NaN
                        valid_idx = find(~isnan(data));
                        [sub_idx, phase_idx] = ind2sub(size(data), valid_idx(outliers));
                        for k = 1:numel(sub_idx)
                            Z_all(sub_idx(k), phase_idx(k), i, j) = NaN;
                        end
                        outlier_count = outlier_count + sum(outliers);
                        
                        if SHOW_OUTLIER_REPORT
                            fprintf('  %s-%s (all phases): removed %d outlier(s)\n', ...
                                rois{i}, rois{j}, sum(outliers));
                        end
                    end
                end
            end
        end
        
        fprintf('\n=== OUTLIER SUMMARY ===\n');
        fprintf('Total values examined: %d\n', total_values);
        fprintf('Outliers removed: %d (%.2f%%)\n', outlier_count, 100*outlier_count/total_values);
        fprintf('=======================\n\n');
    end
    %% ===================================== %%

    % get all unique pairs i<j
    pairs = nchoosek(1:numel(rois), 2);

    % loop over each connection
    for p = 1:size(pairs, 1)
        i = pairs(p, 1);
        j = pairs(p, 2);
        fig = figure; hold on;

        % plot each subject's trajectory
        for id = 1:numel(ids)
            y = squeeze(Z_all(id, :, i, j));
            % Only plot if there's at least one non-NaN value
            if any(~isnan(y))
                plot(1:numel(tasks), y, '--', 'Color', [0.7 0.7 0.7]);
            end
        end

        % overlay the group mean ± SEM (using nanmean and nanstd)
        Ymean = squeeze(nanmean(Z_all(:, :, i, j), 1));
        % Count non-NaN subjects per phase for proper SEM calculation
        n_valid = squeeze(sum(~isnan(Z_all(:, :, i, j)), 1));
        Ysem  = squeeze(nanstd(Z_all(:, :, i, j), [], 1)) ./ sqrt(n_valid);
        
        % Replace Inf/NaN SEM with 0
        Ysem(~isfinite(Ysem)) = 0;
        
        % Only plot mean/SEM where we have valid data
        valid_phases = ~isnan(Ymean);
        if any(valid_phases)
            phases_to_plot = find(valid_phases);
            fill([phases_to_plot fliplr(phases_to_plot)], ...
                [Ymean(valid_phases) + Ysem(valid_phases) fliplr(Ymean(valid_phases) - Ysem(valid_phases))], ...
                [0.8 0.8 1], 'EdgeColor', 'none', 'FaceAlpha', 0.4);
            plot(phases_to_plot, Ymean(valid_phases), '-o', 'LineWidth', 2, 'Color', [0 0 0.8]);
        end

        set(gca, 'XTick', 1:numel(tasks), 'XTickLabel', tasks, 'FontSize', 12);
        xlabel('phase', 'FontSize', 14);
        ylabel(sprintf('fisher-z(%s–%s)', rois{i}, rois{j}), 'FontSize', 14);
        title(sprintf('%s – %s connectivity', rois{i}, rois{j}), 'FontSize', 16,'Interpreter','none');

        % perform paired t-tests for all comparisons
        comps = [1 2; 2 3; 1 3];
        Yall  = squeeze(Z_all(:, :, i, j));
        pvals = nan(size(comps, 1), 1);
        for c = 1:size(comps, 1)
            x1 = Yall(:, comps(c, 1));
            x2 = Yall(:, comps(c, 2));
            % Remove NaN pairs
            valid_idx = ~isnan(x1) & ~isnan(x2);
            if sum(valid_idx) >= 3  % Need at least 3 pairs for t-test
                [~, pvals(c)] = ttest(x1(valid_idx), x2(valid_idx));
            end
        end

        % determine y positions for bars
        y_max   = 0.4;
        y_min   = nanmin(Ymean - Ysem);
        y_range = y_max - y_min;
        off     = 0.1 * y_range;
        hbar    = 0.02 * y_range;
        ncomp   = size(comps, 1);
        y_bases = y_max + off * (1:ncomp);

        % draw significance bars and asterisks
        for c = 1:ncomp
            x1 = comps(c, 1);
            x2 = comps(c, 2);
            y0 = y_bases(c);
            if ~isnan(pvals(c))  % Only draw if we have a valid p-value
                plot([x1, x1, x2, x2], [y0, y0 + hbar, y0 + hbar, y0], 'k', 'LineWidth', 1.5);
                if pvals(c) < 0.001
                    sig = '***';
                    text(mean([x1, x2]), y0 + hbar + 0.03 * y_range, sig, ...
                        'HorizontalAlignment', 'center', 'FontSize', 14,'Color','r');
                elseif pvals(c) < 0.01
                    sig = '**';
                    text(mean([x1, x2]), y0 + hbar + 0.03 * y_range, sig, ...
                        'HorizontalAlignment', 'center', 'FontSize', 14,'Color','r');
                elseif pvals(c) < 0.05
                    sig = '*';
                    text(mean([x1, x2]), y0 + hbar + 0.03 * y_range, sig, ...
                        'HorizontalAlignment', 'center', 'FontSize', 14,'Color','r');
                elseif pvals(c) < 0.1
                    sig = 'o';
                    text(mean([x1, x2]), y0 + hbar + 0.03 * y_range, sig, ...
                        'HorizontalAlignment', 'center', 'FontSize', 14,'Color','r');
                else
                    sig = 'n.s.';
                    text(mean([x1, x2]), y0 + hbar + 0.03 * y_range, sig, ...
                        'HorizontalAlignment', 'center', 'FontSize', 12,'Color','k');
                end
            end
        end

        xlim([0.5, numel(tasks) + 0.5]); %ylim([-0.8 0.8])
        box on;
        hold off;

        % save
        savefig(fig, fullfile(path_par, 'group_fig', ...
            sprintf('%s_%s_vs_%s_sigTest_bs.fig', folderlabel, rois{i}, rois{j})));
        saveas(fig, fullfile(path_par, 'group_fig', ...
            sprintf('%s_%s_vs_%s_sigTest_bs.jpg', folderlabel, rois{i}, rois{j})), 'jpg');
    end

    % compute group mean fisher-z matrix for each phase (using nanmean)
    Z_group = squeeze(nanmean(Z_all, 1));

    thr_r = 0.1;

    for t1 = 1:numel(tasks)
        Zg = squeeze(Z_group(t1, :, :));
        Zg(isnan(Zg)) = 0;
        Zg = (Zg + Zg.') / 2;
        Rg = tanh(Zg);

        % threshold adjacency
        Ag = Rg .* ~eye(numel(rois));
        Ag(abs(Ag) < thr_r) = 0;

        % extract edges
        [i_idx, j_idx, vg] = find(triu(Ag, 1));

        % compute p-values (one-sample t-test against zero, uncorrected)
        pmat = ones(numel(rois), numel(rois));
        for i2 = 1:numel(rois)
            for j2 = i2+1:numel(rois)
                data = squeeze(Z_all(:, t1, i2, j2));
                % Remove NaNs before t-test
                data_clean = data(~isnan(data));
                if numel(data_clean) >= 3
                    [~, p] = ttest(data_clean, 0);
                    pmat(i2, j2) = p;
                end
            end
        end

        % build graph
        Gg   = graph(Ag, rois, 'upper');
        rvecg = Gg.Edges.Weight;

        % prepare edge labels with * or o if p<0.1
        lblg = cell(size(rvecg));
        for e = 1:numel(rvecg)
            i_e = i_idx(e);
            j_e = j_idx(e);
            if pmat(i_e, j_e) < 0.05
                lblg{e} = sprintf('%.2f*', rvecg(e));
            elseif pmat(i_e, j_e) < 0.1 && pmat(i_e, j_e) > 0.05
                lblg{e} = sprintf('%.2f◎', rvecg(e));
            else
                lblg{e} = sprintf('%.2f', rvecg(e));
            end
        end

        % layout positions
        theta = linspace(0, 2*pi, numel(rois)+1); theta(end) = [];
        xy = [cos(theta); sin(theta)];

        % plot connectivity graph
        figG = figure;
        pg = plot(Gg, ...
            'XData', xy(1, :), 'YData', xy(2, :), ...
            'Marker', 's', 'MarkerSize', 14, 'NodeColor', [0.1 0.1 0.1], ...
            'NodeLabel', rois, 'NodeFontSize', 14, 'LineWidth', 1);

        if ~isempty(rvecg)
            lwg = 1 + 7 * rescale(abs(rvecg), 'InputMin', thr_r);
            lwg(~isfinite(lwg)) = eps;
            pg.LineWidth = lwg;
            pg.EdgeCData = rvecg;
            pg.EdgeColor = 'flat';

            pg.EdgeLabel = lblg;
            pg.EdgeFontSize = 12;
            pg.EdgeLabelColor = [0 0 0];
            pg.Interpreter = 'none';

            clim([-0.5 0.5]);
            colormap(jet);
            cb = colorbar('FontSize', 12);
            cb.Label.String = 'correlation (r)';
            cb.Label.FontSize = 14;
        end

        axis equal; axis off;
        xticklabels(phaseticks)
        title(sprintf('connectivity graph – %s', tasks{t1}), 'FontSize', 16,'Interpreter','none');

        savefig(figG, fullfile(path_par, 'group_fig', ...
            sprintf('%s_connectivity_%s_bs.fig', folderlabel, tasks{t1})));
        saveas(figG, fullfile(path_par, 'group_fig', ...
            sprintf('%s_connectivity_%s_bs.jpg', folderlabel, tasks{t1})), 'jpg');
        close(figG);


        % ===== Graph 2: Only significant connections (p < 0.05) =====
        Ag_sig = Ag;
        for i2 = 1:numel(rois)
            for j2 = i2+1:numel(rois)
                if pmat(i2, j2) >= 0.05
                    Ag_sig(i2, j2) = 0;
                    Ag_sig(j2, i2) = 0;
                end
            end
        end

        [i_idx_sig, j_idx_sig, vg_sig] = find(triu(Ag_sig, 1));
        
        if ~isempty(i_idx_sig)
            Gg_sig = graph(Ag_sig, rois, 'upper');
            rvecg_sig = Gg_sig.Edges.Weight;

            lblg_sig = cell(size(rvecg_sig));
            for e = 1:numel(rvecg_sig)
                lblg_sig{e} = sprintf('%.2f*', rvecg_sig(e));
            end

            figG_sig = figure;
            pg_sig = plot(Gg_sig, ...
                'XData', xy(1, :), 'YData', xy(2, :), ...
                'Marker', 's', 'MarkerSize', 14, 'NodeColor', [0.1 0.1 0.1], ...
                'NodeLabel', rois, 'NodeFontSize', 14, 'LineWidth', 1);

            lwg_sig = 1 + 7 * rescale(abs(rvecg_sig), 'InputMin', thr_r);
            lwg_sig(~isfinite(lwg_sig)) = eps;
            pg_sig.LineWidth = lwg_sig;
            pg_sig.EdgeCData = rvecg_sig;
            pg_sig.EdgeColor = 'flat';

            pg_sig.EdgeLabel = lblg_sig;
            pg_sig.EdgeFontSize = 12;
            pg_sig.EdgeLabelColor = [0 0 0];
            pg_sig.Interpreter = 'none';

            clim([-0.5 0.5]);
            colormap(jet);
            cb = colorbar('FontSize', 12);
            cb.Label.String = 'correlation (r)';
            cb.Label.FontSize = 14;

            axis equal; axis off;
            title(sprintf('significant connectivity (p<.05) – %s', tasks{t1}), 'FontSize', 16,'Interpreter','none');

            savefig(figG_sig, fullfile(path_par, 'group_fig', ...
                sprintf('%s_connectivity_SIG_%s_bs.fig', folderlabel, tasks{t1})));
            saveas(figG_sig, fullfile(path_par, 'group_fig', ...
                sprintf('%s_connectivity_SIG_%s_bs.jpg', folderlabel, tasks{t1})), 'jpg');
            close(figG_sig);
        end
    end
end

%% mPFC-RSC depth-specific analysis

close all

if a1 == 3 || a1 == 5

    idx_sup_mPFC  = find(strcmp(rois, 'mPFC_layer_sup'));
    idx_mid_mPFC  = find(strcmp(rois, 'mPFC_layer_mid'));
    idx_deep_mPFC = find(strcmp(rois, 'mPFC_layer_deep'));
    idx_sup_RSC   = find(strcmp(rois, 'RSC_layer_sup'));
    idx_mid_RSC   = find(strcmp(rois, 'RSC_layer_mid'));
    idx_deep_RSC  = find(strcmp(rois, 'RSC_layer_deep'));

    nS = numel(ids);
    nT = numel(tasks);

    % extract connectivity for each layer pair
    Y_sup_mean   = squeeze(nanmean(Z_all(:,:,idx_sup_mPFC,  idx_sup_RSC), 1));
    n_valid_sup  = squeeze(sum(~isnan(Z_all(:,:,idx_sup_mPFC,  idx_sup_RSC)), 1));
    Y_sup_sem    = squeeze(nanstd(Z_all(:,:,idx_sup_mPFC,  idx_sup_RSC),[],1))./sqrt(n_valid_sup);

    Y_mid_mean   = squeeze(nanmean(Z_all(:,:,idx_mid_mPFC,  idx_mid_RSC), 1));
    n_valid_mid  = squeeze(sum(~isnan(Z_all(:,:,idx_mid_mPFC,  idx_mid_RSC)), 1));
    Y_mid_sem    = squeeze(nanstd(Z_all(:,:,idx_mid_mPFC,  idx_mid_RSC),[],1))./sqrt(n_valid_mid);

    Y_deep_mean  = squeeze(nanmean(Z_all(:,:,idx_deep_mPFC, idx_deep_RSC), 1));
    n_valid_deep = squeeze(sum(~isnan(Z_all(:,:,idx_deep_mPFC, idx_deep_RSC)), 1));
    Y_deep_sem   = squeeze(nanstd(Z_all(:,:,idx_deep_mPFC, idx_deep_RSC),[],1))./sqrt(n_valid_deep);

    % Handle any Inf or NaN in SEM
    Y_sup_sem(~isfinite(Y_sup_sem)) = 0;
    Y_mid_sem(~isfinite(Y_mid_sem)) = 0;
    Y_deep_sem(~isfinite(Y_deep_sem)) = 0;

    % t-tests across phases for each layer
    comps = [1 2; 2 3; 1 3];
    p_sup  = nan(size(comps,1),1);
    p_mid  = nan(size(comps,1),1);
    p_deep = nan(size(comps,1),1);

    for c = 1:size(comps,1)
        x1s = squeeze(Z_all(:, comps(c,1), idx_sup_mPFC,  idx_sup_RSC));
        x2s = squeeze(Z_all(:, comps(c,2), idx_sup_mPFC,  idx_sup_RSC));
        valid_idx = ~isnan(x1s) & ~isnan(x2s);
        if sum(valid_idx) >= 3
            [~, p_sup(c)] = ttest(x1s(valid_idx), x2s(valid_idx));
        end
        
        x1m = squeeze(Z_all(:, comps(c,1), idx_mid_mPFC,  idx_mid_RSC));
        x2m = squeeze(Z_all(:, comps(c,2), idx_mid_mPFC,  idx_mid_RSC));
        valid_idx = ~isnan(x1m) & ~isnan(x2m);
        if sum(valid_idx) >= 3
            [~, p_mid(c)] = ttest(x1m(valid_idx), x2m(valid_idx));
        end
        
        x1d = squeeze(Z_all(:, comps(c,1), idx_deep_mPFC, idx_deep_RSC));
        x2d = squeeze(Z_all(:, comps(c,2), idx_deep_mPFC, idx_deep_RSC));
        valid_idx = ~isnan(x1d) & ~isnan(x2d);
        if sum(valid_idx) >= 3
            [~, p_deep(c)] = ttest(x1d(valid_idx), x2d(valid_idx));
        end
    end

    % prep fig
    figure; hold on

    % colours
    col_sup  = [1 0 0];
    col_mid  = [0.47 0.67 0.19];
    col_deep = [0 0 1];

    % plot shaded errorbars
    t = 1:nT;
    fill([t fliplr(t)], [Y_sup_mean+Y_sup_sem fliplr(Y_sup_mean-Y_sup_sem)], ...
         col_sup, 'FaceAlpha',0.2, 'EdgeColor','none');
    fill([t fliplr(t)], [Y_mid_mean+Y_mid_sem fliplr(Y_mid_mean-Y_mid_sem)], ...
         col_mid, 'FaceAlpha',0.2, 'EdgeColor','none');
    fill([t fliplr(t)], [Y_deep_mean+Y_deep_sem fliplr(Y_deep_mean-Y_deep_sem)], ...
         col_deep, 'FaceAlpha',0.2, 'EdgeColor','none');

    % plot mean lines
    plot(t, Y_sup_mean,  '-o', 'LineWidth',2, 'Color',col_sup);
    plot(t, Y_mid_mean,  '-o', 'LineWidth',2, 'Color',col_mid);
    plot(t, Y_deep_mean, '-o', 'LineWidth',2, 'Color',col_deep);

    % axis labels and title
    set(gca, 'XTick', t, 'XTickLabel', tasks, 'FontSize',12);
    xlabel('phase', 'FontSize',14);
    ylabel('Mean Fisher-Z (mPFC–RSC)', 'FontSize',14);
    title('mPFC–RSC connectivity by layer depth', 'FontSize',16);

    % determine ylim for significance bars
    y_max_sup  = nanmax(Y_sup_mean + Y_sup_sem);
    y_max_mid  = nanmax(Y_mid_mean + Y_mid_sem);
    y_max_deep = nanmax(Y_deep_mean + Y_deep_sem);
    y_min_sup  = nanmin(Y_sup_mean - Y_sup_sem);
    y_min_mid  = nanmin(Y_mid_mean - Y_mid_sem);
    y_min_deep = nanmin(Y_deep_mean - Y_deep_sem);

    y_global_max = nanmax([y_max_sup, y_max_mid, y_max_deep]);
    y_global_min = nanmin([y_min_sup, y_min_mid, y_min_deep]);
    y_range = y_global_max - y_global_min;
    off = 0.05 * y_range;
    hbar = 0.02 * y_range;

    % pos for significance bars per depth
    base_sup  = y_max_sup  + off;
    base_mid  = y_max_mid  + 2*off;
    base_deep = y_max_deep + 3*off;

    yline(0,'LineStyle','--','Color',[0.3 0.3 0.3],'LineWidth',2)

    % annotate significance for each comparison and depth
    for c = 1:size(comps,1)
        x1 = comps(c,1);
        x2 = comps(c,2);
        % sup
        if ~isnan(p_sup(c))
            y0 = base_sup + (c-1)*(hbar+0.01*y_range)+0.1;
            if p_sup(c) < 0.05
                plot([x1 x1 x2 x2], [y0 y0+hbar y0+hbar y0], 'r', 'LineWidth',1.5);
                text(mean([x1,x2]), y0 + hbar + 0.01*y_range, '*', ...
                     'HorizontalAlignment','center','FontSize',14,'Color',col_sup);
            elseif p_sup(c) < 0.1
                plot([x1 x1 x2 x2], [y0 y0+hbar y0+hbar y0], 'r', 'LineWidth',1.5);
                text(mean([x1,x2]), y0 + hbar + 0.01*y_range, 'o', ...
                     'HorizontalAlignment','center','FontSize',14,'Color',col_sup);
            end
        end
        % mid
        if ~isnan(p_mid(c))
            y1 = base_mid + (c-1)*(hbar+0.01*y_range);
            if p_mid(c) < 0.05
                plot([x1 x1 x2 x2], [y1 y1+hbar y1+hbar y1], 'g', 'LineWidth',1.5);
                text(mean([x1,x2]), y1 + hbar + 0.01*y_range, '*', ...
                     'HorizontalAlignment','center','FontSize',14,'Color',col_mid);
            elseif p_mid(c) < 0.1
                plot([x1 x1 x2 x2], [y1 y1+hbar y1+hbar y1], 'g', 'LineWidth',1.5);
                text(mean([x1,x2]), y1 + hbar + 0.01*y_range, 'o', ...
                     'HorizontalAlignment','center','FontSize',14,'Color',col_mid);
            end
        end
        % deep
        if ~isnan(p_deep(c))
            y2 = base_deep + (c-1)*(hbar+0.01*y_range);
            if p_deep(c) < 0.05
                plot([x1 x1 x2 x2], [y2 y2+hbar y2+hbar y2], 'b', 'LineWidth',1.5);
                text(mean([x1,x2]), y2 + hbar + 0.01*y_range, '*', ...
                     'HorizontalAlignment','center','FontSize',14,'Color',col_deep);
            elseif p_deep(c) < 0.1
                plot([x1 x1 x2 x2], [y2 y2+hbar y2+hbar y2], 'b', 'LineWidth',1.5);
                text(mean([x1,x2]), y2 + hbar + 0.01*y_range, 'o', ...
                     'HorizontalAlignment','center','FontSize',14,'Color',col_deep);
            end
        end
    end

    legend({'Sup (SEM)','Mid (SEM)','Deep (SEM)', ...
            'Sup Mean','Mid Mean','Deep Mean'}, ...
           'Location','southoutside', 'FontSize',12);
    xticklabels(phaseticks)

    xlim([0.8, nT+0.2]);
    % ylim([-0.4 0.4])
    box on; grid on; hold off;

    % save
    savefig(fullfile(path_par,'group_fig','mPFC-RSC_depth_sig_SE_bs.fig'));
    saveas(gcf, fullfile(path_par,'group_fig','mPFC-RSC_depth_sig_SE_bs.jpg'),'jpg');
end

%%
%% Subiculum-ErC connectivity

close all

if a1 == 5
    idx_Sub = find(strcmp(rois, 'Sub'));
    idx_ErC = find(strcmp(rois, 'ErC'));
    
    if ~isempty(idx_Sub) && ~isempty(idx_ErC)
        nS = numel(ids);
        nT = numel(tasks);
        
        % Extract connectivity
        Y_mean = squeeze(nanmean(Z_all(:,:,idx_Sub, idx_ErC), 1));
        n_valid = squeeze(sum(~isnan(Z_all(:,:,idx_Sub, idx_ErC)), 1));
        Y_sem = squeeze(nanstd(Z_all(:,:,idx_Sub, idx_ErC),[],1))./sqrt(n_valid);
        Y_sem(~isfinite(Y_sem)) = 0;
        
        % t-tests
        comps = [1 2; 2 3; 1 3];
        pvals = nan(size(comps,1),1);
        for c = 1:size(comps,1)
            x1 = squeeze(Z_all(:, comps(c,1), idx_Sub, idx_ErC));
            x2 = squeeze(Z_all(:, comps(c,2), idx_Sub, idx_ErC));
            valid_idx = ~isnan(x1) & ~isnan(x2);
            if sum(valid_idx) >= 3
                [~, pvals(c)] = ttest(x1(valid_idx), x2(valid_idx));
            end
        end
        
        % Plot
        figure; hold on
        
        % Individual trajectories
        for id = 1:nS
            y = squeeze(Z_all(id, :, idx_Sub, idx_ErC));
            if any(~isnan(y))
                plot(1:nT, y, '--', 'Color', [0.7 0.7 0.7]);
            end
        end
        
        % Group mean
        t = 1:nT;
        fill([t fliplr(t)], [Y_mean+Y_sem fliplr(Y_mean-Y_sem)], ...
             [0.8 0.8 1], 'FaceAlpha',0.3, 'EdgeColor','none');
        plot(t, Y_mean, '-o', 'LineWidth',2, 'Color',[0 0 0.8]);
        
        % Formatting
        set(gca, 'XTick', t, 'XTickLabel', tasks, 'FontSize',12);
        xlabel('Phase', 'FontSize',14);
        ylabel('Fisher-Z', 'FontSize',14);
        xticklabels(phaseticks)
        title('Subiculum–Entorhinal Cortex connectivity', 'FontSize',16);
        
        % Significance bars
        y_max = 0.4;
        y_min = nanmin(Y_mean - Y_sem);
        y_range = y_max - y_min;
        off = 0.1 * y_range;
        hbar = 0.02 * y_range;
        y_bases = y_max + off * (1:size(comps,1));
        
        for c = 1:size(comps,1)
            x1 = comps(c,1);
            x2 = comps(c,2);
            y0 = y_bases(c);
            if ~isnan(pvals(c))
                plot([x1 x1 x2 x2], [y0 y0+hbar y0+hbar y0], 'k', 'LineWidth',1.5);
                if pvals(c) < 0.001
                    text(mean([x1,x2]), y0+hbar+0.03*y_range, '***', ...
                        'HorizontalAlignment','center','FontSize',14,'Color','r');
                elseif pvals(c) < 0.01
                    text(mean([x1,x2]), y0+hbar+0.03*y_range, '**', ...
                        'HorizontalAlignment','center','FontSize',14,'Color','r');
                elseif pvals(c) < 0.05
                    text(mean([x1,x2]), y0+hbar+0.03*y_range, '*', ...
                        'HorizontalAlignment','center','FontSize',14,'Color','r');
                elseif pvals(c) < 0.1
                    text(mean([x1,x2]), y0+hbar+0.03*y_range, 'o', ...
                        'HorizontalAlignment','center','FontSize',14,'Color','r');
                else
                    text(mean([x1,x2]), y0+hbar+0.03*y_range, 'n.s.', ...
                        'HorizontalAlignment','center','FontSize',12,'Color','k');
                end
            end
        end
        
        xlim([0.5, nT+0.5]); %ylim([-0.8 0.8]);
        box on; grid on; hold off;
        
        savefig(fullfile(path_par,'group_fig','Sub-ErC_connectivity_bs.fig'));
        saveas(gcf, fullfile(path_par,'group_fig','Sub-ErC_connectivity_bs.jpg'),'jpg');
    end
end

%% mPFC (all layers) - Hippocampal subfields
close all
if a1 == 5
    idx_mPFC_sup = find(strcmp(rois, 'mPFC_layer_sup'));
    idx_mPFC_mid = find(strcmp(rois, 'mPFC_layer_mid'));
    idx_mPFC_deep = find(strcmp(rois, 'mPFC_layer_deep'));
    idx_CA1 = find(strcmp(rois, 'CA1'));
    idx_CA3 = find(strcmp(rois, 'CA3'));
    idx_DG = find(strcmp(rois, 'DG'));
    idx_Sub = find(strcmp(rois, 'Sub'));
    
    hpc_regions = {'CA1', 'CA3', 'DG', 'Sub'};
    hpc_idx = [idx_CA1, idx_CA3, idx_DG, idx_Sub];
    mpfc_names = {'mPFC-sup', 'mPFC-mid', 'mPFC-deep'};
    mpfc_idx = [idx_mPFC_sup, idx_mPFC_mid, idx_mPFC_deep];
    mpfc_colors = {[1 0 0], [0.47 0.67 0.19], [0 0 1]};
    
    nS = numel(ids);
    nT = numel(tasks);
    
    % Loop through hippocampal regions
    for h = 1:numel(hpc_regions)
        figure; hold on
        
        % Plot each mPFC layer
        for m = 1:numel(mpfc_idx)
            Y_mean = squeeze(nanmean(Z_all(:,:,mpfc_idx(m), hpc_idx(h)), 1));
            n_valid = squeeze(sum(~isnan(Z_all(:,:,mpfc_idx(m), hpc_idx(h))), 1));
            Y_sem = squeeze(nanstd(Z_all(:,:,mpfc_idx(m), hpc_idx(h)),[],1))./sqrt(n_valid);
            Y_sem(~isfinite(Y_sem)) = 0;
            
            t = 1:nT;
            fill([t fliplr(t)], [Y_mean+Y_sem fliplr(Y_mean-Y_sem)], ...
                 mpfc_colors{m}, 'FaceAlpha',0.2, 'EdgeColor','none');
            plot(t, Y_mean, '-o', 'LineWidth',2, 'Color',mpfc_colors{m}, ...
                 'DisplayName', mpfc_names{m});
        end
        
        % Formatting
        set(gca, 'XTick', 1:nT, 'XTickLabel', phaseticks, 'FontSize',12);
        
        xlabel('phase', 'FontSize',14);
        ylabel(sprintf('Fisher-Z (mPFC–%s)', hpc_regions{h}), 'FontSize',14);
        title(sprintf('mPFC layers – %s connectivity', hpc_regions{h}), 'FontSize',16);
        legend('Location','southoutside', 'FontSize',12);
        yline(0,'LineStyle','--','Color',[0.3 0.3 0.3],'LineWidth',1.5);
        xlim([0.5, nT+0.5]); %ylim([-0.6 0.6]);
        box on; grid on; hold off;
        
        savefig(fullfile(path_par,'group_fig',sprintf('mPFC-layers_%s_connectivity_bs.fig', hpc_regions{h})));
        saveas(gcf, fullfile(path_par,'group_fig',sprintf('mPFC-layers_%s_connectivity_bs.jpg', hpc_regions{h})),'jpg');
    end
end

%%

close all

if a1 == 5
    idx_mPFC_sup = find(strcmp(rois, 'mPFC_layer_sup'));
    idx_mPFC_mid = find(strcmp(rois, 'mPFC_layer_mid'));
    idx_mPFC_deep = find(strcmp(rois, 'mPFC_layer_deep'));
    idx_CA1 = find(strcmp(rois, 'CA1'));
    idx_CA3 = find(strcmp(rois, 'CA3'));
    idx_DG = find(strcmp(rois, 'DG'));
    idx_Sub = find(strcmp(rois, 'Sub'));
    
    hpc_regions = {'CA1', 'CA3', 'DG', 'Sub'};
    hpc_idx = [idx_CA1, idx_CA3, idx_DG, idx_Sub];
    mpfc_names = {'mPFC-sup', 'mPFC-mid', 'mPFC-deep'};
    mpfc_idx = [idx_mPFC_sup, idx_mPFC_mid, idx_mPFC_deep];
    mpfc_colors = {[1 0 0], [0.47 0.67 0.19], [0 0 1]};
    
    nS = numel(ids);
    nT = numel(tasks);
    
    % Loop through hippocampal regions
    for h = 1:numel(hpc_regions)
        figure; hold on
        
        % Store data for each layer
        Y_means = nan(numel(mpfc_idx), nT);
        Y_sems = nan(numel(mpfc_idx), nT);
        
        % Plot each mPFC layer
        for m = 1:numel(mpfc_idx)
            Y_mean = squeeze(nanmean(Z_all(:,:,mpfc_idx(m), hpc_idx(h)), 1));
            n_valid = squeeze(sum(~isnan(Z_all(:,:,mpfc_idx(m), hpc_idx(h))), 1));
            Y_sem = squeeze(nanstd(Z_all(:,:,mpfc_idx(m), hpc_idx(h)),[],1))./sqrt(n_valid);
            Y_sem(~isfinite(Y_sem)) = 0;
            
            Y_means(m,:) = Y_mean;
            Y_sems(m,:) = Y_sem;
            
            t = 1:nT;
            fill([t fliplr(t)], [Y_mean+Y_sem fliplr(Y_mean-Y_sem)], ...
                 mpfc_colors{m}, 'FaceAlpha',0.2, 'EdgeColor','none');
            plot(t, Y_mean, '-o', 'LineWidth',2, 'Color',mpfc_colors{m}, ...
                 'DisplayName', mpfc_names{m});
        end
        
        % T-tests for each layer
        comps = [1 2; 2 3; 1 3];
        p_sup = nan(size(comps,1),1);
        p_mid = nan(size(comps,1),1);
        p_deep = nan(size(comps,1),1);
        
        for c = 1:size(comps,1)
            % Sup
            x1s = squeeze(Z_all(:, comps(c,1), idx_mPFC_sup, hpc_idx(h)));
            x2s = squeeze(Z_all(:, comps(c,2), idx_mPFC_sup, hpc_idx(h)));
            valid_idx = ~isnan(x1s) & ~isnan(x2s);
            if sum(valid_idx) >= 3
                [~, p_sup(c)] = ttest(x1s(valid_idx), x2s(valid_idx));
            end
            
            % Mid
            x1m = squeeze(Z_all(:, comps(c,1), idx_mPFC_mid, hpc_idx(h)));
            x2m = squeeze(Z_all(:, comps(c,2), idx_mPFC_mid, hpc_idx(h)));
            valid_idx = ~isnan(x1m) & ~isnan(x2m);
            if sum(valid_idx) >= 3
                [~, p_mid(c)] = ttest(x1m(valid_idx), x2m(valid_idx));
            end
            
            % Deep
            x1d = squeeze(Z_all(:, comps(c,1), idx_mPFC_deep, hpc_idx(h)));
            x2d = squeeze(Z_all(:, comps(c,2), idx_mPFC_deep, hpc_idx(h)));
            valid_idx = ~isnan(x1d) & ~isnan(x2d);
            if sum(valid_idx) >= 3
                [~, p_deep(c)] = ttest(x1d(valid_idx), x2d(valid_idx));
            end
        end
        
        % Significance bars (only if p < 0.1)
        y_max_sup = nanmax(Y_means(1,:) + Y_sems(1,:));
        y_max_mid = nanmax(Y_means(2,:) + Y_sems(2,:));
        y_max_deep = nanmax(Y_means(3,:) + Y_sems(3,:));
        y_global_max = nanmax([y_max_sup, y_max_mid, y_max_deep]);
        y_min = nanmin(Y_means(:) - Y_sems(:));
        y_range = y_global_max - y_min;
        off = 0.05 * y_range;
        hbar = 0.02 * y_range;
        
        base_sup = y_max_sup + off;
        base_mid = y_max_mid + 2*off;
        base_deep = y_max_deep + 3*off;
        
        for c = 1:size(comps,1)
            x1 = comps(c,1);
            x2 = comps(c,2);
            
            % Sup
            if ~isnan(p_sup(c)) && p_sup(c) < 0.1
                y0 = base_sup + (c-1)*(hbar+0.01*y_range);
                plot([x1 x1 x2 x2], [y0 y0+hbar y0+hbar y0], 'Color', mpfc_colors{1}, 'LineWidth',1.5);
                if p_sup(c) < 0.05
                    text(mean([x1,x2]), y0+hbar+0.01*y_range, '*', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',mpfc_colors{1});
                else
                    text(mean([x1,x2]), y0+hbar+0.01*y_range, 'o', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',mpfc_colors{1});
                end
            end
            
            % Mid
            if ~isnan(p_mid(c)) && p_mid(c) < 0.1
                y1 = base_mid + (c-1)*(hbar+0.01*y_range);
                plot([x1 x1 x2 x2], [y1 y1+hbar y1+hbar y1], 'Color', mpfc_colors{2}, 'LineWidth',1.5);
                if p_mid(c) < 0.05
                    text(mean([x1,x2]), y1+hbar+0.01*y_range, '*', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',mpfc_colors{2});
                else
                    text(mean([x1,x2]), y1+hbar+0.01*y_range, 'o', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',mpfc_colors{2});
                end
            end
            
            % Deep
            if ~isnan(p_deep(c)) && p_deep(c) < 0.1
                y2 = base_deep + (c-1)*(hbar+0.01*y_range);
                plot([x1 x1 x2 x2], [y2 y2+hbar y2+hbar y2], 'Color', mpfc_colors{3}, 'LineWidth',1.5);
                if p_deep(c) < 0.05
                    text(mean([x1,x2]), y2+hbar+0.01*y_range, '*', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',mpfc_colors{3});
                else
                    text(mean([x1,x2]), y2+hbar+0.01*y_range, 'o', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',mpfc_colors{3});
                end
            end
        end
        
        % Formatting
        set(gca, 'XTick', 1:nT, 'XTickLabel', tasks, 'FontSize',12);
        xlabel('phase', 'FontSize',14);
        ylabel(sprintf('fisher-z (mPFC–%s)', hpc_regions{h}), 'FontSize',14);
        title(sprintf('mPFC layers – %s connectivity', hpc_regions{h}), 'FontSize',16);
        legend('Location','southoutside', 'FontSize',12);
        yline(0,'LineStyle','--','Color',[0.3 0.3 0.3],'LineWidth',1.5);
        xlim([0.5, nT+0.5]);
        box on; grid on; hold off;
        
        savefig(fullfile(path_par,'group_fig',sprintf('mPFC-layers_%s_connectivity_bs.fig', hpc_regions{h})));
        saveas(gcf, fullfile(path_par,'group_fig',sprintf('mPFC-layers_%s_connectivity_bs.jpg', hpc_regions{h})),'jpg');
        
    end
end


%%

%% EC (all layers) - Hippocampal subfields
close all
if a1 == 5
    idx_mPFC_sup = find(strcmp(rois, 'EC_layer_sup'));
    idx_mPFC_mid = find(strcmp(rois, 'EC_layer_mid'));
    idx_mPFC_deep = find(strcmp(rois, 'EC_layer_deep'));
    idx_CA1 = find(strcmp(rois, 'CA1'));
    idx_CA3 = find(strcmp(rois, 'CA3'));
    idx_DG = find(strcmp(rois, 'DG'));
    idx_Sub = find(strcmp(rois, 'Sub'));
    
    hpc_regions = {'CA1', 'CA3', 'DG', 'Sub'};
    hpc_idx = [idx_CA1, idx_CA3, idx_DG, idx_Sub];
    mpfc_names = {'EC-sup', 'EC-mid', 'EC-deep'};
    mpfc_idx = [idx_mPFC_sup, idx_mPFC_mid, idx_mPFC_deep];
    mpfc_colors = {[1 0 0], [0.47 0.67 0.19], [0 0 1]};
    
    nS = numel(ids);
    nT = numel(tasks);
    
    % Loop through hippocampal regions
    for h = 1:numel(hpc_regions)
        figure; hold on
        
        % Plot each mPFC layer
        for m = 1:numel(mpfc_idx)
            Y_mean = squeeze(nanmean(Z_all(:,:,mpfc_idx(m), hpc_idx(h)), 1));
            n_valid = squeeze(sum(~isnan(Z_all(:,:,mpfc_idx(m), hpc_idx(h))), 1));
            Y_sem = squeeze(nanstd(Z_all(:,:,mpfc_idx(m), hpc_idx(h)),[],1))./sqrt(n_valid);
            Y_sem(~isfinite(Y_sem)) = 0;
            
            t = 1:nT;
            fill([t fliplr(t)], [Y_mean+Y_sem fliplr(Y_mean-Y_sem)], ...
                 mpfc_colors{m}, 'FaceAlpha',0.2, 'EdgeColor','none');
            plot(t, Y_mean, '-o', 'LineWidth',2, 'Color',mpfc_colors{m}, ...
                 'DisplayName', mpfc_names{m});
        end
        
        % Formatting
        set(gca, 'XTick', 1:nT, 'XTickLabel', phaseticks, 'FontSize',12);
        
        xlabel('phase', 'FontSize',14);
        ylabel(sprintf('Fisher-Z (mPFC–%s)', hpc_regions{h}), 'FontSize',14);
        title(sprintf('EC layers – %s connectivity', hpc_regions{h}), 'FontSize',16);
        legend('Location','southoutside', 'FontSize',12);
        yline(0,'LineStyle','--','Color',[0.3 0.3 0.3],'LineWidth',1.5);
        xlim([0.5, nT+0.5]); %ylim([-0.6 0.6]);
        box on; grid on; hold off;
        
        savefig(fullfile(path_par,'group_fig',sprintf('EC-layers_%s_connectivity_bs.fig', hpc_regions{h})));
        saveas(gcf, fullfile(path_par,'group_fig',sprintf('EC-layers_%s_connectivity_bs.jpg', hpc_regions{h})),'jpg');
    end
end

%%

%% EC (all layers) - Hippocampal subfields
close all
if a1 == 5
    idx_EC_sup = find(strcmp(rois, 'EC_layer_sup'));
    idx_EC_mid = find(strcmp(rois, 'EC_layer_mid'));
    idx_EC_deep = find(strcmp(rois, 'EC_layer_deep'));
    idx_CA1 = find(strcmp(rois, 'CA1'));
    idx_CA3 = find(strcmp(rois, 'CA3'));
    idx_DG = find(strcmp(rois, 'DG'));
    idx_Sub = find(strcmp(rois, 'Sub'));
    
    hpc_regions = {'CA1', 'CA3', 'DG', 'Sub'};
    hpc_idx = [idx_CA1, idx_CA3, idx_DG, idx_Sub];
    ec_names = {'EC-sup', 'EC-mid', 'EC-deep'};
    ec_idx = [idx_EC_sup, idx_EC_mid, idx_EC_deep];
    ec_colors = {[1 0 0], [0.47 0.67 0.19], [0 0 1]};
    
    nS = numel(ids);
    nT = numel(tasks);
    
    % Loop through hippocampal regions
    for h = 1:numel(hpc_regions)
        figure; hold on
        
        % Store data for significance testing
        Y_means = nan(numel(ec_idx), nT);
        Y_sems = nan(numel(ec_idx), nT);
        
        % Plot each EC layer
        for m = 1:numel(ec_idx)
            Y_mean = squeeze(nanmean(Z_all(:,:,ec_idx(m), hpc_idx(h)), 1));
            n_valid = squeeze(sum(~isnan(Z_all(:,:,ec_idx(m), hpc_idx(h))), 1));
            Y_sem = squeeze(nanstd(Z_all(:,:,ec_idx(m), hpc_idx(h)),[],1))./sqrt(n_valid);
            Y_sem(~isfinite(Y_sem)) = 0;
            
            Y_means(m,:) = Y_mean;
            Y_sems(m,:) = Y_sem;
            
            t = 1:nT;
            fill([t fliplr(t)], [Y_mean+Y_sem fliplr(Y_mean-Y_sem)], ...
                 ec_colors{m}, 'FaceAlpha',0.2, 'EdgeColor','none');
            plot(t, Y_mean, '-o', 'LineWidth',2, 'Color',ec_colors{m}, ...
                 'DisplayName', ec_names{m});
        end
        
        % T-tests for each layer
        comps = [1 2; 2 3; 1 3];
        p_sup = nan(size(comps,1),1);
        p_mid = nan(size(comps,1),1);
        p_deep = nan(size(comps,1),1);
        
        for c = 1:size(comps,1)
            % Sup
            x1s = squeeze(Z_all(:, comps(c,1), idx_EC_sup, hpc_idx(h)));
            x2s = squeeze(Z_all(:, comps(c,2), idx_EC_sup, hpc_idx(h)));
            valid_idx = ~isnan(x1s) & ~isnan(x2s);
            if sum(valid_idx) >= 3
                [~, p_sup(c)] = ttest(x1s(valid_idx), x2s(valid_idx));
            end
            
            % Mid
            x1m = squeeze(Z_all(:, comps(c,1), idx_EC_mid, hpc_idx(h)));
            x2m = squeeze(Z_all(:, comps(c,2), idx_EC_mid, hpc_idx(h)));
            valid_idx = ~isnan(x1m) & ~isnan(x2m);
            if sum(valid_idx) >= 3
                [~, p_mid(c)] = ttest(x1m(valid_idx), x2m(valid_idx));
            end
            
            % Deep
            x1d = squeeze(Z_all(:, comps(c,1), idx_EC_deep, hpc_idx(h)));
            x2d = squeeze(Z_all(:, comps(c,2), idx_EC_deep, hpc_idx(h)));
            valid_idx = ~isnan(x1d) & ~isnan(x2d);
            if sum(valid_idx) >= 3
                [~, p_deep(c)] = ttest(x1d(valid_idx), x2d(valid_idx));
            end
        end
        
        % Significance bars (only if p < 0.1)
        y_max_sup = nanmax(Y_means(1,:) + Y_sems(1,:));
        y_max_mid = nanmax(Y_means(2,:) + Y_sems(2,:));
        y_max_deep = nanmax(Y_means(3,:) + Y_sems(3,:));
        y_global_max = nanmax([y_max_sup, y_max_mid, y_max_deep]);
        y_min = nanmin(Y_means(:) - Y_sems(:));
        y_range = y_global_max - y_min;
        off = 0.05 * y_range;
        hbar = 0.02 * y_range;
        
        base_sup = y_max_sup + off;
        base_mid = y_max_mid + 2*off;
        base_deep = y_max_deep + 3*off;
        
        for c = 1:size(comps,1)
            x1 = comps(c,1);
            x2 = comps(c,2);
            
            % Sup
            if ~isnan(p_sup(c)) && p_sup(c) < 0.1
                y0 = base_sup + (c-1)*(hbar+0.01*y_range);
                plot([x1 x1 x2 x2], [y0 y0+hbar y0+hbar y0], 'Color', ec_colors{1}, 'LineWidth',1.5);
                if p_sup(c) < 0.05
                    text(mean([x1,x2]), y0+hbar+0.01*y_range, '*', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',ec_colors{1});
                else
                    text(mean([x1,x2]), y0+hbar+0.01*y_range, 'o', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',ec_colors{1});
                end
            end
            
            % Mid
            if ~isnan(p_mid(c)) && p_mid(c) < 0.1
                y1 = base_mid + (c-1)*(hbar+0.01*y_range);
                plot([x1 x1 x2 x2], [y1 y1+hbar y1+hbar y1], 'Color', ec_colors{2}, 'LineWidth',1.5);
                if p_mid(c) < 0.05
                    text(mean([x1,x2]), y1+hbar+0.01*y_range, '*', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',ec_colors{2});
                else
                    text(mean([x1,x2]), y1+hbar+0.01*y_range, 'o', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',ec_colors{2});
                end
            end
            
            % Deep
            if ~isnan(p_deep(c)) && p_deep(c) < 0.1
                y2 = base_deep + (c-1)*(hbar+0.01*y_range);
                plot([x1 x1 x2 x2], [y2 y2+hbar y2+hbar y2], 'Color', ec_colors{3}, 'LineWidth',1.5);
                if p_deep(c) < 0.05
                    text(mean([x1,x2]), y2+hbar+0.01*y_range, '*', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',ec_colors{3});
                else
                    text(mean([x1,x2]), y2+hbar+0.01*y_range, 'o', ...
                        'HorizontalAlignment','center','FontSize',14,'Color',ec_colors{3});
                end
            end
        end
        
        % Formatting
        set(gca, 'XTick', 1:nT, 'XTickLabel', phaseticks, 'FontSize',12);
        xlabel('phase', 'FontSize',14);
        ylabel(sprintf('Fisher-Z (EC–%s)', hpc_regions{h}), 'FontSize',14);
        title(sprintf('EC layers – %s connectivity', hpc_regions{h}), 'FontSize',16);
        legend('Location','southoutside', 'FontSize',12, 'Orientation','horizontal');
        yline(0,'LineStyle','--','Color',[0.3 0.3 0.3],'LineWidth',1.5);
        xlim([0.5, nT+0.5]);
        box on; grid on; hold off;
        
        savefig(fullfile(path_par,'group_fig',sprintf('EC-layers_%s_connectivity_bs.fig', hpc_regions{h})));
        saveas(gcf, fullfile(path_par,'group_fig',sprintf('EC-layers_%s_connectivity_bs.jpg', hpc_regions{h})),'jpg');
    end
end

%% export

excelFile = fullfile(path_par, 'connectivity_values.xlsx');
if exist(excelFile, 'file')
    delete(excelFile);
end

close all
for a1 = 1:5

    if a1 == 1
        rois        = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup'};
        folderlabel = 'mPFC';
    elseif a1 == 2
        rois        = {'RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        folderlabel = 'RSC';
    elseif a1 == 3
        rois        = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup', ...
                       'RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        folderlabel = 'all';
    elseif a1 == 4
        rois        = {'CA1','CA3','DG','Sub'};
        folderlabel = 'HPC';
    elseif a1 == 5
        rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup','CA1','CA3','DG','Sub'};
        layerFlag=1;
        folderlabel = 'all_2';
    end

    nS = numel(ids);
    nT = numel(tasks);
    nR = numel(rois);

    Z_all = nan(nS, nT, nR, nR);
    for s = 1:nS
        subj = ids{s};
        % Determine which tasks are available for this subject
        if ismember(subj, limited_ids)
            available_tasks = limited_tasks;
        else
            available_tasks = tasks;
        end
        
        for t = 1:nT
            % Check if this task is available for this subject
            if ismember(tasks{t}, available_tasks)
                fn = fullfile(path_par, [subj 'v1s1'], 'func' ,'laminar', folderlabel, ...
                             sprintf('Z_%s_%s.mat', subj, tasks{t}));
                if exist(fn, 'file')
                    try
                        tmp = load(fn, 'Z');
                        Z_all(s, t, :, :) = tmp.Z;
                    catch
                        warning('Failed to load: %s', fn);
                    end
                end
            end
        end
    end

    % Apply outlier removal to export data as well
    if REMOVE_OUTLIERS
        pairs = nchoosek(1:nR, 2);
        for p = 1:size(pairs, 1)
            i = pairs(p, 1);
            j = pairs(p, 2);
            
            if strcmp(OUTLIER_SCOPE, 'per_phase')
                for t = 1:nT
                    data = squeeze(Z_all(:, t, i, j));
                    valid_data = data(~isnan(data));
                    
                    if numel(valid_data) >= 4
                        outliers = detect_outliers(valid_data, OUTLIER_METHOD, OUTLIER_THRESHOLD);
                        
                        if any(outliers)
                            valid_idx = find(~isnan(data));
                            outlier_subjects = valid_idx(outliers);
                            Z_all(outlier_subjects, t, i, j) = NaN;
                        end
                    end
                end
            else
                data = squeeze(Z_all(:, :, i, j));
                valid_data = data(~isnan(data));
                
                if numel(valid_data) >= 4
                    outliers = detect_outliers(valid_data, OUTLIER_METHOD, OUTLIER_THRESHOLD);
                    
                    if any(outliers)
                        valid_idx = find(~isnan(data));
                        [sub_idx, phase_idx] = ind2sub(size(data), valid_idx(outliers));
                        for k = 1:numel(sub_idx)
                            Z_all(sub_idx(k), phase_idx(k), i, j) = NaN;
                        end
                    end
                end
            end
        end
    end

    pairs   = nchoosek(1:nR, 2);
    numRows = numel(pairs) * nT * nS;
    rows    = cell(numRows, 4);
    rCnt    = 0;

    % Order: ROI-pair → phase → subject
    for p = 1:size(pairs, 1)
        i = pairs(p, 1);
        j = pairs(p, 2);
        roiPair = [rois{i} '-' rois{j}];
        for t = 1:nT
            phaseName = tasks{t};
            for s = 1:nS
                subj = ids{s};
                rCnt = rCnt + 1;
                zVal = squeeze(Z_all(s, t, i, j));
                rows(rCnt, :) = {roiPair, phaseName, subj, zVal};
            end
        end
    end

    rows = rows(1:rCnt, :);
    T = cell2table(rows, ...
        'VariableNames', {'ROI_Pair','Phase','Subject','FisherZ'});
    writetable(T, excelFile, 'Sheet', folderlabel);

end


%% export 2 (rows: subjects, sheets: phases, columns: connections)

excelFile = fullfile(path_par, 'connectivity_values.xlsx');
if exist(excelFile, 'file')
    delete(excelFile);
end

% define ROI pairs and their names
rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup','CA1','CA3','DG','Sub'};
pairs     = nchoosek(1:numel(rois), 2);
pairNames = arrayfun(@(i,j) sprintf('%s-%s', rois{i}, rois{j}), ...
                     pairs(:,1), pairs(:,2), 'UniformOutput', false);

% Load Z_all one more time for export 2
nS = numel(ids);
nT = numel(tasks);
nR = numel(rois);

Z_all = nan(nS, nT, nR, nR);
folderlabel = 'all_2';
for s = 1:nS
    subj = ids{s};
    % Determine which tasks are available for this subject
    if ismember(subj, limited_ids)
        available_tasks = limited_tasks;
    else
        available_tasks = tasks;
    end
    
    for t = 1:nT
        % Check if this task is available for this subject
        if ismember(tasks{t}, available_tasks)
            fn = fullfile(path_par, [subj 'v1s1'], 'func' ,'laminar', folderlabel, ...
                         sprintf('Z_%s_%s.mat', subj, tasks{t}));
            if exist(fn, 'file')
                try
                    tmp = load(fn, 'Z');
                    Z_all(s, t, :, :) = tmp.Z;
                catch
                    warning('Failed to load: %s', fn);
                end
            end
        end
    end
end

% Apply outlier removal to export 2 data as well
if REMOVE_OUTLIERS
    pairs_export = nchoosek(1:nR, 2);
    for p = 1:size(pairs_export, 1)
        i = pairs_export(p, 1);
        j = pairs_export(p, 2);
        
        if strcmp(OUTLIER_SCOPE, 'per_phase')
            for t = 1:nT
                data = squeeze(Z_all(:, t, i, j));
                valid_data = data(~isnan(data));
                
                if numel(valid_data) >= 4
                    outliers = detect_outliers(valid_data, OUTLIER_METHOD, OUTLIER_THRESHOLD);
                    
                    if any(outliers)
                        valid_idx = find(~isnan(data));
                        outlier_subjects = valid_idx(outliers);
                        Z_all(outlier_subjects, t, i, j) = NaN;
                    end
                end
            end
        else
            data = squeeze(Z_all(:, :, i, j));
            valid_data = data(~isnan(data));
            
            if numel(valid_data) >= 4
                outliers = detect_outliers(valid_data, OUTLIER_METHOD, OUTLIER_THRESHOLD);
                
                if any(outliers)
                    valid_idx = find(~isnan(data));
                    [sub_idx, phase_idx] = ind2sub(size(data), valid_idx(outliers));
                    for k = 1:numel(sub_idx)
                        Z_all(sub_idx(k), phase_idx(k), i, j) = NaN;
                    end
                end
            end
        end
    end
end

% write one sheet per phase
for t = 1:numel(tasks)
    phase = tasks{t};
    % prepare table with Subject column
    T = table(ids', 'VariableNames', {'Subject'});
    % add connectivity columns
    for p = 1:size(pairs, 1)
        i = pairs(p, 1);
        j = pairs(p, 2);
        T.(pairNames{p}) = squeeze(Z_all(:, t, i, j));
    end
    % write to Excel
    writetable(T, excelFile, 'Sheet', phase);
end

%% ========== OUTLIER DETECTION FUNCTION ========== %%
function outliers = detect_outliers(data, method, threshold)
    % Detect outliers in data using specified method and threshold
    % data: vector of values (NaNs should already be removed)
    % method: 'mad', 'zscore', or 'iqr'
    % threshold: threshold value for the chosen method
    % Returns: logical vector indicating outliers
    
    outliers = false(size(data));
    
    if numel(data) < 4
        return;  % Need at least 4 points
    end
    
    switch lower(method)
        case 'mad'
            % Median Absolute Deviation (robust to outliers)
            med = median(data);
            mad = median(abs(data - med));
            if mad == 0
                mad = mean(abs(data - med));  % Fallback if MAD is zero
            end
            if mad > 0
                modified_z = 0.6745 * (data - med) / mad;
                outliers = abs(modified_z) > threshold;
            end
            
        case 'zscore'
            % Standard Z-score method
            mu = mean(data);
            sigma = std(data);
            if sigma > 0
                z = (data - mu) / sigma;
                outliers = abs(z) > threshold;
            end
            
        case 'iqr'
            % Interquartile Range method
            q1 = prctile(data, 25);
            q3 = prctile(data, 75);
            iqr_val = q3 - q1;
            lower_bound = q1 - threshold * iqr_val;
            upper_bound = q3 + threshold * iqr_val;
            outliers = (data < lower_bound) | (data > upper_bound);
            
        otherwise
            error('Unknown outlier detection method: %s', method);
    end
end
