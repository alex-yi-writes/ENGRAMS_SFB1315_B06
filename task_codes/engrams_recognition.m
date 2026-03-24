%% ENGRAMS experiment: recognition

function [dat] = engrams_recognition(id,block,condition,phase,mri,pupil,taskpath,prepulse)

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
elseif strcmp(pupil,'No')==1
    EyeFlag = 0;
end


behavfilename  = [num2str(ID) '_rcg_' phases '_' num2str(Block) '.mat'];

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

if exist(strcat(paths.logs, num2str(ID), '_rcg_', phases, '_', num2str(Block), '_log_', string(date), '.txt')) == 2
K=string(datestr(now));
try
diary(strcat(paths.logs, num2str(ID), '_rcg_', phases, '_', num2str(Block), '_log_', string(date),'_',K{1}(end-1:end),'.txt'))
catch
diary(strcat(paths.logs, num2str(ID), '_rcg_', phases, '_', num2str(Block), '_log_', string(date),'_',K(end-1:end),'.txt'))
end
else
diary(strcat(paths.logs, num2str(ID), '_rcg_', phases, '_', num2str(Block), '_log_', string(date), '.txt'))
end

disp(strcat('ENGRAMS RECOGNITION ', string(datetime)))

% load design matrix
if strcmp(phase,'Original')==1
    phases = 'orig';
    load([paths.elements 'desmat/GA_ENGRAMS_RCG_designstruct_type1_Top' num2str(mod(ID,2)) '.mat'])
elseif strcmp(phase,'Recombination')==1
    phases = 'recombi';
    load([paths.elements 'desmat/GA_ENGRAMS_RCG_designstruct_type1_Top' num2str(mod(ID+1,2)) '.mat'])
end

% create the data structure
cd(paths.behav)
if exist(behavfilename) == 2
    load([paths.behav behavfilename])
else
    dat = [];
    dat.ID  = ID;
    dat.rcg = [];
    dat.rcg.condition = conditions;
    dat.rcg.phase     = phases;
    dat.rcg.measured_on = datetime;
end

% scanner preparation
if MRIFlag == 1
    dat.rcg.mri          = [];
    dat.rcg.mri.scanPort = 1;
    dat.rcg.mri.dummy    = PrePulse+5        % no. of dummy vols
    dat.rcg.mri.nslice   = 51;       % no. of slices
    dat.rcg.mri.TE       = 32;       % time for each slice in msec
    dat.rcg.mri.TR       = 2.34;     % MRIinfo.nslice * MRIinfo.TE/1000; % time for volume in msec
end

disp('environment prepared')
disp(['subject ID ' num2str(ID) ', block number ' num2str(Block) ', condition ' conditions])

%% prepare stimuli

config = [];

% ======== prepare stimuli ======== %

rng('shuffle'); % prepare for true randomisation

stimlist = [];
stimlist = readtable([paths.stimlist 'recognition_' phases '_' conditions '.xlsx']);

config.stimuli.numtrials = size(stimlist,1);

v = 1:config.stimuli.numtrials;
randomIndex = randperm(length(v));
randomizedVector = v(randomIndex);

config.stimuli.stimlist.scene       = stimlist(randomizedVector,1);
config.stimuli.stimlist.object      = stimlist(randomizedVector,2);
config.stimuli.stimlist.options     = stimlist(randomizedVector,3:5);
config.stimuli.stimlist.answerkeys  = table2array(stimlist(randomizedVector,6:8));
config.stimuli.stimlist.all         = stimlist(randomizedVector,:);
config.stimuli.scaleFactor.scenes   = 0.9;
config.stimuli.scaleFactor.objects  = 0.75; %0.5;
config.stimuli.scaleFactor.QnA      = 0.8;
config.stimuli.scaleFactor.xOffset  = 120; xOffset=config.stimuli.scaleFactor.xOffset;


scaleFactor.scenes = config.stimuli.scaleFactor.scenes;
scaleFactor.objects = config.stimuli.scaleFactor.objects;
scaleFactor.QnA = config.stimuli.scaleFactor.QnA;

% ================================= %


% ======== timing information ======== %

rng('shuffle'); % shuffle again
config.timing.fixation_afterScene = FinalDesignMatrix.eventlist(:,6);
config.timing.fixation_afterObject = FinalDesignMatrix.eventlist(:,7);
config.timing.fixation_afterConfidence = FinalDesignMatrix.eventlist(:,8);
config.timing.fixation_ITI = FinalDesignMatrix.eventlist(:,9);%randi([10, 40], 60, 1) * 100;%eval(['cell2mat(RET17T_' num2str(BlockNum) '(:,5)).*1000']);
config.timing.intermission = [randi([10, 15], 60, 1) * 100, randi([5, 10], 60, 1) * 100];%eval(['cell2mat(RET17T_' num2str(BlockNum) '(:,5)).*1000']);
config.timing.scene    = 750;
config.timing.object   = 750;
config.timing.together = 750;
config.timing.confidenceQ = 3000;
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

% Get the size of the screen
[screenXpixels, screenYpixels] = Screen('WindowSize', w);





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
        verticalOffsetOptions = 0.6;
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
        verticalOffsetOptions = 0.6;
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
        verticalOffsetOptions = 0.6;
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
        verticalOffsetOptions = 0.6;
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3 buttons test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear img_buttonQ buttonQtex img_objL img_objM img_objR objLtex objMtex objRtex

% Draw the question
img_buttonQ       = imread([paths.elements 'keytest_question.png']);

img_objL    = imread([paths.elements 'GreyCircle.png']);
img_objM    = imread([paths.elements 'X.png']);
img_objR    = imread([paths.elements 'X.png']);

buttonQtex     = Screen('MakeTexture', w, img_buttonQ);

objLtex     = Screen('MakeTexture', w, img_objL);
objMtex     = Screen('MakeTexture', w, img_objM);
objRtex     = Screen('MakeTexture', w, img_objR);

% Define the starting x position for the question iamges
if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
end
Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);

% Define spacing between the option images
optionSpacing = 200; % Adjust this value to increase or decrease the space between images

% Calculate the total width of the option images including spacing
optionTextures = [objLtex, objMtex, objRtex];
totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);

% Calculate the starting X position for the first option image
startX = ((screenXpixels - totalWidthWithSpacing) / 2);

% Draw the option images with spacing
if MRIFlag == 1
    verticalOffsetOptions = 0.87;  % Adjust this value as needed, the bigger the value, the further away from the center images go
else
    verticalOffsetOptions = 0.65;
end
% Draw the option images with spacing and adjusted vertical position
for i = 1:length(optionTextures)
    [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
    scaledImgH = imgH;
    scaledImgW = imgW;
    optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
    Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
    startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
end

Screen('Flip', w); 

[rsp] = getKeys([FarLeftKey],Inf); 

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




clear img_buttonQ buttonQtex img_objL img_objM img_objR objLtex objMtex objRtex

% Draw the question
img_buttonQ       = imread([paths.elements 'keytest_question.png']);

img_objL    = imread([paths.elements 'X.png']);
img_objM    = imread([paths.elements 'GreyCircle.png']);
img_objR    = imread([paths.elements 'X.png']);

buttonQtex     = Screen('MakeTexture', w, img_buttonQ);

objLtex     = Screen('MakeTexture', w, img_objL);
objMtex     = Screen('MakeTexture', w, img_objM);
objRtex     = Screen('MakeTexture', w, img_objR);

% Define the starting x position for the question iamges
if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
end
Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);

% Define spacing between the option images
optionSpacing = 200; % Adjust this value to increase or decrease the space between images

% Calculate the total width of the option images including spacing
optionTextures = [objLtex, objMtex, objRtex];
totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);

% Calculate the starting X position for the first option image
startX = ((screenXpixels - totalWidthWithSpacing) / 2);

% Draw the option images with spacing
if MRIFlag == 1
    verticalOffsetOptions = 0.87;  % Adjust this value as needed, the bigger the value, the further away from the center images go
else
    verticalOffsetOptions = 0.65;
end
% Draw the option images with spacing and adjusted vertical position
for i = 1:length(optionTextures)
    [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
    scaledImgH = imgH;
    scaledImgW = imgW;
    optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
    Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
    startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
end

Screen('Flip', w); 

[rsp] = getKeys([MiddleLeftKey,MiddleRightKey],Inf); 

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





clear img_buttonQ buttonQtex img_objL img_objM img_objR objLtex objMtex objRtex

% Draw the question
img_buttonQ       = imread([paths.elements 'keytest_question.png']);

img_objL    = imread([paths.elements 'X.png']);
img_objM    = imread([paths.elements 'X.png']);
img_objR    = imread([paths.elements 'GreyCircle.png']);

buttonQtex     = Screen('MakeTexture', w, img_buttonQ);

objLtex     = Screen('MakeTexture', w, img_objL);
objMtex     = Screen('MakeTexture', w, img_objM);
objRtex     = Screen('MakeTexture', w, img_objR);

% Define the starting x position for the question iamges
if MRIFlag == 1
    verticalOffset = 0.64;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
else
    verticalOffset = 0.42;
    questionDestRectUp = [screenXpixels / 2 - size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset - size(img_buttonQ, 1) / 2, screenXpixels / 2 + size(img_buttonQ, 2) / 2, screenYpixels * verticalOffset + size(img_buttonQ, 1) / 2];
end
Screen('DrawTexture', w, buttonQtex, [], questionDestRectUp);

% Define spacing between the option images
optionSpacing = 200; % Adjust this value to increase or decrease the space between images

% Calculate the total width of the option images including spacing
optionTextures = [objLtex, objMtex, objRtex];
totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);

% Calculate the starting X position for the first option image
startX = ((screenXpixels - totalWidthWithSpacing) / 2);

% Draw the option images with spacing
if MRIFlag == 1
    verticalOffsetOptions = 0.87;  % Adjust this value as needed, the bigger the value, the further away from the center images go
else
    verticalOffsetOptions = 0.65;
end
% Draw the option images with spacing and adjusted vertical position
for i = 1:length(optionTextures)
    [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
    scaledImgH = imgH;
    scaledImgW = imgW;
    optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
    Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
    startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
end

Screen('Flip', w); 

[rsp] = getKeys([FarRightKey],Inf); 

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


% ---------- Load the instruction text ---------- %

instruction = imread([paths.elements 'instr_orig_recognition.png']);

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

% ----------------------------------------------------- %


% Show stimulus on screen at next possible display refresh cycle,
% and record stimulus onset time in 'startrt':
[VBLTimestamp, t0_inst, FlipTimestamp]=Screen('Flip', w);
tmp=VBLTimestamp;
clear rsp
[rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],Inf);

% Let the scanner start the task, allow n dummy volumes
if MRIFlag == 1
    
    % hail the operator
    
    % load operator information screen
    clear tex
    opinfo = imread([paths.elements 'operator_hail.bmp']);
    % Create a texture from the image
    tex=Screen('MakeTexture', w, opinfo);
    Screen('DrawTexture', w, tex);
    
    [VBLTimestamp, ~, FlipTimestamp]=Screen('Flip', w);
    
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

    [VBLTimestamp, t0_standby, FlipTimestamp]=Screen('Flip', w);
    
    %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%
         tic % ding ding ding
    %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%
   
    
    % Initialize counters and flags
    numTriggers = 0;
    trigfirst = NaN;
    triglast = NaN;
    prepulsereceived=0;
    
    % Loop until 5 triggers are detected
    while numTriggers < dat.rcg.mri.dummy
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
                    firstprepulse = toc 
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
%     dat.rcg.mri.dummyscanfirst= rsp;
%     disp('5')
%     WaitSecs(0.1);
%     for dum = 1:(dat.rcg.mri.dummy - 2)
%         [rsp] = getKeys(MRItrigger,Inf);
%         disp(num2str(4-dum+1))
%         WaitSecs(0.1);
%     end
%     [rsp] = getKeys(MRItrigger,Inf);
%     trig5=toc; %%%
%     disp('1')
%     dat.rcg.mri.dummyscanlast = rsp; % the last dummy scan
    
    
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
    
    WaitSecs(dat.rcg.mri.TR);

    
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
    % If MRIFlag is 0, position in the center
    crossX = screenXpixels / 2;
    crossY = screenYpixels / 2; % Center of the screen
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
i = 0; fixc = 0; scenec = 0; objc = 0; togc = 0; rcgQc = 0; confQc = 0; resp1c = 0; resp2c = 0;
SOT_f1=[]; SOT_together = []; SOT_obj = []; SOT_scene = []; SOT_confQ =[]; SOT_rcgQ =[]; SOT_resprcgQ = []; SOT_respconfQ = [];
rcgQ=[]; confQ=[]; valQ_objs=[]; RT_rcgQ=[]; RT_obj=[];
OptionChosen_rcgQ=[]; accuracies=[]; accuracies_bin=[]; confidences=[]; keypress_conf=[]; keypress_recog=[];
dat.rcg.results = [];

for trl = 1:config.stimuli.numtrials
    
    i = i+1;
    fprintf('\n============================================\n')
    fprintf('Trial %d\n', trl)
    
    
    
    
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

    SceneStim = imread([paths.stimuli config.stimuli.stimlist.scene{trl,1}{1}]);
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
%     verticalOffset = crossY + (crossSize / 2) + (imageHeight / 2) + (relativeVerticalDistance * screenYpixels);
    
    dstRect = CenterRectOnPointd([0 0 imageWidth imageHeight], mx, verticalOffset);

    % Draw the image
    Screen('DrawTexture', w, SceneTexture, [], dstRect);
    
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    scenec=scenec+1; SOT_scene(scenec,1)=toc;
    WaitSecs(config.timing.scene/1000);
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = config.stimuli.stimlist.scene{trl,1}{1,1};
    
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
    
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    
    WaitSecs(config.timing.fixation_afterScene(trl,1))
        
    % ----------------------------------------------------------------- %
    
    
    
    % -------------------- present options (obj) ----------------------- %
    
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
    img_rcgQ       = imread([paths.elements 'question_recognition.png']);
    
    img_objL    = imread([paths.stimuli config.stimuli.stimlist.options{trl,1}{1}]);
    img_objM    = imread([paths.stimuli config.stimuli.stimlist.options{trl,2}{1}]);
    img_objR    = imread([paths.stimuli config.stimuli.stimlist.options{trl,3}{1}]);
    
    rcgQtex     = Screen('MakeTexture', w, img_rcgQ);
    
    objLtex     = Screen('MakeTexture', w, img_objL);
    objMtex     = Screen('MakeTexture', w, img_objM);
    objRtex     = Screen('MakeTexture', w, img_objR);
    
    % Define the starting x position for the question iamges
    if MRIFlag == 1
    verticalOffset = 0.6;
    questionDestRectUp = [screenXpixels / 2 - size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset - size(img_rcgQ, 1) / 2, screenXpixels / 2 + size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset + size(img_rcgQ, 1) / 2];
    else
    verticalOffset = 0.37;
    questionDestRectUp = [screenXpixels / 2 - size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset - size(img_rcgQ, 1) / 2, screenXpixels / 2 + size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset + size(img_rcgQ, 1) / 2];
    end
    Screen('DrawTexture', w, rcgQtex, [], questionDestRectUp);
    
    % Define spacing between the option images
    optionSpacing = 30; % Adjust this value to increase or decrease the space between images
    
    % Calculate the total width of the option images including spacing
    optionTextures = [objLtex, objMtex, objRtex];
    totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
    totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);
    
    % Calculate the starting X position for the first option image
    % startX = ((screenXpixels - totalWidthWithSpacing) / 2) + 225;
    startX = ((screenXpixels - totalWidthWithSpacing) / 2) + xOffset;
    
    % Draw the option images with spacing
    if MRIFlag == 1
    verticalOffsetOptions = 0.87;  % Adjust this value as needed, the bigger the value, the further away from the center images go
    else
    verticalOffsetOptions = 0.65; 
    end
    % Draw the option images with spacing and adjusted vertical position
    for i = 1:length(optionTextures)
        [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
        scaledImgH = imgH * scaleFactor.objects;
        scaledImgW = imgW * scaleFactor.objects;
        optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
        Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
        startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
    end
%     for i = 1:length(optionTextures)
%         [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
% %         optionDestRect = [startX, screenYpixels * 0.7 - (imgH) / 2, startX + (imgW), screenYpixels * 0.7 + (imgH) / 2];
%         optionDestRect = [startX, screenYpixels * 0.7 - (imgH*scaleFactor.objects) / 2, startX + (imgW*scaleFactor.objects), screenYpixels * 0.7 + (imgH*scaleFactor.objects) / 2];
%         Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
%         startX = startX + imgW + optionSpacing; % Move to the next position with spacing
%     end
    
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); tmp = toc;
    rcgQc=rcgQc+1; SOT_rcgQ(rcgQc,1)=toc;
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = 'recognitionQ';
    
    
    [rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],config.timing.resp.memory/1000); tmp = toc;
    
    
    % RT
    if ~isstruct(rsp) %if they didn't press anything
        response1 = NaN; % mark their response as nan
        keypress1 = NaN;
        rt1 = NaN; % mark their reaction time as nan
        WaitSecs(0);
        rcgQ(trl,1) = NaN;
        RT_rcgQ(trl,1) = NaN;
        
        % record keypress
        keypress_recog(trl,1)=keypress1;
        
        % calculate accuracy (hit=1, internallure=-1, externallure=0)
        accuracies(trl,1)=NaN;
        accuracies_bin(trl,1)=NaN;
        
        
    else % otherwise
        response1 = KbName(rsp.keyName); % their response is whatever key they pressed.
        keypress1 = rsp.keyName;
        fprintf(['\nkey pressed: %d \n'],KbName(rsp.keyName))
        
        if response1==FarLeftKey
            rcgQ(trl,1) = 1;
        elseif response1==MiddleLeftKey
            rcgQ(trl,1) = 2;
        elseif response1==MiddleRightKey
            rcgQ(trl,1) = 2;
        elseif response1==FarRightKey
            rcgQ(trl,1) = 3;
        else
            try
                warning('unknown key pressed - 1st attempt at resolving')
                
                clear tmpKeyPressedError
                tmpKeyPressedError=rsp.keyName;                
                KbName(tmpKeyPressedError(1));
                
                response1 = response1(1); % their response is whatever key they pressed.
                keypress1 = keypress1(1);
                fprintf(['\nproceeding with key pressed as: %d \n'],keypress1)
                
                if  response1(1)==FarLeftKey
                    rcgQ(trl,1) = 1;
                elseif  response1(1)==MiddleLeftKey
                    rcgQ(trl,1) = 2;
                elseif  response1(1)==MiddleRightKey
                    rcgQ(trl,1) = 2;
                elseif  response1(1)==FarRightKey
                    rcgQ(trl,1) = 3;
                end
            catch
                warning('unknown key pressed - proceeding with null input')
                KbName(rsp.keyName);
                rcgQ(trl,1) = NaN;
            end
        end
        
        rt1 = rsp.RT(1); % and their reaction time is the time they pressed the button-the time the stimulus apprered
        RT_rcgQ(trl,1) = rt1;
        resp1c=resp1c+1; SOT_resprcgQ(resp1c,1) = tmp+rt1;
        clear tmp
        
        
        % record keypress
        try
            keypress_recog(trl,1)=keypress1;
        catch
            try
                keypress_recog(trl,1)=KbName(rsp.keyName);
            catch
                try
                    keypress_recog(trl,1)=keypress1(1);
                catch
                    keypress_recog(trl,1)=NaN;
                end
            end
        end
        
        % calculate accuracy (hit=1, internallure=-1, externallure=0)
        try
            OptionChosen_rcgQ(trl,1) = config.stimuli.stimlist.answerkeys(trl,rcgQ(trl,1));
            if OptionChosen_rcgQ(trl,1)==1
                accuracies(trl,1)=1;
                accuracies_bin(trl,1)=1;
            elseif OptionChosen_rcgQ(trl,1)==-1
                accuracies(trl,1)=-1;
                accuracies_bin(trl,1)=0;
            elseif OptionChosen_rcgQ(trl,1)==0
                accuracies(trl,1)=0;
                accuracies_bin(trl,1)=0;
            else
                accuracies(trl,1)=NaN;
                accuracies_bin(trl,1)=NaN;
            end
        catch
            warning('button press not recognised, proceeding with null input')
            OptionChosen_rcgQ(trl,1) = NaN;
            accuracies(trl,1)=NaN;
            accuracies_bin(trl,1)=NaN;
        end

        
        % response received, waiting for the next screen
        for i = 0:(tilesX-1)
            for j = 0:(tilesY-1)
                destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
                Screen('DrawTexture', w, bgtexture, [], destRect);
            end
        end
        crossSize = 25;
        crossColour = [200, 200, 200];
        lineWidth = 10;
        crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
        if MRIFlag == 1
            crossX = screenXpixels / 2;
            crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
        else
            crossX = screenXpixels / 2;
            crossY = screenYpixels / 2; % Center of the screen
        end
        Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
        img_ok   = imread([paths.elements 'received.png']);
        oktex    = Screen('MakeTexture', w, img_ok);
        if MRIFlag == 1
            verticalOffset = 0.6;
            questionDestRectUp = [screenXpixels / 2 - size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset - size(img_rcgQ, 1) / 2, screenXpixels / 2 + size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset + size(img_rcgQ, 1) / 2];
        else
            verticalOffset = 0.37;
            questionDestRectUp = [screenXpixels / 2 - size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset - size(img_rcgQ, 1) / 2, screenXpixels / 2 + size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset + size(img_rcgQ, 1) / 2];
        end
        Screen('DrawTexture', w, oktex, [], questionDestRectUp);
        
        objLtex     = Screen('MakeTexture', w, img_objL);
        objMtex     = Screen('MakeTexture', w, img_objM);
        objRtex     = Screen('MakeTexture', w, img_objR);
        
        % Define spacing between the option images
        optionSpacing = 30; % Adjust this value to increase or decrease the space between images
        
        % Calculate the total width of the option images including spacing
        optionTextures = [objLtex, objMtex, objRtex];
        totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
        totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);
        
        % Calculate the starting X position for the first option image
        startX = ((screenXpixels - totalWidthWithSpacing) / 2) + xOffset;
        % startX = ((screenXpixels - totalWidthWithSpacing) / 2) + 225;
        
        % Draw the option images with spacing
        if MRIFlag == 1
            verticalOffsetOptions = 0.87;  % Adjust this value as needed, the bigger the value, the further away from the center images go
        else
            verticalOffsetOptions = 0.65;
        end
        % Draw the option images with spacing and adjusted vertical position
        for i = 1:length(optionTextures)
            [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
            scaledImgH = imgH * scaleFactor.objects;
            scaledImgW = imgW * scaleFactor.objects;
            optionDestRect = [startX, screenYpixels * verticalOffsetOptions - scaledImgH / 2, startX + scaledImgW, screenYpixels * verticalOffsetOptions + scaledImgH / 2];
            Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
            startX = startX + scaledImgW + optionSpacing; % Move to the next position with spacing
        end
        
        [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs((config.timing.resp.memory/1000)-(rt1/1000));
        
    end
    
%     % record keypress
%     keypress_recog(trl,1)=keypress1;
%     
%     
%     % calculate accuracy (hit=1, internallure=-1, externallure=0)
%     
%     OptionChosen_rcgQ(trl,1) = config.stimuli.stimlist.answerkeys(trl,rcgQ(trl,1));
%     if OptionChosen_rcgQ(trl,1)==1
%         accuracies(trl,1)=1;
%         accuracies_bin(trl,1)=1;
%     elseif OptionChosen_rcgQ(trl,1)==-1
%         accuracies(trl,1)=-1;
%         accuracies_bin(trl,1)=0;
%     elseif OptionChosen_rcgQ(trl,1)==0
%         accuracies(trl,1)=0;
%         accuracies_bin(trl,1)=0;
%     else
%         accuracies(trl,1)=NaN;
%         accuracies_bin(trl,1)=NaN;
%     end
        
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
    
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    
    WaitSecs(config.timing.fixation_afterObject(trl,1))
        
    % ----------------------------------------------------------------- %
    
    
    
    % ------------------ present confidence rating -------------------- %

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
    img_confQ       = imread([paths.elements 'rating_confidence.png']);
    
    img_garnicht    = imread([paths.elements 'gar_nicht.png']);
    img_etwas       = imread([paths.elements 'etwas.png']);
    img_ziemlich    = imread([paths.elements 'ziemlich.png']);
    img_sehr        = imread([paths.elements 'sehr.png']);
    
    rcgQtex         = Screen('MakeTexture', w, img_confQ);
    garnichttex     = Screen('MakeTexture', w, img_garnicht);
    etwastex        = Screen('MakeTexture', w, img_etwas);
    ziemlichtex     = Screen('MakeTexture', w, img_ziemlich);
    sehrtex         = Screen('MakeTexture', w, img_sehr);
    
    % Define the starting x position for the question image
    if MRIFlag == 1
    verticalOffset = 0.6;
    else
    verticalOffset = 0.37;
    end
    questionDestRectUp = [screenXpixels / 2 - size(img_confQ, 2) / 2, screenYpixels * verticalOffset - size(img_confQ, 1) / 2, screenXpixels / 2 + size(img_confQ, 2) / 2, screenYpixels * verticalOffset + size(img_confQ, 1) / 2];
    Screen('DrawTexture', w, rcgQtex, [], questionDestRectUp);
%     questionDestRectUp = [screenXpixels / 2 - size(img_confQ, 2) / 2, screenYpixels * 0.325 - size(img_confQ, 1) / 2, screenXpixels / 2 + size(img_confQ, 2) / 2, screenYpixels * 0.325 + size(img_confQ, 1) / 2];
%     Screen('DrawTexture', w, rcgQtex, [], questionDestRectUp);
    
    % Define spacing between the option images
    optionSpacing = 30; % Adjust this value to increase or decrease the space between images
    
    % Calculate the total width of the option images including spacing
    optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
    totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
    totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);
    
    % Calculate the starting X position for the first option image
    if MRIFlag == 1
    startX = (screenXpixels - totalWidthWithSpacing) / 2 + 70;
    else
    startX = (screenXpixels - totalWidthWithSpacing) / 2;   
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
    
%     for i = 1:length(optionTextures)
%         [imgH, imgW, ~] = size(Screen('GetImage', optionTextures(i)));
%         optionDestRect = [startX, screenYpixels * 0.65 - (imgH*scaleFactor.QnA) / 2, startX + (imgW*scaleFactor.QnA), screenYpixels * 0.65 + (imgH*scaleFactor.QnA) / 2];
%         Screen('DrawTexture', w, optionTextures(i), [], optionDestRect);
%         startX = startX + imgW + optionSpacing; % Move to the next position with spacing
%     end
    
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); tmp = toc;
    confQc=confQc+1; SOT_confQ(confQc,1)=toc;
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = 'confidenceRating';
    
    
    [rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],config.timing.resp.confidence/1000); tmp = toc;
    
    
    % RT
    if ~isstruct(rsp) %if they didn't press anything
        response2 = NaN; % mark their response as nan
        keypress2 = NaN;
        rt2 = NaN; % mark their reaction time as nan
        WaitSecs(0);
        confQ(trl,1) = NaN;
        RT_confQ(trl,1) = NaN;
        
        % record confidence ratings
        confidences(trl,1)=confQ(trl,1);
        
        % record keypress
        keypress_conf(trl,1)=keypress2;
        
    else % otherwise
        response2 = KbName(rsp.keyName); % their response is whatever key they pressed.
        keypress2 = rsp.keyName;
        fprintf(['\nkey pressed: %d \n'],KbName(rsp.keyName))
        
        if response2==FarLeftKey
            confQ(trl,1) = 0;
        elseif response2==MiddleLeftKey
            confQ(trl,1) = 1;
        elseif response2==MiddleRightKey
            confQ(trl,1) = 2;
        elseif response2==FarRightKey
            confQ(trl,1) = 3;
        else
            try
                warning('unknown key pressed - 1st attempt at resolving')
                
                clear tmpKeyPressedError
                tmpKeyPressedError=rsp.keyName;                
                KbName(tmpKeyPressedError(1));
                
                response2 = response2(1); % their response is whatever key they pressed.
                keypress2 = keypress2(1);
                fprintf(['\nproceeding with key pressed as: %d \n'],keypress2)
                
                if  response2(1)==FarLeftKey
                    confQ(trl,1) = 0;
                elseif  response2(1)==MiddleLeftKey
                    confQ(trl,1) = 1;
                elseif  response2(1)==MiddleRightKey
                    confQ(trl,1) = 2;
                elseif  response2(1)==FarRightKey
                    confQ(trl,1) = 3;
                end
            catch
                warning('unknown key pressed - proceeding with null input')
                KbName(rsp.keyName);
                confQ(trl,1) = NaN;
            end
        end            
        
        rt2 = rsp.RT(1); % and their reaction time is the time they pressed the button-the time the stimulus apprered
        RT_confQ(trl,1) = rt2;
        resp2c=resp2c+1; SOT_respconfQ(resp2c,1) = tmp+rt2;
        clear tmp
        
        % record confidence ratings
        confidences(trl,1)=confQ(trl,1);
        
        % record keypress
        
        try
        keypress_conf(trl,1)=keypress2;
        catch
            try
                keypress_conf(trl,1)=KbName(rsp.keyName);
            catch
                try
                keypress_conf(trl,1)=keypress2(1);
                catch
                keypress_conf(trl,1)=NaN;
                end
            end
        end
        
        % response received, waiting for the next screen
        for i = 0:(tilesX-1)
            for j = 0:(tilesY-1)
                destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
                Screen('DrawTexture', w, bgtexture, [], destRect);
            end
        end
        crossSize = 25;
        crossColour = [200, 200, 200];
        lineWidth = 10;
        crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
        if MRIFlag == 1
            crossX = screenXpixels / 2;
            crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
        else
            crossX = screenXpixels / 2;
            crossY = screenYpixels / 2; % Center of the screen
        end
        Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
        img_ok   = imread([paths.elements 'received.png']);
        oktex    = Screen('MakeTexture', w, img_ok);
        if MRIFlag == 1
            verticalOffset = 0.6;
            questionDestRectUp = [screenXpixels / 2 - size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset - size(img_rcgQ, 1) / 2, screenXpixels / 2 + size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset + size(img_rcgQ, 1) / 2];
        else
            verticalOffset = 0.37;
            questionDestRectUp = [screenXpixels / 2 - size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset - size(img_rcgQ, 1) / 2, screenXpixels / 2 + size(img_rcgQ, 2) / 2, screenYpixels * verticalOffset + size(img_rcgQ, 1) / 2];
        end
        Screen('DrawTexture', w, oktex, [], questionDestRectUp);
        
        garnichttex     = Screen('MakeTexture', w, img_garnicht);
        etwastex        = Screen('MakeTexture', w, img_etwas);
        ziemlichtex     = Screen('MakeTexture', w, img_ziemlich);
        sehrtex         = Screen('MakeTexture', w, img_sehr);
        
        % Define spacing between the option images
        optionSpacing = 30; % Adjust this value to increase or decrease the space between images
        
        % Calculate the total width of the option images including spacing
        optionTextures = [garnichttex, etwastex, ziemlichtex, sehrtex];
        totalImageWidth = sum(arrayfun(@(x) size(Screen('GetImage', x), 2), optionTextures));
        totalWidthWithSpacing = totalImageWidth + optionSpacing * (length(optionTextures) - 1);
        
        % Calculate the starting X position for the first option image
        % Calculate the starting X position for the first option image
        if MRIFlag == 1
            startX = (screenXpixels - totalWidthWithSpacing) / 2 + 70;
        else
            startX = (screenXpixels - totalWidthWithSpacing) / 2;
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
        
        [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs((config.timing.resp.confidence/1000)-(rt2/1000));
        
    end

    
    % ----------------------------------------------------------------- %
    
    
    
%     % ------------------- present intermission x ---------------------- %
%    
%     for i = 0:(tilesX-1)
%         for j = 0:(tilesY-1)
%             destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
%             Screen('DrawTexture', w, bgtexture, [], destRect);
%         end
%     end
%     
%     % Now, let's draw the fixation cross based on MRIFlag
%     crossSize = 25;
%     crossColour = [200, 200, 200];
%     lineWidth = 10;
%     crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
%     % Check MRIFlag again to position the fixation cross
%     if MRIFlag == 1
%         % If MRIFlag is 1, position at the bottom half
%         crossX = screenXpixels / 2;
%         crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
%     else
%         % If MRIFlag is 0, position in the center
%         crossX = screenXpixels / 2;
%         crossY = screenYpixels / 2; % Center of the screen
%     end
%     Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
% 
%     [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
%     
%     WaitSecs(config.timing.fixation_afterConfidence(trl,1))
%         
%     % ----------------------------------------------------------------- %
%     
%     
%     % ------------------------ present together -------------------------- %
% 
%     for i = 0:(tilesX-1)
%         for j = 0:(tilesY-1)
%             destRect = [i * bgWidth, j * bgHeight, (i+1) * bgWidth, (j+1) * bgHeight];
%             Screen('DrawTexture', w, bgtexture, [], destRect);
%         end
%     end
%     
%    % Now, let's draw the fixation cross based on MRIFlag
%     crossSize = 25;
%     crossColour = [200, 200, 200];
%     lineWidth = 10;
%     crossLines = [-crossSize, crossSize, 0, 0; 0, 0, -crossSize, crossSize];
%     % Check MRIFlag again to position the fixation cross
%     if MRIFlag == 1
%         % If MRIFlag is 1, position at the bottom half
%         crossX = screenXpixels / 2;
%         crossY = (3 * screenYpixels / 4) - crossSize; % Position it just above the bottom
%     else
%         % If MRIFlag is 0, position in the center
%         crossX = screenXpixels / 2;
%         crossY = screenYpixels / 2; % Center of the screen
%     end
%     Screen('DrawLines', w, crossLines, lineWidth, crossColour, [crossX, crossY]);
%     
%     
%     
%     
%     clear SceneStim
%     SceneStim = imread([paths.stimuli config.stimuli.stimlist.scene{trl,1}{1,1}]);
%     SceneTexture = Screen('MakeTexture', w, SceneStim);
%     
%     % Define size and position of the image
%     [s1, s2, ~] = size(SceneStim);
%     aspectRatio = s2 / s1;
%     imageHeight = screenYpixels * 0.3 * scaleFactor.scenes; 
%     imageWidth = imageHeight * aspectRatio;
%     
%     % Adjust the vertical offset 
%     if MRIFlag == 1
%     relativeVerticalDistance = 0.75;
%     verticalOffset = crossY * relativeVerticalDistance;
%     else
%     verticalOffset = screenYpixels * 0.3;    
%     end
%     dstRect = CenterRectOnPointd([0 0 imageWidth imageHeight], mx, verticalOffset);
%     
%     % Draw the image
%     Screen('DrawTexture', w, SceneTexture, [], dstRect);
%     
%     
%     
%     
%     clear ObjectStim
%     ObjectStim = imread([paths.stimuli config.stimuli.stimlist.object{trl,1}{1,1}]);
%     ObjTexture = Screen('MakeTexture', w, ObjectStim);
%     
%     % Define size and position of the image
%     [imgH, imgW, ~] = size(Screen('GetImage', ObjTexture));
%     imageHeight = imgH * scaleFactor.objects;
%     imageWidth = imgW * scaleFactor.objects;
%     
% %     [s1, s2, ~] = size(ObjectStim);
% %     aspectRatio = s2 / s1;
% %     imageHeight = screenYpixels * 0.3 * scaleFactor.objects; 
% %     imageWidth = imageHeight * aspectRatio;
%     
%     % Adjust the vertical offset    
%     if MRIFlag == 1
%     relativeVerticalDistance = 1.2;
%     verticalOffset = crossY * relativeVerticalDistance;
% %     horizontalOffset = screenXpixels * 0.625;
%     horizontalOffset = screenXpixels * 0.375;   % object on the left
%     else
%     verticalOffset = screenYpixels * 0.65;
% %     horizontalOffset = screenXpixels * 0.625;
%     horizontalOffset = screenXpixels * 0.375;   % object on the left
%     end
%     
%     dstRect = CenterRectOnPointd([0 0 imageWidth imageHeight], horizontalOffset, verticalOffset);
%     
%     % Draw the image
%     Screen('DrawTexture', w, ObjTexture, [], dstRect);
%     
%     
%     [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
%     togc=togc+1; SOT_together(togc,1)=toc;
%     WaitSecs(config.timing.together/1000);
%     eventmarker = eventmarker+1;
%     results.presentation{eventmarker,1} = [config.stimuli.stimlist.scene{trl,1}{1,1} '_' config.stimuli.stimlist.object{trl,1}{1,1}];
%     
%     % ----------------------------------------------------------------- %



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
    
    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
    fixc=fixc+1; SOT_f1(fixc,1)=toc;
    
    WaitSecs(config.timing.fixation_ITI(trl))
    eventmarker = eventmarker+1;
    results.presentation{eventmarker,1} = '+';
        
    % ----------------------------------------------------------------- %


    % mid-save the things
    
    if MRIFlag==1
    dat.rcg.results.SOT.t0_standby_PTB = t0_standby;
    dat.rcg.results.SOT.t0_instruction_PTB = t0_inst;
    dat.rcg.results.SOT.trig1 = trigfirst;
    dat.rcg.results.SOT.trig5 = triglast;
    dat.rcg.results.SOT.t0_fix0 = t0_fix0_raw;
    dat.rcg.results.SOT.fixationX = SOT_f1;
    dat.rcg.results.SOT.scene = SOT_scene;
    dat.rcg.results.SOT.together = SOT_together;
    dat.rcg.results.SOT.RecognitionQ = SOT_rcgQ;
    dat.rcg.results.SOT.resp_RecognitionQ = SOT_resprcgQ;
    dat.rcg.results.SOT.ConfidenceQ = SOT_confQ;
    dat.rcg.results.SOT.resp_confidenceQ = SOT_respconfQ;
    
    dat.rcg.results.RT.RecognitionQ = RT_rcgQ;
    dat.rcg.results.RT.ConfidenceQ = RT_confQ;
    
    dat.rcg.results.accuracy = accuracies;
    dat.rcg.results.confidence = confidences;
    
    dat.rcg.results.keypress.recognition = keypress_recog;
    dat.rcg.results.keypress.confidence = keypress_conf;
    
    dat.rcg.results.presentationOrder = results.presentation;
    
    dat.rcg.results.codingInfo = 'confidence: 0=garnicht,1=etwas,2=ziemlich,3=sehr / recognition: 1=hit, -1=internalLure, 0=externalLure';
    
    dat.rcg.config.keymap = KbName('KeyNames');
    dat.rcg.config.stimlist = config.stimuli.stimlist;
    dat.rcg.config.timing  = config.timing;
    
    save([paths.behav 'tmp_' behavfilename],'dat')
    
    else
    dat.rcg.results.RT.RecognitionQ = RT_rcgQ;
    dat.rcg.results.RT.ConfidenceQ = RT_confQ;
    
    dat.rcg.results.accuracy = accuracies;
    dat.rcg.results.confidence = confidences;
    
    dat.rcg.results.presentationOrder = results.presentation;
    
    dat.rcg.results.codingInfo = 'confidence: 0=garnicht,1=etwas,2=ziemlich,3=sehr / recognition: 1=hit, -1=internalLure, 0=externalLure';
    
    dat.rcg.config.keymap = KbName('KeyNames');
    dat.rcg.config.stimlist = config.stimuli.stimlist;
    dat.rcg.config.timing  = config.timing;
    
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
sca; ShowCursor;

if MRIFlag==1
    dat.rcg.results.SOT.t0_standby_PTB = t0_standby;
    dat.rcg.results.SOT.t0_instruction_PTB = t0_inst;
    dat.rcg.results.SOT.firstprepulse = firstprepulse;
    dat.rcg.results.SOT.trig1 = trigfirst;
    dat.rcg.results.SOT.trig5 = triglast;
    dat.rcg.results.SOT.t0_fix0 = t0_fix0_raw;
    dat.rcg.results.SOT.fixationX = SOT_f1;
    dat.rcg.results.SOT.scene = SOT_scene;
    dat.rcg.results.SOT.together = SOT_together;
    dat.rcg.results.SOT.RecognitionQ = SOT_rcgQ;
    dat.rcg.results.SOT.resp_RecognitionQ = SOT_resprcgQ;
    dat.rcg.results.SOT.ConfidenceQ = SOT_confQ;
    dat.rcg.results.SOT.resp_confidenceQ = SOT_respconfQ;
    
    dat.rcg.results.RT.RecognitionQ = RT_rcgQ;
    dat.rcg.results.RT.ConfidenceQ = RT_confQ;
    
    dat.rcg.results.accuracy = accuracies;
    dat.rcg.results.confidence = confidences;
    
    dat.rcg.results.keypress.recognition = keypress_recog;
    dat.rcg.results.keypress.confidence = keypress_conf;
    
    dat.rcg.results.presentationOrder = results.presentation;
    
    dat.rcg.results.codingInfo = 'confidence: 0=garnicht,1=etwas,2=ziemlich,3=sehr / recognition: 1=hit, -1=internalLure, 0=externalLure';
    
    dat.rcg.config.keymap = KbName('KeyNames');
    dat.rcg.config.stimlist = config.stimuli.stimlist;
    dat.rcg.config.timing  = config.timing;
    
    save([paths.behav behavfilename],'dat')
    
else
    dat.rcg.results.RT.RecognitionQ = RT_rcgQ;
    dat.rcg.results.RT.ConfidenceQ = RT_confQ;
    
    dat.rcg.results.accuracy = accuracies;
    dat.rcg.results.confidence = confidences;
    
    dat.rcg.results.keypress.recognition = keypress_recog;
    dat.rcg.results.keypress.confidence = keypress_conf;
    
    dat.rcg.results.presentationOrder = results.presentation;
    
    dat.rcg.results.codingInfo = 'confidence: 0=garnicht,1=etwas,2=ziemlich,3=sehr / recognition: 1=hit, -1=internalLure, 0=externalLure';
    
    dat.rcg.config.keymap = KbName('KeyNames');
    dat.rcg.config.stimlist = config.stimuli.stimlist;
    dat.rcg.config.timing  = config.timing;
    
    save([paths.behav behavfilename],'dat')
    
end

disp('*********************************************')
disp('*********************************************')
disp('*********************************************')

fprintf(['BLOCK ' num2str(Block) ' Accuracy: %3.2f \n'], nanmean(accuracies))

disp('*********************************************')
disp('*********************************************')
disp('*********************************************')


% % Close textures
% Screen('Close', texture);

% Close the screensssaa
Screen('CloseAll');
disp('*********************************************')
disp('******* the end of the encoding phase *******')

disp(datetime)

diary off;

end
