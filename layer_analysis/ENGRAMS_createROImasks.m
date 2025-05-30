%% extract binary overlap masks of mPFC and RSC with each cortical layer
% (deep, mid, sup) separately for left, right and combined
%% prep

clc;clear
ids={'sub-104','sub-106','sub-107','sub-108','sub-109'};
path_par = '/Users/alex/Dropbox/paperwriting/1315/data/segmentation/';

% set environments for the bash tools
setenv('PATH', [getenv('PATH') ':/Library/Apple/usr/bin:/Users/alex/LayNii_v2.9.0_Mac_M']);
setenv('PATH', [getenv('PATH') ':/Applications/freesurfer/7.4.1/bin:/Applications/freesurfer/7.4.1/fsfast/bin:/Users/alex/fsl/bin:/Users/alex/fsl/share/fsl/bin:/Applications/freesurfer/7.4.1/mni/bin:/Applications/freesurfer/7.4.1:/usr/local/bin/python3/:/Library/Frameworks/Python.framework/Versions/3.12/bin:/Users/alex/fsl/share/fsl/bin:/Users/alex/fsl/share/fsl/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/alex/ants/bin/:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/X11/bin']);
setenv('ANTSPATH','/Users/alex/ants/bin/')
setenv('FS_LICENSE','/Applications/freesurfer/7.4.1/license.txt')
setenv('FREESURFER_HOME','/Applications/freesurfer/7.4.1')
!source /Applications/freesurfer/7.4.1/SetUpFreeSurfer.sh
setenv( 'FSLDIR', '/Users/alex/fsl' );
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
fsldir = getenv('FSLDIR');
fsldirmpath = sprintf('%s/etc/matlab',fsldir);
path(path, fsldirmpath);
clear fsldir fsldirmpath;

run

for id=1:length(ids)

    asegFile   = [path_par ids{id} 'v1s1/anat/t1/aparc+aseg_nat.nii.gz'];
    layersFile = [path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_equi_volume_layers_bined_3layers.nii.gz'];
    outDir     = [path_par ids{id} 'v1s1/anat/roi/native/'];

    if ~exist(outDir,'dir'), mkdir(outDir); end

    aseg       = niftiread(asegFile);
    try
        layers     = niftiread(layersFile);
        layersInfo = niftiinfo(layersFile);
    catch
        layers = niftiread([path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_equi_volume_layers_bined_3layers.nii']);
        layersInfo = niftiinfo([path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_equi_volume_layers_bined_3layers.nii']);
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

    rimFile = [path_par ids{id} 'v1s1/anat/t1/' ids{id} 'v1s1_run-01_T1w_0pt35_rim.nii.gz'];
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

%% run ENGRAMS_transform_ROIs.sh after
 
