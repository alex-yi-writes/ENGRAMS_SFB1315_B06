%%CONN Script New%%

%% preparation

clc; clear all;

% setup paths
path_parent = '/Volumes/ALEX_DATA2/RESTING_STATE/analysistest/';
path_data   = [path_parent 'data_missing/'];
path_result = [path_parent '0_results/'];

% define subjects
% load('/Users/alex/Dropbox/paperwriting/resting state/data/ID_LIDO.mat')
% subjects = ID_LIDO;
% subject = ID_LIDO;
subjects = {'105','106','314'};
subject = {'105','106','314'};
ID_LIDO = subject;


% specify missing data, column 1 - EM, column 2 - SW
dataStats = [];
for id=1:length(ID_LIDO)
    if ismember(ID_LIDO{id},{'210', '306', '322'}) % if EM data missing
        dataStats(id,1)=0;
        dataStats(id,2)=1;
    elseif ismember(ID_LIDO{id},{'115', '202', '216', '218', '301',...
            '314', '317', '318', '319', '325', '327', '329', '333'}) % if SW data is missing
        dataStats(id,1)=1;
        dataStats(id,2)=0;
    elseif ismember(ID_LIDO{id},{'316'}) % EM data with no regressor but yes SW data
        dataStats(id,1)=NaN;
        dataStats(id,2)=1;
    elseif ismember(ID_LIDO{id},{'301'}) % EM data with no regressor and no SW data
        dataStats(id,1)=NaN;
        dataStats(id,2)=0;    
    elseif ismember(ID_LIDO{id},{'224', '322'})
        dataStats(id,1)=0;
        dataStats(id,2)=0;
    else
        dataStats(id,1)=1;
        dataStats(id,2)=1;
    end
    
end


cd(path_parent)

% clean up the thumbnail bullshit from mac
for id=1:length(ID_LIDO)
    
    % request cleanup for mac
    eval(['!rm ' path_data  ID_LIDO{id} '/._*'])
    eval(['!rm ' path_data  ID_LIDO{id} '/anat/._*'])
    eval(['!rm ' path_data  ID_LIDO{id} '/funcEM/._*'])
    eval(['!rm ' path_data  ID_LIDO{id} '/funcSW/._*'])
    eval(['!rm ' path_data  ID_LIDO{id} '/segs/._*'])
        
end

% load ROIs
% load([path_parent 'ROInames.mat'])

disp('prep done')

%% setup commands

clear batch;

batch.filename          = [path_result 'conn_missing2.mat'];
batch.Setup.done        = 1; 
batch.Setup.overwrite   = 1; % 1 = overwrite previous analysis

disp('batch opened')

%% basic

batch.Setup.nsubjects = length(subjects); % the number of subjects

% prepare overall experimental information
for i= 1:length(subjects)
    
%     nsessions(i)    = 2; % EM and SW together
    RT(i)           = 1.46;
    acq(i)          = 1;
    
end 

nsessions                   = nansum(dataStats,2)';
batch.Setup.nsessions       = nsessions;
batch.Setup.RT              = RT;
batch.Setup.acquisitiontype = acq;

% indicate missing datasets
batch.Setup.basic = nansum(dataStats,2);

disp('base info defined')

%% define ROIs

cd(path_data)

batch.Setup.done = 0;

grey            = cellstr(conn_dir('*c1*.nii'));
white           = cellstr(conn_dir('*c2*.nii'));
csf             = cellstr(conn_dir('*c3*.nii'));

a35             = cellstr(conn_dir('*A35.nii'));
a36             = cellstr(conn_dir('*A36.nii'));
amygdala        = cellstr(conn_dir('*amygdala.nii'));

ca1             = cellstr(conn_dir('*CA1.nii'));
ca2             = cellstr(conn_dir('*CA2.nii'));
ca3             = cellstr(conn_dir('*CA3.nii'));
cac             = cellstr(conn_dir('*CaudalAnteriorCingulate.nii'));
caudate         = cellstr(conn_dir('*caudate.nii'));
cerebellum      = cellstr(conn_dir('*cerebellum.nii'));

dentategyrus    = cellstr(conn_dir('*DG.nii'));

entorhinal      = cellstr(conn_dir('*entorhinal.nii'));
etc             =  cellstr(conn_dir('*ETC.nii'));

frontalpole     =  cellstr(conn_dir('*frontalpole.nii'));

hippocampaltail =  cellstr(conn_dir('*HippocampalTail.nii'));
hippocampus     =  cellstr(conn_dir('*hippocampus.nii'));

insula          =  cellstr(conn_dir('*insula.nii'));

lc              =  cellstr(conn_dir('*LCmask_on_EPI.nii'));

middlefrontal   =  cellstr(conn_dir('*MiddleFrontal.nii'));
middletemporal  =  cellstr(conn_dir('*MiddleTemporal.nii'));

pallidum        =  cellstr(conn_dir('*pallidum.nii'));
parahippocampalgyrus =  cellstr(conn_dir('*parahippocampal.nii'));
parsoperculais  =  cellstr(conn_dir('*parsopercularis.nii'));
parstriangularis =  cellstr(conn_dir('*parstriangularis.nii'));
phc             =  cellstr(conn_dir('*PHC.nii'));
precuneus       =  cellstr(conn_dir('*precuneus.nii'));
% prefrontalgyrus =  cellstr(conn_dir('*prefrontal.nii')); % doesn't exist
putamen         =  cellstr(conn_dir('*putamen.nii'));

rostralacc      = cellstr(conn_dir('*RostralAnteriorCingulate.nii'));

sn              = cellstr(conn_dir('*SNmask_on_EPI.nii'));
subiculum       = cellstr(conn_dir('*Subiculum.nii'));
superiorfrontalgyrus  = cellstr(conn_dir('*SuperiorFrontal.nii'));
superiorparietalgyrus = cellstr(conn_dir('*SuperiorParietal.nii'));
superiortemporalgyrus = cellstr(conn_dir('*SuperiorTemporal.nii'));

temporalpole    = cellstr(conn_dir('*temporalpole.nii'));

thalamusav      = cellstr(conn_dir('*Thalamus_AV.nii'));
thalamuscl      = cellstr(conn_dir('*Thalamus_CL.nii'));
thalamuscm      = cellstr(conn_dir('*Thalamus_CM.nii'));
thalamusld      = cellstr(conn_dir('*Thalamus_LD.nii'));
thalamuslgn     = cellstr(conn_dir('*Thalamus_LGN.nii'));
thalamusmdl     = cellstr(conn_dir('*Thalamus_MDl.nii'));
thalamusmdm     = cellstr(conn_dir('*Thalamus_MDm.nii'));
thalamusmgn     = cellstr(conn_dir('*Thalamus_MGN.nii'));
thalamuspul     = cellstr(conn_dir('*Thalamus_PuI.nii'));
thalamuspum     = cellstr(conn_dir('*Thalamus_PuM.nii'));
thalamus        = cellstr(conn_dir('*thalamus.nii'));

vta             = cellstr(conn_dir('*VTAmask_on_EPI.nii'));


% setup base masks
for id = 1:length(subjects) 
    
    anat_dir = [path_data subjects{id} '/anat']; %char(fullfile(cwd, subject(id), 'anat'));
    
    cd(anat_dir);
    
    grey_file   = strcat(conn_dir('*c1*.nii'));
    white_file  = strcat(conn_dir('*c2*.nii'));
    csf_file    = strcat(conn_dir('*c3*.nii'));
    
    batch.Setup.masks.Grey.files{id}    = grey_file;
    batch.Setup.masks.White.files{id}   = white_file;
    batch.Setup.masks.CSF.files{id}     = csf_file;
    
end


% setup ROIs

batch.Setup.rois.names = {...
    'Grey Matter','White Matter','CSF', ...
    'A35','A36','Amygdala', ...
    'CA1','CA2','CA3','Caudal ACC','Caudate','Cerebellum',...
    'Dentate gyrus', ...
    'Entorhinal cortex','ETC',...
    'Frontal pole',...
    'Hippocampal tail','Hippocampus',...
    'Insula',...
    'LC',...
    'Middle frontal gyrus','Middle temporal gyrus',...
    'Pallidum','Parahippocampal gyrus','Pars operculais','Pars triangularis','PHC','Precuneus','Putamen',...
    'Rostral ACC',...
    'SN','Subiculum','Superior frontal gyrus','Superior parietal gyrus','Superior temporal gyrus',...
    'Temporal pole',...
    'Thalamus AV','Thalamus CL','Thalamus CM','Thalamus LD','Thalamus LGN','Thalamus MDl','Thalamus MDm','Thalamus MGN','Thalamus Pul',...
    'Thalamus PuM','Thalamus', ...
    'VTA'
    };

batch.Setup.rois.files = { {grey}, {white}, {csf},...
    {a35}, {a36}, {amygdala}, ...
    {ca1}, {ca2}, {ca3}, {cac}, {caudate}, {cerebellum},...
    {dentategyrus}, ...
    {entorhinal}, {etc},...
    {frontalpole}, ...
    {hippocampaltail}, {hippocampus}, ...
    {insula}, ...
    {lc}, ...
    {middlefrontal}, {middletemporal},...
    {pallidum}, {parahippocampalgyrus}, {parsoperculais}, {parstriangularis}, {phc}, {precuneus}, {putamen},...
    {rostralacc}, ...
    {sn}, {subiculum}, {superiorfrontalgyrus}, {superiorparietalgyrus}, {superiortemporalgyrus},...
    {temporalpole},...
    {thalamusav}, {thalamuscl}, {thalamuscm}, {thalamusld}, {thalamuslgn}, {thalamusmdl}, {thalamusmdm}, {thalamusmgn},...
    {thalamuspul}, {thalamuspum}, {thalamus},...
    {vta} };

% batch.Setup.rois.files = {grey,white,csf,a35,a36,amygdala,ca1,...
%     ca2, ca3,cac,caudate,cerebellum,dentategyrus,entorhinal,etc,...
%     frontalpole,hippocampaltail,hippocampus,insula,lc, middlefrontal,middletemporal,...
%     pallidum,parahippocampalgyrus,parsoperculais,parstriangularis, phc, precuneus,prefrontalgyrus,... 
%     putamen,rostralacc,sn,subiculum,superiorfrontalgyrus,superiorparietalgyrus, superiortemporalgyrus,...
%     temporalpole,thalamusav,thalamuscl,thalamuscm,thalamusld,thalamuslgn,thalamusmdl,thalamusmdm,...
%     thalamusmgn,thalamuspul,thalamuspum,thalamus,vta};

batch.Setup.rois.regresscovariates = 1;

disp('ROIs defined')

%% Functional & Structural

SubjectFolder       = subject;
SessionSubFolder    = {'funcEM','funcSW'};

cwd = path_data;

for id=1:numel(SubjectFolder)
    
    for sess=1:numel(SessionSubFolder)
        
        if strcmp(SessionSubFolder{sess},'funcEM')
            if dataStats(id,1)==0
                disp('no data')
            else
                files = conn_dir(fullfile(cwd,SubjectFolder{id},SessionSubFolder{sess},'auf*-1.nii'));
                batch.Setup.functionals{id}{sess} = files;
                fprintf('Subject %d, Session %s: %d functional files in %s\n',...
                    id,SessionSubFolder{sess},size(files,1),fullfile(SubjectFolder{id},SessionSubFolder{sess}));
        
            end
        elseif strcmp(SessionSubFolder{sess},'funcSW')
            if dataStats(id,2)==0
                disp('no data')
            else
                files = conn_dir(fullfile(cwd,SubjectFolder{id},SessionSubFolder{sess},'res*_sw2em.nii'));
                batch.Setup.functionals{id}{sess} = files;
                fprintf('Subject %d, Session %s: %d functional files in %s\n',...
                    id,SessionSubFolder{sess},size(files,1),fullfile(SubjectFolder{id},SessionSubFolder{sess}));
        
            end
        end
        
        
    end
    
    filesx  = conn_dir(fullfile(cwd,SubjectFolder{id},'anat/T1_on_EPI.nii'));
    if size(filesx,1)~=1, error('no anatomical file found'); end
    batch.Setup.structurals{id} = filesx;
    
end

disp('functional and structural images defined')

%% Conditions : right now only one condition

batch.Setup.conditions.names{1} = 'rest';

for ncond = 1:length(batch.Setup.conditions.names)
    
    for id = 1:length(subject) % for the number of subjects
        
        for sess = 1:nsessions(id) % for the number of sessions
            if isnan(dataStats(id,sess)) % if regressor info is not available
            batch.Setup.conditions.onsets{ncond}{id}{sess}      = NaN;
            batch.Setup.conditions.durations{ncond}{id}{sess}   = NaN;    
            else
            batch.Setup.conditions.onsets{ncond}{id}{sess}      = 0;
            batch.Setup.conditions.durations{ncond}{id}{sess}   = [inf];
            end
        end
        
    end
    
end

disp('conditions defined')

%% Covariates

cd(path_data)

batch.Setup.covariates.names    = {'realignment','physio and task'};

realignment      = string(conn_dir('*rp_auf*.txt'));
physioandtask    = string(conn_dir('*regr_mat.mat'));

for id = 1:length(subject)
    for sess = 1:nsessions(id)
        if strcmp(SessionSubFolder{sess},'funcEM')
            if dataStats(id,1)==0
                disp('no data')
            else
                clear realignment physioandtask
                realignment      = string(conn_dir('*rp_auf*_em.txt'));
                physioandtask    = string(conn_dir('*regr_mat_em.mat'));
            end
        elseif strcmp(SessionSubFolder{sess},'funcSW')
            if dataStats(id,2)==0
                disp('no data')
            else
                clear realignment physioandtask
                realignment      = string(conn_dir('*rp_auf*_sw.txt'));
                physioandtask    = string(conn_dir('*regr_mat_sw.mat'));
            end
        end
        batch.Setup.covariates.files{1}{id}{sess} = realignment{id};
        batch.Setup.covariates.files{2}{id}{sess} = physioandtask{id};
    end
end

batch.Setup.covariates.add = 0;

disp('covariates defined')

%%%%%%%%%%%%%%%%%%%
 conn_batch(batch)
%%%%%%%%%%%%%%%%%%%

disp('batch mid-save')

%% Options

batch.Setup.analyses        = [1,2];
batch.Setup.voxelresolution = 3;
batch.Setup.voxelmask       = 1;
batch.Setup.voxelmaskfile   = '/Applications/spm12/toolbox/FieldMap/brainmask.nii';
% batch.Setup.voxelmaskfile   = fullfile(append(strtrim(fileparts(which('spm'))),'\toolbox\FieldMap\brainmask.nii'));
batch.Setup.analysisunits   = 1;
batch.Setup.outputfiles     = [1,1,1,1,1,1];

disp('options selected')

%% Preprocessing Commands

batch.Setup.preprocessing.steps             ='functional_art';
batch.Setup.preprocessing.art_thresholds(1) = 9;
batch.Setup.preprocessing.art_thresholds(2) = 2;

disp('preproc options selected')

%% run (as much as we can)

%%%%%%%%%%%%%%%%%
conn_batch(batch)
%%%%%%%%%%%%%%%%%

disp('batch setup done')

%% Denoising - doesn't work within the batch script

batch.Denoising.done = 1;
batch.Denoising.overwrite = 1;
batch.Denoising.filter = [0.01 inf];
batch.Denoising.detrending = 1;
batch.Denoising.despiking = 0;
batch.Denoising.regbp = 1;
batch.Denoising.filter  = [0.008 0.1];
batch.Denoising.confounds.names = {'Grey Matter';'White Matter';'CSF';'realignment';'scrubbing';'physio and task';};

disp('denoising done')


%% First Level Analysis - doesn't work within the batch script

batch.Analysis.name = 'Test_ROI_to_ROI_Analysis';
batch.Analysis.done = 1;
batch.Analysis.overwrite = 0; 
batch.Analysis.measure = 1;
batch.Analysis.weight = 2;
batch.Analysis.modulation = 0;
batch.Analysis.type = [1,2];

disp('1st level done')


%% Final
conn_batch(batch);
% conn
% conn ('load', fullfile('D:/Hiwi/CONN/conn.mat'));
% conn gui_results
