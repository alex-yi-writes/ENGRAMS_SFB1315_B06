%% parse connectome physio files (because somehow it's different from the previous Siemens-Tics formats)
% requirements: - TAPAS physIO [https://github.com/translationalneuromodeling/tapas/tree/master/PhysIO]
%               - SPM12 [https://www.fil.ion.ucl.ac.uk/spm/software/spm12/]
% if you have questions please send an email to: ucjuyyi@ucl.ac.uk
%% prep

clc; clear;
path_raw = '/Users/alex/Dropbox/paperwriting/1315/data/physio/104/2_2/';
sessionTypes = {'AUTO','ENC','REC'};  % name tags for the physio files and the output files

% infos for the tapas physio
nSlices=96; 
TR=2; 
nDummies=0; 
nVols=255; 
onsetSlice=42;

disp('prep done')

%% identify all log files 

tmpAll = dir(fullfile(path_raw,'*.log'));

for s = 1:numel(sessionTypes)
    sess = lower(sessionTypes{s}); % 'auto','enc','rec' for pattern matching

    % extract the relevant files (PULS, RESP, AcquisitionInfo)
    idx = find(contains({tmpAll.name}, sess));
    files_sess = tmpAll(idx);

    % reorganise PULS log
    fixChannelFile(files_sess, 'PULS', [sessionTypes{s} '_FIXED_PULS.log']);

    % reorganise RESP log
    fixChannelFile(files_sess, 'RESP', [sessionTypes{s} '_FIXED_RESP.log']);

    % reorganise AcquisitionInfo (trigger information i presume)
    fixAcquisitionInfo(files_sess, [sessionTypes{s} '_FIXED_AcquisitionInfo.log']);

    % craft spm batch 
    buildSPMphysio(path_raw, ...
        fullfile(path_raw,[sessionTypes{s} '_FIXED_PULS.log']), ...
        fullfile(path_raw,[sessionTypes{s} '_FIXED_RESP.log']), ...
        fullfile(path_raw,[sessionTypes{s} '_FIXED_AcquisitionInfo.log']), ...
        lower(sessionTypes{s}),...
        nSlices, TR, nDummies,nVols,onsetSlice);
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
idx = find(contains({fileStruct.name},'AcquisitionInfo'));
if isempty(idx), return; end
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
physiobatch{1}.spm.tools.physio.log_files.cardiac = {pulFile};
physiobatch{1}.spm.tools.physio.log_files.respiration = {respFile};
physiobatch{1}.spm.tools.physio.log_files.scan_timing = {infoFile};
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
