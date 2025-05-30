%% layer-specific connectivity: single subjects
%  pre-run following scripts before running this one:
%       1. ENGRAMS_LAYERS_pipeline_v2.py
%       2. ENGRAMS_transform_ROIs.sh
%       3. ENGRAMS_createROImasks.m
%       4. ENGRAMS_compcor.py
%       5. then this one

%% prep

clc;clear
tasks   = {'rest','origenc','origrec'};
% tasks   = {'rest','origenc'};
ids     = {'sub-109','sub-202'};
nChunks = 6; % 6 chunks

path_par='/Users/alex/Dropbox/paperwriting/1315/data/segmentation/';

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


%% first, chunk data so that we can run LN2_DEVEIN (the file's too big)

for id=1%:length(ids)

    %%%%%%%%%%%%%%%
    subj = ids{id};
    disp(['chunk ' subj])
    %%%%%%%%%%%%%%%

    for t1=1:numel(tasks)

        % define subject specific paths
        path_roi        = [path_par subj 'v1s1/anat/roi/func/' tasks{t1} '/'];
        path_func       = [path_par subj 'v1s1/func/'];
        path_analyses   = [path_par subj 'v1s1/analyses/GM/'];

        % where are the files
        maskFile        = [path_roi 'rim_columns300_on_' tasks{t1} '_bin.nii.gz']; eval(['!gzip -d -f ' maskFile '.gz'])
        clear tmp; tmp=dir([path_func 'au' subj 'v*s*_task-' tasks{t1} '_run-0*_bold.nii']);
        fmriFile        = [path_func tmp.name]; % dims X*Y*Z*T
        layerFile       = [path_roi 'equivol_on_' tasks{t1} '.nii.gz'];

        % load files
        maskNii   = load_untouch_nii(maskFile);
        fmriNii   = load_untouch_nii(fmriFile);
        layerNii  = load_untouch_nii(layerFile);
        colNii    = load_untouch_nii([path_roi '/rim_columns300_on_' tasks{t1} '.nii.gz']);

        % compute vol per z slice
        nVolumes  = size(fmriNii.img,4); % keep all timepoints
        mask3D    = maskNii.img>0;
        [~,~,Z]   = size(mask3D);
        assert(size(colNii.img,3)==Z,'column z-dim mismatch');
        voxPerZ   = squeeze(sum(sum(mask3D,1),2));
        cumVox    = cumsum(voxPerZ);
        totalVox  = cumVox(end);
        target    = totalVox/nChunks;

        % what is total z
        [~,~,Z,~] = size(fmriNii.img);

        % split z into chunks
        baseSz    = floor(Z / nChunks);
        rem       = mod(Z, nChunks); % first rem chunks get baseSz+1, rest get baseSz
        chunkSizes = [ repmat(baseSz+1,1,rem), repmat(baseSz,1,nChunks-rem) ];

        % compute per-chunk start & end indices
        starts = cumsum([1, chunkSizes(1:end-1)]);
        ends   = cumsum(chunkSizes);

        % sanity check
        assert(ends(end)==Z, 'Z‐coverage failed');

        % now chunk both vols

        % workspace: save at the grey matter folder
        mkdir(path_analyses)
        cd(path_analyses)

        for i = 1:nChunks
            zidx = starts(i):ends(i);

            % 4D fmri chunk
            sub4     = fmriNii;
            sub4.img = sub4.img(:,:,zidx,1:nVolumes);
            sz4      = size(sub4.img); % [X Y Zchunk T]
            sub4.hdr.dime.dim(2:5) = sz4;
            save_untouch_nii(sub4, sprintf('chunk_fMRI_%s_%02d.nii', tasks{t1}, i));

            % 3D layer chunk
            sub3     = layerNii;
            sub3.img = sub3.img(:,:,zidx);
            sz3full  = size(sub3.img); % [X Y Zchunk]
            if numel(sz3full)<3, sz3full(3)=1; end
            sub3.hdr.dime.dim(2:4) = sz3full(1:3);
            save_untouch_nii(sub3, sprintf('chunk_layer_%s_%02d.nii', tasks{t1}, i));

            clear sub3
            % 3D column chunk
            sub3     = colNii;
            sub3.img = sub3.img(:,:,zidx);
            sz3full  = size(sub3.img); % [X Y Zchunk]
            if numel(sz3full)<3, sz3full(3)=1; end
            sub3.hdr.dime.dim(2:4) = sz3full(1:3);
            save_untouch_nii(sub3, sprintf('chunk_columns_%s_%02d.nii', tasks{t1}, i));

        end
    end

end

%% we devein
% i could have written a separate shell scripts but having in one matlab
% script seemed to be more coherent (at least to me eyes)

for id=1:length(ids)

    %%%%%%%%%%%%%%%
    subj = ids{id};
    disp(['devein ' subj])
    %%%%%%%%%%%%%%%

    path_analyses   = [path_par subj 'v1s1/analyses/GM/'];

    for t1=1:numel(tasks)

        for ck=1:nChunks
            % create ALF image (from laynii tutorial)
            eval(['!/Users/alex/Dropbox/paperwriting/1315/script/ALF_melmac_ENGRAMS.sh ' path_analyses ...
                'chunk_fMRI_' tasks{t1} '_0' num2str(ck) '.nii ' path_analyses])

            % devein main command line
            eval(['!LN2_DEVEIN '...
                '-input ' path_analyses 'chunk_fMRI_' tasks{t1} '_0' num2str(ck) '.nii '...
                '-layer_file ' path_analyses 'chunk_layer_' tasks{t1} '_0' num2str(ck) '.nii '...
                '-column_file ' path_analyses 'chunk_columns_' tasks{t1} '_0' num2str(ck) '.nii ' ...
                '-ALF ' path_analyses 'AFL_chunk_fMRI_' tasks{t1} '_0' num2str(ck) '.nii.gz ' ...
                '-output ' path_analyses 'chunk_fMRI_' tasks{t1} '_0' num2str(ck) '_linearDV.nii.gz'])
        end

        % after deveining, assemble back and cleanup
        eval(['!fslmerge -z ' path_analyses '/func_' tasks{t1} '_deveined.nii.gz '...
            path_analyses 'chunk_fMRI_' tasks{t1} '_*_linearDV_deveinDeconv.nii.gz'])
    end
    eval(['!gzip -f ' path_analyses '/*.nii'])
end


%% calc connectivities

%%%%%%%%% choose one of those %%%%%%%%%

for a1=1:4

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

    end

    for id=1%:length(ids)

        %%%%%%%%%%%%%%%
        subj = ids{id};
        disp(['connect ' subj])
        %%%%%%%%%%%%%%%

        if strcmp(subj,'sub-202')
            tasks   = {'rest','origenc'};
        end

        for t1=1:numel(tasks)

            path_roi    = [path_par subj 'v1s1/anat/roi/func/' tasks{t1}];
            path_func   = [path_par subj 'v1s1/analyses/GM/'];
            funcFile    = [path_func 'func_' tasks{t1} '_deveined.nii.gz'];

            % load func
            V           = single(niftiread(funcFile)); % x*y*z*t
            timeseries_mat = zeros(numel(rois), size(V,4), 'single');

            for r2 = 1:numel(rois)
                mask   = niftiread([path_roi '/' rois{r2} '_GMmasked.nii.gz']) > 0;
                masktest{r2,1}=mask; % for diagnostics
                voxels = V(repmat(mask, 1, 1, 1, size(V,4))); % apply mask through time
                timeseries_mat(r2,:) = mean(reshape(voxels, [], size(V,4)), 1,'omitnan');
            end

            % there seems to be some sort of signal leakage between the layers
            % so we need to orthogonalise
            if numel(rois)<=3 % for single within ROI connectivity

                clear deep mid midresid

                deep = timeseries_mat(1,:)';
                mid  = timeseries_mat(2,:)';

                beta_dm   = (deep\mid); % ls fit of deep -> mid
                mid_resid = mid - deep*beta_dm; % mid layer with deep component removed
                timeseries_mat(2,:) = mid_resid'; % replace row-2 with residual

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

            elseif numel(rois)>4 % for mPFC-RSC layer connectivity

                % approach 1: orthogonalise symmetrically
                % mPFC
                D = timeseries_mat(1,:)';   % deep
                M = timeseries_mat(2,:)';   % mid
                S = timeseries_mat(3,:)';   % sup

                M = M - (D\M)*D;            % mid ⟂ deep
                D = D - (M\D)*M;            % deep ⟂ mid   (now symmetric)
                X = [D M];
                S = S - X*(X\S);            % sup ⟂ [deep mid]

                timeseries_mat(1,:) = D';
                timeseries_mat(2,:) = M';
                timeseries_mat(3,:) = S';

                % RSC
                D = timeseries_mat(4,:)';
                M = timeseries_mat(5,:)';
                S = timeseries_mat(6,:)';

                M = M - (D\M)*D;
                D = D - (M\D)*M;
                X = [D M];
                S = S - X*(X\S);

                timeseries_mat(4,:) = D';
                timeseries_mat(5,:) = M';
                timeseries_mat(6,:) = S';


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
            end

            R = corrcoef(timeseries_mat'); % pearson
            R = max(min(R,0.999999),-0.999999); % keep |R| < 1
            Z = atanh(R); % fisher-z (now finite)

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
            acompcor=dlmread([path_par subj...
                'v1s1/func/compcor_csf_wm_' tasks{t1} '.txt'], '\t', 1, 0);
            % realignment regressors
            nuisanceReg=load([path_par subj 'v1s1/func/reg_all_' tasks{t1} '.mat'],'R');

            % assemble
            if layerFlag
                if numel(rois)<=3
                    sup_ts = timeseries_mat(3,:);
                    confounds   = [nuisanceReg.R acompcor sup_ts'];
                elseif numel(rois)>3
                    sup_ts = timeseries_mat([3 6],:);
                    confounds   = [nuisanceReg.R acompcor sup_ts'];
                end
            else
                % for hippocampal subfields we do something else
                confounds   = [nuisanceReg.R acompcor];
            end
            confounds = zscore(confounds); % z-scores each column
            % confounds(:,any(isnan(confounds))) = []; % drop all-NaN columns (just in case)

            beta   = pinv(confounds)*timeseries_mat';
            cleaned= timeseries_mat' - confounds*beta; % residuals -> correlate

            R=corrcoef(cleaned);
            Z = atanh(R);

            disp('cleaned R=')
            disp(R)
            disp('cleaned Z=')
            disp(Z)

            mkdir(['/Users/alex/Dropbox/paperwriting/1315/data/segmentation/' ...
                subj 'v1s1/analyses/' folderlabel])
            save(['/Users/alex/Dropbox/paperwriting/1315/data/segmentation/' ...
                subj 'v1s1/analyses/' folderlabel '/Z_' subj '_' tasks{t1} '.mat'], 'Z','R')

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

for a1=1:4

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

    end

    for id=1:length(ids)

        %%%%%%%%%%%%%%%
        subj = ids{id};
        disp(['connect ' subj])
        %%%%%%%%%%%%%%%

        for t1=1:numel(tasks)
            close all

            % load fisher-z mat we calculated above
            load([path_par subj 'v1s1/analyses/' folderlabel '/Z_' subj '_' tasks{t1} '.mat'],'Z')

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

            G     = graph(A, rois, 'upper');
            rvec  = G.Edges.Weight; % signed r values for surviving edges

            % layout
            theta = linspace(0,2*pi,nR+1); theta(end)=[];
            xy    = [cos(theta); sin(theta)];

            figure;
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
            savefig([path_par subj 'v1s1/analyses/' folderlabel '/connectivities_' subj '_' tasks{t1} '.fig'])

            % heatmap
            figure; imagesc(Z); axis square
            set(gca,'XTick',1:nR,'XTickLabel',rois, ...
                'YTick',1:nR,'YTickLabel',rois, ...
                'TickLabelInterpreter', 'none');
            colormap(redblue);caxis([-1 1])
            colorbar; title({[subj '  ROI connectivity (fisher-z)'],['phase: ' tasks{t1}]})
            savefig([path_par subj 'v1s1/analyses/' folderlabel '/heatmap_' subj '_' tasks{t1} '.fig'])

            % summary printout: all lower-triangle pairs
            clc
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

