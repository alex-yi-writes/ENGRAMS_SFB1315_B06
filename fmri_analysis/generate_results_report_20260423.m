%% gererate results report

clc;clear;
%
% IDs  = [2202 2203 2204 2205 2206 2207 2208 2109 2110 2112 2113 2114 2115 2116 2217 2218 2219 2220 2221 2222 2223 2224 2125 2126 2127 2129 2130]; %% 2203 2207 2217 delayed memory test lost
% days = [1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2];
% d1m  = [1 2; 1 0; 1 2; 1 2; 1 2; 1 0; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2]; % 1=immediate 2=delayed
% d2m  = [1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 0; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2; 1 2];

path_2nd = '/Users/yyi/Desktop/EM/2nd/';
load('/Users/yyi/Desktop/EM/ID_2nd.mat')

tmp = dir(path_2nd);
list_2nd = tmp(~startsWith({tmp.name}, '.'));
clear tmp

% load all SPM.mat files
SPMmat = {};
mc = 0;
for l1 = 1:length(list_2nd)
    mc = mc + 1;
    SPMmat{mc,1} = load([path_2nd list_2nd(l1).name '/SPM.mat']);
end


%% now collect

getcons = @(s) s.SPM.xCon;  % always returns struct array


% uncorrected p<0.001, grey matter mask, collect TabDat for FDRc 

FDRmat = {};
fdrc   = 0;

for l2 = 1:length(SPMmat)

    cons = getcons(SPMmat{l2,1});

    for xcon = 1:length(cons)

        disp(cons(xcon).name)
        cd(SPMmat{l2,1}.SPM.swd)

        clear matlabbatch
        spm_jobman('initcfg');

        matlabbatch{1}.spm.stats.results.spmmat              = cellstr([SPMmat{l2,1}.SPM.swd '/SPM.mat']);
        matlabbatch{1}.spm.stats.results.conspec.titlestr    = cons(xcon).name;
        matlabbatch{1}.spm.stats.results.conspec.contrasts   = xcon;   % explicit index
        matlabbatch{1}.spm.stats.results.conspec.threshdesc  = 'none';
        matlabbatch{1}.spm.stats.results.conspec.thresh      = 0.001;
        matlabbatch{1}.spm.stats.results.conspec.extent      = 0;
        matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
        matlabbatch{1}.spm.stats.results.conspec.mask.image.name  = {'/Users/yyi/Desktop/ENGRAMS/templates/mni_icbm152/grey_bin.nii,1'};
        matlabbatch{1}.spm.stats.results.conspec.mask.image.mtype = 0;
        matlabbatch{1}.spm.stats.results.units  = 1;
        matlabbatch{1}.spm.stats.results.print  = false;
        matlabbatch{1}.spm.stats.results.write.tspm.basename = [cons(xcon).name '_p001_c0_grey'];

        spm_jobman('run', matlabbatch);

        % TabDat is written to the base workspace by spm_list
        if ~exist('TabDat', 'var')
            error('TabDat was not populated after running results for contrast "%s" (model %d). Check SPM version compatibility.', cons(xcon).name, l2);
        end

        fdrc = fdrc + 1;
        FDRmat{fdrc, 1} = TabDat;
        FDRmat{fdrc, 2} = l2;     % store model index for safe cross-referencing
        FDRmat{fdrc, 3} = xcon;   % store contrast index for safe cross-referencing
        clear TabDat              % clear to catch missing population on next iteration

    end
end

save([path_2nd 'FDRmat.mat'], 'FDRmat')



%% cluster-corrected (FDRc extent), binary GM mask 

getFDRcExtent = @(td) getExtentSafe(td);

% FDRmat is already in workspace; reload only if running this section independently
if ~exist('FDRmat', 'var')
    load([path_2nd 'FDRmat.mat'])
end

if ~exist('SPMmat', 'var')
    SPMmat = {};
    mc = 0;
    for l1 = 1:length(list_2nd)
        mc = mc + 1;
        SPMmat{mc,1} = load([path_2nd list_2nd(l1).name '/SPM.mat']);
    end
end

for l3 = 1:length(SPMmat)

    cons = getcons(SPMmat{l3,1});

    for xcon = 1:length(cons)

        % find corresponding FDRmat entry by stored indices (safe, order-independent)
        idx = find(cell2mat(FDRmat(:,2)) == l3 & cell2mat(FDRmat(:,3)) == xcon);
        if isempty(idx)
            warning('No FDRmat entry found for model %d, contrast %d. Skipping.', l3, xcon);
            continue
        end
        k_extent = getFDRcExtent(FDRmat{idx, 1});

        clear matlabbatch
        spm_jobman('initcfg');

        matlabbatch{1}.spm.stats.results.spmmat              = cellstr([SPMmat{l3,1}.SPM.swd '/SPM.mat']);
        matlabbatch{1}.spm.stats.results.conspec.titlestr    = cons(xcon).name;
        matlabbatch{1}.spm.stats.results.conspec.contrasts   = xcon;
        matlabbatch{1}.spm.stats.results.conspec.threshdesc  = 'none';
        matlabbatch{1}.spm.stats.results.conspec.thresh      = 0.001;
        matlabbatch{1}.spm.stats.results.conspec.extent      = k_extent;
        matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
        matlabbatch{1}.spm.stats.results.conspec.mask.image.name  = {'/Users/yyi/Desktop/ENGRAMS/templates/mni_icbm152/grey_bin.nii,1'};
        matlabbatch{1}.spm.stats.results.conspec.mask.image.mtype = 0;
        matlabbatch{1}.spm.stats.results.units  = 1;
        matlabbatch{1}.spm.stats.results.print  = false;
        matlabbatch{1}.spm.stats.results.write.tspm.basename = [cons(xcon).name '_p001_c' num2str(k_extent) '_grey'];

        spm_jobman('run', matlabbatch);

    end
end


%% brainstem mask, uncorrected p<0.001, no cluster extent

for l4 = 1:length(SPMmat)

    cons = getcons(SPMmat{l4,1});

    for xcon = 1:length(cons)

        clear matlabbatch
        spm_jobman('initcfg');

        matlabbatch{1}.spm.stats.results.spmmat              = cellstr([SPMmat{l4,1}.SPM.swd '/SPM.mat']);
        matlabbatch{1}.spm.stats.results.conspec.titlestr    = cons(xcon).name;
        matlabbatch{1}.spm.stats.results.conspec.contrasts   = xcon;
        matlabbatch{1}.spm.stats.results.conspec.threshdesc  = 'none';
        matlabbatch{1}.spm.stats.results.conspec.thresh      = 0.001;
        matlabbatch{1}.spm.stats.results.conspec.extent      = 0;
        matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
        matlabbatch{1}.spm.stats.results.conspec.mask.image.name  = {'/Users/yyi/Desktop/ENGRAMS/templates/mni_icbm152/brainstemMask_short.nii,1'};
        matlabbatch{1}.spm.stats.results.conspec.mask.image.mtype = 0;
        matlabbatch{1}.spm.stats.results.units  = 1;
        matlabbatch{1}.spm.stats.results.print  = false;
        matlabbatch{1}.spm.stats.results.write.tspm.basename = [cons(xcon).name '_p001_c0_Brainstem'];

        spm_jobman('run', matlabbatch);

    end
end


%%  move result images

for f1 = 1:length(SPMmat)

    path_source = SPMmat{f1,1}.SPM.swd;
    path_dest   = '/Users/yyi/Desktop/EM/results/nii/';

    tmplist = dir([path_source '/spmT_00*_*.nii']);
    for ff1 = 1:length(tmplist)
        movefile(fullfile(tmplist(ff1).folder, tmplist(ff1).name), ...
                 fullfile(path_dest, tmplist(ff1).name))
    end

    tmplist = dir([path_source '/spmF_00*_*.nii']);
    for ff2 = 1:length(tmplist)
        movefile(fullfile(tmplist(ff2).folder, tmplist(ff2).name), ...
                 fullfile(path_dest, tmplist(ff2).name))
    end

end

%% work on the results report

% export data to CSV
ind=~isnan(table2array(results(:,4)));
results(ind==0,:)=[];
writetable(results,'resultstable.xls')
clear results

% first, AAL -> cluster labelling (ROI_MNI_V7_1mm.nii) -> right click the table -> extract data
% structure
clear clusterlabelling
clusterlabelling = [ans.hdr;ans.dat];
writecell(clusterlabelling,'clusterlabelling.xls')

%%
% extract FDRc cluster extent from TabDat
% TabDat.ftr{5,2}(4) is the expected location of the FDRc-corrected k threshold


function k = getExtentSafe(td)
    k = 0;  % default: no cluster extent threshold
    try
        val = td.ftr{5,2};
        if isnumeric(val) && numel(val) >= 4
            k = val(4);
        else
            warning('FDRc extent field does not have expected structure; defaulting extent to 0.');
        end
    catch
        warning('Could not read FDRc extent from TabDat.ftr; defaulting extent to 0.');
    end
end

