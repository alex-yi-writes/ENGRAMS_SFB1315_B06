#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v2023.1.3),
    on April 10, 2024, at 13:02
If you publish work using this script the most relevant publication is:

    Peirce J, Gray JR, Simpson S, MacAskill M, Höchenberger R, Sogo H, Kastman E, Lindeløv JK. (2019) 
        PsychoPy2: Experiments in behavior made easy Behav Res 51: 195. 
        https://doi.org/10.3758/s13428-018-01193-y

"""

# --- Import packages ---
from psychopy import locale_setup
from psychopy import prefs
from psychopy import plugins
plugins.activatePlugins()
prefs.hardware['audioLib'] = 'ptb'
prefs.hardware['audioLatencyMode'] = '3'
from psychopy import sound, gui, visual, core, data, event, logging, clock, colors, layout, iohub, hardware
from psychopy.tools import environmenttools
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)

import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle, choice as randchoice
import os  # handy system and path functions
import sys  # to get file system encoding

import psychopy.iohub as io
from psychopy.hardware import keyboard



# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)
# Store info about the experiment session
psychopyVersion = '2023.1.3'
expName = 'Exp_01'  # from the Builder filename that created this script
expInfo = {
    'participant': '',
}
# --- Show participant info dialog --
dlg = gui.DlgFromDict(dictionary=expInfo, sortKeys=False, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data/%s_%s_%s' % (expInfo['participant'], expName, expInfo['date'])

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath='C:\\Users\\PhilippFeistmantl\\OneDrive - uibk.ac.at\\EMMA\\Pavlovia\\Online Training neutral\\N_online_training_lastrun.py',
    savePickle=True, saveWideText=True,
    dataFileName=filename)
# save a log file for detail verbose info
logFile = logging.LogFile(filename+'.log', level=logging.EXP)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

endExpNow = False  # flag for 'escape' or other condition => quit the exp
frameTolerance = 0.001  # how close to onset before 'same' frame

# Start Code - component code to be run after the window creation

# --- Setup the Window ---
win = visual.Window(
    size=[1536, 864], fullscr=False, screen=0, 
    winType='pyglet', allowStencil=True,
    monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
    backgroundImage='images/background.bmp', backgroundFit='fill',
    blendMode='avg', useFBO=True, 
    units='height')
win.mouseVisible = True
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess
# --- Setup input devices ---
ioConfig = {}

# Setup iohub keyboard
ioConfig['Keyboard'] = dict(use_keymap='psychopy')

ioSession = '1'
if 'session' in expInfo:
    ioSession = str(expInfo['session'])
ioServer = io.launchHubServer(window=win, **ioConfig)
eyetracker = None

# create a default keyboard (e.g. to check for escape)
defaultKeyboard = keyboard.Keyboard(backend='iohub')

# --- Initialize components for Routine "introduction" ---
background = visual.ImageStim(
    win=win,
    name='background', 
    image='images/background.bmp', mask=None, anchor='center',
    ori=0.0, pos=(0, 0), size=(2, 2),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=0.0)
introduction_text = visual.TextBox2(
     win, text='Willkommen zur Online-Version des Experiments! Die Online-Aufgabe ist gleich dem zweiten Teil der Aufgabe, die Sie vor Ort gemacht haben. Sie bekommen diesmal gleich die Szene dargestellt und sollen anschließend jenes Objekt durch Anklicken auswählen, das mit der entsprechenden Szene verbunden war. Danach wird Ihnen wieder kurz die richtige Lösung präsentiert.\nDiese Aufgabe sollen Sie das erste Mal am nächsten Tag und dann alle drei Tage durchführen; d.h. über die kommenden 2 Wochen hinweg insgesamt\xa05-mal.', placeholder='Type here...', font='Open Sans',
     pos=(0, 0.1),     letterHeight=0.04,
     size=(1.6, 0.5), borderWidth=2.0,
     color=[-1.0000, -1.0000, -1.0000], colorSpace='rgb',
     opacity=None,
     bold=False, italic=False,
     lineSpacing=1.0, speechPoint=None,
     padding=0.0, alignment='center',
     anchor='center', overflow='visible',
     fillColor=[0.3255, 0.3255, 0.3255], borderColor=None,
     flipHoriz=False, flipVert=False, languageStyle='LTR',
     editable=False,
     name='introduction_text',
     depth=-1, autoLog=True,
)
text_introduction_button = visual.TextBox2(
     win, text='Drücken Sie hier, um anzufangen', placeholder='Type here...', font='Open Sans',
     pos=(0, -0.3),     letterHeight=0.04,
     size=(0.5, 0.25), borderWidth=2.0,
     color=[-1.0000, -1.0000, -1.0000], colorSpace='rgb',
     opacity=None,
     bold=False, italic=False,
     lineSpacing=1.0, speechPoint=None,
     padding=0.0, alignment='center',
     anchor='center', overflow='visible',
     fillColor=[0.3255, 0.3255, 0.3255], borderColor=None,
     flipHoriz=False, flipVert=False, languageStyle='LTR',
     editable=False,
     name='text_introduction_button',
     depth=-2, autoLog=True,
)
mouse_2 = event.Mouse(win=win)
x, y = [None, None]
mouse_2.mouseClock = core.Clock()

# --- Initialize components for Routine "recognition" ---
# Run 'Begin Experiment' code from feedback_code
score = 0
background_2 = visual.ImageStim(
    win=win,
    name='background_2', 
    image='images/background.bmp', mask=None, anchor='center',
    ori=0.0, pos=(0, 0), size=(2, 2),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-1.0)
question_emotional = visual.TextBox2(
     win, text='Welches Bild war rechts unten?', placeholder='Type here...', font='Open Sans',
     pos=(0, 0.2),     letterHeight=0.05,
     size=(0.75, 0.2), borderWidth=2.0,
     color=[-1.0000, -1.0000, -1.0000], colorSpace='rgb',
     opacity=None,
     bold=False, italic=False,
     lineSpacing=1.2, speechPoint=None,
     padding=0.0, alignment='center',
     anchor='center', overflow='visible',
     fillColor=[0.3255, 0.3255, 0.3255], borderColor=None,
     flipHoriz=False, flipVert=False, languageStyle='LTR',
     editable=False,
     name='question_emotional',
     depth=-2, autoLog=True,
)
image_top_3 = visual.ImageStim(
    win=win,
    name='image_top_3', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(0, 0.2), size=(0.6, 0.45),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-3.0)
image_left = visual.ImageStim(
    win=win,
    name='image_left', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(-0.6, -0.2), size=(0.5, 0.4),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-4.0)
image_middle = visual.ImageStim(
    win=win,
    name='image_middle', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(0, -0.2), size=(0.5, 0.4),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-5.0)
image_right = visual.ImageStim(
    win=win,
    name='image_right', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(0.6, -0.2), size=(0.5, 0.4),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-6.0)
mouse = event.Mouse(win=win)
x, y = [None, None]
mouse.mouseClock = core.Clock()

# --- Initialize components for Routine "feedback" ---
background_3 = visual.ImageStim(
    win=win,
    name='background_3', 
    image='images/background.bmp', mask=None, anchor='center',
    ori=0.0, pos=(0, 0), size=(2, 2),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=0.0)
textbox = visual.TextBox2(
     win, text='', placeholder='Type here...', font='Open Sans',
     pos=(0, 0),     letterHeight=0.05,
     size=(0.4, 0.2), borderWidth=2.0,
     color=[-1.0000, -1.0000, -1.0000], colorSpace='rgb',
     opacity=None,
     bold=False, italic=False,
     lineSpacing=1.0, speechPoint=None,
     padding=0.0, alignment='center',
     anchor='center', overflow='visible',
     fillColor=[0.3255, 0.3255, 0.3255], borderColor=None,
     flipHoriz=False, flipVert=False, languageStyle='LTR',
     editable=False,
     name='textbox',
     depth=-1, autoLog=True,
)

# --- Initialize components for Routine "solution" ---
background_4 = visual.ImageStim(
    win=win,
    name='background_4', 
    image='images/background.bmp', mask=None, anchor='center',
    ori=0.0, pos=(0, 0), size=(2, 2),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=0.0)
image_top_solution = visual.ImageStim(
    win=win,
    name='image_top_solution', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(0, 0.2), size=(0.6, 0.45),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-1.0)
image_solution = visual.ImageStim(
    win=win,
    name='image_solution', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(-0.6, -0.2), size=(0.5, 0.4),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-2.0)

# --- Initialize components for Routine "end" ---
background_5 = visual.ImageStim(
    win=win,
    name='background_5', 
    image='images/background.bmp', mask=None, anchor='center',
    ori=0.0, pos=(0, 0), size=(2, 2),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-1.0)
textbox_2 = visual.TextBox2(
     win, text='Der Durchgang ist beendet. Drücken Sie auf den roten Kreis, um das Experiment zu beenden.', placeholder='Type here...', font='Open Sans',
     pos=(0, 0),     letterHeight=0.05,
     size=(0.8, 0.3), borderWidth=2.0,
     color=[-1.0000, -1.0000, -1.0000], colorSpace='rgb',
     opacity=None,
     bold=False, italic=False,
     lineSpacing=1.0, speechPoint=None,
     padding=0.0, alignment='center',
     anchor='center', overflow='visible',
     fillColor=[0.3255, 0.3255, 0.3255], borderColor=None,
     flipHoriz=False, flipVert=False, languageStyle='LTR',
     editable=False,
     name='textbox_2',
     depth=-2, autoLog=True,
)
textbox_3 = visual.TextBox2(
     win, text='', placeholder='Type here...', font='Open Sans',
     pos=(0, -0.35),     letterHeight=0.05,
     size=(0.5, 0.2), borderWidth=2.0,
     color='black', colorSpace='rgb',
     opacity=None,
     bold=False, italic=False,
     lineSpacing=1.0, speechPoint=None,
     padding=0.0, alignment='center',
     anchor='center', overflow='visible',
     fillColor=[0.3255, 0.3255, 0.3255], borderColor=None,
     flipHoriz=False, flipVert=False, languageStyle='LTR',
     editable=False,
     name='textbox_3',
     depth=-3, autoLog=True,
)
polygon = visual.ShapeStim(
    win=win, name='polygon',
    size=(0.2, 0.2), vertices='circle',
    ori=0.0, pos=(0.75, 0), anchor='center',
    lineWidth=1.0,     colorSpace='rgb',  lineColor='red', fillColor='red',
    opacity=None, depth=-4.0, interpolate=True)
mouse_3 = event.Mouse(win=win)
x, y = [None, None]
mouse_3.mouseClock = core.Clock()

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.Clock()  # to track time remaining of each (possibly non-slip) routine 

# --- Prepare to start Routine "introduction" ---
continueRoutine = True
# update component parameters for each repeat
introduction_text.reset()
text_introduction_button.reset()
# setup some python lists for storing info about the mouse_2
mouse_2.x = []
mouse_2.y = []
mouse_2.leftButton = []
mouse_2.midButton = []
mouse_2.rightButton = []
mouse_2.time = []
mouse_2.clicked_name = []
gotValidClick = False  # until a click is received
# keep track of which components have finished
introductionComponents = [background, introduction_text, text_introduction_button, mouse_2]
for thisComponent in introductionComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
frameN = -1

# --- Run Routine "introduction" ---
routineForceEnded = not continueRoutine
while continueRoutine:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *background* updates
    
    # if background is starting this frame...
    if background.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        background.frameNStart = frameN  # exact frame index
        background.tStart = t  # local t and not account for scr refresh
        background.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(background, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'background.started')
        # update status
        background.status = STARTED
        background.setAutoDraw(True)
    
    # if background is active this frame...
    if background.status == STARTED:
        # update params
        pass
    
    # *introduction_text* updates
    
    # if introduction_text is starting this frame...
    if introduction_text.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        introduction_text.frameNStart = frameN  # exact frame index
        introduction_text.tStart = t  # local t and not account for scr refresh
        introduction_text.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(introduction_text, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'introduction_text.started')
        # update status
        introduction_text.status = STARTED
        introduction_text.setAutoDraw(True)
    
    # if introduction_text is active this frame...
    if introduction_text.status == STARTED:
        # update params
        pass
    
    # *text_introduction_button* updates
    
    # if text_introduction_button is starting this frame...
    if text_introduction_button.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        text_introduction_button.frameNStart = frameN  # exact frame index
        text_introduction_button.tStart = t  # local t and not account for scr refresh
        text_introduction_button.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(text_introduction_button, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'text_introduction_button.started')
        # update status
        text_introduction_button.status = STARTED
        text_introduction_button.setAutoDraw(True)
    
    # if text_introduction_button is active this frame...
    if text_introduction_button.status == STARTED:
        # update params
        pass
    # *mouse_2* updates
    
    # if mouse_2 is starting this frame...
    if mouse_2.status == NOT_STARTED and t >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        mouse_2.frameNStart = frameN  # exact frame index
        mouse_2.tStart = t  # local t and not account for scr refresh
        mouse_2.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(mouse_2, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.addData('mouse_2.started', t)
        # update status
        mouse_2.status = STARTED
        mouse_2.mouseClock.reset()
        prevButtonState = mouse_2.getPressed()  # if button is down already this ISN'T a new click
    if mouse_2.status == STARTED:  # only update if started and not finished!
        buttons = mouse_2.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # check if the mouse was inside our 'clickable' objects
                gotValidClick = False
                clickableList = environmenttools.getFromNames(text_introduction_button, namespace=locals())
                for obj in clickableList:
                    # is this object clicked on?
                    if obj.contains(mouse_2):
                        gotValidClick = True
                        mouse_2.clicked_name.append(obj.name)
                x, y = mouse_2.getPos()
                mouse_2.x.append(x)
                mouse_2.y.append(y)
                buttons = mouse_2.getPressed()
                mouse_2.leftButton.append(buttons[0])
                mouse_2.midButton.append(buttons[1])
                mouse_2.rightButton.append(buttons[2])
                mouse_2.time.append(mouse_2.mouseClock.getTime())
                if gotValidClick:
                    continueRoutine = False  # end routine on response
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
        if eyetracker:
            eyetracker.setConnectionState(False)
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        routineForceEnded = True
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in introductionComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# --- Ending Routine "introduction" ---
for thisComponent in introductionComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# store data for thisExp (ExperimentHandler)
thisExp.addData('mouse_2.x', mouse_2.x)
thisExp.addData('mouse_2.y', mouse_2.y)
thisExp.addData('mouse_2.leftButton', mouse_2.leftButton)
thisExp.addData('mouse_2.midButton', mouse_2.midButton)
thisExp.addData('mouse_2.rightButton', mouse_2.rightButton)
thisExp.addData('mouse_2.time', mouse_2.time)
thisExp.addData('mouse_2.clicked_name', mouse_2.clicked_name)
thisExp.nextEntry()
# the Routine "introduction" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
trials = data.TrialHandler(nReps=1.0, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('Excel_online_training_neutral.xlsx'),
    seed=None, name='trials')
thisExp.addLoop(trials)  # add the loop to the experiment
thisTrial = trials.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
if thisTrial != None:
    for paramName in thisTrial:
        exec('{} = thisTrial[paramName]'.format(paramName))

for thisTrial in trials:
    currentLoop = trials
    # abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
    if thisTrial != None:
        for paramName in thisTrial:
            exec('{} = thisTrial[paramName]'.format(paramName))
    
    # --- Prepare to start Routine "recognition" ---
    continueRoutine = True
    # update component parameters for each repeat
    question_emotional.reset()
    image_top_3.setImage(Picture_Recognition)
    image_left.setImage(Q1_l)
    image_middle.setImage(Q1_m)
    image_right.setImage(Q1_r)
    # setup some python lists for storing info about the mouse
    mouse.x = []
    mouse.y = []
    mouse.leftButton = []
    mouse.midButton = []
    mouse.rightButton = []
    mouse.time = []
    mouse.clicked_name = []
    gotValidClick = False  # until a click is received
    # keep track of which components have finished
    recognitionComponents = [background_2, question_emotional, image_top_3, image_left, image_middle, image_right, mouse]
    for thisComponent in recognitionComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1
    
    # --- Run Routine "recognition" ---
    routineForceEnded = not continueRoutine
    while continueRoutine:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *background_2* updates
        
        # if background_2 is starting this frame...
        if background_2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            background_2.frameNStart = frameN  # exact frame index
            background_2.tStart = t  # local t and not account for scr refresh
            background_2.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(background_2, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'background_2.started')
            # update status
            background_2.status = STARTED
            background_2.setAutoDraw(True)
        
        # if background_2 is active this frame...
        if background_2.status == STARTED:
            # update params
            pass
        
        # *question_emotional* updates
        
        # if question_emotional is starting this frame...
        if question_emotional.status == NOT_STARTED and tThisFlip >= 2.1-frameTolerance:
            # keep track of start time/frame for later
            question_emotional.frameNStart = frameN  # exact frame index
            question_emotional.tStart = t  # local t and not account for scr refresh
            question_emotional.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(question_emotional, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'question_emotional.started')
            # update status
            question_emotional.status = STARTED
            question_emotional.setAutoDraw(True)
        
        # if question_emotional is active this frame...
        if question_emotional.status == STARTED:
            # update params
            pass
        
        # *image_top_3* updates
        
        # if image_top_3 is starting this frame...
        if image_top_3.status == NOT_STARTED and tThisFlip >= 0-frameTolerance:
            # keep track of start time/frame for later
            image_top_3.frameNStart = frameN  # exact frame index
            image_top_3.tStart = t  # local t and not account for scr refresh
            image_top_3.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(image_top_3, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'image_top_3.started')
            # update status
            image_top_3.status = STARTED
            image_top_3.setAutoDraw(True)
        
        # if image_top_3 is active this frame...
        if image_top_3.status == STARTED:
            # update params
            pass
        
        # if image_top_3 is stopping this frame...
        if image_top_3.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > image_top_3.tStartRefresh + 1.6-frameTolerance:
                # keep track of stop time/frame for later
                image_top_3.tStop = t  # not accounting for scr refresh
                image_top_3.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'image_top_3.stopped')
                # update status
                image_top_3.status = FINISHED
                image_top_3.setAutoDraw(False)
        
        # *image_left* updates
        
        # if image_left is starting this frame...
        if image_left.status == NOT_STARTED and tThisFlip >= 2.1-frameTolerance:
            # keep track of start time/frame for later
            image_left.frameNStart = frameN  # exact frame index
            image_left.tStart = t  # local t and not account for scr refresh
            image_left.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(image_left, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'image_left.started')
            # update status
            image_left.status = STARTED
            image_left.setAutoDraw(True)
        
        # if image_left is active this frame...
        if image_left.status == STARTED:
            # update params
            pass
        
        # *image_middle* updates
        
        # if image_middle is starting this frame...
        if image_middle.status == NOT_STARTED and tThisFlip >= 2.1-frameTolerance:
            # keep track of start time/frame for later
            image_middle.frameNStart = frameN  # exact frame index
            image_middle.tStart = t  # local t and not account for scr refresh
            image_middle.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(image_middle, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'image_middle.started')
            # update status
            image_middle.status = STARTED
            image_middle.setAutoDraw(True)
        
        # if image_middle is active this frame...
        if image_middle.status == STARTED:
            # update params
            pass
        
        # *image_right* updates
        
        # if image_right is starting this frame...
        if image_right.status == NOT_STARTED and tThisFlip >= 2.1-frameTolerance:
            # keep track of start time/frame for later
            image_right.frameNStart = frameN  # exact frame index
            image_right.tStart = t  # local t and not account for scr refresh
            image_right.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(image_right, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'image_right.started')
            # update status
            image_right.status = STARTED
            image_right.setAutoDraw(True)
        
        # if image_right is active this frame...
        if image_right.status == STARTED:
            # update params
            pass
        # *mouse* updates
        
        # if mouse is starting this frame...
        if mouse.status == NOT_STARTED and t >= 2.1-frameTolerance:
            # keep track of start time/frame for later
            mouse.frameNStart = frameN  # exact frame index
            mouse.tStart = t  # local t and not account for scr refresh
            mouse.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(mouse, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.addData('mouse.started', t)
            # update status
            mouse.status = STARTED
            mouse.mouseClock.reset()
            prevButtonState = mouse.getPressed()  # if button is down already this ISN'T a new click
        if mouse.status == STARTED:  # only update if started and not finished!
            buttons = mouse.getPressed()
            if buttons != prevButtonState:  # button state changed?
                prevButtonState = buttons
                if sum(buttons) > 0:  # state changed to a new click
                    # check if the mouse was inside our 'clickable' objects
                    gotValidClick = False
                    clickableList = environmenttools.getFromNames([image_left,image_middle,image_right], namespace=locals())
                    for obj in clickableList:
                        # is this object clicked on?
                        if obj.contains(mouse):
                            gotValidClick = True
                            mouse.clicked_name.append(obj.name)
                    x, y = mouse.getPos()
                    mouse.x.append(x)
                    mouse.y.append(y)
                    buttons = mouse.getPressed()
                    mouse.leftButton.append(buttons[0])
                    mouse.midButton.append(buttons[1])
                    mouse.rightButton.append(buttons[2])
                    mouse.time.append(mouse.mouseClock.getTime())
                    if gotValidClick:
                        continueRoutine = False  # end routine on response
        
        # check for quit (typically the Esc key)
        if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()
            if eyetracker:
                eyetracker.setConnectionState(False)
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in recognitionComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "recognition" ---
    for thisComponent in recognitionComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # Run 'End Routine' code from feedback_code
    ID = expInfo['participant']
    condition = 'e'
    stage = 'main'
    round0 = 0
    scene = Picture_Recognition
    correct_object = Picture_Recognition_2
    
    if mouse.clicked_name[0] == 'image_left':
        memory_resp = Q1_l
    elif mouse.clicked_name[0] == 'image_middle':
        memory_resp = Q1_m
    elif mouse.clicked_name[0] == 'image_right':
        memory_resp = Q1_r
    else:
        raise RuntimeError
    memory_rt = mouse.time[0]
    
    if memory_resp == correct_object:
        accuracy = 1
    else:
        accuracy = 0
    x = mouse.x
    y = mouse.y
    
    if accuracy == 1:
        this_feedback = 'Korrekt'
        score += 1
    else:
        this_feedback = 'Nicht korrekt'
    
    trials.addData('condition', condition)
    trials.addData('stage', stage)
    trials.addData('scene', scene)
    trials.addData('correct object', correct_object)
    trials.addData('left option', Q1_l)
    trials.addData('middle option', Q1_m)
    trials.addData('right option', Q1_r)
    trials.addData('memory resp', memory_resp)
    trials.addData('memory rt', memory_rt)
    trials.addData('accuracy', accuracy)
    trials.addData('score', score)
    trials.addData('x mouse', x)
    trials.addData('y mouse', y)
    trials.addData('internal lure', internal_lure)
    trials.addData('external lure', external_lure)
    # store data for trials (TrialHandler)
    trials.addData('mouse.x', mouse.x)
    trials.addData('mouse.y', mouse.y)
    trials.addData('mouse.leftButton', mouse.leftButton)
    trials.addData('mouse.midButton', mouse.midButton)
    trials.addData('mouse.rightButton', mouse.rightButton)
    trials.addData('mouse.time', mouse.time)
    trials.addData('mouse.clicked_name', mouse.clicked_name)
    # the Routine "recognition" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # --- Prepare to start Routine "feedback" ---
    continueRoutine = True
    # update component parameters for each repeat
    textbox.reset()
    textbox.setText(this_feedback)
    # keep track of which components have finished
    feedbackComponents = [background_3, textbox]
    for thisComponent in feedbackComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1
    
    # --- Run Routine "feedback" ---
    routineForceEnded = not continueRoutine
    while continueRoutine and routineTimer.getTime() < 1.0:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *background_3* updates
        
        # if background_3 is starting this frame...
        if background_3.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            background_3.frameNStart = frameN  # exact frame index
            background_3.tStart = t  # local t and not account for scr refresh
            background_3.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(background_3, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'background_3.started')
            # update status
            background_3.status = STARTED
            background_3.setAutoDraw(True)
        
        # if background_3 is active this frame...
        if background_3.status == STARTED:
            # update params
            pass
        
        # if background_3 is stopping this frame...
        if background_3.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > background_3.tStartRefresh + 1-frameTolerance:
                # keep track of stop time/frame for later
                background_3.tStop = t  # not accounting for scr refresh
                background_3.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'background_3.stopped')
                # update status
                background_3.status = FINISHED
                background_3.setAutoDraw(False)
        
        # *textbox* updates
        
        # if textbox is starting this frame...
        if textbox.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            textbox.frameNStart = frameN  # exact frame index
            textbox.tStart = t  # local t and not account for scr refresh
            textbox.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(textbox, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'textbox.started')
            # update status
            textbox.status = STARTED
            textbox.setAutoDraw(True)
        
        # if textbox is active this frame...
        if textbox.status == STARTED:
            # update params
            pass
        
        # if textbox is stopping this frame...
        if textbox.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > textbox.tStartRefresh + 1.0-frameTolerance:
                # keep track of stop time/frame for later
                textbox.tStop = t  # not accounting for scr refresh
                textbox.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'textbox.stopped')
                # update status
                textbox.status = FINISHED
                textbox.setAutoDraw(False)
        
        # check for quit (typically the Esc key)
        if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()
            if eyetracker:
                eyetracker.setConnectionState(False)
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in feedbackComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "feedback" ---
    for thisComponent in feedbackComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
    if routineForceEnded:
        routineTimer.reset()
    else:
        routineTimer.addTime(-1.000000)
    
    # --- Prepare to start Routine "solution" ---
    continueRoutine = True
    # update component parameters for each repeat
    image_top_solution.setImage(Picture_Recognition)
    image_solution.setImage(Picture_Recognition_2)
    # keep track of which components have finished
    solutionComponents = [background_4, image_top_solution, image_solution]
    for thisComponent in solutionComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    frameN = -1
    
    # --- Run Routine "solution" ---
    routineForceEnded = not continueRoutine
    while continueRoutine and routineTimer.getTime() < 3.1:
        # get current time
        t = routineTimer.getTime()
        tThisFlip = win.getFutureFlipTime(clock=routineTimer)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *background_4* updates
        
        # if background_4 is starting this frame...
        if background_4.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            background_4.frameNStart = frameN  # exact frame index
            background_4.tStart = t  # local t and not account for scr refresh
            background_4.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(background_4, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'background_4.started')
            # update status
            background_4.status = STARTED
            background_4.setAutoDraw(True)
        
        # if background_4 is active this frame...
        if background_4.status == STARTED:
            # update params
            pass
        
        # if background_4 is stopping this frame...
        if background_4.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > background_4.tStartRefresh + 3.1-frameTolerance:
                # keep track of stop time/frame for later
                background_4.tStop = t  # not accounting for scr refresh
                background_4.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'background_4.stopped')
                # update status
                background_4.status = FINISHED
                background_4.setAutoDraw(False)
        
        # *image_top_solution* updates
        
        # if image_top_solution is starting this frame...
        if image_top_solution.status == NOT_STARTED and tThisFlip >= 1.1-frameTolerance:
            # keep track of start time/frame for later
            image_top_solution.frameNStart = frameN  # exact frame index
            image_top_solution.tStart = t  # local t and not account for scr refresh
            image_top_solution.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(image_top_solution, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'image_top_solution.started')
            # update status
            image_top_solution.status = STARTED
            image_top_solution.setAutoDraw(True)
        
        # if image_top_solution is active this frame...
        if image_top_solution.status == STARTED:
            # update params
            pass
        
        # if image_top_solution is stopping this frame...
        if image_top_solution.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > image_top_solution.tStartRefresh + 2-frameTolerance:
                # keep track of stop time/frame for later
                image_top_solution.tStop = t  # not accounting for scr refresh
                image_top_solution.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'image_top_solution.stopped')
                # update status
                image_top_solution.status = FINISHED
                image_top_solution.setAutoDraw(False)
        
        # *image_solution* updates
        
        # if image_solution is starting this frame...
        if image_solution.status == NOT_STARTED and tThisFlip >= 1.1-frameTolerance:
            # keep track of start time/frame for later
            image_solution.frameNStart = frameN  # exact frame index
            image_solution.tStart = t  # local t and not account for scr refresh
            image_solution.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(image_solution, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'image_solution.started')
            # update status
            image_solution.status = STARTED
            image_solution.setAutoDraw(True)
        
        # if image_solution is active this frame...
        if image_solution.status == STARTED:
            # update params
            pass
        
        # if image_solution is stopping this frame...
        if image_solution.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > image_solution.tStartRefresh + 2-frameTolerance:
                # keep track of stop time/frame for later
                image_solution.tStop = t  # not accounting for scr refresh
                image_solution.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'image_solution.stopped')
                # update status
                image_solution.status = FINISHED
                image_solution.setAutoDraw(False)
        
        # check for quit (typically the Esc key)
        if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
            core.quit()
            if eyetracker:
                eyetracker.setConnectionState(False)
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            routineForceEnded = True
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in solutionComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # --- Ending Routine "solution" ---
    for thisComponent in solutionComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # using non-slip timing so subtract the expected duration of this Routine (unless ended on request)
    if routineForceEnded:
        routineTimer.reset()
    else:
        routineTimer.addTime(-3.100000)
    thisExp.nextEntry()
    
# completed 1.0 repeats of 'trials'


# --- Prepare to start Routine "end" ---
continueRoutine = True
# update component parameters for each repeat
# Run 'Begin Routine' code from score
final_score = f'Erreichter Score: {(score / 60) * 100}%'
textbox_2.reset()
textbox_3.reset()
textbox_3.setText(final_score)
# setup some python lists for storing info about the mouse_3
mouse_3.x = []
mouse_3.y = []
mouse_3.leftButton = []
mouse_3.midButton = []
mouse_3.rightButton = []
mouse_3.time = []
mouse_3.clicked_name = []
gotValidClick = False  # until a click is received
# keep track of which components have finished
endComponents = [background_5, textbox_2, textbox_3, polygon, mouse_3]
for thisComponent in endComponents:
    thisComponent.tStart = None
    thisComponent.tStop = None
    thisComponent.tStartRefresh = None
    thisComponent.tStopRefresh = None
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED
# reset timers
t = 0
_timeToFirstFrame = win.getFutureFlipTime(clock="now")
frameN = -1

# --- Run Routine "end" ---
routineForceEnded = not continueRoutine
while continueRoutine:
    # get current time
    t = routineTimer.getTime()
    tThisFlip = win.getFutureFlipTime(clock=routineTimer)
    tThisFlipGlobal = win.getFutureFlipTime(clock=None)
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *background_5* updates
    
    # if background_5 is starting this frame...
    if background_5.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        background_5.frameNStart = frameN  # exact frame index
        background_5.tStart = t  # local t and not account for scr refresh
        background_5.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(background_5, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'background_5.started')
        # update status
        background_5.status = STARTED
        background_5.setAutoDraw(True)
    
    # if background_5 is active this frame...
    if background_5.status == STARTED:
        # update params
        pass
    
    # *textbox_2* updates
    
    # if textbox_2 is starting this frame...
    if textbox_2.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        textbox_2.frameNStart = frameN  # exact frame index
        textbox_2.tStart = t  # local t and not account for scr refresh
        textbox_2.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(textbox_2, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'textbox_2.started')
        # update status
        textbox_2.status = STARTED
        textbox_2.setAutoDraw(True)
    
    # if textbox_2 is active this frame...
    if textbox_2.status == STARTED:
        # update params
        pass
    
    # *textbox_3* updates
    
    # if textbox_3 is starting this frame...
    if textbox_3.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        textbox_3.frameNStart = frameN  # exact frame index
        textbox_3.tStart = t  # local t and not account for scr refresh
        textbox_3.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(textbox_3, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'textbox_3.started')
        # update status
        textbox_3.status = STARTED
        textbox_3.setAutoDraw(True)
    
    # if textbox_3 is active this frame...
    if textbox_3.status == STARTED:
        # update params
        pass
    
    # *polygon* updates
    
    # if polygon is starting this frame...
    if polygon.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        polygon.frameNStart = frameN  # exact frame index
        polygon.tStart = t  # local t and not account for scr refresh
        polygon.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(polygon, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.timestampOnFlip(win, 'polygon.started')
        # update status
        polygon.status = STARTED
        polygon.setAutoDraw(True)
    
    # if polygon is active this frame...
    if polygon.status == STARTED:
        # update params
        pass
    # *mouse_3* updates
    
    # if mouse_3 is starting this frame...
    if mouse_3.status == NOT_STARTED and t >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        mouse_3.frameNStart = frameN  # exact frame index
        mouse_3.tStart = t  # local t and not account for scr refresh
        mouse_3.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(mouse_3, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.addData('mouse_3.started', t)
        # update status
        mouse_3.status = STARTED
        mouse_3.mouseClock.reset()
        prevButtonState = mouse_3.getPressed()  # if button is down already this ISN'T a new click
    if mouse_3.status == STARTED:  # only update if started and not finished!
        buttons = mouse_3.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # check if the mouse was inside our 'clickable' objects
                gotValidClick = False
                clickableList = environmenttools.getFromNames(polygon, namespace=locals())
                for obj in clickableList:
                    # is this object clicked on?
                    if obj.contains(mouse_3):
                        gotValidClick = True
                        mouse_3.clicked_name.append(obj.name)
                x, y = mouse_3.getPos()
                mouse_3.x.append(x)
                mouse_3.y.append(y)
                buttons = mouse_3.getPressed()
                mouse_3.leftButton.append(buttons[0])
                mouse_3.midButton.append(buttons[1])
                mouse_3.rightButton.append(buttons[2])
                mouse_3.time.append(mouse_3.mouseClock.getTime())
                if gotValidClick:
                    continueRoutine = False  # end routine on response
    
    # check for quit (typically the Esc key)
    if endExpNow or defaultKeyboard.getKeys(keyList=["escape"]):
        core.quit()
        if eyetracker:
            eyetracker.setConnectionState(False)
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        routineForceEnded = True
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in endComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# --- Ending Routine "end" ---
for thisComponent in endComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# store data for thisExp (ExperimentHandler)
thisExp.addData('mouse_3.x', mouse_3.x)
thisExp.addData('mouse_3.y', mouse_3.y)
thisExp.addData('mouse_3.leftButton', mouse_3.leftButton)
thisExp.addData('mouse_3.midButton', mouse_3.midButton)
thisExp.addData('mouse_3.rightButton', mouse_3.rightButton)
thisExp.addData('mouse_3.time', mouse_3.time)
thisExp.addData('mouse_3.clicked_name', mouse_3.clicked_name)
thisExp.nextEntry()
# the Routine "end" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# --- End experiment ---
# Flip one final time so any remaining win.callOnFlip() 
# and win.timeOnFlip() tasks get executed before quitting
win.flip()

# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv', delim='auto')
thisExp.saveAsPickle(filename)
logging.flush()
# make sure everything is closed down
if eyetracker:
    eyetracker.setConnectionState(False)
thisExp.abort()  # or data files will save again on exit
win.close()
core.quit()
