%% NORDIC DWI denoising pipeline for ENGRAMS
%
% all diffusion data (all b-values, all directions, all PE directions)
% are merged before NORDIC to make sure we got proper noise estimation
%
% maybe helpful ref: Vizioli, L., Moeller, S., Dowdle, L., Akçakaya, M., De Martino, F.,
%   Yacoub, E., & Uğurbil, K. (2021). Lowering the thermal noise barrier in
%   functional brain mapping with magnetic resonance imaging. Nature Communications,
%   12(1), 5181. https://doi.org/10.1038/s41467-021-25431-8

% version control ==> 
% 20251004: alex: initial version with separate shell processing
% 20260127: alex: revised to merge all shells before nordic per yi-hang's advice

clc; clear

%% prep

addpath('/mnt/work/yyi/ENGRAMS/scripts/NORDIC');

% subjs
subjlist = {'sub-207v1s1'};

% define all acquisitions in the order they will be concatenated
% >> this order must match what the bash script expects! <<
acquisitions = {
    'b1pt0k-AP', ...
    'b1pt0k-PA', ...
    'b2pt5k-AP', ...
    'b2pt5k-PA'
};

%% run nordic

for s1 = 1:length(subjlist)
    
    subj = subjlist{s1};
    dwi_dir = fullfile('/mnt/work/yyi/ENGRAMS/preproc', subj, 'dwi');
    out_dir = fullfile('/mnt/work/yyi/ENGRAMS/analyses', subj, 'dwi', 'nordic');
    
    if ~exist(out_dir, 'dir')
        mkdir(out_dir);
    end
    
    fprintf('\n========================================\n');
    fprintf('Processing %s\n', subj);
    fprintf('========================================\n');
    
    %% collect all files and count volumes

    n_acq = length(acquisitions);
    mag_files = cell(1, n_acq);
    phase_files = cell(1, n_acq);
    vol_counts = zeros(1, n_acq);
    
    fprintf('\nchecking input files...\n');
    for i = 1:n_acq
        acq = acquisitions{i};
        mag_files{i} = fullfile(dwi_dir, sprintf('%s_%s_dwi.nii.gz', subj, acq));
        phase_files{i} = fullfile(dwi_dir, sprintf('%s_%s_dwi_ph.nii.gz', subj, acq));
        
        % verify files are there
        if ~exist(mag_files{i}, 'file')
            error('Magnitude file not found: %s', mag_files{i});
        end
        if ~exist(phase_files{i}, 'file')
            error('Phase file not found: %s', phase_files{i});
        end
        
        % get volume count (they're all the same but just in case)
        info_tmp = niftiinfo(mag_files{i});
        if length(info_tmp.ImageSize) == 4
            vol_counts(i) = info_tmp.ImageSize(4);
        else
            vol_counts(i) = 1;
        end
        fprintf('  %s: %d volumes\n', acq, vol_counts(i));
    end
    
    total_vols = sum(vol_counts);
    fprintf('total volumes to process: %d\n', total_vols);
    
    %% save vol counts for bash script
    %  i'm planning to compile this script and run at superdome flex so
    %  echoing the details of processes will be super helpful

    vol_info_file = fullfile(out_dir, sprintf('%s_volume_info.txt', subj));
    fid = fopen(vol_info_file, 'w');
    fprintf(fid, '# volume counts for each acquisition (in concatenation order)\n');
    fprintf(fid, '# format: acquisition_name volume_count\n');
    for i = 1:n_acq
        fprintf(fid, '%s %d\n', acquisitions{i}, vol_counts(i));
    end
    fprintf(fid, '# Total: %d\n', total_vols);
    fclose(fid);
    fprintf('volume info saved to: %s\n', vol_info_file);
    
    %% load ref header from first acquisition

    fprintf('\nloading reference header...\n');
    ref_info = niftiinfo(mag_files{1});
    
    %% concat all magnitude and phase data

    fprintf('merging all acquisitions...\n');
    
    % preallocate based on first file dimensions
    first_mag = niftiread(mag_files{1});
    [nx, ny, nz, ~] = size(first_mag);
    
    mag_all = zeros(nx, ny, nz, total_vols, 'like', first_mag);
    phase_all = zeros(nx, ny, nz, total_vols, 'like', first_mag);
    
    vol_idx = 1;
    for i = 1:n_acq
        fprintf('  loading %s...\n', acquisitions{i});
        
        if i == 1
            nii_mag = first_mag;  % already loaded
        else
            nii_mag = niftiread(mag_files{i});
        end
        nii_phase = niftiread(phase_files{i});
        
        % Insert into preallocated array
        mag_all(:,:,:,vol_idx:vol_idx+vol_counts(i)-1) = nii_mag;
        phase_all(:,:,:,vol_idx:vol_idx+vol_counts(i)-1) = nii_phase;
        
        vol_idx = vol_idx + vol_counts(i);
    end
    clear first_mag nii_mag nii_phase  % free up memory
    
    %% write temporary merged niftiis with preserved header
    %  also just in case because i had unexpected problems with this a while ago

    fprintf('writing merged niftii files...\n');
    
    merged_mag_file = fullfile(out_dir, sprintf('%s_all_merged_dwi.nii', subj));
    merged_phase_file = fullfile(out_dir, sprintf('%s_all_merged_dwi_ph.nii', subj));
    
    % update header for merged data
    merged_info = ref_info;
    merged_info.ImageSize = [nx, ny, nz, total_vols];
    merged_info.PixelDimensions = ref_info.PixelDimensions(1:4);
    if length(merged_info.PixelDimensions) < 4
        merged_info.PixelDimensions(4) = ref_info.PixelDimensions(end);
    end
    
    % remove .gz extension handling (niftiwrite adds it based on compressed flag)
    merged_mag_file = regexprep(merged_mag_file, '\.gz$', '');
    merged_phase_file = regexprep(merged_phase_file, '\.gz$', '');
    
    % write uncompressed niftii (nordic annoyingly expects uncompressed input)
    niftiwrite(mag_all, merged_mag_file, merged_info, 'Compressed', false);
    niftiwrite(phase_all, merged_phase_file, merged_info, 'Compressed', false);
    
    clear mag_all phase_all  % free memory before nordic
    
    %% finally run nordic

    fprintf('\nrunning nordic on combined data (%d volumes)...\n', total_vols);
    
    ARG = [];
    ARG.temporal_phase = 1;          % use temporal phase information
    ARG.phase_filter_width = 1;      % phase filter width
    ARG.DIROUT = [out_dir '/'];      % output directory (must end with /)
    ARG.save_add_info = 1;           % save additional info (g-factor maps, etc)
    ARG.write_gzipped_niftis = 1;    % compress output
    ARG.use_generic_NII_read = 0;    % i don't know what this is but only works with this option so far
    
    output_name = sprintf('%s_all_nordic', subj);
    
    tic
    NIFTI_NORDIC(merged_mag_file, merged_phase_file, output_name, ARG);
    elapsed = toc;
    
    fprintf('nordic done in %.1f minutes\n', elapsed/60);
    
    %% clean up temporary files 
    % fprintf('Cleaning up temporary merged files...\n');
    % delete(merged_mag_file);
    % delete(merged_phase_file);
    
    %% verify output exists

    nordic_output = fullfile(out_dir, sprintf('%s_all_nordic.nii.gz', subj));
    if exist(nordic_output, 'file')
        fprintf('\nnordic output is there: %s\n', nordic_output);
        out_info = niftiinfo(nordic_output);
        fprintf('output dimensions: [%s]\n', num2str(out_info.ImageSize));
    else
        warning('nordic output not found! something''s wrong...');
    end
    
    fprintf('\n========================================\n');
    fprintf('done processing for %s\n', subj);
    fprintf('========================================\n');
    
end

fprintf('\nall subjects done\n');
