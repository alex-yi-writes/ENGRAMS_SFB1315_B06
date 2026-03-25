%% extract binary overlap masks of mPFC and RSC with each cortical layer
% (deep, mid, sup) separately for left, right and combined
%% prep

clc;clear
ids={'sub-301'}%{'sub-104','sub-106','sub-107','sub-108','sub-109','sub-110','sub-111',...
    % 'sub-202','sub-207','sub-302','sub-303','sub-304'};
path_par = '/Users/yyi/Desktop/ENGRAMS/analyses/';

% set environments for the bash tools
setenv('PATH', [getenv('PATH') ':/Users/yyi/miniconda3/bin:/Users/yyi/miniconda3/condabin:/usr/local/fsl/bin:/Applications/freesurfer/7.4.1/bin:/Applications/freesurfer/7.4.1/fsfast/bin:/usr/local/fsl/bin:/usr/local/fsl/share/fsl/bin:/Applications/freesurfer/7.4.1/mni/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/pmk/env/global/bin:/usr/local/bin:/Users/yyi:/Users/yyi/LayNii_v2.9.0_Mac_M:/Users/ikndadmin/abin']);
setenv('ANTSPATH','/usr/local/bin')
setenv('FS_LICENSE','/Applications/freesurfer/7.4.1/license.txt')
setenv('FREESURFER_HOME','/Applications/freesurfer/7.4.1')
!source /Applications/freesurfer/7.4.1/SetUpFreeSurfer.sh
setenv( 'FSLDIR', '/usr/local/fsl' );
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
fsldir = getenv('FSLDIR');
fsldirmpath = sprintf('%s/etc/matlab',fsldir);
path(path, fsldirmpath);
clear fsldir fsldirmpath;

%% run

for id=1:length(ids)

    asegFile   = [path_par ids{id} 'v1s1/anat/t1/aparc+aseg_nat.nii.gz'];
    layersFile = [path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_bs_equi_volume_layers_bined_3layers.nii.gz'];
    outDir     = [path_par ids{id} 'v1s1/anat/roi/native/'];

    if ~exist(outDir,'dir'), mkdir(outDir); end

    aseg       = niftiread(asegFile);
    try
        layers     = niftiread(layersFile);
        layersInfo = niftiinfo(layersFile);
    catch
        layers = niftiread([path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_bs_equi_volume_layers_bined_3layers.nii']);
        layersInfo = niftiinfo([path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_bs_equi_volume_layers_bined_3layers.nii']);
    end


    rois = {
        'mPFC',   [1014,1026,2014,2026];
        'mPFC_L', [1014,1026];
        'mPFC_R', [2014,2026];
        'RSC',    [1010,2010];
        'RSC_L',  [1010];
        'RSC_R',  [2010];
        };
    layerNames = {'deep','mid','sup'};

    for i = 1:size(rois,1)
        name   = rois{i,1};
        labels = rois{i,2};
        roiMask = ismember(aseg, labels);
        for idx = 1:3
            outMask = uint8( roiMask & (layers==idx) );
            info           = layersInfo;
            info.Datatype  = 'uint8';
            info.ImageSize = size(outMask);
            fname = sprintf('%s_layer_%s', name, layerNames{idx});
            niftiwrite(outMask, fullfile(outDir, fname), info, 'Compressed', true);
        end
    end

    disp('done. masks saved...');


    %% now, create coregistration mask

    rimFile = [path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_bs_rim.nii.gz'];
    outDir  = [path_par ids{id} 'v1s1/anat/roi/regmask'];
    if ~exist(outDir,'dir'), mkdir(outDir); end

    aseg       = niftiread(asegFile);
    layers     = niftiread(rimFile);
    layersInfo = niftiinfo(rimFile);

    rois = {
        'mPFC',   [1014,1026,2014,2026]
        'RSC',    [1010,2010];
        };

    for i = 1:size(rois,1)
        name   = rois{i,1};
        labels = rois{i,2};
        roiMask    = ismember(aseg, labels);
        mergedMask = uint8( roiMask & (layers > 0) );

        info           = layersInfo;
        info.Datatype  = 'uint8';
        info.ImageSize = size(mergedMask);

        fname = sprintf('%s_bin', name);
        niftiwrite(mergedMask, fullfile(outDir, fname), info);

        mkdir([path_par ids{id} 'v1s1/anat/roi/regmask'])

        eval(['!fslmaths ' path_par ids{id} 'v1s1/anat/roi/regmask/' name '_bin.nii -dilM -dilM -dilM -dilM ' ...
            path_par ids{id} 'v1s1/anat/roi/regmask/' name '_dilated.nii.gz'])


        % eval(['!rm /Users/alex/Dropbox/paperwriting/1315/data/segmentation/' ids{id} 'v1s1/anat/roi/regmask/s' name '_bin.nii'])
        eval(['!gzip /Users/alex/Dropbox/paperwriting/1315/data/segmentation/' ids{id} 'v1s1/anat/roi/regmask/*.nii -f'])

    end

end

%% additional: entorhinal cortex

for id=1:length(ids)

    asegFile   = [path_par ids{id} 'v1s1/anat/t1/aparc+aseg_nat.nii.gz'];
    layersFile = [path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_bs_equi_volume_layers_bined_3layers.nii.gz'];
    outDir     = [path_par ids{id} 'v1s1/anat/roi/native/'];

    if ~exist(outDir,'dir'), mkdir(outDir); end

    aseg       = niftiread(asegFile);
    try
        layers     = niftiread(layersFile);
        layersInfo = niftiinfo(layersFile);
    catch
        layers = niftiread([path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_bs_equi_volume_layers_bined_3layers.nii']);
        layersInfo = niftiinfo([path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_bs_equi_volume_layers_bined_3layers.nii']);
    end


    rois = {
        'EC',   [1016,2016];
        'EC_L', [1016];
        'EC_R', [2016];
        };
    layerNames = {'deep','mid','sup'};

    for i = 1:size(rois,1)
        name   = rois{i,1};
        labels = rois{i,2};
        roiMask = ismember(aseg, labels);
        for idx = 1:3
            outMask = uint8( roiMask & (layers==idx) );
            info           = layersInfo;
            info.Datatype  = 'uint8';
            info.ImageSize = size(outMask);
            fname = sprintf('%s_layer_%s', name, layerNames{idx});
            niftiwrite(outMask, fullfile(outDir, fname), info, 'Compressed', true);
        end
    end

    disp('done. EC masks also saved...');


    %% now, create coregistration mask

    rimFile = [path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_bs_rim.nii.gz'];
    outDir  = [path_par ids{id} 'v1s1/anat/roi/regmask'];
    if ~exist(outDir,'dir'), mkdir(outDir); end

    aseg       = niftiread(asegFile);
    layers     = niftiread(rimFile);
    layersInfo = niftiinfo(rimFile);

    rois = {
        'EC',   [1016, 2016]
        };

    for i = 1:size(rois,1)
        name   = rois{i,1};
        labels = rois{i,2};
        roiMask    = ismember(aseg, labels);
        mergedMask = uint8( roiMask & (layers > 0) );

        info           = layersInfo;
        info.Datatype  = 'uint8';
        info.ImageSize = size(mergedMask);

        fname = sprintf('%s_bin', name);
        niftiwrite(mergedMask, fullfile(outDir, fname), info);

        mkdir([path_par ids{id} 'v1s1/anat/roi/regmask'])

        eval(['!fslmaths ' path_par ids{id} 'v1s1/anat/roi/regmask/' name '_bin.nii -dilM -dilM -dilM -dilM ' ...
            path_par ids{id} 'v1s1/anat/roi/regmask/' name '_dilated.nii.gz'])


        % eval(['!rm /Users/alex/Dropbox/paperwriting/1315/data/segmentation/' ids{id} 'v1s1/anat/roi/regmask/s' name '_bin.nii'])
        eval(['!gzip /Users/alex/Dropbox/paperwriting/1315/data/segmentation/' ids{id} 'v1s1/anat/roi/regmask/*.nii -f'])

    end

end

%% run ENGRAMS_transform_ROIs.sh after
