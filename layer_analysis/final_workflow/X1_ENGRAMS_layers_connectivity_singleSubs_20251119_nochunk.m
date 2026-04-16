%% layer-specific connectivity: single subjects
%  pre-run following scripts before running this one:
%       1. ENGRAMS_LAYERS_pipeline_v2.py
%       2. ENGRAMS_transform_ROIs.sh
%       3. ENGRAMS_createROImasks.m
%       4. ENGRAMS_compcor.py
%       5. then this one

%% prep

clc;clear
tasks   = {'rest','origenc','origrec1','origrec2','recombienc','recombirec1'};%{'rest','origenc','origrec'};
ids     = {'sub-101','sub-104','sub-106','sub-107','sub-108','sub-109','sub-110','sub-111','sub-202','sub-207','sub-302','sub-303','sub-304'};%{'sub-205','sub-111'};%,'sub-101','sub-102'};
% filters for cleanup (it's too aggressive, or maybe i'm not doing this right... let's not do this)
hp=0.01; lp=0.1; TR=2;
[b,a] = butter(5,[hp lp]*TR*0.5,'bandpass');

% paths
path_par='/Users/yyi/Desktop/ENGRAMS/';

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

disp('prep done')
%% save full-volume files for LN2_DEVEIN (no chunking needed on this machine)

for id=11%1:length(ids)

    %%%%%%%%%%%%%%%
    subj = ids{id};
    disp(['prepare full volumes: ' subj])
    %%%%%%%%%%%%%%%

    for t1=1:numel(tasks)

        disp('************')
        disp(['**' tasks{t1} '**'])
        disp('************')

        % define subject specific paths
        path_roi        = [path_par 'analyses/' subj 'v1s1/anat/roi/func/' tasks{t1} '/'];
        if t1<=3
            path_analyses   = [path_par 'analyses/' subj 'v1s1/func/laminar/GM/'];
            path_func       = [path_par 'preproc/' subj 'v1s1/func/'];
        else
            path_analyses   = [path_par 'analyses/' subj 'v2s1/func/laminar/GM/'];
            path_func       = [path_par 'preproc/' subj 'v2s1/func/'];
        end

        % where are the files
        maskFile        = [path_roi 'rim_columns300_on_' tasks{t1} '_bin.nii.gz'];
        if str2num(ids{id}(5:7))<110 && str2num(ids{id}(5:7))<200
            clear tmp; tmp=dir([path_func 'au' subj 'v2s2_task-' tasks{t1} '*_run-0*_bold.nii.gz']);
        elseif str2num(ids{id}(5:7))==202
            clear tmp; tmp=dir([path_func 'au' subj 'v*s*_task-' tasks{t1} '*_run-0*_bold.nii.gz']);
        else
            clear tmp; tmp=dir([path_func 'ar' subj 'v*s*_task-' tasks{t1} '_run-0*_bold_topup.nii.gz']);
        end
        fmriFile        = [path_func tmp.name]; % dims X*Y*Z*T
        layerFile       = [path_roi 'equivol_on_' tasks{t1} '.nii.gz'];

        % load files
        try
            maskNii   = load_untouch_nii(maskFile);
        catch
            if t1==6 || t1==3
                maskFile  = [path_roi 'rim_columns300_on_' tasks{t1}(1:end-1) '_bin.nii.gz'];
                maskNii   = load_untouch_nii(maskFile);
            else
                maskNii   = load_untouch_nii(maskFile);
            end
        end
        fmriNii   = load_untouch_nii(fmriFile);

        % if (str2num(ids{id}(5:7))>110 && str2num(ids{id}(5:7))<200)...
        %     || (str2num(ids{id}(5:7))>200 && str2num(ids{id}(5:7))~=202)
        %     img       = double(fmriNii.img)*fmriNii.hdr.dime.scl_slope ...
        %         + fmriNii.hdr.dime.scl_inter;
        %     fmriNii.img              = single(img);        % keep precision
        %     fmriNii.hdr.dime.datatype = 16;  % float32
        %     fmriNii.hdr.dime.bitpix   = 32;
        %     fmriNii.hdr.dime.scl_slope = 1;
        %     fmriNii.hdr.dime.scl_inter = 0;
        % end

        try
            layerNii  = load_untouch_nii(layerFile);
        catch
            if t1==6 || t1==3
                layerFile = [path_roi 'equivol_on_' tasks{t1}(1:end-1) '.nii.gz'];
                layerNii  = load_untouch_nii(layerFile);
            else
                layerNii  = load_untouch_nii(layerFile);
            end
        end
        try
            colNii    = load_untouch_nii([path_roi '/rim_columns300_on_' tasks{t1} '.nii.gz']);
        catch
            if t1==6 || t1==3
                colNii    = load_untouch_nii([path_roi '/rim_columns300_on_' tasks{t1}(1:end-1) '.nii.gz']);
            else
                error('no col file matched')
            end
        end

        % sanity check: z-dim consistency
        assert(size(colNii.img,3)==size(fmriNii.img,3), 'column/fMRI z-dim mismatch');

        % workspace: save at the grey matter folder
        mkdir(path_analyses)
        cd(path_analyses)

        % save full 4D fMRI volume (uncompressed, as required by ALF and LN2_DEVEIN)
        nVolumes              = size(fmriNii.img,4);
        full4                 = fmriNii;
        full4.img             = full4.img(:,:,:,1:nVolumes);
        sz4                   = size(full4.img);
        full4.hdr.dime.dim(2:5) = sz4;
        save_untouch_nii(full4, sprintf('full_fMRI_%s.nii', tasks{t1}));

        % save full 3D layer volume
        full3                 = layerNii;
        sz3                   = size(full3.img);
        if numel(sz3)<3, sz3(3)=1; end
        full3.hdr.dime.dim(2:4) = sz3(1:3);
        save_untouch_nii(full3, sprintf('full_layer_%s.nii', tasks{t1}));

        % save full 3D column volume
        full3                 = colNii;
        sz3                   = size(full3.img);
        if numel(sz3)<3, sz3(3)=1; end
        full3.hdr.dime.dim(2:4) = sz3(1:3);
        save_untouch_nii(full3, sprintf('full_columns_%s.nii', tasks{t1}));

        disp(['full volumes saved for ' tasks{t1}])
    end

end

%% we devein (full volume, no chunking)

for id=9%1:length(ids)

    %%%%%%%%%%%%%%%
    subj = ids{id};
    disp(['devein ' subj])
    %%%%%%%%%%%%%%%

    for t1=numel(tasks)%1:numel(tasks)

        disp('************')
        disp(['**' tasks{t1} '**'])
        disp('************')

        if t1<=3
            path_analyses   = [path_par 'analyses/' subj 'v1s1/func/laminar/GM/'];
        else
            path_analyses   = [path_par 'analyses/' subj 'v2s1/func/laminar/GM/'];
        end

        % create ALF image from the full-volume fMRI
        eval(['!/Users/yyi/Desktop/ENGRAMS/script/final_workflow/Z-2_ALF_melmac_ENGRAMS.sh ' path_analyses ...
            'full_fMRI_' tasks{t1} '.nii ' path_analyses])

        % devein main command (full volume, single call)
        eval(['!LN2_DEVEIN '...
            '-input '       path_analyses 'full_fMRI_'    tasks{t1} '.nii '...
            '-layer_file '  path_analyses 'full_layer_'   tasks{t1} '.nii '...
            '-column_file ' path_analyses 'full_columns_' tasks{t1} '.nii '...
            '-ALF '         path_analyses 'AFL_full_fMRI_' tasks{t1} '.nii.gz '...
            '-output '      path_analyses 'full_fMRI_'    tasks{t1} '_linearDV.nii.gz'])

        % rename the LN2_DEVEIN output to the name expected by the
        % connectivity section downstream
        eval(['!mv ' path_analyses 'full_fMRI_' tasks{t1} '_linearDV_deveinDeconv.nii.gz '...
              path_analyses 'func_' tasks{t1} '_deveined.nii.gz'])

    end
    eval(['!gzip -f ' path_analyses '/*.nii'])
end


%% calc connectivities

for a1=5%1:5


    if a1==1
        % ========== mPFC ========== %
        rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup'};
        layerFlag=1;
        folderlabel = 'mPFC';
        % ========================== %
    elseif a1==0
        % ========== EC ========== %
        rois   = {'EC_layer_deep','EC_layer_mid','EC_layer_sup'};
        layerFlag=1;
        folderlabel = 'EC';
        % ========================== %
    elseif a1==2

        % =========== RSC ========== %
        rois   = {'RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        layerFlag=1;
        folderlabel = 'RSC';
        % ========================== %
    elseif a1==3

        % ====== all cortices ====== %
        rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        layerFlag=1;
        folderlabel = 'all';
        % ========================== %
    elseif a1==4

        % =========== HPC ========== %
        rois   = {'CA1','CA3','DG','Sub'};
        layerFlag=0;
        folderlabel = 'HPC';
        % ========================== %
    elseif a1==5

        % ====== all cortices ====== %
        rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup','EC_layer_deep','EC_layer_mid','EC_layer_sup','CA1','CA3','DG','Sub',...
            'ErC','SN','LC','VTA'};
        layerFlag=1;
        folderlabel = 'all_bs';
        % ========================== %

    end

    for id=9%length(ids) 

        %%%%%%%%%%%%%%%
        subj = ids{id};
        disp(['connect ' subj ' in ' folderlabel])
        %%%%%%%%%%%%%%%

        for t1=6%:numel(tasks)

            if str2num(ids{id}(5))==1 && t1<=3 && str2num(ids{id}(5:7))~=111
                path_roi    = [path_par 'analyses/' subj 'v1s1/anat/roi/func/' tasks{t1}];
                path_func   = [path_par 'analyses/' subj 'v2s2/func/laminar/GM/'];
                if t1==1
                    path_physio = [path_par 'preproc/' subj 'v1s1/func/'];
                    tmp2=dir([path_physio 'au' subj 'v1s1_task-' tasks{t1} '*_run-0*_bold.nii.gz']);
                elseif t1>1
                    path_physio = [path_par 'preproc/' subj 'v2s2/func/'];
                    tmp2=dir([path_physio 'au' subj 'v2s2_task-' tasks{t1} '*_run-0*_bold.nii.gz']);
                end
                funcFile    = [path_func 'func_' tasks{t1} '_deveined.nii.gz'];

            elseif str2num(ids{id}(5:7))==111 && t1<=3
                path_roi    = [path_par 'analyses/' subj 'v1s1/anat/roi/func/' tasks{t1}];

                if t1==1
                    path_func   = [path_par 'analyses/' subj 'v1s1/func/laminar/GM/'];
                    path_physio = [path_par 'preproc/' subj 'v1s1/func/'];
                elseif t1>1
                    path_func   = [path_par 'analyses/' subj 'v2s2/func/laminar/GM/'];
                    path_physio = [path_par 'preproc/' subj 'v2s2/func/'];
                end
                funcFile    = [path_func 'func_' tasks{t1} '_deveined.nii.gz'];
                tmp2=dir([path_physio 'ar' subj 'v*s*_task-' tasks{t1} '_run-0*_bold_topup.nii.gz']);

            elseif str2num(ids{id}(5:7))==202
                path_roi    = [path_par 'analyses/' subj 'v1s1/anat/roi/func/' tasks{t1}];

                if t1<=3
                    path_func   = [path_par 'analyses/' subj 'v1s1/func/laminar/GM/'];
                    path_physio = [path_par 'preproc/' subj 'v1s1/func/'];
                else
                    path_func   = [path_par 'analyses/' subj 'v2s1/func/laminar/GM/'];
                    path_physio = [path_par 'preproc/' subj 'v2s1/func/'];
                end
                funcFile    = [path_func 'func_' tasks{t1} '_deveined.nii.gz'];
                tmp2=dir([path_physio 'au' subj 'v*s*_task-' tasks{t1} '_run-0*_bold.nii.gz']);

            elseif (str2num(ids{id}(5))==2 && str2num(ids{id}(5:7))~=202) || str2num(ids{id}(5))==3
                path_roi    = [path_par 'analyses/' subj 'v1s1/anat/roi/func/' tasks{t1}];

                if t1<=3
                    path_func   = [path_par 'analyses/' subj 'v1s1/func/laminar/GM/'];
                    path_physio = [path_par 'preproc/' subj 'v1s1/func/'];
                else
                    path_func   = [path_par 'analyses/' subj 'v2s1/func/laminar/GM/'];
                    path_physio = [path_par 'preproc/' subj 'v2s1/func/'];
                end
                funcFile    = [path_func 'func_' tasks{t1} '_deveined.nii.gz'];
                tmp2=dir([path_physio 'ar' subj 'v*s*_task-' tasks{t1} '_run-0*_bold_topup.nii.gz']);
            end

            % load func
            % V           = single(niftiread(funcFile)); % x*y*z*t
            % timeseries_mat = zeros(numel(rois), size(V,4), 'single');

            % load deveined func for cortex/hippocampus
            V_deveined = single(niftiread(funcFile)); % x*y*z*t
            V_original = single(niftiread([path_physio tmp2.name]));

            timeseries_mat = zeros(numel(rois), size(V_deveined,4), 'single');

            for r2 = 1:numel(rois)
                if r2>=15
                    disp([rois{r2}])
                    mask   = niftiread([path_roi '/' rois{r2} '.nii.gz']) > 0;
                    clear nz
                    nz = nnz(niftiread([path_roi '/' rois{r2} '.nii.gz']));
                else
                    disp([rois{r2} '_GMmasked'])
                    mask   = niftiread([path_roi '/' rois{r2} '_GMmasked.nii.gz']) > 0;
                    clear nz
                    nz = nnz(niftiread([path_roi '/' rois{r2} '_GMmasked.nii.gz']));
                end
               
                if any(nz < 10)
                    warning([rois{r2} ' with <10 voxels – exclude or re-draw'])
                end

                masktest{r2,1}=mask; % for diagnostics
                % voxels = V(repmat(mask, 1, 1, 1, size(V,4))); % apply mask through time
                % timeseries_mat(r2,:) = mean(reshape(voxels, [], size(V,4)), 1,'omitnan');
                % use original for brainstem, deveined for everything else
                if ismember(rois{r2}, {'SN','VTA','LC'})
                    voxels = V_original(repmat(mask, 1, 1, 1, size(V_original,4)));
                    timeseries_mat(r2,:) = mean(reshape(voxels, [], size(V_original,4)), 1,'omitnan');
                else
                    voxels = V_deveined(repmat(mask, 1, 1, 1, size(V_deveined,4)));
                    timeseries_mat(r2,:) = mean(reshape(voxels, [], size(V_deveined,4)), 1,'omitnan');
                end
            end

            % Diagnostic: check timeseries before processing
            fprintf('\n=== TIMESERIES DIAGNOSTICS ===\n')
            for r2 = 1:numel(rois)
                fprintf('%s: mean=%.4f, std=%.4f, range=[%.4f,%.4f]\n', ...
                    rois{r2}, ...
                    mean(timeseries_mat(r2,:),'omitnan'), ...
                    std(timeseries_mat(r2,:),'omitnan'), ...
                    min(timeseries_mat(r2,:)), ...
                    max(timeseries_mat(r2,:)))
            end

            % Plot first 50 timepoints
            figure('Position',[100 100 1200 600]);
            subplot(2,1,1);
            plot(timeseries_mat(:,1:50)');
            legend(rois,'Location','eastoutside','Interpreter','none');
            title('First 50 timepoints - raw');
            xlabel('Time'); ylabel('Signal');

            % Plot correlation matrix of raw timeseries
            subplot(2,1,2);
            imagesc(corrcoef(timeseries_mat'));
            colorbar; caxis([-1 1]);
            set(gca,'XTick',1:numel(rois),'XTickLabel',rois,'XTickLabelRotation',45);
            set(gca,'YTick',1:numel(rois),'YTickLabel',rois);
            title('Raw correlation matrix (before orthogonalisation)');
            drawnow;

            % there seems to be some sort of signal leakage between the layers
            % so we need to orthogonalise
            if numel(rois)<=3 % for single within ROI connectivity

                % approach 2
                % clear deep mid midresid

                % deep = timeseries_mat(1,:)';
                % mid  = timeseries_mat(2,:)';
                %
                % beta_dm   = (deep\mid); % ls fit of deep -> mid
                % mid_resid = mid - deep*beta_dm; % mid layer with deep component removed
                % timeseries_mat(2,:) = mid_resid'; % replace row-2 with residual

                % approach 3: qr decomposition
                % alex/yeo-jin (20250530):
                % we have big voxels for thin layers and because of this
                % the 3 layers share lots of slow drift and vasc noise...
                % stock exchange suggests using qr (i think it's like gram-schmidt way)
                % basically we try to orthogonalise each signal of the layers that are
                % messed about across each other and extract unique signals
                % because the common signals that drive the extreme
                % connectivity are probably some vascular noise or signals
                % bleeding from one another because again we have big
                % voxels
                % anyway read this: https://doi.org/10.1145/2049662.2049670
                X = zscore(timeseries_mat.',0,1);
                [Q,~] = qr(X,0);
                timeseries_mat = Q.';

            elseif numel(rois)==4 % for HPC subfields connectivity
                % what do i do? idk, maybe let's orthogonalise everything?
                CA1 = timeseries_mat(1,:)';
                CA3 = timeseries_mat(2,:)';
                DG  = timeseries_mat(3,:)';
                Sub = timeseries_mat(4,:)';

                % remove shared CA1 component from CA3 and Sub
                CA3 = CA3 - (CA1\CA3)*CA1;   % residual
                Sub = Sub - (CA1\Sub)*CA1;
                DG  = DG  - (CA1\DG )*CA1;

                timeseries_mat(2,:) = CA3';
                timeseries_mat(3,:) = DG';
                timeseries_mat(4,:) = Sub';

                % another attempt with partial correlation
                % pcR = partialcorr(timeseries_mat');
                % pcR = max(min(pcR,0.999999),-0.999999);
                % R   = pcR;  Z = atanh(R);  Z(1:5:end)=0;

            elseif numel(rois)==6 % for mPFC-RSC layer connectivity

                % % approach 1: orthogonalise symmetrically
                % % mPFC
                % D = timeseries_mat(1,:)';   % deep
                % M = timeseries_mat(2,:)';   % mid
                % S = timeseries_mat(3,:)';   % sup
                %
                % M = M - (D\M)*D;            % mid ⟂ deep
                % D = D - (M\D)*M;            % deep ⟂ mid   (now symmetric)
                % X = [D M];
                % S = S - X*(X\S);            % sup ⟂ [deep mid]
                %
                % timeseries_mat(1,:) = D';
                % timeseries_mat(2,:) = M';
                % timeseries_mat(3,:) = S';
                %
                % % RSC
                % D = timeseries_mat(4,:)';
                % M = timeseries_mat(5,:)';
                % S = timeseries_mat(6,:)';
                %
                % M = M - (D\M)*D;
                % D = D - (M\D)*M;
                % X = [D M];
                % S = S - X*(X\S);
                %
                % timeseries_mat(4,:) = D';
                % timeseries_mat(5,:) = M';
                % timeseries_mat(6,:) = S';


                % % approach 2
                % % mPFC
                % clear deep mid midresid
                %
                % deep = timeseries_mat(1,:)';
                % mid  = timeseries_mat(2,:)';
                %
                % beta_dm   = (deep\mid); % LS fit of deep -> mid
                % mid_resid = mid - deep*beta_dm; % mid layer with deep component removed
                %
                % timeseries_mat(2,:) = mid_resid'; % replace row-2 with residual
                %
                % % RSC
                % clear deep mid midresid
                %
                % deep = timeseries_mat(4,:)';
                % mid  = timeseries_mat(5,:)';
                %
                % beta_dm   = (deep\mid); % LS fit of deep -> mid
                % mid_resid = mid - deep*beta_dm; % mid layer with deep component removed
                %
                % timeseries_mat(5,:) = mid_resid'; % replace row-2 with residual


                % approach 3
                % mPFC
                X = zscore(timeseries_mat(1:3,:).',0,1);
                [Q,~] = qr(X,0);
                timeseries_mat(1:3,:) = Q.';

                % RSC
                X = zscore(timeseries_mat(4:6,:).',0,1);
                [Q,~] = qr(X,0);
                timeseries_mat(4:6,:) = Q.';


            elseif numel(rois) > 6

                % approach 3
                % mPFC
                X = zscore(timeseries_mat(1:3,:).',0,1);
                [Q,~] = qr(X,0);
                timeseries_mat(1:3,:) = Q.';

                % RSC
                X = zscore(timeseries_mat(4:6,:).',0,1);
                [Q,~] = qr(X,0);
                timeseries_mat(4:6,:) = Q.';

                % HPC
                CA1 = timeseries_mat(10,:)';
                CA3 = timeseries_mat(11,:)';
                DG  = timeseries_mat(12,:)';
                Sub = timeseries_mat(13,:)';

                % remove shared CA1 component from CA3 and Sub
                CA3 = CA3 - (CA1\CA3)*CA1;   % residual
                Sub = Sub - (CA1\Sub)*CA1;
                DG  = DG  - (CA1\DG )*CA1;

                timeseries_mat(11,:) = CA3';
                timeseries_mat(12,:) = DG';
                timeseries_mat(13,:) = Sub';

            end

            R = corrcoef(timeseries_mat'); % pearson
            R = max(min(R,0.999999),-0.999999); % keep |R| < 1
            Z = atanh(R); % fisher-z

            % preliminary report
            disp(['>>> ' tasks{t1} ' <<<'])
            disp('raw R=')
            disp(R)
            disp('raw Z=')
            disp(Z)

            clear V mask

            %% WM signal bleed cleanup (deprecated) - use compcor instead
            % % after deveining, WM is 0 because we only keep data wihtin GM ribbon
            % path_func =['/Users/alex/Dropbox/paperwriting/1315/data/segmentation/' subj 'v1s1/func/'];
            % wm   = {'WM'};
            % Vraw     = single(niftiread([path_func 'au' subj 'v2s2_task-origrec_run-04_bold.nii']));
            % wm_ts   = zeros(numel(wm), size(Vraw,4), 'single');
            %
            % for r3 = 1:numel(wm)
            %     WMmask   = niftiread([path_roi wm{r3} '_clean.nii.gz']) > 0;
            %     voxels_wm = Vraw(repmat(WMmask, 1, 1, 1, size(Vraw,4))); % apply mask through time
            %     wm_ts(r3,:) = mean(reshape(voxels_wm, [], size(Vraw,4)), 1);
            % end

            %% cleanup

            % compcor WM+CSF regression (ENGRAMS_compcor.py)
            try
            acompcor=dlmread([path_physio 'compcor_csf_wm_' tasks{t1} '.txt'], '\t', 1, 0);
            catch
            acompcor=dlmread([path_physio 'compcor_csf_wm_' tasks{t1}(1:end-1) '.txt'], '\t', 1, 0);
            end
            % realignment regressors

            % if strcmp('sub-202',subj) & strcmp('origrec',tasks{t1})
            %     nuisanceReg=load([path_physio 'reg_all_' tasks{t1} '1.mat'],'R');
            % elseif strcmp('sub-205',subj) & strcmp('origrec',tasks{t1})
            %     nuisanceReg=load([path_physio 'reg_all_' tasks{t1} '1.mat'],'R');
            % else
            try
                nuisanceReg=load([path_physio 'reg_all_' tasks{t1} '.mat'],'R');
            catch
                nuisanceReg=load([path_physio 'reg_all_' tasks{t1}(1:end-1) '.mat'],'R');
            end
            % end

            % assemble
            if layerFlag
                if numel(rois)<=3
                    sup_ts = timeseries_mat(3,:);
                    confounds   = [nuisanceReg.R acompcor]; %sup_ts']; % we're using qr so we don't need the sup layer trace anymore
                elseif numel(rois)>3
                    sup_ts = timeseries_mat([3 6],:);
                    confounds   = [nuisanceReg.R acompcor];% sup_ts'];
                end
            else
                % for hippocampal subfields we do something else
                confounds   = [nuisanceReg.R acompcor];
            end
            confounds = zscore(confounds); % z-scores each column
            % confounds(:,any(isnan(confounds))) = []; % drop all-NaN columns (just in case)

            if str2num(ids{id}(5:7))==202 && t1==6
            beta   = pinv(confounds)*timeseries_mat(:,1:length(confounds))';
            cleaned= timeseries_mat(:,1:length(confounds))' - confounds*beta; % residuals -> correlate
            else
            beta   = pinv(confounds)*timeseries_mat';
            cleaned= timeseries_mat' - confounds*beta; % residuals -> correlate
            end

            % bandpass and scrub
            % rp  = nuisanceReg.R(:,1:6); % dx-dy-dz-pitch-roll-yaw (rad)
            % rot = rp(:,4:6) * 50; % convert rotations to mm (50 mm radius)
            % mpar = [rp(:,1:3) rot]; % now all in mm
            % dpar = [zeros(1,6); diff(mpar)]; % f2f change
            % fd   = sum(abs(dpar),2); % Power et al. 2012
            %
            % cleaned = filtfilt(b,a,cleaned);
            % cleaned(:,fd>0.3) = NaN;


            R=corrcoef(cleaned);
            R = max(min(R, 0.999999), -0.999999); %% added : 20251105
            Z = atanh(R);

            disp('cleaned R=')
            disp(R)
            disp('cleaned Z=')
            disp(Z)

            mkdir([path_par 'analyses/' ...
                subj 'v1s1/func/laminar/' folderlabel])
            save([path_par 'analyses/' ...
                subj 'v1s1/func/laminar/' folderlabel '/Z_' subj '_' tasks{t1} '_bs.mat'], 'Z','R')

            %% diagnostics

            % % verify zero overlap *after* any cropping
            % nnz(masktest{1,1} & masktest{2,1})
            %
            % % look at raw traces
            % plot(zscore(timeseries_mat(1,1:200))); hold on
            % plot(zscore(timeseries_mat(2,1:200)));
            % legend(rois{1},rois{2})
            %
            % % compare voxel counts
            % [cellfun(@nnz,{masktest{1,1},masktest{2,1},masktest{3,1}})] % should be roughly similar

        end

    end
end

%% inspect and visualise

close all

for a1=5

    if a1==1
        % ========== mPFC ========== %
        rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup'};
        layerFlag=1;
        folderlabel = 'mPFC';
        % ========================== %
    elseif a1==2

        % =========== RSC ========== %
        rois   = {'RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        layerFlag=1;
        folderlabel = 'RSC';
        % ========================== %
    elseif a1==3

        % ====== all cortices ====== %
        rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup'};
        layerFlag=1;
        folderlabel = 'all';
        % ========================== %
    elseif a1==4

        % =========== HPC ========== %
        rois   = {'CA1','CA3','DG','Sub'};
        layerFlag=0;
        folderlabel = 'HPC';
        % ========================== %
    % elseif a1==5
    % 
    %     % ====== all cortices ====== %
    %     rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup','EC_layer_deep','EC_layer_mid','EC_layer_sup','CA1','CA3','DG','Sub',...
    %         'ErC'};
    %     layerFlag=1;
    %     folderlabel = 'all_2';
    %     % ========================== %
    elseif a1==5

        % ====== all cortices ====== %
        rois   = {'mPFC_layer_deep','mPFC_layer_mid','mPFC_layer_sup','RSC_layer_deep','RSC_layer_mid','RSC_layer_sup','EC_layer_deep','EC_layer_mid','EC_layer_sup','CA1','CA3','DG','Sub',...
            'ErC','SN','LC','VTA'};
        layerFlag=1;
        folderlabel = 'all_bs';
        % ========================== %

    end

    for id=9%:length(ids)

        %%%%%%%%%%%%%%%
        subj = ids{id};
        disp(['connect ' subj 'in ' folderlabel])
        %%%%%%%%%%%%%%%



        for t1=6%1:numel(tasks)
            close all

            % load fisher-z mat we calculated above
            % load([path_par '/analyses/' subj 'v1s1/func/laminar/' folderlabel '/Z_' subj '_' tasks{t1} '.mat'],'Z')
            load([path_par '/analyses/' subj 'v1s1/func/laminar/' folderlabel '/Z_' subj '_' tasks{t1} '_bs.mat'],'Z')

            nR = numel(rois);

            % wipe out any NaNs so they don’t become edges
            Z(isnan(Z)) = 0;
            % force symmetry
            Z = (Z + Z.')/2;
            % back-transform to r (if you want to show correlations rather than z)
            R = tanh(Z);

            % build adjacency on r (sign preserved), threshold at |r|>0.2
            thr_r = 0.2;
            A     = R .* ~eye(nR);
            A(abs(A)<thr_r) = 0;

            % A already has |r|<thr_r set to 0
            [i,j,v] = find(triu(A,1));          % upper-tri only
            fprintf('Edges kept for %s  %s\n', subj, tasks{t1});
            for k = 1:numel(v)
                fprintf('%s ↔ %s   r = %.6f\n', rois{i(k)}, rois{j(k)}, v(k));
            end


            G     = graph(A, rois, 'upper');
            rvec  = G.Edges.Weight; % signed r values for surviving edges

            % layout
            theta = linspace(0,2*pi,nR+1); theta(end)=[];
            xy    = [cos(theta); sin(theta)];

            fig1=figure;
            % make the fancy plot
            p = plot(G, ...
                'XData',xy(1,:),'YData',xy(2,:), ...
                'Marker','s','MarkerSize',14,'NodeColor',[.1 .1 .1], ...
                'NodeLabel',rois,'NodeFontSize',14,'LineWidth',1);

            if ~isempty(rvec)
                % width: 1–8 pts scaled by |r|
                lw = 1 + 7*rescale(abs(rvec),'InputMin',thr_r);
                lw(~isfinite(lw)) = eps;
                p.LineWidth = lw;

                % colour: red=pos blue=neg
                p.EdgeCData = rvec;
                p.EdgeColor = 'flat';

                % labels: only on finite edges
                lbl = arrayfun(@(x) sprintf('%.2f', x), rvec, 'uni',false);
                p.EdgeLabel = lbl;
                p.EdgeFontSize = 12;
                p.EdgeLabelColor = [0 0 0];
                p.Interpreter = 'none';

                % diverging map
                colormap(redblue); caxis([-1 1]); cb=colorbar('Ticks',[-1 -0.5 0 0.5 1],'Location','west');
                % ylabel(cb, 'Pearson''s r','FontSize',12)
            end

            axis off equal
            title({['' subj ' : |pearson''s r| > 0.2  (red=pos, blue=neg)'],['phase: ' tasks{t1}]},'Fontsize',20,'FontWeight','bold')
            % savefig([path_par subj 'v1s1/analyses/' folderlabel '/connectivities_' subj '_' tasks{t1} '.fig'])
            figPath1 = fullfile('/Volumes/korokdorf/ENGRAMS/single_fig/', [subj 'v1s1'], folderlabel, ...
                sprintf('connectivities_%s_%s.fig', subj, [tasks{t1} '_' folderlabel]));
            mkdir(fullfile('/Volumes/korokdorf/ENGRAMS/single_fig/', [subj 'v1s1'], folderlabel))
            savefig(fig1, figPath1)
            saveas(fig1, strrep(figPath1, '.fig', '.jpg'), 'jpg')

            % heatmap
            fig2=figure; imagesc(Z); axis square
            set(gca,'XTick',1:nR,'XTickLabel',rois, ...
                'YTick',1:nR,'YTickLabel',rois, ...
                'TickLabelInterpreter', 'none');
            colormap(redblue);caxis([-1 1])
            colorbar; title({[subj '  ROI connectivity (fisher-z)'],['phase: ' tasks{t1}]})
            % savefig([path_par subj 'v1s1/analyses/' folderlabel '/heatmap_' subj '_' tasks{t1} '.fig'])
            figPath2 = fullfile('/Volumes/korokdorf/ENGRAMS/single_fig', [subj 'v1s1'], folderlabel, ...
                sprintf('heatmap_%s_%s.fig', subj, [tasks{t1} '_' folderlabel]));
            savefig(fig2, figPath2)
            saveas(fig2, strrep(figPath2, '.fig', '.jpg'), 'jpg')

            % summary printout: all lower-triangle pairs
            % clc
            fprintf('\n%s  ROI connectivity (fisher-z)\n', subj)
            for i = 2:nR
                for j = 1:i-1
                    fprintf('%s – %s  %6.3f\n', rois{j}, rois{i}, Z(i,j))
                end
            end
        end
    end

end

%% troubleshooting

% V = single(niftiread([path_analyses 'func_origrec_deveined.nii.gz'])); % deveined timeseries
% timeseries_mat = zeros(numel(rois), size(V,4), 'single');
% for r = 1:numel(rois)
%     m   = niftiread([rois{r1} '.nii.gz'])>0;
%     vox = V(repmat(m,1,1,1,size(V,4)));
%     timeseries_mat(r,:) = mean(reshape(vox,[],size(V,4)),1);
% end
%
% partialcorr(timeseries_mat(1,:)', timeseries_mat(2,:)', timeseries_mat(3,:)')


%% trying something...

% %  build a pure vein nuisance column from the superficial rim
% sup_mask = niftiread([path_roi '/RSC_layer_sup.nii.gz']) > 0; % boolean 3D
% sup_tc   = mean(V(repmat(sup_mask,1,1,1,size(V,4))),[1 2 3])'; % T*1
% nt       = size(V,4); % numvol
%
% vox_sup  = V(repmat(sup_mask,1,1,1,nt)); % rowvec
% sup_tc   = mean(reshape(vox_sup, [], nt), 1)'; % nt*1 col
% sup_tc   = double(sup_tc); % cast to double
%
% % add that column to the existing confounds
% conf2   = [confounds  sup_tc]; % T*(25+1)
% conf2   = detrend(conf2,'constant');
%
% beta2   = pinv(conf2) * timeseries_mat';  % nuisance beta
% clean2  = timeseries_mat' - conf2 * beta2;
% R_vein  = corrcoef(clean2); % 3*3
%
% disp(R_vein)

