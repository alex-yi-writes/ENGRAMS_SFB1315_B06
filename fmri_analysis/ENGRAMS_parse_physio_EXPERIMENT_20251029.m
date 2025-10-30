%% parse connectome physio files (because somehow it's different from the previous Siemens-Tics formats)
% requirements: - TAPAS physIO [https://github.com/translationalneuromodeling/tapas/tree/master/PhysIO]
%               - SPM12 [https://www.fil.ion.ucl.ac.uk/spm/software/spm12/]
% for questions please send an email to alex: ucjuyyi@ucl.ac.uk

%% prep

clc; clear;
path_raw = '/Users/yyi/Desktop/ENGRAMS/raw/';
path_preproc = '/Users/yyi/Desktop/ENGRAMS/preproc/';
sessionTypes = {'AUTO','REST','ORIGENC','ORIGREC1','ORIGREC2','RECOMBIENC','RECOMBIREC'};  % name tags for the physio files and the output files

% open options
[selected, ok] = listdlg( ...
    'PromptString', 'Select one or more options:', ...
    'SelectionMode', 'multiple', ...
    'ListString', sessionTypes);

% list subjects
ID = {'306'};%{'302','303','304'};%{'102','104','106','107'};%,'108','109'};%,'202'};

% fixed parametres
nSlices=96;
TR=2;
nDummies=0;
onsetSlice=42;

disp('prep done')

%% now parse

for id=1:length(ID)

    disp(['processing ID' ID{id}])

    if ok

        % iterate through selected options
        for i1 = selected

            choice = sessionTypes{i1};

            switch choice
                case 'AUTO'

                    sess    = lower(sessionTypes{i1}); % 'for pattern matching
                    disp(['selected option ' sess]);

                    clear tmpfmri f fpath hdr dims nVols
                    tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s2/func/sub-*autobio*.nii*']);
                    if isempty(tmpfmri)
                        error('No NIfTI found for %s, ID %s', choice, ID{id});
                    end
                    f = tmpfmri(1);
                    fpath = fullfile(f.folder, f.name);

                    % read header only (works on .nii and .nii.gz)
                    hdr   = niftiinfo(fpath);
                    dims  = hdr.ImageSize;
                    if numel(dims) >= 4
                        nVols = dims(4);
                    else
                        nVols = 1;
                    end
%                     if isempty(tmpfmri)
%                         disp('seems to be only compressed niftii file there - proceeding to decompress')
%                         clear tmpfmri
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s2/func/sub-*autobio*.nii.gz']);
%                         eval(['!gzip -d ' fullfile(tmpfmri.folder,tmpfmri.name) ' -f'])
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s2/func/sub-*autobio*.nii']);
%                     end
%                     nVols   = length( spm_vol( [path_preproc 'sub-' ID{id} 'v2s2/func/' tmpfmri.name] ) );
%                     eval(['!gzip ' path_preproc 'sub-' ID{id} 'v2s2/func/' tmpfmri.name ' -f'])

                    clear path_rawphysio
                    path_rawphysio=[path_raw ID{id} 'v2s2/physio/'];

                case 'REST'
                    sess    = lower(sessionTypes{i1}); % 'for pattern matching
                    disp(['selected option ' sess]);

                    clear tmpfmri f fpath hdr dims nVols
                    tmpfmri = dir([path_preproc 'sub-' ID{id} 'v1s1/func/sub-*rest_run-*.nii*']);
                    if isempty(tmpfmri)
                        error('No NIfTI found for %s, ID %s', choice, ID{id});
                    end
                    f = tmpfmri(1);
                    fpath = fullfile(f.folder, f.name);

                    % read header only (works on .nii and .nii.gz)
                    hdr   = niftiinfo(fpath);
                    dims  = hdr.ImageSize;
                    if numel(dims) >= 4
                        nVols = dims(4);
                    else
                        nVols = 1;
                    end
%                     if isempty(tmpfmri)
%                         disp('seems to be only compressed niftii file there - proceeding to decompress')
%                         clear tmpfmri
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v1s1/func/sub-*rest*.nii.gz']);
%                         eval(['!gzip -d ' fullfile(tmpfmri.folder,tmpfmri.name) ' -f'])
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v1s1/func/sub-*rest*.nii']);
%                     end
%                     nVols   = length( spm_vol( [path_preproc 'sub-' ID{id} 'v1s1/func/' tmpfmri.name] ) );
%                     eval(['!gzip ' path_preproc 'sub-' ID{id} 'v1s1/func/' tmpfmri.name ' -f'])

                    clear path_rawphysio
                    path_rawphysio=[path_raw ID{id} 'v1s1/physio/'];

                case 'ORIGENC'
                    sess    = lower(sessionTypes{i1}); % 'for pattern matching
                    disp(['selected option ' sess]);

                    clear tmpfmri f fpath hdr dims nVols
                    if str2num(ID{id}(1))==2
                    tmpfmri = dir([path_preproc 'sub-' ID{id} 'v1s1/func/sub-*_task-origenc_run-*.nii*']);
                    else
                    tmpfmri = dir([path_preproc 'sub-' ID{id} 'v1s1/func/sub-*_task-origenc_run-*.nii*'])
                    end
                    if isempty(tmpfmri)
                        error('No NIfTI found for %s, ID %s', choice, ID{id});
                    end
                    f = tmpfmri(1);
                    fpath = fullfile(f.folder, f.name);

                    % read header only (works on .nii and .nii.gz)
                    hdr   = niftiinfo(fpath);
                    dims  = hdr.ImageSize;
                    if numel(dims) >= 4
                        nVols = dims(4);
                    else
                        nVols = 1;
                    end
%                     if isempty(tmpfmri)
%                         disp('seems to be only compressed niftii file there - proceeding to decompress')
%                         clear tmpfmri
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s2/func/sub-*origenc*.nii.gz']);
%                         eval(['!gzip -d ' fullfile(tmpfmri.folder,tmpfmri.name) ' -f'])
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s2/func/sub-*origenc*.nii']);
%                     end
%                     nVols   = length( spm_vol( [path_preproc 'sub-' ID{id} 'v2s2/func/' tmpfmri.name] ) );
%                     eval(['!gzip ' path_preproc 'sub-' ID{id} 'v2s2/func/' tmpfmri.name ' -f'])

                    clear path_rawphysio
                    if strcmp('2',ID{id}(1))
                    path_rawphysio=[path_raw ID{id} 'v1s1/physio/'];
                    else
                    path_rawphysio=[path_raw ID{id} 'v1s1/physio/'];
                    end

                case 'ORIGREC1'
                    sess    = lower(sessionTypes{i1}); % 'for pattern matching
                    disp(['selected option ' sess]);
                    
                    clear tmpfmri f fpath hdr dims nVols
                    tmpfmri = dir([path_preproc 'sub-' ID{id} 'v1s1/func/sub-*_task-origrec1_run-*.nii*']);
                    if isempty(tmpfmri)
                        error('No NIfTI found for %s, ID %s', choice, ID{id});
                    end
                    f = tmpfmri(1);
                    fpath = fullfile(f.folder, f.name);

                    % read header only (works on .nii and .nii.gz)
                    hdr   = niftiinfo(fpath);
                    dims  = hdr.ImageSize;
                    if numel(dims) >= 4
                        nVols = dims(4);
                    else
                        nVols = 1;
                    end
%                     if isempty(tmpfmri)
%                         disp('seems to be only compressed niftii file there - proceeding to decompress')
%                         clear tmpfmri
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v1s1/func/sub-*origrec1*.nii.gz']);
%                         eval(['!gzip -d ' fullfile(tmpfmri.folder,tmpfmri.name) ' -f'])
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v1s1/func/sub-*origrec1*.nii']);
%                     end
%                     nVols   = length( spm_vol( [path_preproc 'sub-' ID{id} 'v1s1/func/' tmpfmri.name] ) );
%                     eval(['!gzip ' path_preproc 'sub-' ID{id} 'v1s1/func/' tmpfmri.name ' -f'])

                    clear path_rawphysio
                    path_rawphysio=[path_raw ID{id} 'v1s1/physio/'];

                case 'ORIGREC2'
                    sess    = lower(sessionTypes{i1}); % 'for pattern matching
                    disp(['selected option ' sess]);
        
                    clear tmpfmri f fpath hdr dims nVols
                    tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s1/func/sub-*_task-origrec2_run-*.nii*']);
                    if isempty(tmpfmri)
                        error('No NIfTI found for %s, ID %s', choice, ID{id});
                    end
                    f = tmpfmri(1);
                    fpath = fullfile(f.folder, f.name);

                    % read header only (works on .nii and .nii.gz)
                    hdr   = niftiinfo(fpath);
                    dims  = hdr.ImageSize;
                    if numel(dims) >= 4
                        nVols = dims(4);
                    else
                        nVols = 1;
                    end
%                     if isempty(tmpfmri)
%                         disp('seems to be only compressed niftii file there - proceeding to decompress')
%                         clear tmpfmri
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s1/func/sub-*origrec2*.nii.gz']);
%                         eval(['!gzip -d ' fullfile(tmpfmri.folder,tmpfmri.name) ' -f'])
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s1/func/sub-*origrec2*.nii']);
%                     end
%                     nVols   = length( spm_vol( [path_preproc 'sub-' ID{id} 'v2s1/func/' tmpfmri.name] ) );
%                     eval(['!gzip ' path_preproc 'sub-' ID{id} 'v2s1/func/' tmpfmri.name ' -f'])

                    clear path_rawphysio
                    path_rawphysio=[path_raw ID{id} 'v2s1/physio/'];

                case 'RECOMBIENC'
                    sess    = lower(sessionTypes{i1}); % 'for pattern matching
                    disp(['selected option ' sess]);
    
                    clear tmpfmri f fpath hdr dims nVols
                    tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s1/func/sub-*_task-recombienc*_run-*.nii*']);
                    if isempty(tmpfmri)
                        error('No NIfTI found for %s, ID %s', choice, ID{id});
                    end
                    f = tmpfmri(1);
                    fpath = fullfile(f.folder, f.name);

                    % read header only (works on .nii and .nii.gz)
                    hdr   = niftiinfo(fpath);
                    dims  = hdr.ImageSize;
                    if numel(dims) >= 4
                        nVols = dims(4);
                    else
                        nVols = 1;
                    end
%                     if isempty(tmpfmri)
%                         disp('seems to be only compressed niftii file there - proceeding to decompress')
%                         clear tmpfmri
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s1/func/sub-*recombienc*.nii.gz']);
%                         eval(['!gzip -d ' fullfile(tmpfmri.folder,tmpfmri.name) ' -f'])
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s1/func/sub-*recombienc*.nii']);
%                     end
%                     nVols   = length( spm_vol( [path_preproc 'sub-' ID{id} 'v2s1/func/' tmpfmri.name] ) );
%                     eval(['!gzip ' path_preproc 'sub-' ID{id} 'v2s1/func/' tmpfmri.name ' -f'])

                    clear path_rawphysio
                    path_rawphysio=[path_raw ID{id} 'v2s1/physio/'];

                case 'RECOMBIREC'
                    sess    = lower(sessionTypes{i1}); % 'for pattern matching
                    disp(['selected option ' sess]);

                    clear tmpfmri f fpath hdr dims nVols
                    tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s1/func/sub-*_task-recombirec*_run-*.nii*']);
                    if isempty(tmpfmri)
                        error('No NIfTI found for %s, ID %s', choice, ID{id});
                    end
                    f = tmpfmri(1);
                    fpath = fullfile(f.folder, f.name);

                    % read header only (works on .nii and .nii.gz)
                    hdr   = niftiinfo(fpath);
                    dims  = hdr.ImageSize;
                    if numel(dims) >= 4
                        nVols = dims(4);
                    else
                        nVols = 1;
                    end
%                     if isempty(tmpfmri)
%                         disp('seems to be only compressed niftii file there - proceeding to decompress')
%                         clear tmpfmri
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s1/func/sub-*recombirec*.nii.gz']);
%                         eval(['!gzip -d ' fullfile(tmpfmri.folder,tmpfmri.name) ' -f'])
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s1/func/sub-*recombirec*.nii']);
%                     end
%                     nVols   = length( spm_vol( [path_preproc 'sub-' ID{id} 'v2s1/func/' tmpfmri.name] ) );
%                     eval(['!gzip ' path_preproc 'sub-' ID{id} 'v2s1/func/' tmpfmri.name ' -f'])

                    clear path_rawphysio
                    path_rawphysio=[path_raw ID{id} 'v2s1/physio/'];

                case 'ORIGREC'
                    sess    = lower(sessionTypes{i1}); % 'for pattern matching
                    disp(['selected option ' sess]);

                    clear tmpfmri f fpath hdr dims nVols
                    tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s2/func/sub-*_task-origrec*_run-*.nii*']);
                    if isempty(tmpfmri)
                        error('No NIfTI found for %s, ID %s', choice, ID{id});
                    end
                    f = tmpfmri(1);
                    fpath = fullfile(f.folder, f.name);

                    % read header only (works on .nii and .nii.gz)
                    hdr   = niftiinfo(fpath);
                    dims  = hdr.ImageSize;
                    if numel(dims) >= 4
                        nVols = dims(4);
                    else
                        nVols = 1;
                    end
%                     if isempty(tmpfmri)
%                         disp('seems to be only compressed niftii file there - proceeding to decompress')
%                         clear tmpfmri
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s2/func/sub-*origrec*.nii.gz']);
%                         eval(['!gzip -d ' fullfile(tmpfmri.folder,tmpfmri.name) ' -f'])
%                         tmpfmri = dir([path_preproc 'sub-' ID{id} 'v2s2/func/sub-*origrec*.nii']);
%                     end
%                     nVols   = length( spm_vol( [path_preproc 'sub-' ID{id} 'v2s2/func/' tmpfmri.name] ) );
%                     eval(['!gzip ' path_preproc 'sub-' ID{id} 'v2s2/func/' tmpfmri.name ' -f'])

                    clear path_rawphysio
                    path_rawphysio=[path_raw ID{id} 'v2s2/physio/'];
            end

            % identify all log files
            clear tmpAll tmplogs tmplogs2 indlogs files_logs
            tmpAll = dir(fullfile(path_rawphysio,'*.log'));
            tmplogs=strfind({tmpAll.name},lower(sessionTypes{i1}));tmplogs2=cellfun(@isempty,tmplogs);
            if str2num(ID{id})==205 && strcmpi(sessionTypes{i1},'rest')
                indlogs=[find(tmplogs2==0):find(tmplogs2==0)+2];
            else
                indlogs=[find(tmplogs2==0):find(tmplogs2==0)+3];
            end
            files_logs=tmpAll(indlogs);

            % extract the relevant files (PULS, RESP, AcquisitionInfo)

            % ==== reorganise PULS log
            if str2num(ID{id})==202 && strcmpi(sessionTypes{i1},'origrec1')
                warning('no PULS log for ID 202, for recognition original!')
            elseif str2num(ID{id})==205 && strcmpi(sessionTypes{i1},'rest')
                warning('no PULSE log for ID 205, for rest!')
            else
            clear tmp1 tmp2 tmp3
            tmp1={files_logs.name}; tmp2=strfind(tmp1,'PULS'); tmp3=cellfun(@isempty,tmp2);
            indpuls=find(tmp3==0);
            % reorganise
            fixChannelFile(files_logs, 'PULS', [sessionTypes{i1} '_FIXED_PULS.log']);
            end

            % ==== reorganise RESP log
            if str2num(ID{id})==109 && strcmpi(sessionTypes{i1},'auto')
                warning('no RESP log for ID 109, for autobio!')
            else
            clear tmp1 tmp2 tmp3
            tmp1={files_logs.name}; tmp2=strfind(tmp1,'RESP'); tmp3=cellfun(@isempty,tmp2);
            indpuls=find(tmp3==0);
            % reorganise
            fixChannelFile(files_logs, 'RESP', [sessionTypes{i1} '_FIXED_RESP.log']);
            end

            % ==== reorganise AcquisitionInfo (trigger information i presume)
            fixAcquisitionInfo(files_logs, [sessionTypes{i1} '_FIXED_AcquisitionInfo.log']);

            % craft spm batch and run
            if (str2num(ID{id})==109 && strcmpi(sessionTypes{i1},'auto'))
                warning(['no RESP log for ID ' ID{id} ', for ' sessionTypes{i1} '!'])
                buildSPMphysio(path_rawphysio, ...
                    {fullfile(path_rawphysio,[sessionTypes{i1} '_FIXED_PULS.log'])}, ...
                    [], ...
                    {fullfile(path_rawphysio,[sessionTypes{i1} '_FIXED_AcquisitionInfo.log'])}, ...
                    lower(sessionTypes{i1}),...
                    nSlices, TR, nDummies,nVols,onsetSlice);
                close all
            elseif str2num(ID{id})==202 && strcmpi(sessionTypes{i1},'origrec1') || str2num(ID{id})==205 && strcmpi(sessionTypes{i1},'rest')
                warning(['no PULS log for ID ' ID{id} ', for ' sessionTypes{i1} '!'])
                buildSPMphysio(path_rawphysio, ...
                    [], ...
                    {fullfile(path_rawphysio,[sessionTypes{i1} '_FIXED_RESP.log'])}, ...
                    {fullfile(path_rawphysio,[sessionTypes{i1} '_FIXED_AcquisitionInfo.log'])}, ...
                    lower(sessionTypes{i1}),...
                    nSlices, TR, nDummies,nVols,onsetSlice);
                close all
            else
                buildSPMphysio(path_rawphysio, ...
                    {fullfile(path_rawphysio,[sessionTypes{i1} '_FIXED_PULS.log'])}, ...
                    {fullfile(path_rawphysio,[sessionTypes{i1} '_FIXED_RESP.log'])}, ...
                    {fullfile(path_rawphysio,[sessionTypes{i1} '_FIXED_AcquisitionInfo.log'])}, ...
                    lower(sessionTypes{i1}),...
                    nSlices, TR, nDummies,nVols,onsetSlice);
                close all
            end

        end
    else
        warning('cancelled the selection');
    end

end

%% fx

function fixChannelFile(fileStruct, channelTag, outName)
idx = find(contains({fileStruct.name}, channelTag));
if isempty(idx), return; end
inputFile = fullfile(fileStruct(idx).folder, fileStruct(idx).name);
data = readmatrix(inputFile, 'Delimiter',' ', 'NumHeaderLines',1);
timeTics = data(:,1);
signal = data(:,2);
fid = fopen(fullfile(fileStruct(idx).folder,outName),'w');
fprintf(fid, 'ACQ_TIME_TICS  CHANNEL  VALUE  SIGNAL\n');
for i = 1:numel(timeTics)
    fprintf(fid, '%d %s %d %d\n', timeTics(i), channelTag, signal(i), signal(i));
end
fclose(fid);
disp([outName ' saved.']);
end

function fixAcquisitionInfo(fileStruct, outName)
names      = {fileStruct.name};
isInfo     = contains(names, 'AcquisitionInfo');
isAlready  = contains(names, 'FIXED');
idx        = find(isInfo & ~isAlready);
if isempty(idx), return; end
% idx = find(contains({fileStruct.name},'AcquisitionInfo'));
% if isempty(idx), return; end
inputFile = fullfile(fileStruct(idx).folder, fileStruct(idx).name);
data = readmatrix(inputFile, 'Delimiter',' ', 'NumHeaderLines',1);
echoID = data(:,2);   % ECO_ID
repID  = data(:,4);   % REP_ID (Volume)
sliceID= data(:,12);  % Slice_ID
acqTime= data(:,13);  % AcqTime_Tics
VOLUME = -1;
ECHO   = -1;
outputData = [];
for i=1:size(data,1)
    if repID(i)~=VOLUME || echoID(i)~=ECHO
        VOLUME = VOLUME+1;
        ECHO = echoID(i);
    end
    startTics = acqTime(i);
    finishTics= startTics + 7;
    outputData = [outputData; VOLUME sliceID(i) startTics finishTics ECHO];
end
fid = fopen(fullfile(fileStruct(idx).folder,outName),'w');
fprintf(fid, 'VOLUME   SLICE   ACQ_START_TICS  ACQ_FINISH_TICS  ECHO\n');
for i = 1:size(outputData,1)
    fprintf(fid, '%d %d %d %d %d\n', outputData(i,:));
end
fclose(fid);
disp([outName ' saved.']);
end

function buildSPMphysio(path_raw, pulFile, respFile, infoFile, fName_suffix, nSlices, TR, nDummies,nVols,onsetSlice)

clear physiobatch

spm_jobman('initcfg')

physiobatch{1}.spm.tools.physio.save_dir = {path_raw};
physiobatch{1}.spm.tools.physio.log_files.vendor = 'Siemens_Tics';
physiobatch{1}.spm.tools.physio.log_files.cardiac = pulFile;
physiobatch{1}.spm.tools.physio.log_files.respiration = respFile;
physiobatch{1}.spm.tools.physio.log_files.scan_timing = infoFile;
physiobatch{1}.spm.tools.physio.log_files.sampling_interval = [];
physiobatch{1}.spm.tools.physio.log_files.relative_start_acquisition = 0;
physiobatch{1}.spm.tools.physio.log_files.align_scan = 'last';

physiobatch{1}.spm.tools.physio.scan_timing.sqpar.Nslices = nSlices;
physiobatch{1}.spm.tools.physio.scan_timing.sqpar.TR = TR;
physiobatch{1}.spm.tools.physio.scan_timing.sqpar.Ndummies = nDummies;
physiobatch{1}.spm.tools.physio.scan_timing.sqpar.Nscans = nVols;
physiobatch{1}.spm.tools.physio.scan_timing.sqpar.onset_slice = onsetSlice;

physiobatch{1}.spm.tools.physio.preproc.cardiac.modality = 'PPU';
physiobatch{1}.spm.tools.physio.preproc.cardiac.filter.no = struct([]);
physiobatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.min = 0.4;
physiobatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.auto_matched.max_heart_rate_bpm = 90;
physiobatch{1}.spm.tools.physio.preproc.cardiac.posthoc_cpulse_select.off = struct([]);

physiobatch{1}.spm.tools.physio.preproc.respiratory.filter.passband = [0.01 2];
physiobatch{1}.spm.tools.physio.preproc.respiratory.despike = false;

physiobatch{1}.spm.tools.physio.model.output_multiple_regressors = ['multiple_regressors_' fName_suffix '.txt'];
physiobatch{1}.spm.tools.physio.model.output_physio = ['physio_' fName_suffix '.mat'];
physiobatch{1}.spm.tools.physio.model.orthogonalise = 'none';
physiobatch{1}.spm.tools.physio.model.censor_unreliable_recording_intervals = false;
physiobatch{1}.spm.tools.physio.model.retroicor.yes.order.c = 3;
physiobatch{1}.spm.tools.physio.model.retroicor.yes.order.r = 4;
physiobatch{1}.spm.tools.physio.model.retroicor.yes.order.cr = 1;
physiobatch{1}.spm.tools.physio.model.rvt.no = struct([]);
physiobatch{1}.spm.tools.physio.model.hrv.no = struct([]);
physiobatch{1}.spm.tools.physio.model.noise_rois.no = struct([]);
physiobatch{1}.spm.tools.physio.model.movement.no = struct([]);
physiobatch{1}.spm.tools.physio.model.other.no = struct([]);

physiobatch{1}.spm.tools.physio.verbose.level = 2;
physiobatch{1}.spm.tools.physio.verbose.fig_output_file = '';
physiobatch{1}.spm.tools.physio.verbose.use_tabs = false;

spm_jobman('run',physiobatch);
disp(['physio regressors created for ' fName_suffix]);

end
