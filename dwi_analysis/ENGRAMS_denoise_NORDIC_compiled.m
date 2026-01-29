function ENGRAMS_denoise_NORDIC_compiled(subject_id, base_dir, temporal_phase_value)
% ENGRAMS_denoise_NORDIC_compiled - compiled version for SDFlex
%
% Usage (compiled):
%   ./run_ENGRAMS_denoise_NORDIC_compiled.sh <MCR_ROOT> <subject_id> <base_dir>
%
% Example:
%   ./run_ENGRAMS_denoise_NORDIC_compiled.sh /share/apps/mcr/R2023b sub-207v1s1 /mnt/work/yyi/ENGRAMS
%
% Inputs:
%   subject_id - Subject identifier (e.g., 'sub-207v1s1')
%   base_dir   - Base directory containing preproc/ and analyses/ folders
%
% 20260127: alex: compiled version for Superdome Flex cluster

% Input validation
if nargin < 3
    error('Usage: ENGRAMS_denoise_NORDIC_compiled(subject_id, base_dir, temporal_phase_value)');
end

% Handle compiled inputs (they come in as strings)
if isdeployed
    if ischar(subject_id)
        subject_id = strtrim(subject_id);
    end
    if ischar(base_dir)
        base_dir = strtrim(base_dir);
    end
    if isnumeric(temporal_phase_value)
        temporal_phase_value=double(temporal_phase_value);
    end
end

fprintf('\n========================================\n');
fprintf('NORDIC Denoising (Compiled Version)\n');
fprintf('========================================\n');
fprintf('Subject: %s\n', subject_id);
fprintf('Base directory: %s\n', base_dir);
fprintf('Started: %s\n', datestr(now));
fprintf('========================================\n\n');

% Setup paths
dwi_dir = fullfile(base_dir, 'preproc', subject_id, 'dwi');
out_dir = fullfile(base_dir, 'analyses', subject_id, 'dwi', 'nordic');

if ~exist(dwi_dir, 'dir')
    error('DWI directory not found: %s', dwi_dir);
end

if ~exist(out_dir, 'dir')
    mkdir(out_dir);
    fprintf('Created output directory: %s\n', out_dir);
end

% Define acquisitions (order matters!)
acquisitions = {'b1pt0k-AP', 'b1pt0k-PA', 'b2pt5k-AP', 'b2pt5k-PA'};

% Collect all files and count volumes
n_acq = length(acquisitions);
mag_files = cell(1, n_acq);
phase_files = cell(1, n_acq);
vol_counts = zeros(1, n_acq);

fprintf('Checking input files...\n');
for i = 1:n_acq
    acq = acquisitions{i};
    mag_files{i} = fullfile(dwi_dir, sprintf('%s_%s_dwi.nii.gz', subject_id, acq));
    phase_files{i} = fullfile(dwi_dir, sprintf('%s_%s_dwi_ph.nii.gz', subject_id, acq));
    
    % Verify files exist
    if ~exist(mag_files{i}, 'file')
        error('Magnitude file not found: %s', mag_files{i});
    end
    if ~exist(phase_files{i}, 'file')
        error('Phase file not found: %s', phase_files{i});
    end
    
    % Get volume count
    info_tmp = niftiinfo(mag_files{i});
    if length(info_tmp.ImageSize) == 4
        vol_counts(i) = info_tmp.ImageSize(4);
    else
        vol_counts(i) = 1;
    end
    fprintf('  %s: %d volumes\n', acq, vol_counts(i));
end

total_vols = sum(vol_counts);
fprintf('Total volumes to process: %d\n', total_vols);

% Save volume counts for bash script
vol_info_file = fullfile(out_dir, sprintf('%s_volume_info.txt', subject_id));
fid = fopen(vol_info_file, 'w');
if fid == -1
    error('Cannot write volume info file: %s', vol_info_file);
end
fprintf(fid, '# Volume counts for each acquisition (in concatenation order)\n');
fprintf(fid, '# Format: acquisition_name volume_count\n');
for i = 1:n_acq
    fprintf(fid, '%s %d\n', acquisitions{i}, vol_counts(i));
end
fprintf(fid, '# Total: %d\n', total_vols);
fclose(fid);
fprintf('Volume info saved to: %s\n', vol_info_file);

% Load reference header from first acquisition
fprintf('\nLoading reference header...\n');
ref_info = niftiinfo(mag_files{1});

% Concatenate all magnitude and phase data
fprintf('Merging all acquisitions...\n');

% Preallocate based on first file dimensions
first_mag = niftiread(mag_files{1});
[nx, ny, nz, ~] = size(first_mag);

% Determine data type
data_type = class(first_mag);
fprintf('Data type: %s\n', data_type);
fprintf('Matrix size: %d x %d x %d x %d\n', nx, ny, nz, total_vols);

mag_all = zeros(nx, ny, nz, total_vols, data_type);
phase_all = zeros(nx, ny, nz, total_vols, data_type);

vol_idx = 1;
for i = 1:n_acq
    fprintf('  Loading %s (%d/%d)...\n', acquisitions{i}, i, n_acq);
    
    if i == 1
        nii_mag = first_mag;
    else
        nii_mag = niftiread(mag_files{i});
    end
    nii_phase = niftiread(phase_files{i});
    
    % Insert into preallocated array
    mag_all(:,:,:,vol_idx:vol_idx+vol_counts(i)-1) = nii_mag;
    phase_all(:,:,:,vol_idx:vol_idx+vol_counts(i)-1) = nii_phase;
    
    vol_idx = vol_idx + vol_counts(i);
end
clear first_mag nii_mag nii_phase

% Write temporary merged NIfTIs with preserved header
fprintf('Writing merged NIfTI files...\n');

merged_mag_file = fullfile(out_dir, sprintf('%s_all_merged_dwi.nii', subject_id));
merged_phase_file = fullfile(out_dir, sprintf('%s_all_merged_dwi_ph.nii', subject_id));

% Update header for merged data
merged_info = ref_info;
merged_info.ImageSize = [nx, ny, nz, total_vols];
if length(ref_info.PixelDimensions) >= 4
    merged_info.PixelDimensions = ref_info.PixelDimensions(1:4);
else
    merged_info.PixelDimensions = [ref_info.PixelDimensions, 1];
end

% Write uncompressed NIfTI
niftiwrite(mag_all, merged_mag_file, merged_info, 'Compressed', false);
fprintf('  Written: %s\n', merged_mag_file);
niftiwrite(phase_all, merged_phase_file, merged_info, 'Compressed', false);
fprintf('  Written: %s\n', merged_phase_file);

clear mag_all phase_all

% Run NORDIC
fprintf('\n========================================\n');
fprintf('Running NORDIC on combined data (%d volumes)...\n', total_vols);
fprintf('This may take a while...\n');
fprintf('========================================\n');

ARG = [];
ARG.temporal_phase = temporal_phase_value;
ARG.phase_filter_width = 3;
ARG.DIROUT = [out_dir '/'];
ARG.save_add_info = 1;
ARG.write_gzipped_niftis = 1;
ARG.use_generic_NII_read = 0;
ARG.noise_volume_last = 0;

output_name = sprintf('%s_all_nordic', subject_id);

tic
try
    NIFTI_NORDIC(merged_mag_file, merged_phase_file, output_name, ARG);
catch ME
    fprintf('ERROR in NORDIC: %s\n', ME.message);
    fprintf('Stack trace:\n');
    disp(ME.stack);
    rethrow(ME);
end
elapsed = toc;

fprintf('\nNORDIC completed in %.1f minutes (%.1f hours)\n', elapsed/60, elapsed/3600);

% Clean up temporary files
fprintf('Cleaning up temporary merged files...\n');
if exist(merged_mag_file, 'file')
    delete(merged_mag_file);
end
if exist(merged_phase_file, 'file')
    delete(merged_phase_file);
end

% Verify output exists
nordic_output = fullfile(out_dir, sprintf('%s_all_nordic.nii.gz', subject_id));
if exist(nordic_output, 'file')
    fprintf('\nNORDIC output verified: %s\n', nordic_output);
    out_info = niftiinfo(nordic_output);
    fprintf('Output dimensions: [%s]\n', num2str(out_info.ImageSize));
    
    % Get file size
    file_info = dir(nordic_output);
    fprintf('Output file size: %.2f GB\n', file_info.bytes / 1e9);
else
    error('NORDIC output not found at expected location: %s', nordic_output);
end

% Write completion marker
completion_file = fullfile(out_dir, sprintf('%s_nordic_complete.txt', subject_id));
fid = fopen(completion_file, 'w');
fprintf(fid, 'NORDIC processing completed successfully\n');
fprintf(fid, 'Subject: %s\n', subject_id);
fprintf(fid, 'Completed: %s\n', datestr(now));
fprintf(fid, 'Processing time: %.1f minutes\n', elapsed/60);
fprintf(fid, 'Output: %s\n', nordic_output);
fclose(fid);

fprintf('\n========================================\n');
fprintf('Completed processing for %s\n', subject_id);
fprintf('Finished: %s\n', datestr(now));
fprintf('========================================\n');

end
