%% autobiographical memory test
% 
%  In emergency contact Alex:
%              +49 162 713 20 49
%              yeo-jin.yi.15@ucl.ac.uk

%% work log

%   05_03_2024      created the scripts


%%
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % %-------------------------sssssssssssssssssssssss---------------------------------------------
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % %                ssssssssssssssssssssssssss   stay on this field before starting the task
% % % ---------------------------
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% %
% %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------
% % %----------------------------------------------------------------------

%% experiment preparation

clear all; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       how many pre-pulses?        %

prepulse = 1; % debugging
% prepulse = 1152; % if we're using the 96-slice fMRI
% prepulse = 1128; % if we're using the 94-slice fMRI

% or you can write down manually too, if it's anything else!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

taskpath       = 'C:/Users/Presentation/Documents/ENGRAMS/';
savepath_behav = [taskpath 'data/behav/'];
logpath        = [taskpath 'data/logs/'];
stimpath       = [taskpath 'autobio/stim/'];
addpath(genpath([taskpath 'scripts']))

% enter experiment details
input_prompt = {'ID (e.g. 4001)';'MRI (1 = yes, 0 = no)'};
defaults     = {'9999','1'};
input_answer = inputdlg(input_prompt, 'Input experiment details. NO SPACES!', 1, defaults);

ID           = str2num(input_answer{1,1});
MRIFlag      = str2num(input_answer{2,1});


%% set up the experiment

sca % close any open Psychtoolbox windows

% temp settings
path_ECHO      = taskpath;
PrePulse       = prepulse;

behavfilename  = [num2str(ID) '_autobio.mat'];

% set paths
paths.parent   = path_ECHO;
paths.stimuli  = stimpath;
paths.stimlist = [paths.parent 'autobio/'];
paths.bg       = paths.parent;
paths.behav    = [paths.parent 'data/behav/'];
paths.logs     = [paths.parent 'data/logs/'];

addpath(genpath([paths.parent 'scripts']))

if exist(strcat(paths.logs, num2str(ID), '_autobio_log_', string(date), '.txt')) == 2
    K=string(datestr(now));
    try
        diary(strcat(paths.logs, num2str(ID), '_autobio_log_', string(date),'_',K{1}(end-1:end),'.txt'))
    catch
        diary(strcat(paths.logs, num2str(ID), '_autobio_log_', string(date),'_',K(end-1:end),'.txt'))
    end
else
    diary(strcat(paths.logs, num2str(ID), '_autobio_log_', string(date), '.txt'))
end

disp(strcat('ENGRAMS AUTOBIOGRAPHICAL MEMORY TASK ', string(datetime)))

% create the data structure
cd(paths.behav)
if exist(behavfilename) == 2
    load([paths.behav behavfilename])
else
    dat = [];
    dat.ID  = ID;
    dat.auto = [];
end

% scanner preparation
if MRIFlag == 1
    dat.auto.mri          = [];
    dat.auto.mri.scanPort = 1;
    dat.auto.mri.dummy    = PrePulse+5        % no. of dummy vols
    dat.auto.mri.nslice   = 96;       % no. of slices
    dat.auto.mri.TE       = 25;       % time for each slice in msec
    dat.auto.mri.TR       = 2.5;     % MRIinfo.nslice * MRIinfo.TE/1000; % time for volume in msec
end

disp('environment prepared')
disp(['subject ID ' num2str(ID) ', autobiographical memory'])


%% define parameters


rng('shuffle'); % prepare for true randomisation

config = [];

% ======== stimuli information ======== %

config.stimuli.numtrials.total = 36;
config.stimuli.numtrials.am    = 18;
config.stimuli.numtrials.ma    = 18;

v = 1:config.stimuli.numtrials.am;
rI = randperm(length(v));
rV = v(rI);

clear amtmp matmp
amtmp = readtable([paths.stimlist 'stimlist_autobio.xlsx']); amtmp=amtmp(rV,:); am=amtmp(1:config.stimuli.numtrials.am,:);
matmp = randi([1, 99], config.stimuli.numtrials.ma, 2); ma=num2cell([matmp sum(matmp,2)]);

stimlist_orig=[table2cell(amtmp);ma];

v = 1:config.stimuli.numtrials.total;
randomIndex = randperm(length(v));
randomizedVector = v(randomIndex);

config.stimuli.stimlist             = stimlist_orig(randomizedVector,:);

config.stimuli.scaleFactor.word     = 0.9;
config.stimuli.scaleFactor.QnA      = 0.8;

scaleFactor.word = config.stimuli.scaleFactor.word;
scaleFactor.QnA = config.stimuli.scaleFactor.QnA;

% ================================= %


% ======== timing information ======== %

rng('shuffle'); % shuffle again
config.timing.fixation = randi([10, 40], 60, 1) * 100;%eval(['cell2mat(RET17T_' num2str(BlockNum) '(:,5)).*1000']);
config.timing.intermission = [randi([10, 15], 60, 1) * 100, randi([5, 10], 60, 1) * 100];%eval(['cell2mat(RET17T_' num2str(BlockNum) '(:,5)).*1000']);
config.timing.word    = 2000;
config.timing.ratings = 3000;
config.timing.memory  = 8000;
config.timing.maxlength = 10000;

% ================================= %

%% Set up Psychtoolbox

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

try
    % Initialize screen
    screens=Screen('Screens'); % this should be one, which is the main screen that you're looking at
    screenNumber=screens(2);%max(screens);
    
    oldRes=SetResolution(0,1280,720); % at 7T, only this resolution works
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, [0 0 0]);
    
    ListenChar(2) ; % suppress keyboard input to Matlab windows
%     HideCursor; % Hide the mouse cursor:

    [screenXpixels, screenYpixels] = Screen('WindowSize', w);
    [mx, my] = RectCenter(wRect);
    W=wRect(3); H=wRect(4);
    
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    
    Screen('TextFont',w,'Arial');
    Screen('TextSize',w,17);
    
    
    % ---------- Load the instruction text ---------- %
    
    greencircle = imread([stimpath 'autobio_instruction.png']);
    
    % Create a texture from the image
    tex=Screen('MakeTexture', w, greencircle);
    
    [imageHeight, imageWidth, ~] = size(greencircle);
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
        opinfo = imread([stimpath 'operator_hail.bmp']);
        % Create a texture from the image
        tex=Screen('MakeTexture', w, opinfo);
        Screen('DrawTexture', w, tex);
        
        [VBLTimestamp, ~, FlipTimestamp]=Screen('Flip', w);
        
        [rsp] = getKeys(KbName('space'),Inf);
        
        WaitSecs(0.2);
        
        % start the dummy scan
        clear tex
        standby = imread([stimpath 'standby.bmp']);
        
        % Create a texture from the image
        tex=Screen('MakeTexture', w, standby);
        [imageHeight, imageWidth, ~] = size(greencircle);
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
        while numTriggers < dat.auto.mri.dummy
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
        
        % draw the first fixation
        
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
        
        WaitSecs(dat.auto.mri.TR);
        
        
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
    i = 0; fix1c = 0; fix2c=0; wordcuec = 0; mathQc=0; togc = 0; autoQc = 0; memQc = 0; resp1c = 0; memoryresp2c = 0;
    memoryc=0; mathsolvec=0; mathRQc=0; mathRatingresp2c=0;
    SOT_f1=[]; SOT_f2=[]; SOT_mathQ=[]; SOT_wordcue = []; SOT_memQ =[]; SOT_respmemoryQ = [];
    memoryQ=[]; RT_mathQ=[]; RT_mathFQ = []; SOT_mathRQ=[]; SOT_respmathRQ=[]; SOT_mathResp=[];
    memoryratings=[]; keypress_memoryrating=[];
    dat.auto.results = []; RT_mathF=[];
    
    for trl = 1:config.stimuli.numtrials.total
        
        % ================ fix cross ================ %
        
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
        
        [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs(config.timing.fixation(trl)/1000)
        fix1c=fix1c+1; SOT_f1(fix1c,1)=toc;
        
        % ============================================= %
        
        
        % ================ conditions ================= %
        
        if strcmp(config.stimuli.stimlist{trl,2},'AM') == 1
            
            %%%%%%%%% present word cue
            WordCue = imread([paths.stimuli config.stimuli.stimlist{trl,3} '.jpg']);
            WordTexture = Screen('MakeTexture', w, WordCue);
            
            WordProceed = imread([paths.stimuli 'autobio_memoryQ.png']);
            WordProceedTexture = Screen('MakeTexture', w, WordProceed);
                       
            if MRIFlag == 1
                verticalOffset = 0.65;
            else
                verticalOffset = 0.37;
            end
            WordRectUp = [screenXpixels / 2 - size(WordCue, 2) / 2, screenYpixels * verticalOffset - size(WordCue, 1) / 2, screenXpixels / 2 + size(WordCue, 2) / 2, screenYpixels * verticalOffset + size(WordCue, 1) / 2];
            Screen('DrawTexture', w, WordTexture, [], WordRectUp);
            
%             [imageHeight, imageWidth, ~] = size(WordCue);
%             if MRIFlag == 1
%                 destX = (screenXpixels - imageWidth) / 2;  % Center the image horizontally
%                 destY = (3 * screenYpixels / 4) - imageHeight;%screenYpixels - imageHeight + 0.6 ;       % Position the image at the bottom
%             else
%                 destX = (screenXpixels - imageWidth) / 2;  % Center the image horizontally
%                 destY = (screenYpixels - imageHeight) / 2; % Center the image vertically
%             end
%             destRect = [destX, destY, destX + imageWidth, destY + imageHeight]; % Define the destination rectangle
%             
%             % Draw the word cue
%             Screen('DrawTexture', w, WordTexture, [], destRect);
%             
            % Create a texture from the image
            if MRIFlag == 1
                verticalOffset = 0.81;
            else
                verticalOffset = 0.6;
            end
            WordProceedRectUp = [screenXpixels / 2 - size(WordProceed, 2) / 2, screenYpixels * verticalOffset - size(WordProceed, 1) / 2, screenXpixels / 2 + size(WordProceed, 2) / 2, screenYpixels * verticalOffset + size(WordProceed, 1) / 2];
            Screen('DrawTexture', w, WordProceedTexture, [], WordProceedRectUp);

            [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w);
            wordcuec=wordcuec+1; SOT_wordcue(wordcuec,1)=toc;
            eventmarker = eventmarker+1;
            results.presentation{eventmarker,1} = config.stimuli.stimlist{trl,3};
            
            [rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],Inf);
            
            
            %%%%%%%%%%% present a green circle
            greencircle = imread([paths.stimuli 'GreenCircle.png']);
            
            % Create a texture from the image
            tex=Screen('MakeTexture', w, greencircle);
            
            [imageHeight, imageWidth, ~] = size(greencircle);
            if MRIFlag == 1
                destX = (screenXpixels - imageWidth) / 2;  % Center the image horizontally
                destY = (3 * screenYpixels / 4) - imageHeight;       % Position the image at the bottom
            else
                destX = (screenXpixels - imageWidth) / 2;  % Center the image horizontally
                destY = (screenYpixels - imageHeight) / 2; % Center the image vertically
            end
            destRect = [destX, destY, destX + imageWidth, destY + imageHeight]; % Define the destination rectangle
            
            % Draw the texture
            Screen('DrawTexture', w, tex, [], destRect);
            [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs(config.timing.memory/1000);
            memoryc=memoryc+1; SOT_memory(memoryc,1)=toc;
            eventmarker = eventmarker+1;
            results.presentation{eventmarker,1} = 'autobiographical memory block';
            
            
            
            %%%%%%%%%% intermediate fixation cross
            % a littel smaller
            crossSize = 5;
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
            
            [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs(1)
            fix2c=fix2c+1; SOT_f2(fix2c,1)=toc;
            eventmarker = eventmarker+1;
            results.presentation{eventmarker,1} = 'dot';
            
            
            % =============== question screen =============== %
            
            % Draw the question
            img_memoryratingQ       = imread([paths.stimuli 'autobio_memoryQ_rating.jpg']);
            
            img_faint               = imread([paths.stimuli 'faint.jpg']);
            img_vague               = imread([paths.stimuli 'vague.jpg']);
            img_clear               = imread([paths.stimuli 'clear.jpg']);
            img_vivid               = imread([paths.stimuli 'vivid.jpg']);
            
            memratingQtex           = Screen('MakeTexture', w, img_memoryratingQ);
            fainttex                = Screen('MakeTexture', w, img_faint);
            vaguetex                = Screen('MakeTexture', w, img_vague);
            cleartex                = Screen('MakeTexture', w, img_clear);
            vividtex                = Screen('MakeTexture', w, img_vivid);
            
            % Define the starting x position for the question image
            if MRIFlag == 1
                verticalOffset = 0.7;
            else
                verticalOffset = 0.37;
            end
            questionDestRectUp = [screenXpixels / 2 - size(img_memoryratingQ, 2) / 2, screenYpixels * verticalOffset - size(img_memoryratingQ, 1) / 2, screenXpixels / 2 + size(img_memoryratingQ, 2) / 2, screenYpixels * verticalOffset + size(img_memoryratingQ, 1) / 2];
            Screen('DrawTexture', w, memratingQtex, [], questionDestRectUp);
            %     questionDestRectUp = [screenXpixels / 2 - size(img_confQ, 2) / 2, screenYpixels * 0.325 - size(img_confQ, 1) / 2, screenXpixels / 2 + size(img_confQ, 2) / 2, screenYpixels * 0.325 + size(img_confQ, 1) / 2];
            %     Screen('DrawTexture', w, autoQtex, [], questionDestRectUp);
            
            % Define spacing between the option images
            optionSpacing = 50; % Adjust this value to increase or decrease the space between images
            
            % Calculate the total width of the option images including spacing
            optionTextures = [fainttex, vaguetex, cleartex, vividtex];
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
            
            [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); tmp = toc;
            memQc=memQc+1; SOT_memQ(memQc,1)=toc;
            eventmarker = eventmarker+1;
            results.presentation{eventmarker,1} = 'memoryRating';
            
            [rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],config.timing.ratings/1000); tmp = toc;
            
            % RT
            if ~isstruct(rsp) %if they didn't press anything
                response1 = NaN; % mark their response as nan
                keypress1 = NaN;
                rt1 = NaN; % mark their reaction time as nan
                
                memoryQ(trl,1) = NaN;
                RT_memoryQ(trl,1) = NaN;
                
                mathRQ(trl,1) = NaN;
                mathsolvedfirst(trl,1) = NaN;
                mathsolvedf{trl,1} = NaN;
                mentalarithmeticfirst(trl,1)=NaN;
                mentalarithmeticFollowup{trl,1}=NaN;
                keypress_mathrating(trl,1)=NaN;
                mathRQ(trl,1) = NaN;
                RT_mathQ(trl,1) = NaN;
                RT_mathRQ(trl,1) = NaN;

                WaitSecs(0);
                
                memoryratings(trl,1)=NaN;
                keypress_memoryrating(trl,1)=NaN;
                
            elseif isstruct(rsp) % otherwise
                
                mathRQ(trl,1) = NaN;
                mathsolvedfirst(trl,1) = NaN;
                mentalarithmeticfirst(trl,1)=NaN;
                RT_mathQ(trl,1) = NaN;
                RT_mathRQ(trl,1) = NaN;
                
                response1 = KbName(rsp.keyName); % their response is whatever key they pressed.
                keypress1 = rsp.keyName;
                fprintf(['\nkey pressed: %d \n'],KbName(rsp.keyName))
                
                if response1==FarLeftKey
                    memoryQ(trl,1) = 0;
                elseif response1==MiddleLeftKey
                    memoryQ(trl,1) = 1;
                elseif response1==MiddleRightKey
                    memoryQ(trl,1) = 2;
                elseif response1==FarRightKey
                    memoryQ(trl,1) = 3;
                else
                    warning('unknown key pressed')
                    KbName(rsp.keyName);
                end
                
                rt1 = rsp.RT; % and their reaction time is the time they pressed the button-the time the stimulus apprered
                RT_memoryQ(trl,1) = rt1;
                memoryresp2c=memoryresp2c+1; SOT_respmemoryQ(memoryresp2c,1) = tmp+rt1;
                clear tmp
                
                % record confidence ratings
                memoryratings(trl,1)=memoryQ(trl,1);
                
                % record keypress
                keypress_memoryrating(trl,1)=keypress1;
                
                img_ok   = imread([paths.stimuli 'received.png']);
                oktex    = Screen('MakeTexture', w, img_ok);
                if MRIFlag == 1
                    verticalOffset = 0.7;
                    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
                else
                    verticalOffset = 0.37;
                    questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
                end
                Screen('DrawTexture', w, oktex, [], questionDestRectUp);
                
                fainttex        = Screen('MakeTexture', w, img_faint);
                vaguetex        = Screen('MakeTexture', w, img_vague);
                cleartex        = Screen('MakeTexture', w, img_clear);
                vividtex        = Screen('MakeTexture', w, img_vivid);
                
                % Define spacing between the option images
                optionSpacing = 50; % Adjust this value to increase or decrease the space between images
                
                % Calculate the total width of the option images including spacing
                optionTextures = [fainttex, vaguetex, cleartex, vividtex];
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
                
                [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs((config.timing.ratings/1000)-(rt1/1000));
                
            end
            
            
        else
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Present arithmetic problem
            
            % Draw the question
            img_mathQ           = imread([paths.stimuli 'autobio_mathQ.png']);
            mathQtex            = Screen('MakeTexture', w, img_mathQ);
            
            % Define the starting x position for the question image
            if MRIFlag == 1
                verticalOffset = 0.8;
            else
                verticalOffset = 0.37;
            end
            questionDestRectUp = [screenXpixels / 2 - size(img_mathQ, 2) / 2, screenYpixels * verticalOffset - size(img_mathQ, 1) / 2, screenXpixels / 2 + size(img_mathQ, 2) / 2, screenYpixels * verticalOffset + size(img_mathQ, 1) / 2];
            Screen('DrawTexture', w, mathQtex, [], questionDestRectUp);
            
            
            if MRIFlag == 1
                verticalPosition2 = screenYpixels * 0.75; % Adjust this value for the bottom half of the screen
            else
                verticalPosition2 = screenYpixels * 0.685; % Adjust this value for the bottom half of the screen
            end
            
            mathProblem = [ num2str(config.stimuli.stimlist{trl,1}) ' + ' num2str(config.stimuli.stimlist{trl,2})]; % Example problem, replace with actual problems
            DrawFormattedText(w, mathProblem, 'center', verticalPosition2, white);
            
            [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); tmp = toc;
            mathQc=mathQc+1; SOT_mathQ(mathQc,1)=toc;
            eventmarker = eventmarker+1;
            results.presentation{eventmarker,1} = 'mentalarithmetic_0';
            
            [rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],10); tmp = toc;
            
            %%%%%%%%%% intermediate fixation cross
            % a littel smaller
            crossSize = 5;
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
            
            [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs(0.5)
            
            if ~isstruct(rsp) %if they didn't press anything
                response2 = NaN; % mark their response as nan
                keypress2 = NaN;
                rt2 = NaN; % mark their reaction time as nan
                
                memoryQ(trl,1) = NaN;
                RT_memoryQ(trl,1) = NaN;
                memoryratings(trl,1)=NaN;
                keypress_memoryrating(trl,1)=NaN;
                
                mathRQ(trl,1) = NaN;
                mathsolvedfirst(trl,1) = NaN;
                mentalarithmeticfirst(trl,1)=NaN;
                RT_mathQ(trl,1) = NaN;
                RT_mathRQ(trl,1) = NaN;
                
                WaitSecs(0);
                
            elseif isstruct(rsp) % otherwise
                
                memoryQ(trl,1) = NaN;
                RT_memoryQ(trl,1) = NaN;
                memoryratings(trl,1)=NaN;
                memoryratings(trl,1)=NaN;
                keypress_memoryrating(trl,1)=NaN;
                
                clear timeleft
                timeleft = (config.timing.maxlength/1000) - rsp.RT;
                
                response2 = KbName(rsp.keyName); % their response is whatever key they pressed.
                keypress2 = rsp.keyName;
                fprintf(['\nkey pressed: %d \n'],KbName(rsp.keyName))
                
                if response2==FarLeftKey
                    mathsolvedfirst(trl,1) = 1;
                elseif response2==MiddleLeftKey
                    mathsolvedfirst(trl,1) = 1;
                elseif response2==MiddleRightKey
                    mathsolvedfirst(trl,1) = 1;
                elseif response2==FarRightKey
                    mathsolvedfirst(trl,1) = 1;
                else
                    warning('unknown key pressed')
                    KbName(rsp.keyName);
                end
                
                rt2 = rsp.RT; % and their reaction time is the time they pressed the button-the time the stimulus apprered
                RT_mathQ(trl,1) = rt2;
                mathsolvec=mathsolvec+1; SOT_mathResp(mathsolvec,1) = tmp+rt2;
                clear tmp
                
                % record confidence ratings
                mentalarithmeticfirst(trl,1)=mathsolvedfirst(trl,1);
                
                % record keypress
                keypress_mathQ(trl,1)=keypress2;
                
                followupcount=0;
                startTime = GetSecs(); maxDuration = timeleft;
                % start the loop of maths
                while GetSecs() - startTime < maxDuration
                    
                    % Draw the question
                    img_mathfollow = imread([paths.stimuli 'autobio_mathQ_followup.png']);
                    mathfollowtex  = Screen('MakeTexture', w, img_mathfollow);
                    
                    % Define the starting x position for the question image
                    if MRIFlag == 1
                        verticalOffset = 0.75;
                    else
                        verticalOffset = 0.37;
                    end
                    questionDestRectUp = [screenXpixels / 2 - size(img_mathfollow, 2) / 2, screenYpixels * verticalOffset - size(img_mathfollow, 1) / 2, screenXpixels / 2 + size(img_mathfollow, 2) / 2, screenYpixels * verticalOffset + size(img_mathfollow, 1) / 2];
                    Screen('DrawTexture', w, mathfollowtex, [], questionDestRectUp);
                    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); tmp = toc;
                    eventmarker = eventmarker+1;
                    results.presentation{eventmarker,1} = 'mentalarithmetic_+';
                    
                    clear remainingTime
                    remainingTime = maxDuration - (GetSecs() - startTime);
                    [rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],remainingTime); tmp = toc;
                    
                    if ~isstruct(rsp) %if they didn't press anything
                        
                        followupcount=followupcount+1;
                        
                        response3 = NaN; % mark their response as nan
                        keypress3 = NaN;
                        rt3 = NaN; % mark their reaction time as nan
                        mathsolvedf{trl,followupcount} = NaN;
                        RT_mathF{trl,followupcount} = NaN;
                        
                        mentalarithmeticFollowup{trl,followupcount}=NaN;
                        keypress_mathF{trl,followupcount}=NaN;
                        
                        WaitSecs(0);
                        
                    elseif isstruct(rsp) % otherwise 
                        timeleft = timeleft - rsp.RT;
                        followupcount=followupcount+1;
                        
                        response3 = KbName(rsp.keyName); % their response is whatever key they pressed.
                        keypress3 = rsp.keyName;
                        fprintf(['\nkey pressed: %d \n'],KbName(rsp.keyName))
                        
                        if response3==FarLeftKey
                            mathsolvedf{trl,followupcount} = 1;
                        elseif response3==MiddleLeftKey
                            mathsolvedf{trl,followupcount} = 1;
                        elseif response3==MiddleRightKey
                            mathsolvedf{trl,followupcount} = 1;
                        elseif response3==FarRightKey
                            mathsolvedf{trl,followupcount} = 1;
                        else
                            warning('unknown key pressed')
                            KbName(rsp.keyName);
                        end
                        
                        rt3 = rsp.RT; % and their reaction time is the time they pressed the button-the time the stimulus apprered
                        RT_mathFQ{trl,followupcount} = rt3;
                        mathsolvec=mathsolvec+1; SOT_mathResp(mathsolvec,1) = tmp+rt3;
                        clear tmp
                        
                        % record confidence ratings
                        mentalarithmeticFollowup{trl,followupcount}=mathsolvedf{trl,followupcount};
                        
                        % record keypress
                        keypress_mathQF(trl,followupcount)=keypress3;
                        
                        
                        %%%%%%%%%% intermediate fixation cross
                        % a littel smaller
                        crossSize = 5;
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
                        
                        [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs(0.2)
                    end
                    
                end
                
                % now ratings
                
                %%%%%%%%%% intermediate fixation cross
                % a littel smaller
                crossSize = 5;
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
                
                [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs(0.8)
                
                
                % =============== question screen =============== %
                
                % Draw the question
                img_mathratingQ       = imread([paths.stimuli 'autobio_mathQ_rating.png']);
                
                img_veasy               = imread([paths.stimuli 'veryeasy.jpg']);
                img_easy               = imread([paths.stimuli 'easy.jpg']);
                img_quitediff               = imread([paths.stimuli 'quitedifficult.jpg']);
                img_vdiff               = imread([paths.stimuli 'verydifficult.jpg']);
                
                memratingQtex           = Screen('MakeTexture', w, img_mathratingQ);
                veasytex                = Screen('MakeTexture', w, img_veasy);
                easytex                = Screen('MakeTexture', w, img_easy);
                quitedifftex                = Screen('MakeTexture', w, img_quitediff);
                vdifftex                = Screen('MakeTexture', w, img_vdiff);
                
                % Define the starting x position for the question image
                if MRIFlag == 1
                    verticalOffset = 0.65;
                else
                    verticalOffset = 0.37;
                end
                questionDestRectUp = [screenXpixels / 2 - size(img_mathratingQ, 2) / 2, screenYpixels * verticalOffset - size(img_mathratingQ, 1) / 2, screenXpixels / 2 + size(img_mathratingQ, 2) / 2, screenYpixels * verticalOffset + size(img_mathratingQ, 1) / 2];
                Screen('DrawTexture', w, memratingQtex, [], questionDestRectUp);
                %     questionDestRectUp = [screenXpixels / 2 - size(img_confQ, 2) / 2, screenYpixels * 0.325 - size(img_confQ, 1) / 2, screenXpixels / 2 + size(img_confQ, 2) / 2, screenYpixels * 0.325 + size(img_confQ, 1) / 2];
                %     Screen('DrawTexture', w, autoQtex, [], questionDestRectUp);
                
                % Define spacing between the option images
                optionSpacing = 50; % Adjust this value to increase or decrease the space between images
                
                % Calculate the total width of the option images including spacing
                optionTextures = [veasytex, easytex, quitedifftex, vdifftex];
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
                
                [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); tmp = toc;
                mathRQc=mathRQc+1; SOT_mathRQ(mathRQc,1)=toc;
                eventmarker = eventmarker+1;
                results.presentation{eventmarker,1} = 'mathRating';
                
                [rsp] = getKeys([FarLeftKey,MiddleLeftKey,MiddleRightKey,FarRightKey],config.timing.ratings/1000); tmp = toc;
                
                % RT
                if ~isstruct(rsp)%~isstruct(rsp) %if they didn't press anything
                    response4 = NaN; % mark their response as nan
                    keypress4 = NaN;
                    rt4 = NaN; % mark their reaction time as nan
                    WaitSecs(0);
                    mathRQ(trl,1) = NaN;
                    RT_mathRQ(trl,1) = NaN;
                    
                    % record confidence ratings
                    mathratings(trl,1)=NaN;
                    
                    % record keypress
                    keypress_mathrating(trl,1)=NaN;
                    
                elseif isstruct(rsp) % otherwise
                    response4 = KbName(rsp.keyName); % their response is whatever key they pressed.
                    keypress4 = rsp.keyName;
                    fprintf(['\nkey pressed: %d \n'],KbName(rsp.keyName))
                    
                    if response4==FarLeftKey
                        mathRQ(trl,1) = 0;
                    elseif response4==MiddleLeftKey
                        mathRQ(trl,1) = 1;
                    elseif response4==MiddleRightKey
                        mathRQ(trl,1) = 2;
                    elseif response4==FarRightKey
                        mathRQ(trl,1) = 3;
                    else
                        warning('unknown key pressed')
                        KbName(rsp.keyName);
                    end
                    
                    rt4 = rsp.RT; % and their reaction time is the time they pressed the button-the time the stimulus apprered
                    RT_mathRQ(trl,1) = rt4;
                    mathRatingresp2c=mathRatingresp2c+1; SOT_respmathRQ(mathRatingresp2c,1) = tmp+rt4;
                    clear tmp
                    
                    % record confidence ratings
                    mathratings(trl,1)=mathRQ(trl,1);
                    
                    % record keypress
                    keypress_mathrating(trl,1)=keypress4;
                    
                    img_ok   = imread([paths.stimuli 'received.png']);
                    oktex    = Screen('MakeTexture', w, img_ok);
                    if MRIFlag == 1
                        verticalOffset = 0.65;
                        questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
                    else
                        verticalOffset = 0.37;
                        questionDestRectUp = [screenXpixels / 2 - size(img_ok, 2) / 2, screenYpixels * verticalOffset - size(img_ok, 1) / 2, screenXpixels / 2 + size(img_ok, 2) / 2, screenYpixels * verticalOffset + size(img_ok, 1) / 2];
                    end
                    Screen('DrawTexture', w, oktex, [], questionDestRectUp);
                    
                    veasytex        = Screen('MakeTexture', w, img_veasy);
                    easytex        = Screen('MakeTexture', w, img_easy);
                    quitedifftex        = Screen('MakeTexture', w, img_quitediff);
                    vdifftex        = Screen('MakeTexture', w, img_vdiff);
                    
                    % Define spacing between the option images
                    optionSpacing = 50; % Adjust this value to increase or decrease the space between images
                    
                    % Calculate the total width of the option images including spacing
                    optionTextures = [veasytex, easytex, quitedifftex, vdifftex];
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
                    
                    [VBLTimestamp, stimOnsetTime, FlipTimestamp]=Screen('Flip', w); WaitSecs((config.timing.ratings/1000)-(rt4/1000));
                    
                end
                
                
            end
            
            
            
            
        end
        
        
        % mid-save the things
        
        if MRIFlag==1
            dat.auto.results.SOT.t0_standby_PTB = t0_standby;
            dat.auto.results.SOT.t0_instruction_PTB = t0_inst;
            dat.auto.results.SOT.trig1 = trigfirst;
            dat.auto.results.SOT.trig5 = triglast;
            dat.auto.results.SOT.t0_fix0 = t0_fix0_raw;
            
            dat.auto.results.SOT.fixationX = SOT_f1;
            try
            dat.auto.results.SOT.AMstart = SOT_memory;
            dat.auto.results.SOT.AMend = SOT_f2;
            dat.auto.results.SOT.AMcue = SOT_wordcue;
            dat.auto.results.SOT.AMrating = SOT_memQ;
            dat.auto.results.SOT.AMratingresp = SOT_respmemoryQ;
            catch
            end
            
            try
            dat.auto.results.SOT.MAstart = SOT_mathQ;
            dat.auto.results.SOT.MAsolved = SOT_mathResp;
            dat.auto.results.SOT.MAend = SOT_mathRQ-1;
            dat.auto.results.SOT.MArating = SOT_mathRQ;
            dat.auto.results.SOT.MAratingresp = SOT_respmathRQ;
            catch
            end
            
            try
            dat.auto.results.AM.RT = RT_memoryQ;
            dat.auto.results.AM.ratings = memoryratings;
            catch
            end
            
            try
            dat.auto.results.MA.RT_initial = RT_mathQ;
            dat.auto.results.MA.RT_followup = RT_mathF;
            dat.auto.results.MA.ratings = mathRQ;
            dat.auto.results.MA.solved_initial = mentalarithmeticfirst;
            dat.auto.results.MA.solved_followup = mentalarithmeticFollowup;
            catch
            end
            
            try
            dat.auto.results.keypress.AMratings = keypress_memoryrating;
            catch
            end
            try
            dat.auto.results.keypress.MAratings = keypress_mathrating;
            catch
            end
            
            dat.auto.results.presentationOrder = results.presentation;
            
            dat.auto.results.codingInfo = 'AMratings: 0=faint,1=vague,2=clear,3=vivid / MAratings:  0=very easy,1=easy,2=quite difficult,3=very difficult ';
            
            dat.auto.config.keymap = KbName('KeyNames');
            dat.auto.config.stimlist = config.stimuli.stimlist;
            dat.auto.config.timing = config.timing;
            
            save([paths.behav 'tmp_' behavfilename],'dat')
            
        else
            
            dat.auto.results.AM.RT = RT_memoryQ;
            dat.auto.results.AM.ratings = memoryratings;
            
            dat.auto.results.MA.RT_initial = RT_mathQ;
            dat.auto.results.MA.RT_followup = RT_mathF;
            dat.auto.results.MA.ratings = mathRQ;
            dat.auto.results.MA.solved_initial = mentalarithmeticfirst;
            dat.auto.results.MA.solved_followup = mentalarithmeticFollowup;
            
            dat.auto.results.keypress.AMratings = keypress_memoryrating;
            dat.auto.results.keypress.MAratings = keypress_mathrating;
            
            dat.auto.results.presentationOrder = results.presentation;
            
            dat.auto.results.codingInfo = 'AMratings: 0=faint,1=vague,2=clear,3=vivid / MAratings:  0=very easy,1=easy,2=quite difficult,3=very difficult ';
            
            dat.auto.config.keymap = KbName('KeyNames');
            dat.auto.config.stimlist = config.stimuli.stimlist;
            dat.auto.config.timing = config.timing;
            
            save([paths.behav 'tmp_' behavfilename],'dat')
            
        end
        
        
    end
    
    
    if MRIFlag==1
        dat.auto.results.SOT.t0_standby_PTB = t0_standby;
        dat.auto.results.SOT.t0_instruction_PTB = t0_inst;
        dat.auto.results.SOT.trig1 = trigfirst;
        dat.auto.results.SOT.trig5 = triglast;
        dat.auto.results.SOT.t0_fix0 = t0_fix0_raw;
        dat.auto.results.SOT.firstprepulse = firstprepulse;
        
        dat.auto.results.SOT.fixationX = SOT_f1;
        dat.auto.results.SOT.AMstart = SOT_memory;
        dat.auto.results.SOT.AMend = SOT_f2;
        dat.auto.results.SOT.AMcue = SOT_wordcue;
        dat.auto.results.SOT.AMrating = SOT_memQ;
        dat.auto.results.SOT.AMratingresp = SOT_respmemoryQ;
        
        dat.auto.results.SOT.MAstart = SOT_mathQ;
        dat.auto.results.SOT.MAsolved = SOT_mathResp;
        dat.auto.results.SOT.MAend = SOT_mathRQ-1;
        dat.auto.results.SOT.MArating = SOT_mathRQ;
        dat.auto.results.SOT.MAratingresp = SOT_respmathRQ;
        
        dat.auto.results.AM.RT = RT_memoryQ;
        dat.auto.results.AM.ratings = memoryratings;
        
        dat.auto.results.MA.RT_initial = RT_mathQ;
        dat.auto.results.MA.RT_followup = RT_mathF;
        dat.auto.results.MA.ratings = mathRQ;
        dat.auto.results.MA.solved_initial = mentalarithmeticfirst;
        dat.auto.results.MA.solved_followup = mentalarithmeticFollowup;
        
        dat.auto.results.keypress.AMratings = keypress_memoryrating;
        dat.auto.results.keypress.MAratings = keypress_mathrating;
        
        dat.auto.results.presentationOrder = results.presentation;
        
        dat.auto.results.codingInfo = 'AMratings: 0=faint,1=vague,2=clear,3=vivid / MAratings:  0=very easy,1=easy,2=quite difficult,3=very difficult ';
        
        dat.auto.config.keymap = KbName('KeyNames');
        dat.auto.config.stimlist = config.stimuli.stimlist;
        dat.auto.config.timing = config.timing;
        
        save([paths.behav behavfilename],'dat')
        
    else
        
        dat.auto.results.AM.RT = RT_memoryQ;
        dat.auto.results.AM.ratings = memoryratings;
        
        dat.auto.results.MA.RT_initial = RT_mathQ;
        dat.auto.results.MA.RT_followup = RT_mathF;
        dat.auto.results.MA.ratings = mathRQ;
        dat.auto.results.MA.solved_initial = mentalarithmeticfirst;
        dat.auto.results.MA.solved_followup = mentalarithmeticFollowup;
        
        dat.auto.results.keypress.AMratings = keypress_memoryrating;
        dat.auto.results.keypress.MAratings = keypress_mathrating;
        
        dat.auto.results.presentationOrder = results.presentation;
        
        dat.auto.results.codingInfo = 'AMratings: 0=faint,1=vague,2=clear,3=vivid / MAratings:  0=very easy,1=easy,2=quite difficult,3=very difficult ';
        
        dat.auto.config.keymap = KbName('KeyNames');
        dat.auto.config.stimlist = config.stimuli.stimlist;
        dat.auto.config.timing = config.timing;
        
        save([paths.behav behavfilename],'dat')
        
    end
    
    
    % End of task
    thankYou = 'Thank you for participating!';
    DrawFormattedText(w, thankYou, 'center', verticalPosition2, white);
    Screen('Flip', w);
    WaitSecs(2);

    % Close screen
    sca;
    
catch
    sca;
    psychrethrow(psychlasterror);
end
