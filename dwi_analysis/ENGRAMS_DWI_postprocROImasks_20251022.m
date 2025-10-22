%% post process the ROI masks to prepare for the MD analysis

%% prep

clc;clear
ids     = {'sub-302','sub-303'};
phases  = {'bsl','origE','origL','recombi'};
path_par= '/Volumes/korokdorf/ENGRAMS/analyses/';

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

%% mask postproc

for id=1:length(ids)

    %%%%%%%%%%%%%%%
    subj = ids{id};
    disp(['mask postproc ' subj])
    %%%%%%%%%%%%%%%

    for t1=1:numel(phases)

        disp(phases{t1})

        path_roi = [path_par subj 'v1s1/anat/roi_dwi/' phases{t1} '/'];

        asegFile   = [path_par ids{id} 'v1s1/anat/roi_dwi/aparc_on_' phases{t1} '.nii.gz'];
        outDir     = [path_par ids{id} 'v1s1/anat/roi_dwi/' phases{t1}];

        if ~exist(outDir,'dir'), mkdir(outDir); end

        aseg = niftiread(asegFile); aseg = double(aseg);
        asegInfo = niftiinfo(asegFile);  
        
        rois = {
            'mPFC', [1014,1026,2014,2026];
            'mPFC_L', [1014,1026];
            'mPFC_R', [2014,2026];
            'RSC', [1010,2010];
            'RSC_L', [1010];
            'RSC_R', [2010];
            'Parahippocampal', [1016,2016];
            'Parahippocampal_L', [1016];
            'Parahippocampal_R', [2016];
            'Entorhinal', [1006,2006];
            'Entorhinal_L', [1006];
            'Entorhinal_R', [2006];
            'Fusiform', [1007,2007];
            'Fusiform_L', [1007];
            'Fusiform_R', [2007];
            'Precuneus', [1025,2025];
            'Precuneus_L', [1025];
            'Precuneus_R', [2025];
            'InferiorTemporal', [1009,2009];
            'InferiorTemporal_L', [1009];
            'InferiorTemporal_R', [2009];
            };

        for i = 1:size(rois,1)
            name = rois{i,1};
            labels = rois{i,2};
            
            roiMask = ismember(aseg, double(labels));
            
            num_voxels = sum(roiMask(:));
            if num_voxels > 0
                fprintf('  %s: %d voxels\n', name, num_voxels);
            else
                fprintf('  WARNING: %s mask is empty\n', name);
                continue;
            end
            
            outMask = uint8(roiMask);
            
            info = asegInfo;
            info.Datatype = 'uint8';
            info.BitsPerPixel = 8;
            
            fname = sprintf('%s', name);
            niftiwrite(outMask, fullfile(outDir, fname), info, 'Compressed', true);
        end
        
        disp('done. masks saved...');
    end
end