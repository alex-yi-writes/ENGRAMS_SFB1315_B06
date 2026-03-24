%% ENGRAMS experiment: encoding

%% initialisation

function [dat] = engrams_encoding_pupil(id,block,condition,phase,mri,pupil,taskpath,prepulse)

sca % close any open Psychtoolbox windows

% temp settings
path_ECHO      = taskpath;
ID             = id;
Block          = block;
PrePulse       = prepulse;

if strcmp(condition,'Emotional')==1
    conditions = 'emo';
elseif strcmp(condition,'Neutral')==1
    conditions = 'neu';
end

if strcmp(phase,'Original')==1
    phases = 'orig';
elseif strcmp(phase,'Recombination')==1
    phases = 'recombi';
end

if strcmp(mri,'Yes')==1
    MRIFlag = 1;
    subpath = 'originals/';
%     subpath = 'mirrored/';
elseif strcmp(mri,'No')==1
    MRIFlag = 0;
    subpath = 'originals/';
end

if strcmp(pupil,'Yes')==1
    EyeFlag = 1;
    %%%%%%%%%%%%%%%%%%%%%%
    localhostID=5257;
    %%%%%%%%%%%%%%%%%%%%%%
    
elseif strcmp(pupil,'No')==1
    EyeFlag = 0;
end

behavfilename  = [num2str(ID) '_enc_' phases '_' num2str(Block) '.mat'];

% set paths
paths.parent   = path_ECHO;
paths.stimuli  = [paths.parent conditions '/'];
paths.stimlist = [paths.parent conditions '/Excel/' subpath];
paths.obj      = [paths.parent conditions '/images/objects/' subpath];
paths.scenes   = [paths.parent conditions '/images/scenes/' subpath];
paths.elements = [paths.parent 'elements/' subpath];
paths.bg       = paths.parent;
paths.behav    = [paths.parent 'data/behav/'];
paths.logs     = [paths.parent 'data/logs/'];

addpath(genpath([paths.parent 'scripts']))

if exist(strcat(paths.logs, num2str(ID), '_enc_', phases, '_', num2str(Block), '_log_', string(date), '.txt')) == 2
K=string(datestr(now));
try
diary(strcat(paths.logs, num2str(ID), '_enc_', phases, '_', num2str(Block), '_log_', string(date),'_',K{1}(end-1:end),'.txt'))
catch
diary(strcat(paths.logs, num2str(ID), '_enc_', phases, '_', num2str(Block), '_log_', string(date),'_',K(end-1:end),'.txt'))
end
else
diary(strcat(paths.logs, num2str(ID), '_enc_', phases, '_', num2str(Block), '_log_', string(date), '.txt'))
end
disp(strcat('ENGRAMS ENCODING ', string(datetime)))

% load design matrix
if strcmp(phase,'Original')==1
    phases = 'orig';
    load([paths.elements 'desmat/GA_ENGRAMS_ENC_designstruct_type1_Top' num2str(mod(ID,2)) '.mat'])
elseif strcmp(phase,'Recombination')==1
    phases = 'recombi';
    load([paths.elements 'desmat/GA_ENGRAMS_ENC_designstruct_type1_Top' num2str(mod(ID+1,2)) '.mat'])
end

% create the data structure
cd(paths.behav)
if exist(behavfilename) == 2
    load([paths.behav behavfilename])
else
    dat = [];
    dat.ID  = ID;
    dat.enc = [];
    dat.enc.condition = conditions;
    dat.enc.phase     = phases;
    dat.enc.measured_on = datetime;
end

% scanner preparation
if MRIFlag == 1
    dat.enc.mri          = [];
    dat.enc.mri.scanPort = 1;
%     dat.enc.mri.dummy    = 1;        % no. of dummy vols
    dat.enc.mri.dummy    = PrePulse+5        % no. of dummy vols
    dat.enc.mri.nslice   = 51;       % no. of slices
    dat.enc.mri.TE       = 32;       % time for each slice in msec
    dat.enc.mri.TR       = 2.34;     % MRIinfo.nslice * MRIinfo.TE/1000; % time for volume in msec
end

disp('environment prepared')
disp(['subject ID ' num2str(ID) ', block number ' num2str(Block) ', condition ' conditions])

%% prepare stimuli

config = [];

% ======== prepare stimuli ======== %
rng('default');  % Reset to default settings
rng('shuffle'); % prepare for true randomisation

stimlist = [];
stimlist = readtable([paths.stimlist 'encoding_' phases '_' conditions '.xlsx']);

config.stimuli.numtrials = size(stimlist,1);

v = 1:config.stimuli.numtrials;
randomIndex = randperm(length(v));
randomizedVector = v(randomIndex);

config.stimuli.stimlist = stimlist(randomizedVector,1:2);
config.stimuli.scaleFactor.scenes   = 0.9;
config.stimuli.scaleFactor.objects  = 0.75;%0.5;
config.stimuli.scaleFactor.QnA      = 0.8;

scaleFactor.scenes = config.stimuli.scaleFactor.scenes;
scaleFactor.objects = config.stimuli.scaleFactor.objects;
scaleFactor.QnA = config.stimuli.scaleFactor.QnA;


% ================================= %



% ======== timing information ======== %

rng('shuffle'); % shuffle again
config.timing.fixation_afterScene   = FinalDesignMatrix.eventlist(:,6);
config.timing.fixation_afterObject  = FinalDesignMatrix.eventlist(:,7);
config.timing.fixation_afterBoth    = FinalDesignMatrix.eventlist(:,8);
config.timing.fixation_ITI          = FinalDesignMatrix.eventlist(:,9); %randi([10, 40], 60, 1) * 100;%eval(['cell2mat(RET17T_' num2str(BlockNum) '(:,5)).*1000']);
config.timing.intermission          = FinalDesignMatrix.eventlist(:,10);
config.timing.scene    = 750;
config.timing.object   = 750;
config.timing.together = 750;

config.timing.valenceQ = 3000;
config.timing.resp.valence = 3000;
config.timing.resp.memory = 3000;
config.timing.resp.confidence = 3000;

% ================================= %

disp('task setup done')
disp('initialising...')

%% run

clear KbCheck;

% check for Opengl compatibility, abort otherwise:
AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);

% Make sure keyboard mapping is the same on all supported operating systems
% Apple MacOS/X, MS-Windows and GNU/Linux:
KbName('UnifyKeyNames');

%%%%%%%%%%
% button instructions: left to right, a(left thumb) - b(left index) - c(right index) - d(right thumb) 
%%%%%%%%%%%

FarRightKey      = KbName('d'); %%%%% check again
MiddleRightKey   = KbName('c');
MiddleLeftKey    = KbName('b');
FarLeftKey       = KbName('a');
MRItrigger       = KbName('s');

% Get screenNumber of stimulation display. We choose the display with
% the maximum index, which is usually the right one, e.g., the external
% display on a Laptop:
screens=Screen('Screens'); % this should be one, which is the main screen that you're looking at
screenNumber=screens(2);%max(screens);

ListenChar(2) ; % suppress keyboard input to Matlab windows
% HideCursor; % Hide the mouse cursor:

% background colour should be black
% Returns as default the mean black value of screen:
black=BlackIndex(screenNumber);

% Open a double buffered fullscreen window on the stimulation screen
% 'screenNumber' and choose/draw a black background. 'w' is the handle
% used to direct all drawing commands to that window - the "Name" of
% the window. 'wRect' is a rectangle defining the size of the window.
% See "help PsychRects" for help on such rectangles and useful helper
% functions:
% oldRes=SetResolution(0,2560,1440);
oldRes=SetResolution(0,1280,720); % at 7T, only this resolution works
[w, wRect]=Screen('OpenWindow',screenNumber, black);
[mx, my] = RectCenter(wRect);
W=wRect(3); H=wRect(4);

% Store the current font size and style
oldSize = Screen('TextSize', w);
oldStyle = Screen('TextStyle', w);

Screen('TextFont',w,'Arial');
Screen('TextSize',w,17);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the size of the screen
[screenXpixels, screenYpixels] = Screen('WindowSize', w);

%% --- pupillometry initialization --- %%
if EyeFlag
    eye_connect('localhost',localhostID);
    eye_set_parameter('eye_save_tracking','true');
    eye_set_parameter('eye_save_tracking_and_video','true');
    eye_set_display_parameter(screenXpixels, screenYpixels,360,0.333);
    eye_set_display_offset(0,0);
    if eye_start_calibrate(9)==0
        while eye_get_status()==1 && ~KbCheck
            pt = eye_get_calibration_point();
            Screen('DrawDots',w,[pt(1),pt(2)],20,WhiteIndex(screenNumber),[],2);
            Screen('Flip',w);
        end
    end
    % eye_start_stream(2); % stream pupil size
    nTrials = config.stimuli.numtrials;
    pupil_scene = cell(nTrials,1);
    pupil_obj   = cell(nTrials,1);
    time_scene  = zeros(nTrials,1);
    time_obj    = zeros(nTrials,1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for ButtonTestCode=1
%%%%%%%%%%%%%%%%%%%%%%%%%%%% button tests %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% 4 buttons


% load question
clear img_buttonQ buttonQtex img_garnicht img_etwas img_ziemlich img_sehr garnichttex etwastex ziemlichtex sehrtex

img_buttonQ   = imread([paths.elements 'keytest_question.png']);
buttonQtex    = Screen('MakeTexture', w, img_buttonQ);

img_garnicht    = imread([paths.elements 'GreyCircle.png']);
img_etwas       = imread([paths.elements 'X.png']);
img_ziemlich    = imread([paths.elements 'X.png']);
img_sehr        = imread([paths.elements 'X.png']);

garnichttex     = Screen('MakeTexture', w, img_garnicht);
etwastex        = Screen('MakeTexture', w, img_etwas);
ziemlichtex     = Screen('MakeTexture', w, img_ziemlich);
sehrtex         = Screen('MakeTexture', w, img_sehr);

% Define the starting x position for the question iamge
if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
    Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
    Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);
end

% Define spacing between the option images
optionSpacing = 150; % Adjust this value to increase or decrease the space between images

% Calculate the total width of the option images including spacing
optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);

% Calculate the starting X position for the first option image
if MRIFlag == 1
startX = (screenXpixels - totalWidthWithSpacing) / 2 + 35;
else
startX = (screenXpixels - totalWidthWithSpacing) / 2;
end

% Draw the option images with spacing
if MRIFlag == 1
    verticalOffsetOptions = 0.81;  % Adjust this value as needed, the bigger the value, the further away from the center images go
    for i = 1:length(optionTextures)
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        scaledImgH = imgH * scaleFactor.QnA;
        scaledImgW = imgW * scaleFactor.QnA;
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
    end
    
    
else
    for i = 1:length(optionTextures)
        verticalOffsetOptions = 0.57;
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - imgH / 2, startX + imgW, screenYpixels * verticalOffsetOptions + imgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + imgW + optionSpacing; % Move to the next position with spacing
    end
end

Screen('Flip', w);

[rsp] = getKeys(FarLeftKey,Inf);

clear img_buttonQ buttonQtex img_garnicht img_etwas img_ziemlich img_sehr garnichttex etwastex ziemlichtex sehrtex

img_ok   = imread([paths.elements 'OK.png']);
oktex    = Screen('MakeTexture', w, img_ok);

if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
    Screen('DrawTexture', w, oktex, [], questionDestRectUp);
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
    Screen('DrawTexture', w, oktex, [], questionDestRectUp);
end

Screen('Flip', w); WaitSecs(1);




% load question
clear img_buttonQ buttonQtex img_garnicht img_etwas img_ziemlich img_sehr garnichttex etwastex ziemlichtex sehrtex

img_buttonQ   = imread([paths.elements 'keytest_question.png']);
buttonQtex    = Screen('MakeTexture', w, img_buttonQ);

img_garnicht    = imread([paths.elements 'X.png']);
img_etwas       = imread([paths.elements 'GreyCircle.png']);
img_ziemlich    = imread([paths.elements 'X.png']);
img_sehr        = imread([paths.elements 'X.png']);

garnichttex     = Screen('MakeTexture', w, img_garnicht);
etwastex        = Screen('MakeTexture', w, img_etwas);
ziemlichtex     = Screen('MakeTexture', w, img_ziemlich);
sehrtex         = Screen('MakeTexture', w, img_sehr);

% Define the starting x position for the question iamge
if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
    Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
    Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);
end

% Define spacing between the option images
optionSpacing = 150; % Adjust this value to increase or decrease the space between images

% Calculate the total width of the option images including spacing
optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);

% Calculate the starting X position for the first option image
if MRIFlag == 1
startX = (screenXpixels - totalWidthWithSpacing) / 2 + 35;
else
startX = (screenXpixels - totalWidthWithSpacing) / 2;
end

% Draw the option images with spacing
if MRIFlag == 1
    verticalOffsetOptions = 0.81;  % Adjust this value as needed, the bigger the value, the further away from the center images go
    for i = 1:length(optionTextures)
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        scaledImgH = imgH * scaleFactor.QnA;
        scaledImgW = imgW * scaleFactor.QnA;
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
    end
    
    
else
    for i = 1:length(optionTextures)
        verticalOffsetOptions = 0.57;
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - imgH / 2, startX + imgW, screenYpixels * verticalOffsetOptions + imgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + imgW + optionSpacing; % Move to the next position with spacing
    end
end

Screen('Flip', w);

[rsp] = getKeys(MiddleLeftKey,Inf);

clear img_buttonQ buttonQtex img_garnicht img_etwas img_ziemlich img_sehr garnichttex etwastex ziemlichtex sehrtex

img_ok   = imread([paths.elements 'OK.png']);
oktex    = Screen('MakeTexture', w, img_ok);

if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
    Screen('DrawTexture', w, oktex, [], questionDestRectUp);
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
    Screen('DrawTexture', w, oktex, [], questionDestRectUp);
end

Screen('Flip', w); WaitSecs(1);





% load question
clear img_buttonQ buttonQtex img_garnicht img_etwas img_ziemlich img_sehr garnichttex etwastex ziemlichtex sehrtex

img_buttonQ   = imread([paths.elements 'keytest_question.png']);
buttonQtex    = Screen('MakeTexture', w, img_buttonQ);

img_garnicht    = imread([paths.elements 'X.png']);
img_etwas       = imread([paths.elements 'X.png']);
img_ziemlich    = imread([paths.elements 'GreyCircle.png']);
img_sehr        = imread([paths.elements 'X.png']);

garnichttex     = Screen('MakeTexture', w, img_garnicht);
etwastex        = Screen('MakeTexture', w, img_etwas);
ziemlichtex     = Screen('MakeTexture', w, img_ziemlich);
sehrtex         = Screen('MakeTexture', w, img_sehr);

% Define the starting x position for the question iamge
if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
    Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
    Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);
end

% Define spacing between the option images
optionSpacing = 150; % Adjust this value to increase or decrease the space between images

% Calculate the total width of the option images including spacing
optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);

% Calculate the starting X position for the first option image
if MRIFlag == 1
startX = (screenXpixels - totalWidthWithSpacing) / 2 + 35;
else
startX = (screenXpixels - totalWidthWithSpacing) / 2;
end

% Draw the option images with spacing
if MRIFlag == 1
    verticalOffsetOptions = 0.81;  % Adjust this value as needed, the bigger the value, the further away from the center images go
    for i = 1:length(optionTextures)
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        scaledImgH = imgH * scaleFactor.QnA;
        scaledImgW = imgW * scaleFactor.QnA;
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
    end
    
    
else
    for i = 1:length(optionTextures)
        verticalOffsetOptions = 0.57;
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - imgH / 2, startX + imgW, screenYpixels * verticalOffsetOptions + imgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + imgW + optionSpacing; % Move to the next position with spacing
    end
end

Screen('Flip', w);

[rsp] = getKeys(MiddleRightKey,Inf);

clear img_buttonQ buttonQtex img_garnicht img_etwas img_ziemlich img_sehr garnichttex etwastex ziemlichtex sehrtex

img_ok   = imread([paths.elements 'OK.png']);
oktex    = Screen('MakeTexture', w, img_ok);

if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
    Screen('DrawTexture', w, oktex, [], questionDestRectUp);
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
    Screen('DrawTexture', w, oktex, [], questionDestRectUp);
end

Screen('Flip', w); WaitSecs(1);



% load question
clear img_buttonQ buttonQtex img_garnicht img_etwas img_ziemlich img_sehr garnichttex etwastex ziemlichtex sehrtex

img_buttonQ   = imread([paths.elements 'keytest_question.png']);
buttonQtex    = Screen('MakeTexture', w, img_buttonQ);

img_garnicht    = imread([paths.elements 'X.png']);
img_etwas       = imread([paths.elements 'X.png']);
img_ziemlich    = imread([paths.elements 'X.png']);
img_sehr        = imread([paths.elements 'GreyCircle.png']);

garnichttex     = Screen('MakeTexture', w, img_garnicht);
etwastex        = Screen('MakeTexture', w, img_etwas);
ziemlichtex     = Screen('MakeTexture', w, img_ziemlich);
sehrtex         = Screen('MakeTexture', w, img_sehr);

% Define the starting x position for the question iamge
if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
    Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
    Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);
end

% Define spacing between the option images
optionSpacing = 150; % Adjust this value to increase or decrease the space between images

% Calculate the total width of the option images including spacing
optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);

% Calculate the starting X position for the first option image
if MRIFlag == 1
startX = (screenXpixels - totalWidthWithSpacing) / 2 + 35;
else
startX = (screenXpixels - totalWidthWithSpacing) / 2;
end

% Draw the option images with spacing
if MRIFlag == 1
    verticalOffsetOptions = 0.81;  % Adjust this value as needed, the bigger the value, the further away from the center images go
    for i = 1:length(optionTextures)
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        scaledImgH = imgH * scaleFactor.QnA;
        scaledImgW = imgW * scaleFactor.QnA;
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
    end
    
    
else
    for i = 1:length(optionTextures)
        verticalOffsetOptions = 0.57;
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - imgH / 2, startX + imgW, screenYpixels * verticalOffsetOptions + imgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + imgW + optionSpacing; % Move to the next position with spacing
    end
end

Screen('Flip', w);

[rsp] = getKeys(FarRightKey,Inf);

clear img_buttonQ buttonQtex img_garnicht img_etwas img_ziemlich img_sehr garnichttex etwastex ziemlichtex sehrtex

img_ok   = imread([paths.elements 'OK.png']);
oktex    = Screen('MakeTexture', w, img_ok);

if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
    Screen('DrawTexture', w, oktex, [], questionDestRectUp);
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
    Screen('DrawTexture', w, oktex, [], questionDestRectUp);
end

Screen('Flip', w); WaitSecs(1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end




% Load the background
bg = imread([paths.bg 'background.jpg']);

% Create a texture from the image
bgtexture = Screen('MakeTexture', w, bg);

% Get the size of the image
[bgHeight, bgWidth, ~] = size(bg);

% Calculate the number of tiles needed to cover the screen
tilesX = ceil(screenXpixels / bgWidth);
tilesY = ceil(screenYpixels / bgHeight);

% Tile the bg image across the screen
for i = 0:(tilesX-1)
    for j = 0:(tilesY-1)
        destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
        Screen('DrawTexture', w, bgtexture, [], destRect);
    end
end

% Text presentation doesn't work at the connectome scanner, so we opt for
% presenting an image

% Load the instruction text
instruction = imread([paths.elements 'instr_orig_enc.png']);

% Create a texture from the image
tex=Screen('MakeTexture', w, instruction);

[imageHeight, imageWidth, ~] = size(instruction);
if MRIFlag == 1
    destX = (screenXpixels - imageWidth) / 2;  % Center the image horizontally
    destY = screenYpixels - imageHeight - 40;       % Position the image at the bottom
else
    destX = (screenXpixels - imageWidth) / 2;  % Center the image horizontally
    destY = (screenYpixels - imageHeight) / 2; % Center the image vertically
end
destRect = [destX, destY, destX + imageWidth, destY + imageHeight]; % Define the destination rectangle

% Draw the texture
Screen('DrawTexture', w, tex, [], destRect);

% Show stimulus on screen at next possible display refresh cycle,
% and record stimulus onset time in 'startrt':
[VBLTimestamp, t0_inst, FlipTimestamp]=Screen('Flip', w);
tmp=VBLTimestamp;
clear rsp
[rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],Inf);

% Let the scanner start the task, allow n dummy volumes
if MRIFlag == 1
    
    %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%
         tic % ding ding ding
    %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%
    
    % hail the operator
    
    % load operator information screen
    clear tex
    opinfo = imread([paths.elements 'operator_hail.bmp']);
    % Create a texture from the image
    tex=Screen('MakeTexture', w, opinfo);
    Screen('DrawTexture', w, tex);

    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    
    [rsp] = getKeys(KbName('space'),Inf);
    
    WaitSecs(0.2);
    
    % start the dummy scan
    % Tile the bg image across the screen
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    clear tex
    standby = imread([paths.elements 'standby.bmp']);

    % Create a texture from the image
    tex=Screen('MakeTexture', w, standby);
    [imageHeight, imageWidth, ~] = size(instruction);
    if MRIFlag == 1
        destX = (screenXpixels - imageWidth) / 2;  % Center the image horizontally
        destY = screenYpixels - imageHeight;       % Position the image at the bottom
    else
        destX = (screenXpixels - imageWidth) / 2;  % Center the image horizontally
        destY = (screenYpixels - imageHeight) / 2; % Center the image vertically
    end
    destRect = [destX, destY, destX + imageWidth, destY + imageHeight]; % Define the destination rectangle
    
    % Draw the texture
    Screen('DrawTexture', w, tex, [], destRect);    

    [VBLTimestamp, t0_standby, FlipTimestamp]=Screen('Flip', w); t0_standby_raw = toc;
        
   
    
    % Initialize counters and flags
    numTriggers = 0;
    trigfirst = NaN;
    triglast = NaN;
    prepulsereceived=0;
    
    % Loop until 5 triggers are detected
    while numTriggers < dat.enc.mri.dummy
        % Check the state of the keyboard
        [keyIsDown, ~, keyCode] = KbCheck;
        
        % If a key is pressed
        if keyIsDown
            if keyCode(MRItrigger)
                % Increment the trigger counter
                numTriggers = numTriggers + 1;

                % Record the timing for the 1st and 5th triggers
                if numTriggers == PrePulse + 1
                    disp('First real trigger received, volume acquisition starts: ')
                    trigfirst = toc
                    Screen('TextSize', w, 20);
                    Screen('TextFont', w, 'Arial');
                    DrawFormattedText(w, ['trigger no. 1, total pulse: ' num2str(numTriggers)], 'center', 'center', [255 255 255], 50);
                    Screen('Flip', w);
                    if EyeFlag
                    eye_set_software_event('Trig1st')
                    end
                    
                elseif numTriggers == PrePulse + 2
                    Screen('TextSize', w, 20);                    
                    Screen('TextFont', w, 'Arial');
                    DrawFormattedText(w, ['trigger no. 2, total pulse:' num2str(numTriggers)], 'center', 'center', [255 255 255], 50);
                    Screen('Flip', w);
                elseif numTriggers == PrePulse + 3
                    Screen('TextSize', w, 20);
                    Screen('TextFont', w, 'Arial');
                    DrawFormattedText(w, ['trigger no. 3, total pulse: ' num2str(numTriggers)], 'center', 'center', [255 255 255], 50);
                    Screen('Flip', w);
                elseif numTriggers == PrePulse + 4
                    Screen('TextSize', w, 20);
                    Screen('TextFont', w, 'Arial');
                    DrawFormattedText(w, ['trigger no. 4, total pulse: ' num2str(numTriggers)], 'center', 'center', [255 255 255], 50);
                    Screen('Flip', w);    
                    
                elseif numTriggers == PrePulse + 5
                    disp('Fifth real trigger received, task starts: ')
                    triglast = toc
                    Screen('TextSize', w, 20);
                    Screen('TextFont', w, 'Arial');
                    DrawFormattedText(w, ['trigger no. 5, total pulse: ' num2str(numTriggers)], 'center', 'center', [255 255 255], 50);
                    Screen('Flip', w);
                    
                    break; % Exit the loop after the 5th trigger
                elseif numTriggers <= PrePulse
                    prepulsereceived=prepulsereceived+1;
                    Screen('TextSize', w, 20);
                    Screen('TextFont', w, 'Arial');
                    DrawFormattedText(w, 'Receiving pre-triggers', 'center', 'center', [255 255 255], 50);
                    Screen('Flip', w);
                end
            end
            
            % Wait until all keys are released to avoid detecting the same press again
            while KbCheck; end
        end
        
        % Optional: insert a brief pause to reduce CPU load
        WaitSecs(0.01);
    end
    
    
%     [rsp] = getKeys(MRItrigger,Inf);
%     trig1=toc; %%%
%     dat.enc.mri.dummyscanfirst= rsp;
%     disp('5')
%     WaitSecs(0.1);
%     for dum = 1:(dat.enc.mri.dummy - 2)
%         [rsp] = getKeys(MRItrigger,Inf);
%         disp(num2str(4-dum+1))
%         WaitSecs(0.1);
%     end
%     [rsp] = getKeys(MRItrigger,Inf);
%     trig5=toc; %%%
%     disp('1')
%     dat.enc.mri.dummyscanlast = rsp; % the last dummy scan

    
    % draw the first fixation
    % Tile the bg image across the screen
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
    
    [VBLTimestamp, t0_fix0, FlipTimestamp]=Screen('Flip', w); t0_fix0_raw = toc;
    if EyeFlag
    eye_set_software_event('fix0')
    end

    WaitSecs(dat.enc.mri.TR);

    
else
    
    %%%%%%%%%%%%%%
    tic % ding ding ding
    %%%%%%%%%%%%%%
    
    % draw the first fixation
    % Tile the bg image across the screen
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
    
    [VBLTimestamp, t0_fix0, FlipTimestamp]=Screen('Flip', w); t0_fix0_raw = toc;
    
    WaitSecs(1);
    
end


%% start the trials

results = []; %results.SOT = [];
% if MRIFlag == 1
% results.SOT.ptb.t0_fix0 = t0_fix0;
% results.SOT.ptb.t0_standby = t0_standby;
% results.SOT.ptb.t0_inst = t0_inst;
% results.SOT.raw.trigfirst=trig1;
% results.SOT.raw.triglast=trig5;
% end
% results.SOT.raw.t0_fix0 = t0_fix0_raw;
eventmarker = 0;
i = 0; fixc = 0; scenec = 0; objc = 0; togc = 0; emoSc = 0; emoOc = 0; resp1c = 0; resp2c = 0;
SOT_f1=[]; SOT_together = []; SOT_obj = []; SOT_scene = []; SOT_ValQObj =[]; SOT_ValQSce =[]; SOT_respScene = []; SOT_respObj = [];
valQ_scenes=[]; valQ_objs=[]; RT_scenes=[]; RT_obj=[]; keypress_valQ_scene=[]; keypress_valQ_objects=[];
dat.enc.results = [];

for trl = 1:10%config.stimuli.numtrials
    
    i = i+1;
    fprintf('\n============================================\n')
    fprintf('Trial %d\n', trl)
    
    % ------------------------ present fix x -------------------------- %
    
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
    
    if EyeFlag
        eye_set_software_event(['fix' num2str(trl) '_1'])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    fixc=fixc+1; SOT_f1(fixc,1)=toc;
    
    WaitSecs(config.timing.fixation(trl)/1000)
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = '+';
    
    % ----------------------------------------------------------------- %
    
    
    
    % ------------------------ present scene alone -------------------------- %
        
    % Load Scene
    
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);

    SceneStim = imread([paths.stimuli config.stimuli.stimlist{trl,1}{1,1}]);
    SceneTexture = Screen('MakeTexture', w, SceneStim);
    
    % Define size and position of the image
    [s1, s2, ~] = size(SceneStim);
    aspectRatio = s2 / s1;
    imageHeight = screenYpixels * 0.3 * scaleFactor.scenes; 
    imageWidth = imageHeight * aspectRatio;
    
    % Adjust the vertical offset as needed
    if MRIFlag == 1
    relativeVerticalDistance = 0.75;
    verticalOffset = crossY * relativeVerticalDistance;
    else
    verticalOffset = screenYpixels * 0.3;    
    end
    dstRect = CenterRectOnPointd([0 0 imageWidth imageHeight], mx, verticalOffset);
    
    % Draw the image
    Screen('DrawTexture', w, SceneTexture, [], dstRect);
    
    if EyeFlag
        eye_set_software_event(['scene' num2str(trl)])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    scenec=scenec+1; SOT_scene(scenec,1)=toc;
    WaitSecs(config.timing.scene/1000);
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = config.stimuli.stimlist{trl,1}{1,1};
    
    % ----------------------------------------------------------------- %
    
    
    % ------------------------ present intermission x -------------------------- %
    
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
    
    if EyeFlag
        eye_set_software_event(['bsl' num2str(trl) ''])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    
    WaitSecs(config.timing.fixation_afterScene(trl,1))
        
    % ----------------------------------------------------------------- %
    
    
   
    % -------------------- present object alone ----------------------- %
        
    % Load Scene
    
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
    
    clear ObjectStim
    try
    ObjectStim = imread([paths.stimuli config.stimuli.stimlist{trl,2}{1,1}]);
    catch
    ObjectStim = imread([paths.stimuli config.stimuli.stimlist{trl,2}{1,1} '.png']);
    end
    ObjTexture = Screen('MakeTexture', w, ObjectStim);
    
    % Define size and position of the image
    [imgH, imgW, ~] = size(Screen('GetImage', ObjTexture));
    imageHeight = imgH * scaleFactor.objects;
    imageWidth = imgW * scaleFactor.objects;
%     [s1, s2, ~] = size(ObjectStim);
%     aspectRatio = s2 / s1;
%     imageHeight = screenYpixels * 0.3 * scaleFactor.objects;
%     imageWidth = imageHeight * aspectRatio;
    
    % Adjust the vertical offset 
    if MRIFlag == 1
    relativeVerticalDistance = 1.2;
    verticalOffset = crossY * relativeVerticalDistance;
%     horizontalOffset = screenXpixels * 0.625; % object on the right
    horizontalOffset = screenXpixels * 0.375;   % object on the left
    else
    verticalOffset = screenYpixels * 0.65;
%     horizontalOffset = screenXpixels * 0.625;
    horizontalOffset = screenXpixels * 0.375;   % object on the left
    end
    dstRect = CenterRectOnPointd([0 0 imageWidth imageHeight], horizontalOffset, verticalOffset);
    
    % Draw the image
    Screen('DrawTexture', w, ObjTexture, [], dstRect);
    
    if EyeFlag
        eye_set_software_event(['object' num2str(trl)])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    objc=objc+1; SOT_obj(objc,1)=toc;
    WaitSecs(config.timing.object/1000);
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = config.stimuli.stimlist{trl,2}{1,1};
    
    % ----------------------------------------------------------------- %
    
    
    
    % ------------------------ present intermission x -------------------------- %
    
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);

    if EyeFlag
        eye_set_software_event(['fix' num2str(trl) '_2'])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    
    WaitSecs(config.timing.fixation_afterObject(trl,1))
        
    % ----------------------------------------------------------------- %
    
    
    % ------------------------ present together -------------------------- %

    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
    
    
    
    clear SceneStim
    SceneStim = imread([paths.stimuli config.stimuli.stimlist{trl,1}{1,1}]);
    SceneTexture = Screen('MakeTexture', w, SceneStim);
    
    % Define size and position of the image
    [s1, s2, ~] = size(SceneStim);
    aspectRatio = s2 / s1;
    imageHeight = screenYpixels * 0.3 * scaleFactor.scenes; 
    imageWidth = imageHeight * aspectRatio;
    
    % Adjust the vertical offset 
    if MRIFlag == 1
    relativeVerticalDistance = 0.75;
    verticalOffset = crossY * relativeVerticalDistance;
    else
    verticalOffset = screenYpixels * 0.3;    
    end
    dstRect = CenterRectOnPointd([0 0 imageWidth imageHeight], mx, verticalOffset);
    
    % Draw the image
    Screen('DrawTexture', w, SceneTexture, [], dstRect);
    
    
    
    
    clear ObjectStim
    ObjectStim = imread([paths.stimuli config.stimuli.stimlist{trl,2}{1,1}]);
    ObjTexture = Screen('MakeTexture', w, ObjectStim);
    
    % Define size and position of the image
    [imgH, imgW, ~] = size(Screen('GetImage', ObjTexture));
    imageHeight = imgH * scaleFactor.objects;
    imageWidth = imgW * scaleFactor.objects;
%     [s1, s2, ~] = size(ObjectStim);
%     aspectRatio = s2 / s1;
%     imageHeight = screenYpixels * 0.3 * scaleFactor.objects; 
%     imageWidth = imageHeight * aspectRatio;
    
    % Adjust the vertical offset 
    if MRIFlag == 1
    relativeVerticalDistance = 1.2;
    verticalOffset = crossY * relativeVerticalDistance;
%     horizontalOffset = screenXpixels * 0.625;
    horizontalOffset = screenXpixels * 0.375;   % object on the left
    else
    verticalOffset = screenYpixels * 0.65;
%     horizontalOffset = screenXpixels * 0.625;
    horizontalOffset = screenXpixels * 0.375;   % object on the left
    end
    
    dstRect = CenterRectOnPointd([0 0 imageWidth imageHeight], horizontalOffset, verticalOffset);

    
    % Draw the image
    Screen('DrawTexture', w, ObjTexture, [], dstRect);
    
    
    if EyeFlag
        eye_set_software_event(['both' num2str(trl) ])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    togc=togc+1; SOT_together(togc,1)=toc;
    WaitSecs(config.timing.together/1000);
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = [config.stimuli.stimlist{trl,1}{1,1} '_' config.stimuli.stimlist{trl,2}{1,1}];
    
    % ----------------------------------------------------------------- %

    
    
    % ------------------------ present intermission x -------------------------- %
    
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);

    if EyeFlag
        eye_set_software_event(['fix' num2str(trl) '_3'])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    
   WaitSecs(config.timing.fixation_afterBoth(trl,1))
        
    % ----------------------------------------------------------------- %
    
    
    
    % ------------------------ rating scene -------------------------- %
    
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
   
    
    % Draw the question
    img_emoQ       = imread([paths.elements 'rating_emo_up.png']);
    
    img_garnicht    = imread([paths.elements 'gar_nicht.png']);
    img_etwas       = imread([paths.elements 'etwas.png']);
    img_ziemlich    = imread([paths.elements 'ziemlich.png']);
    img_sehr        = imread([paths.elements 'sehr.png']);
    
    emoQtex         = Screen('MakeTexture', w, img_emoQ);
    garnichttex     = Screen('MakeTexture', w, img_garnicht);
    etwastex        = Screen('MakeTexture', w, img_etwas);
    ziemlichtex     = Screen('MakeTexture', w, img_ziemlich);
    sehrtex         = Screen('MakeTexture', w, img_sehr);
    
    % Define the starting x position for the question iamge
    if MRIFlag == 1
    verticalOffset = 0.6;
    questionDestRectUp = [screenXpixels / 2 - size(img_emoQ, 2) / 2, screenYpixels * verticalOffset - size(img_emoQ, 1) / 2, screenXpixels / 2 + size(img_emoQ, 2) / 2, screenYpixels * verticalOffset + size(img_emoQ, 1) / 2];
    Screen('DrawTexture', w, emoQtex, [], questionDestRectUp);
    else
    verticalOffset = 0.35;
    questionDestRectUp = [screenXpixels / 2 - size(img_emoQ, 2) / 2, screenYpixels * verticalOffset - size(img_emoQ, 1) / 2, screenXpixels / 2 + size(img_emoQ, 2) / 2, screenYpixels * verticalOffset + size(img_emoQ, 1) / 2];
    Screen('DrawTexture', w, emoQtex, [], questionDestRectUp);
    end
    
    % Define spacing between the option images
    optionSpacing = 50; % Adjust this value to increase or decrease the space between images
    
    % Calculate the total width of the option images including spacing
    optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
    totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
    totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);
    
    % Calculate the starting X position for the first option image
    if MRIFlag==1
    startX = (screenXpixels - totalWidthWithSpacing) / 2 + 70;
    else
    startX = (screenXpixels - totalWidthWithSpacing) / 2 - 10;
    end
    
    % Draw the option images with spacing and adjusted vertical position
    if MRIFlag == 1
    verticalOffsetOptions = 0.81;  % Adjust this value as needed, the bigger the value, the further away from the center images go
    for i = 1:length(optionTextures)
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        scaledImgH = imgH * scaleFactor.QnA;
        scaledImgW = imgW * scaleFactor.QnA;
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
    end
    
    
    else
    for i = 1:length(optionTextures)
        verticalOffsetOptions = 0.6;
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - imgH / 2, startX + imgW, screenYpixels * verticalOffsetOptions + imgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + imgW + optionSpacing; % Move to the next position with spacing
    end
    end
    
    if EyeFlag
        eye_set_software_event(['valenceQ_Scene' num2str(trl)])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); tmp = toc;
    emoSc=emoSc+1; SOT_ValQSce(emoSc,1)=toc;
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = 'valenceQ_Scene';
    
    
    [rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],config.timing.resp.valence/1000); tmp = toc;
    
    
    % RT
    if ~isstruct(rsp) %if they didn't press anything
        response1 = NaN; % mark their response as nan
        keypress1 = NaN;
        rt1 = NaN; % mark their reaction time as nan
        WaitSecs(0);
        valQ_scenes(trl,1) = NaN;
        RT_scenes(trl,1) = NaN;
        keypress_valQ_scene(trl,1)=keypress1;
        
    else % otherwise
        response1 = KbName(rsp.keyName); % their response is whatever key they pressed.
        keypress1 = rsp.keyName;
        fprintf(['\nkey pressed: %d \n'],KbName(rsp.keyName));
        
        if response1==FarLeftKey
            valQ_scenes(trl,1) = 0;
        elseif response1==MiddleLeftKey
            valQ_scenes(trl,1) = 1;
        elseif response1==MiddleRightKey
            valQ_scenes(trl,1) = 2;
        elseif response1==FarRightKey
            valQ_scenes(trl,1) = 3;
        else
            warning('unknown key pressed')
            KbName(rsp.keyName);
        end            
        
        rt1 = rsp.RT; % and their reaction time is the time they pressed the button-the time the stimulus apprered
        RT_scenes(trl,1) = rt1;
        resp1c=resp1c+1; SOT_respScene(resp1c,1) = tmp+rt1;
        clear tmp
        
        keypress_valQ_scene(trl,1)=keypress1(1);
        
        % response received, waiting for the next screen
        
        for i = 0:(tilesX-1)
            for j = 0:(tilesY-1)
                destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
                Screen('DrawTexture', w, bgtexture, [], destRect);
            end
        end
        
        % Now, let's draw the fixation cross based on MRIFlag
        crossSize = 25;
        crossColour = [200, 200, 200];
        lineWidth = 10;
        crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
        
        % Check MRIFlag again to position the fixation cross
        if MRIFlag == 1
            % If MRIFlag is 1, position at the bottom half
            crossX = screenXpixels / 2;
            crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
        else
            % If MRIFlag is 0, position in the center
            crossX = screenXpixels / 2;
            crossY = screenYpixels / 2; % Center of the screen
        end
        Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
        
        img_emoQ       = imread([paths.elements 'received.png']);
        
        img_garnicht    = imread([paths.elements 'gar_nicht.png']);
        img_etwas       = imread([paths.elements 'etwas.png']);
        img_ziemlich    = imread([paths.elements 'ziemlich.png']);
        img_sehr        = imread([paths.elements 'sehr.png']);
        
        emoQtex         = Screen('MakeTexture', w, img_emoQ);
        garnichttex     = Screen('MakeTexture', w, img_garnicht);
        etwastex        = Screen('MakeTexture', w, img_etwas);
        ziemlichtex     = Screen('MakeTexture', w, img_ziemlich);
        sehrtex         = Screen('MakeTexture', w, img_sehr);
        
        % Define the starting x position for the question iamge
        if MRIFlag == 1
            verticalOffset = 0.6;
            questionDestRectUp = [screenXpixels / 2 - size(img_emoQ, 2) / 2, screenYpixels * verticalOffset - size(img_emoQ, 1) / 2, screenXpixels / 2 + size(img_emoQ, 2) / 2, screenYpixels * verticalOffset + size(img_emoQ, 1) / 2];
            Screen('DrawTexture', w, emoQtex, [], questionDestRectUp);
        else
            verticalOffset = 0.35;
            questionDestRectUp = [screenXpixels / 2 - size(img_emoQ, 2) / 2, screenYpixels * verticalOffset - size(img_emoQ, 1) / 2, screenXpixels / 2 + size(img_emoQ, 2) / 2, screenYpixels * verticalOffset + size(img_emoQ, 1) / 2];
            Screen('DrawTexture', w, emoQtex, [], questionDestRectUp);
        end
        
        % Define spacing between the option images
        optionSpacing = 50; % Adjust this value to increase or decrease the space between images
        
        % Calculate the total width of the option images including spacing
        optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
        totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
        totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);
        
        % Calculate the starting X position for the first option image
        if MRIFlag==1
            startX = (screenXpixels - totalWidthWithSpacing) / 2 + 70;
        else
            startX = (screenXpixels - totalWidthWithSpacing) / 2 - 10;
        end
        
        % Draw the option images with spacing and adjusted vertical position
        if MRIFlag == 1
            verticalOffsetOptions = 0.81;  % Adjust this value as needed, the bigger the value, the further away from the center images go
            for i = 1:length(optionTextures)
                [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
                scaledImgH = imgH * scaleFactor.QnA;
                scaledImgW = imgW * scaleFactor.QnA;
                optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
                Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
                startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
            end
            
            
        else
            for i = 1:length(optionTextures)
                verticalOffsetOptions = 0.6;
                [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
                optionDestRect = [startX, screenYpixels * verticalOffsetOptions - imgH / 2, startX + imgW, screenYpixels * verticalOffsetOptions + imgH / 2];
                Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
                startX = startX + imgW + optionSpacing; % Move to the next position with spacing
            end
        end
        
        [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs((config.timing.resp.valence/1000)-(rt1/1000));

    end
    
    
    
    
    % ----------------------------------------------------------------- %
    
    
    % ------------------------ present intermission x -------------------------- %
    
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
    
    if EyeFlag
        eye_set_software_event(['fix' num2str(trl) '_4'])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    
    WaitSecs(config.timing.intermission(trl,1))
        
    % ----------------------------------------------------------------- %
    
    
    
    % ------------------------ rating object -------------------------- %
    
    for i = 0:(tilesX-1)
        for j = 0:(tilesY-1)
            destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
            Screen('DrawTexture', w, bgtexture, [], destRect);
        end
    end
    
    % Now, let's draw the fixation cross based on MRIFlag
    crossSize = 25;
    crossColour = [200, 200, 200];
    lineWidth = 10;
    crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
    % Check MRIFlag again to position the fixation cross
    if MRIFlag == 1
        % If MRIFlag is 1, position at the bottom half
        crossX = screenXpixels / 2;
        crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
    else
        % If MRIFlag is 0, position in the center
        crossX = screenXpixels / 2;
        crossY = screenYpixels / 2; % Center of the screen
    end
    Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);

    % load question again
    clear img_emoQ emoQtex
    img_emoQ   = imread([paths.elements 'rating_emo_down.png']);
    emoQtex         = Screen('MakeTexture', w, img_emoQ);

    % Define the starting x position for the question iamge
    if MRIFlag == 1
    verticalOffset = 0.6;
    questionDestRectUp = [screenXpixels / 2 - size(img_emoQ, 2) / 2, screenYpixels * verticalOffset - size(img_emoQ, 1) / 2, screenXpixels / 2 + size(img_emoQ, 2) / 2, screenYpixels * verticalOffset + size(img_emoQ, 1) / 2];
    Screen('DrawTexture', w, emoQtex, [], questionDestRectUp);
    else
    verticalOffset = 0.35;
    questionDestRectUp = [screenXpixels / 2 - size(img_emoQ, 2) / 2, screenYpixels * verticalOffset - size(img_emoQ, 1) / 2, screenXpixels / 2 + size(img_emoQ, 2) / 2, screenYpixels * verticalOffset + size(img_emoQ, 1) / 2];
    Screen('DrawTexture', w, emoQtex, [], questionDestRectUp);
    end
    
    % Define spacing between the option images
    optionSpacing = 50; % Adjust this value to increase or decrease the space between images
    
    % Calculate the total width of the option images including spacing
    optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
    totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
    totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);
    
    % Calculate the starting X position for the first option image
    if MRIFlag==1
    startX = (screenXpixels - totalWidthWithSpacing) / 2 + 70;
    else
    startX = (screenXpixels - totalWidthWithSpacing) / 2 - 10;
    end
    
    % Draw the option images with spacing
    if MRIFlag == 1
    verticalOffsetOptions = 0.81;  % Adjust this value as needed, the bigger the value, the further away from the center images go
    for i = 1:length(optionTextures)
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        scaledImgH = imgH * scaleFactor.QnA;
        scaledImgW = imgW * scaleFactor.QnA;
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
    end
    
    
    else
    for i = 1:length(optionTextures)
        verticalOffsetOptions = 0.6;
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - imgH / 2, startX + imgW, screenYpixels * verticalOffsetOptions + imgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + imgW + optionSpacing; % Move to the next position with spacing
    end
    end
       
    if EyeFlag
        eye_set_software_event(['valenceQ_Obj' num2str(trl)])
    end
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    emoOc=emoOc+1; SOT_ValQObj(emoOc,1)=toc;
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = 'valenceQ_Obj';
    
    
    [rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],config.timing.resp.valence/1000); tmp = toc;
    
    
    % RT
    if ~isstruct(rsp) %if they didn't press anything
        response2 = NaN; % mark their response as nan
        keypress2 = NaN;
        rt2 = NaN; % mark their reaction time as nan
        WaitSecs(0);
        valQ_objs(trl,1) = NaN;
        RT_obj(trl,1) = NaN;
        
        keypress_valQ_objects(trl,1)=keypress2;
        
    else % otherwise
        response2 = KbName(rsp.keyName); % their response is whatever key they pressed.
        keypress2 = rsp.keyName;
        fprintf(['\nkey pressed: %d \n'],KbName(rsp.keyName))
        
        if response2==FarLeftKey
            valQ_objs(trl,1) = 0;
        elseif response2==MiddleLeftKey
            valQ_objs(trl,1) = 1;
        elseif response2==MiddleRightKey
            valQ_objs(trl,1) = 2;
        elseif response2==FarRightKey
            valQ_objs(trl,1) = 3;
        else
            warning('unknown key pressed')
            KbName(rsp.keyName);
        end
        rt2 = rsp.RT; % and their reaction time is the time they pressed the button-the time the stimulus apprered
        RT_obj(trl,1) = rt2;
        resp2c=resp2c+1; SOT_respObj(resp2c,1) = tmp+rt2;
        clear tmp
        
        keypress_valQ_objects(trl,1)=keypress2(1);
        
        % response received, waiting for the next screen
        for i = 0:(tilesX-1)
            for j = 0:(tilesY-1)
                destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
                Screen('DrawTexture', w, bgtexture, [], destRect);
            end
        end
        
        % Now, let's draw the fixation cross based on MRIFlag
        crossSize = 25;
        crossColour = [200, 200, 200];
        lineWidth = 10;
        crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
        % Check MRIFlag again to position the fixation cross
        if MRIFlag == 1
            % If MRIFlag is 1, position at the bottom half
            crossX = screenXpixels / 2;
            crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
        else
            % If MRIFlag is 0, position in the center
            crossX = screenXpixels / 2;
            crossY = screenYpixels / 2; % Center of the screen
        end
        Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
        
        % load question again
        clear img_emoQ emoQtex
        img_emoQ   = imread([paths.elements 'received.png']);
        emoQtex         = Screen('MakeTexture', w, img_emoQ);
        
        % Define the starting x position for the question iamge
        if MRIFlag == 1
            verticalOffset = 0.6;
            questionDestRectUp = [screenXpixels / 2 - size(img_emoQ, 2) / 2, screenYpixels * verticalOffset - size(img_emoQ, 1) / 2, screenXpixels / 2 + size(img_emoQ, 2) / 2, screenYpixels * verticalOffset + size(img_emoQ, 1) / 2];
            Screen('DrawTexture', w, emoQtex, [], questionDestRectUp);
        else
            verticalOffset = 0.35;
            questionDestRectUp = [screenXpixels / 2 - size(img_emoQ, 2) / 2, screenYpixels * verticalOffset - size(img_emoQ, 1) / 2, screenXpixels / 2 + size(img_emoQ, 2) / 2, screenYpixels * verticalOffset + size(img_emoQ, 1) / 2];
            Screen('DrawTexture', w, emoQtex, [], questionDestRectUp);
        end
        
        % Define spacing between the option images
        optionSpacing = 50; % Adjust this value to increase or decrease the space between images
        
        % Calculate the total width of the option images including spacing
        optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
        totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
        totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);
        
        % Calculate the starting X position for the first option image
        if MRIFlag==1
            startX = (screenXpixels - totalWidthWithSpacing) / 2 + 70;
        else
            startX = (screenXpixels - totalWidthWithSpacing) / 2 - 10;
        end
        
        % Draw the option images with spacing
        if MRIFlag == 1
            verticalOffsetOptions = 0.81;  % Adjust this value as needed, the bigger the value, the further away from the center images go
            for i = 1:length(optionTextures)
                [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
                scaledImgH = imgH * scaleFactor.QnA;
                scaledImgW = imgW * scaleFactor.QnA;
                optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
                Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
                startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
            end
            
            
        else
            for i = 1:length(optionTextures)
                verticalOffsetOptions = 0.6;
                [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
                optionDestRect = [startX, screenYpixels * verticalOffsetOptions - imgH / 2, startX + imgW, screenYpixels * verticalOffsetOptions + imgH / 2];
                Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
                startX = startX + imgW + optionSpacing; % Move to the next position with spacing
            end
        end
        
        [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs((config.timing.resp.valence/1000)-(rt2/1000));
        
        
        
        % ------------------------ present fix x -------------------------- %
        
        for i = 0:(tilesX-1)
            for j = 0:(tilesY-1)
                destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
                Screen('DrawTexture', w, bgtexture, [], destRect);
            end
        end
        
        % Now, let's draw the fixation cross based on MRIFlag
        crossSize = 25;
        crossColour = [200, 200, 200];
        lineWidth = 10;
        crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
        % Check MRIFlag again to position the fixation cross
        if MRIFlag == 1
            % If MRIFlag is 1, position at the bottom half
            crossX = screenXpixels / 2;
            crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
        else
            % If MRIFlag is 0, position in the center
            crossX = screenXpixels / 2;
            crossY = screenYpixels / 2; % Center of the screen
        end
        Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
        
        if EyeFlag
        eye_set_software_event(['fix' num2str(trl) '_last'])
        end
        [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
        fixc=fixc+1; SOT_f1(fixc,1)=toc;
        
        WaitSecs(config.timing.fixation_ITI(trl,1))
        eventmarker = eventmarker+1;
        results.presentation{eventmarker,1} = '+';
        
        % ----------------------------------------------------------------- %
        
        
    end
    
        
    % ----------------------------------------------------------------- %
    
    % mid-save the things
    
    if MRIFlag==1
    dat.enc.results.SOT.t0_standby_PTB = t0_standby;
    dat.enc.results.SOT.t0_instruction_PTB = t0_inst;
    dat.enc.results.SOT.prepulse_actual = prepulsereceived;
    dat.enc.results.SOT.trig1 = trigfirst;
    dat.enc.results.SOT.trig5 = triglast;
    dat.enc.results.SOT.t0_fix0 = t0_fix0_raw;
    dat.enc.results.SOT.fixationX = SOT_f1;
    dat.enc.results.SOT.scene = SOT_scene;
    dat.enc.results.SOT.object = SOT_obj;
    dat.enc.results.SOT.together = SOT_together;
    dat.enc.results.SOT.ValenceQ_scene = SOT_ValQSce;
    dat.enc.results.SOT.ValenceQ_obj = SOT_ValQObj;
    dat.enc.results.SOT.resp_scene = SOT_respScene;
    dat.enc.results.SOT.resp_obj = SOT_respObj;
    
    dat.enc.results.RT.ValenceQ_scene = RT_scenes;
    dat.enc.results.RT.ValenceQ_object = RT_obj;
    dat.enc.results.ValenceRatings.scene = valQ_scenes;
    dat.enc.results.ValenceRatings.object = valQ_objs;
    dat.enc.results.presentationOrder = results.presentation;
    
    dat.enc.results.keypress.scenes = keypress_valQ_scene;
    dat.enc.results.keypress.objects = keypress_valQ_objects;
    
    dat.enc.results.codingInfo = 'valQ: 0=garnicht,1=etwas,2=ziemlich,3=sehr';
    
    dat.enc.config.keymap = KbName('KeyNames');
    dat.enc.config.stimlist = config.stimuli.stimlist;
    dat.enc.config.timing  = config.timing;
    
    save([paths.behav 'tmp_' behavfilename],'dat')
    
    else
    dat.enc.results.RT.ValenceQ_scene = RT_scenes;
    dat.enc.results.RT.ValenceQ_object = RT_obj;
    dat.enc.results.ValenceRatings.scene = valQ_scenes;
    dat.enc.results.ValenceRatings.object = valQ_objs;
    dat.enc.results.presentationOrder = results.presentation;
    
    dat.enc.results.keypress.scenes = keypress_valQ_scene;
    dat.enc.results.keypress.objects = keypress_valQ_objects;
    
    dat.enc.results.codingInfo = 'valQ: 0=garnicht,1=etwas,2=ziemlich,3=sehr';
    
    dat.enc.config.keymap = KbName('KeyNames');
    dat.enc.config.stimlist = config.stimuli.stimlist;
    dat.enc.config.timing  = config.timing;
    
    save([paths.behav 'tmp_' behavfilename],'dat')
    end

end

clear ending
ending=imread([paths.elements 'enc_end.png']);
tex=Screen('MakeTexture', w, ending);
Screen('DrawTexture', w, tex);

% Draw the text inside the grey box
% DrawFormattedText(w, finaltext, 'center', 'center', [200 200 200], [], [], [], 1.5, [], centeredRect);
[VBLTimestamp, t0_inst, FlipTimestamp]=Screen('Flip', w); t_TaskEnd_raw = toc;
WaitSecs(3);
sca; ShowCursor;ListenChar(1);

if MRIFlag==1
    dat.enc.results.SOT.t0_standby_PTB = t0_standby;
    dat.enc.results.SOT.t0_standby_raw = t0_standby_raw;
    dat.enc.results.SOT.t0_instruction_PTB = t0_inst;
    dat.enc.results.SOT.prepulse_actual = prepulsereceived;
    dat.enc.results.SOT.trig1 = trigfirst;
    dat.enc.results.SOT.trig5 = triglast;
    dat.enc.results.SOT.t0_fix0 = t0_fix0_raw;
    dat.enc.results.SOT.fixationX = SOT_f1;
    dat.enc.results.SOT.scene = SOT_scene;
    dat.enc.results.SOT.object = SOT_obj;
    dat.enc.results.SOT.together = SOT_together;
    dat.enc.results.SOT.ValenceQ_scene = SOT_ValQSce;
    dat.enc.results.SOT.ValenceQ_obj = SOT_ValQObj;
    dat.enc.results.SOT.resp_scene = SOT_respScene;
    dat.enc.results.SOT.resp_obj = SOT_respObj;
    dat.enc.results.SOT.raw.end  = t_TaskEnd_raw;
    
    dat.enc.results.RT.ValenceQ_scene = RT_scenes;
    dat.enc.results.RT.ValenceQ_object = RT_obj;
    dat.enc.results.ValenceRatings.scene = valQ_scenes;
    dat.enc.results.ValenceRatings.object = valQ_objs;
    dat.enc.results.presentationOrder = results.presentation;
    
    dat.enc.results.keypress.scenes = keypress_valQ_scene;
    dat.enc.results.keypress.objects = keypress_valQ_objects;
    
    dat.enc.results.codingInfo = 'valQ: 0=garnicht,1=etwas,2=ziemlich,3=sehr';
    
    dat.enc.config.keymap = KbName('KeyNames');
    dat.enc.config.stimlist = config.stimuli.stimlist;
    dat.enc.config.timing  = config.timing;
    
    save([paths.behav behavfilename],'dat')
    
else
    dat.enc.results.RT.ValenceQ_scene = RT_scenes;
    dat.enc.results.RT.ValenceQ_object = RT_obj;
    dat.enc.results.ValenceRatings.scene = valQ_scenes;
    dat.enc.results.ValenceRatings.object = valQ_objs;
    dat.enc.results.presentationOrder = results.presentation;
        
    dat.enc.results.keypress.scenes = keypress_valQ_scene;
    dat.enc.results.keypress.objects = keypress_valQ_objects;
    
    dat.enc.results.codingInfo = 'valQ: 0=garnicht,1=etwas,2=ziemlich,3=sehr';
    
    dat.enc.config.keymap = KbName('KeyNames');
    dat.enc.config.stimlist = config.stimuli.stimlist;
    dat.enc.config.timing  = config.timing;
    
    save([paths.behav behavfilename],'dat')
end



% % Close textures
% Screen('Close', texture);

% Close the screen
Screen('CloseAll');
disp('*********************************************')
disp('******* the end of the encoding phase *******')

disp(datetime)

diary off;

%% --- pupillometry cleanup ---
if EyeFlag
    eye_set_software_event('task_end');
    % eye_stop_stream();
    eye_set_parameter('eye_save_tracking','false');
    eye_set_parameter('eye_save_tracking_and_video','false');
end

end
