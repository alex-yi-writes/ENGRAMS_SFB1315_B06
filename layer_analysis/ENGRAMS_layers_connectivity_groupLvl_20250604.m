%% prep

clc;clear
tasks   = {'rest','origenc','origrec'};
% tasks   = {'rest','origenc'};
ids     = {'sub-104','sub-106','sub-107','sub-108','sub-109','sub-202'};

path_par= '/Users/alex/Dropbox/paperwriting/1315/data/segmentation/';

%% with significance bar

close all

for a1 = 1:4

    if a1 == 1
        % ========== mPFC ========== %
        rois        = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup'};
        layerFlag   = 1;
        folderlabel = 'mPFC';
        % ========================== %
    elseif a1 == 2
        % =========== RSC ========== %
        rois        = {'RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        layerFlag   = 1;
        folderlabel = 'RSC';
        % ========================== %
    elseif a1 == 3
        % ====== all cortices ====== %
        rois        = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        layerFlag   = 1;
        folderlabel = 'all';
        % ========================== %
    elseif a1 == 4
        % =========== HPC ========== %
        rois        = {'CA1','CA3','DG','Sub'};
        layerFlag   = 0;
        folderlabel = 'HPC';
        % ========================== %
    end

    % preallocate
    Z_all = nan(numel(ids), numel(tasks), numel(rois), numel(rois));

    % load all Zs into a 4D array
    for id = 1:numel(ids)
        subj = ids{id};
        for t1 = 1:numel(tasks)
            fn  = fullfile(path_par, [subj 'v1s1'], 'analyses', folderlabel, ...
                          sprintf('Z_%s_%s.mat', subj, tasks{t1}));
            tmp = load(fn, 'Z');
            Z_all(id, t1, :, :) = tmp.Z;
        end
    end

    % get all unique pairs i<j
    pairs = nchoosek(1:numel(rois), 2);

    % loop over each connection
    for p = 1:size(pairs, 1)
        i = pairs(p, 1);
        j = pairs(p, 2);
        fig = figure; hold on;

        % plot each subject's trajectory
        for id = 1:numel(ids)
            y = squeeze(Z_all(id, :, i, j));      % phases × 1
            plot(1:numel(tasks), y, '--', 'Color', [0.7 0.7 0.1*id]);
        end

        % overlay the group mean ± SEM
        Ymean = squeeze(mean(Z_all(:, :, i, j), 1));         % 1*phases
        Ysem  = squeeze(std(Z_all(:, :, i, j), [], 1)) / sqrt(numel(ids));
        fill([1:numel(tasks) fliplr(1:numel(tasks))], [Ymean + Ysem fliplr(Ymean - Ysem)], ...
             [0.8 0.8 1], 'EdgeColor', 'none', 'FaceAlpha', 0.4);
        plot(1:numel(tasks), Ymean, '-o', 'LineWidth', 2, 'Color', [0 0 0.8]);

        set(gca, 'XTick', 1:numel(tasks), 'XTickLabel', tasks, 'FontSize', 12);
        xlabel('phase', 'FontSize', 14);
        ylabel(sprintf('fisher-z(%s–%s)', rois{i}, rois{j}), 'FontSize', 14);
        title(sprintf('%s – %s connectivity', rois{i}, rois{j}), 'FontSize', 16,'Interpreter','none');

        % perform paired t-tests for all comparisons
        comps = [1 2; 2 3; 1 3];  % include rest vs origrec
        Yall  = squeeze(Z_all(:, :, i, j));  % subjects*phases
        pvals = nan(size(comps, 1), 1);
        for c = 1:size(comps, 1)
            x1 = Yall(:, comps(c, 1));
            x2 = Yall(:, comps(c, 2));
            [~, pvals(c)] = ttest(x1, x2);
        end

        % determine y positions for bars
        y_max   = 0.4;
        % y_min   = 0.2;
        % y_max   = max(Ymean + Ysem);
        y_min   = min(Ymean - Ysem);
        y_range = y_max - y_min;
        off     = 0.1 * y_range;
        hbar    = 0.02 * y_range;
        ncomp   = size(comps, 1);
        y_bases = y_max + off * (1:ncomp);

        % extend y limits to fit bars
        ylim([y_min, y_max + off * (ncomp + 1) + hbar]);

        % draw significance bars and asterisks
        for c = 1:ncomp
            x1 = comps(c, 1);
            x2 = comps(c, 2);
            y0 = y_bases(c);
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

        xlim([0.5, numel(tasks) + 0.5]); ylim([-0.8 0.8])
        box on;
        hold off;

        % save
        savefig(fig, fullfile(path_par, 'group_fig', ...
                 sprintf('%s_%s_vs_%s_sigTest.fig', folderlabel, rois{i}, rois{j})));
        saveas(fig, fullfile(path_par, 'group_fig', ...
            sprintf('%s_%s_vs_%s_sigTest.jpg', folderlabel, rois{i}, rois{j})), 'jpg');
    end

    % compute group‐mean fisher‐z matrix for each phase
    Z_group = squeeze(mean(Z_all, 1));  % size: numel(tasks) × numel(rois) × numel(rois)

    thr_r = 0.1;   % normally 0.2 but we have very few subjs so...

    for t1 = 1:numel(tasks)
        Zg = squeeze(Z_group(t1, :, :));   % numel(rois) × numel(rois)
        Zg(isnan(Zg)) = 0;
        Zg = (Zg + Zg.') / 2;
        Rg = tanh(Zg);

        % threshold adjacency at |r|>thr_r  (but thr_r=0, so this keeps everything)
        Ag = Rg .* ~eye(numel(rois));
        Ag(abs(Ag) < thr_r) = 0;   % with thr_r=0, only exact zeros get removed

        % extract edges
        [i_idx, j_idx, vg] = find(triu(Ag, 1));

        % compute p‐values (one‐sample t‐test against zero, uncorrected)
        pmat = ones(numel(rois), numel(rois));
        for i2 = 1:numel(rois)
            for j2 = i2+1:numel(rois)
                data = squeeze(Z_all(:, t1, i2, j2));
                [~, p] = ttest(data, 0);
                pmat(i2, j2) = p;
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

            colormap(redblue);
            caxis([-1 1]);
            colorbar('Ticks', [-1 -0.5 0 0.5 1], 'Location', 'west');
        end

        axis off equal
        title({['Group‐level |pearson''s r| (all edges shown)'], ['phase: ' tasks{t1}]}, ...
              'FontSize', 20, 'FontWeight', 'bold');

        % save graph
        graphName = sprintf('group_connectivities_%s_%s', folderlabel, tasks{t1});
        figPathG  = fullfile(path_par, 'group_fig', [graphName '.fig']);
        savefig(figG, figPathG);
        saveas(figG, strrep(figPathG, '.fig', '.jpg'), 'jpg');

        % plot heatmap of Zg
        figH = figure;
        imagesc(Zg); axis square
        set(gca, 'XTick', 1:numel(rois), 'XTickLabel', rois, ...
                 'YTick', 1:numel(rois), 'YTickLabel', rois, ...
                 'TickLabelInterpreter', 'none');
        colormap(redblue); caxis([-1 1]);
        colorbar;
        title({['Group‐level ROI connectivity (fisher-z)'], ['phase: ' tasks{t1}]});

        % save heatmap
        heatName = sprintf('group_heatmap_%s_%s', folderlabel, tasks{t1});
        figPathH  = fullfile(path_par, 'group_fig', [heatName '.fig']);
        savefig(figH, figPathH);
        saveas(figH, strrep(figPathH, '.fig', '.jpg'), 'jpg');
    end

end