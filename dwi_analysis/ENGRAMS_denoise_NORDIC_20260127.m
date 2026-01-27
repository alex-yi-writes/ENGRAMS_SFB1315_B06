% nordic dwi denoising pipeline for ENGRAMS
%  need mag and phase dwi for this
%  20251004: alex: i read that MP-PCA is better but i haven't quite figured
%               out how to use it so for now i do this...

clc; clear

% make sure NORDIC is seen
addpath('/mnt/work/yyi/ENGRAMS/scripts/NORDIC');

% subject list
subjlist = {'sub-207v1s1'};

% acquisitions (will merge shells per acquisition type)
acquisitions = {
    'b1pt0k', 'b2pt5k'
};

% shell suffixes
shells = {'-AP', '-PA'};

for s1 = 1:length(subjlist)
    
    subj = subjlist{s1};
    dwi_dir = fullfile('/mnt/work/yyi/ENGRAMS/preproc', subj, 'dwi');
    out_dir = fullfile('/mnt/work/yyi/ENGRAMS/analyses', subj, 'dwi', 'nordic');
    
    if ~exist(out_dir, 'dir')
        mkdir(out_dir);
    end
    
    for i = 1:length(acquisitions)
        acq_base = acquisitions{i};
        
        fprintf('\nProcessing merged shells for %s\n', acq_base);
        
        % collect magnitude and phase files
        mag_files = cell(1, length(shells));
        phase_files = cell(1, length(shells));
        for sh = 1:length(shells)
            mag_files{sh} = fullfile(dwi_dir, sprintf('%s%s_dwi.nii.gz', subj, [acq_base shells{sh}]));
            phase_files{sh} = fullfile(dwi_dir, sprintf('%s%s_dwi_ph.nii.gz', subj, [acq_base shells{sh}]));
        end
        
        % load and concatenate shells
        fprintf('Merging shells...\n');
        mag_all = [];
        phase_all = [];
        for sh = 1:length(shells)
            nii_mag = niftiread(mag_files{sh});
            nii_phase = niftiread(phase_files{sh});
            mag_all = cat(4, mag_all, nii_mag);
            phase_all = cat(4, phase_all, nii_phase);
        end
        
        % write temporary merged NIfTIs
        merged_mag_file = fullfile(out_dir, sprintf('%s_%s_merged_dwi.nii', subj, acq_base));
        merged_phase_file = fullfile(out_dir, sprintf('%s_%s_merged_dwi_ph.nii', subj, acq_base));
        niftiwrite(mag_all, merged_mag_file);
        niftiwrite(phase_all, merged_phase_file);
        
        % NORDIC params (default)
        ARG = [];
        ARG.temporal_phase = 1;
        ARG.phase_filter_width = 1;
        ARG.DIROUT = [out_dir '/'];
        ARG.save_add_info = 1;
        ARG.write_gzipped_niftis = 1;
        ARG.use_generic_NII_read = 0;
        
        % run NORDIC
        output_name = sprintf('%s_%s_nordic', subj, acq_base);
        disp('Running NORDIC...');
        tic
        NIFTI_NORDIC(merged_mag_file, merged_phase_file, output_name, ARG);
        elapsed = toc;
        fprintf('NORDIC completed in %.1f minutes\n', elapsed/60);
        
    end
    
    fprintf('All done for %s\n', subj);
end


