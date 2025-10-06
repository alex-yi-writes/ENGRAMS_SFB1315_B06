%% nordic dwi denoising pipeline for ENGRAMS
%  need mag and phase dwi for this
%  20251004: alex: i read that MP-PCA is better but i haven't quite figured
%               out how to use it so for now i do this...

clc;clear

% make sure NORDIC is seen
addpath('/Users/alex/Documents/MATLAB/NORDIC_Raw');

% paths
subj = 'sub-302v1s2';
dwi_dir = '/Users/alex/Dropbox/paperwriting/1315/data/dwi_pipeline/sub-302v1s2/dwi';
out_dir = '/Users/alex/Dropbox/paperwriting/1315/data/dwi_pipeline/sub-302v1s2/nordic';

% create workspace
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

%% run each acquisition

acquisitions = {
    'b1pt0k-AP', 'b1pt0k-PA', ...
    'b2pt5k-AP', 'b2pt5k-PA'
};

for i = 1:length(acquisitions)

    acq = acquisitions{i};

    fprintf('\n processing %s \n', acq);
    
    % files
    mag_file = fullfile(dwi_dir, sprintf('%s_%s_dwi.nii.gz', subj, acq));
    phase_file = fullfile(dwi_dir, sprintf('%s_%s_dwi_ph.nii.gz', subj, acq));
    output_name = sprintf('%s_%s_nordic', subj, acq);
    
    % params (dwi specific)
    ARG=[];
    ARG.temporal_phase = 3;
    ARG.phase_filter_width = 3;
    ARG.DIROUT = out_dir;
    ARG.save_add_info = 1;
    ARG.write_gzipped_niftis = 1;
    ARG.use_generic_NII_read = 0;  % force use of niftiread, not load_nii (it bugs)
    
    % actually run NORDIC
    disp('running NORDIC\n');
    tic; % ding ding ding (does it always take this long?)
    NIFTI_NORDIC(mag_file, phase_file, output_name, ARG);
    elapsed = toc;

    fprintf('NORDIC completed in %.1f minutes\n', elapsed/60);

end

fprintf('all done for %s \n', subj);

%% QA (attempt 1)

disp('QA start')

for i = 1:length(acquisitions)

    acq = acquisitions{i};
    
    original_file = fullfile(dwi_dir, sprintf('%s_%s_dwi.nii.gz', subj, acq));
    nordic_file = fullfile(out_dir, sprintf('%s_%s_nordic.nii.gz', subj, acq));
    
    orig_nii = load_untouch_nii(original_file);
    nordic_nii = load_untouch_nii(nordic_file);
    
    orig_data = double(orig_nii.img);
    nordic_data = double(nordic_nii.img);
    
    % calc SNR improvement in b0 volumes (first few volumes)
    b0_vol = 1;
    
    orig_b0 = orig_data(:,:,:,b0_vol);
    nordic_b0 = nordic_data(:,:,:,b0_vol);
    
    % simple SNR estimate: mean/std in ROI (right now it's just the whole tissue)
    brain_mask = orig_b0 > (0.1 * max(orig_b0(:)));
    
    orig_snr = mean(orig_b0(brain_mask)) / std(orig_b0(brain_mask));
    nordic_snr = mean(nordic_b0(brain_mask)) / std(nordic_b0(brain_mask));
    
    improvement = (nordic_snr - orig_snr) / orig_snr * 100;
    
    fprintf('%s: raw SNR = %.2f, denoised(NORDIC) SNR = %.2f (%.1f%% improvement)\n', ...
        acq, orig_snr, nordic_snr, improvement);
end

%% QA (attempt 2)

disp('QA start')

acquisitions = {
    'b1pt0k-AP', 'b1pt0k-PA', ...
    'b2pt5k-AP', 'b2pt5k-PA'
};

results = struct();

for i = 1:length(acquisitions)
    acq = acquisitions{i};

    fprintf('\nQA for %s...\n', acq);
    
    % load files
    original_file = fullfile(dwi_dir, sprintf('%s_%s_dwi.nii.gz', subj, acq));
    nordic_file = fullfile(out_dir, sprintf('%s_%s_nordic.nii.gz', subj, acq));
    
    orig_data = double(niftiread(original_file));
    nordic_data = double(niftiread(nordic_file));
    
    % b0 for snr calculations
    orig_b0 = orig_data(:,:,:,1);
    nordic_b0 = nordic_data(:,:,:,1);
    
    % brain mask
    brain_mask = orig_b0 > (0.1 * max(orig_b0(:)));
    
    % snr (signal mean / noise std)
    orig_signal = mean(orig_b0(brain_mask));
    orig_noise = std(orig_b0(brain_mask));
    orig_snr = orig_signal / orig_noise;
    
    nordic_signal = mean(nordic_b0(brain_mask));
    nordic_noise = std(nordic_b0(brain_mask));
    nordic_snr = nordic_signal / nordic_noise;
    
    % calc improvement metrics
    snr_improvement = ((nordic_snr - orig_snr) / orig_snr) * 100;
    
    % tsnr
    orig_temporal_mean = mean(orig_data, 4);
    orig_temporal_std = std(orig_data, 0, 4);
    orig_tsnr = orig_temporal_mean ./ (orig_temporal_std + eps);
    orig_tsnr_mean = mean(orig_tsnr(brain_mask));
    
    nordic_temporal_mean = mean(nordic_data, 4);
    nordic_temporal_std = std(nordic_data, 0, 4);
    nordic_tsnr = nordic_temporal_mean ./ (nordic_temporal_std + eps);
    nordic_tsnr_mean = mean(nordic_tsnr(brain_mask));
    
    tsnr_improvement = ((nordic_tsnr_mean - orig_tsnr_mean) / orig_tsnr_mean) * 100;
    
    % store data
    results(i).acquisition = acq;
    results(i).orig_snr = orig_snr;
    results(i).nordic_snr = nordic_snr;
    results(i).snr_improvement_pct = snr_improvement;
    results(i).orig_tsnr = orig_tsnr_mean;
    results(i).nordic_tsnr = nordic_tsnr_mean;
    results(i).tsnr_improvement_pct = tsnr_improvement;
    
    % results
    fprintf('  Original SNR (b0):  %.2f\n', orig_snr);
    fprintf('  NORDIC SNR (b0):    %.2f\n', nordic_snr);
    fprintf('  SNR improvement:    %.1f%%\n', snr_improvement);
    fprintf('  Original tSNR:      %.2f\n', orig_tsnr_mean);
    fprintf('  NORDIC tSNR:        %.2f\n', nordic_tsnr_mean);
    fprintf('  tSNR improvement:   %.1f%%\n', tsnr_improvement);
end

% summary table
fprintf('\n **** summary ****\n');
fprintf('%-12s %10s %10s %12s %10s %10s %12s\n', ...
    'acquisition', 'orig SNR', 'NORDIC SNR', 'SNR benefits (%)', ...
    'orig tSNR', 'NORDIC tSNR', 'tSNR benefits (%)');
fprintf('%s\n', repmat('-', 1, 90));

for i = 1:length(results)
    fprintf('%-12s %10.2f %10.2f %12.1f %10.2f %10.2f %12.1f\n', ...
        results(i).acquisition, ...
        results(i).orig_snr, results(i).nordic_snr, results(i).snr_improvement_pct, ...
        results(i).orig_tsnr, results(i).nordic_tsnr, results(i).tsnr_improvement_pct);
end

%% make figs

figure('Position', [100 100 1200 800]);

for i = 1:length(acquisitions)
    acq = acquisitions{i};
    
    % load data
    original_file = fullfile(dwi_dir, sprintf('%s_%s_dwi.nii.gz', subj, acq));
    nordic_file = fullfile(out_dir, sprintf('%s_%s_nordic.nii.gz', subj, acq));
    
    orig_data = double(niftiread(original_file));
    nordic_data = double(niftiread(nordic_file));
    
    % better looking slice from b0 vol
    mid_slice = round(size(orig_data, 3) / 2);
    orig_slice = orig_data(:,:,mid_slice,1);
    nordic_slice = nordic_data(:,:,mid_slice,1);
    
    % plot
    subplot(2, 4, i);
    imshow(orig_slice, []);
    title(sprintf('%s original', acq));
    colorbar;
    
    subplot(2, 4, i + 4);
    imshow(nordic_slice, []);
    title(sprintf('%s NORDIC', acq));
    colorbar;
end

sgtitle(sprintf('%s: original vs NORDIC denoising', subj));

% % save
% saveas(gcf, fullfile(out_dir, sprintf('%s_quality_check.png', subj)));
% fprintf('\nQA fig saved to: %s\n', ...
%     fullfile(out_dir, sprintf('%s_quality_check.png', subj)));