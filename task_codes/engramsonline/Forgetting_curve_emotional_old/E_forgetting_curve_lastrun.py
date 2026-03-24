#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v2023.1.3),
    on April 01, 2024, at 13:21
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
expName = 'E_forgetting_curve'  # from the Builder filename that created this script
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
    originPath='C:\\Users\\PhilippFeistmantl\\OneDrive - uibk.ac.at\\EMMA\\Pavlovia\\Forgetting curve emotional\\E_forgetting_curve_lastrun.py',
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
    size=[1536, 864], fullscr=True, screen=0, 
    winType='pyglet', allowStencil=True,
    monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
    backgroundImage='images/background.bmp', backgroundFit='fill',
    blendMode='avg', useFBO=True, 
    units='height')
win.mouseVisible = False
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
introduction_text = visual.TextBox2(
     win, text='Willkommen zur Online-Version des Experiments! Die Online-Aufgabe ist ähnlich wie die zweite Aufgabe, die Sie vor Ort gemacht haben. Sie bekommen eine Szene dargestellt und sollen anschließend jenes Objekt durch Anklicken auswählen, das Ihrer Erinnerung nach mit der Szene verbunden war. Allerdings sehen Sie danach nicht mehr die richtige Lösung. Es handelt sich hierbei um die Verknüpfungen, die Sie beim zweiten Termin vor Ort gelernt haben.\nDiese Aufgabe sollen Sie das erste Mal am nächsten Tag und dann alle drei Tage durchführen; d.h. über die kommenden 2 Wochen hinweg insgesamt\xa05-mal.', placeholder='Type here...', font='Open Sans',
     pos=(0, 0.12),     letterHeight=0.037,
     size=(1.5, 0.5), borderWidth=2.0,
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
     depth=0, autoLog=True,
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
     fillColor=[0.3255, 0.3255, 0.3255], borderColor=[0.3255, 0.3255, 0.3255],
     flipHoriz=False, flipVert=False, languageStyle='LTR',
     editable=False,
     name='text_introduction_button',
     depth=-1, autoLog=True,
)
mouse_1 = event.Mouse(win=win)
x, y = [None, None]
mouse_1.mouseClock = core.Clock()

# --- Initialize components for Routine "recognition" ---
# Run 'Begin Experiment' code from behavioral
score = 0
question = visual.TextBox2(
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
     name='question',
     depth=-1, autoLog=True,
)
image_top = visual.ImageStim(
    win=win,
    name='image_top', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(0, 0.2), size=(0.6, 0.45),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-2.0)
image_left = visual.ImageStim(
    win=win,
    name='image_left', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(-0.6, -0.2), size=(0.5, 0.4),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-3.0)
image_middle = visual.ImageStim(
    win=win,
    name='image_middle', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(0, -0.2), size=(0.5, 0.4),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-4.0)
image_right = visual.ImageStim(
    win=win,
    name='image_right', 
    image='default.png', mask=None, anchor='center',
    ori=0.0, pos=(0.6, -0.2), size=(0.5, 0.4),
    color=[1,1,1], colorSpace='rgb', opacity=None,
    flipHoriz=False, flipVert=False,
    texRes=128.0, interpolate=True, depth=-5.0)
mouse = event.Mouse(win=win)
x, y = [None, None]
mouse.mouseClock = core.Clock()

# --- Initialize components for Routine "end" ---
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
     depth=0, autoLog=True,
)
polygon = visual.ShapeStim(
    win=win, name='polygon',
    size=(0.2, 0.2), vertices='circle',
    ori=0.0, pos=(0.75, 0), anchor='center',
    lineWidth=1.0,     colorSpace='rgb',  lineColor='red', fillColor='red',
    opacity=None, depth=-1.0, interpolate=True)
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
# setup some python lists for storing info about the mouse_1
mouse_1.x = []
mouse_1.y = []
mouse_1.leftButton = []
mouse_1.midButton = []
mouse_1.rightButton = []
mouse_1.time = []
mouse_1.clicked_name = []
gotValidClick = False  # until a click is received
# keep track of which components have finished
introductionComponents = [introduction_text, text_introduction_button, mouse_1]
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
    # *mouse_1* updates
    
    # if mouse_1 is starting this frame...
    if mouse_1.status == NOT_STARTED and t >= 0.0-frameTolerance:
        # keep track of start time/frame for later
        mouse_1.frameNStart = frameN  # exact frame index
        mouse_1.tStart = t  # local t and not account for scr refresh
        mouse_1.tStartRefresh = tThisFlipGlobal  # on global time
        win.timeOnFlip(mouse_1, 'tStartRefresh')  # time at next scr refresh
        # add timestamp to datafile
        thisExp.addData('mouse_1.started', t)
        # update status
        mouse_1.status = STARTED
        mouse_1.mouseClock.reset()
        prevButtonState = mouse_1.getPressed()  # if button is down already this ISN'T a new click
    if mouse_1.status == STARTED:  # only update if started and not finished!
        buttons = mouse_1.getPressed()
        if buttons != prevButtonState:  # button state changed?
            prevButtonState = buttons
            if sum(buttons) > 0:  # state changed to a new click
                # check if the mouse was inside our 'clickable' objects
                gotValidClick = False
                clickableList = environmenttools.getFromNames(text_introduction_button, namespace=locals())
                for obj in clickableList:
                    # is this object clicked on?
                    if obj.contains(mouse_1):
                        gotValidClick = True
                        mouse_1.clicked_name.append(obj.name)
                x, y = mouse_1.getPos()
                mouse_1.x.append(x)
                mouse_1.y.append(y)
                buttons = mouse_1.getPressed()
                mouse_1.leftButton.append(buttons[0])
                mouse_1.midButton.append(buttons[1])
                mouse_1.rightButton.append(buttons[2])
                mouse_1.time.append(mouse_1.mouseClock.getTime())
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
thisExp.addData('mouse_1.x', mouse_1.x)
thisExp.addData('mouse_1.y', mouse_1.y)
thisExp.addData('mouse_1.leftButton', mouse_1.leftButton)
thisExp.addData('mouse_1.midButton', mouse_1.midButton)
thisExp.addData('mouse_1.rightButton', mouse_1.rightButton)
thisExp.addData('mouse_1.time', mouse_1.time)
thisExp.addData('mouse_1.clicked_name', mouse_1.clicked_name)
thisExp.nextEntry()
# the Routine "introduction" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
trials = data.TrialHandler(nReps=1.0, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('Excel_forgetting_curve_emotional.xlsx', selection='0'),
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
    question.reset()
    image_top.setImage(Picture_Recognition)
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
    recognitionComponents = [question, image_top, image_left, image_middle, image_right, mouse]
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
        
        # *question* updates
        
        # if question is starting this frame...
        if question.status == NOT_STARTED and tThisFlip >= 2.1-frameTolerance:
            # keep track of start time/frame for later
            question.frameNStart = frameN  # exact frame index
            question.tStart = t  # local t and not account for scr refresh
            question.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(question, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'question.started')
            # update status
            question.status = STARTED
            question.setAutoDraw(True)
        
        # if question is active this frame...
        if question.status == STARTED:
            # update params
            pass
        
        # *image_top* updates
        
        # if image_top is starting this frame...
        if image_top.status == NOT_STARTED and tThisFlip >= 0-frameTolerance:
            # keep track of start time/frame for later
            image_top.frameNStart = frameN  # exact frame index
            image_top.tStart = t  # local t and not account for scr refresh
            image_top.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(image_top, 'tStartRefresh')  # time at next scr refresh
            # add timestamp to datafile
            thisExp.timestampOnFlip(win, 'image_top.started')
            # update status
            image_top.status = STARTED
            image_top.setAutoDraw(True)
        
        # if image_top is active this frame...
        if image_top.status == STARTED:
            # update params
            pass
        
        # if image_top is stopping this frame...
        if image_top.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > image_top.tStartRefresh + 1.6-frameTolerance:
                # keep track of stop time/frame for later
                image_top.tStop = t  # not accounting for scr refresh
                image_top.frameNStop = frameN  # exact frame index
                # add timestamp to datafile
                thisExp.timestampOnFlip(win, 'image_top.stopped')
                # update status
                image_top.status = FINISHED
                image_top.setAutoDraw(False)
        
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
    # Run 'End Routine' code from behavioral
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
    thisExp.nextEntry()
    
# completed 1.0 repeats of 'trials'


# --- Prepare to start Routine "end" ---
continueRoutine = True
# update component parameters for each repeat
textbox_2.reset()
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
endComponents = [textbox_2, polygon, mouse_3]
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
