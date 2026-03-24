/************************** 
 * E_Online_Training Test *
 **************************/

import { core, data, sound, util, visual, hardware } from './lib/psychojs-2023.1.3.js';
const { PsychoJS } = core;
const { TrialHandler, MultiStairHandler } = data;
const { Scheduler } = util;
//some handy aliases as in the psychopy scripts;
const { abs, sin, cos, PI: pi, sqrt } = Math;
const { round } = util;


// store info about the experiment session:
let expName = 'E_online_training';  // from the Builder filename that created this script
let expInfo = {
    'participant': '',
};

// Start code blocks for 'Before Experiment'
// init psychoJS:
const psychoJS = new PsychoJS({
  debug: true
});

// open window:
psychoJS.openWindow({
  fullscr: false,
  color: new util.Color([0,0,0]),
  units: 'height',
  waitBlanking: true
});
// schedule the experiment:
psychoJS.schedule(psychoJS.gui.DlgFromDict({
  dictionary: expInfo,
  title: expName
}));

const flowScheduler = new Scheduler(psychoJS);
const dialogCancelScheduler = new Scheduler(psychoJS);
psychoJS.scheduleCondition(function() { return (psychoJS.gui.dialogComponent.button === 'OK'); }, flowScheduler, dialogCancelScheduler);

// flowScheduler gets run if the participants presses OK
flowScheduler.add(updateInfo); // add timeStamp
flowScheduler.add(experimentInit);
flowScheduler.add(introductionRoutineBegin());
flowScheduler.add(introductionRoutineEachFrame());
flowScheduler.add(introductionRoutineEnd());
const trialsLoopScheduler = new Scheduler(psychoJS);
flowScheduler.add(trialsLoopBegin(trialsLoopScheduler));
flowScheduler.add(trialsLoopScheduler);
flowScheduler.add(trialsLoopEnd);
flowScheduler.add(endRoutineBegin());
flowScheduler.add(endRoutineEachFrame());
flowScheduler.add(endRoutineEnd());
flowScheduler.add(quitPsychoJS, '', true);

// quit if user presses Cancel in dialog box:
dialogCancelScheduler.add(quitPsychoJS, '', false);

psychoJS.start({
  expName: expName,
  expInfo: expInfo,
  resources: [
    // resources:
    {'name': 'Excel_online_training_emotional.xlsx', 'path': 'Excel_online_training_emotional.xlsx'},
    {'name': 'images/scenes/originals/set026_2.png', 'path': 'images/scenes/originals/set026_2.png'},
    {'name': 'images/objects/originals/crushed cans.png', 'path': 'images/objects/originals/crushed cans.png'},
    {'name': 'images/objects/originals/dirty food tray.png', 'path': 'images/objects/originals/dirty food tray.png'},
    {'name': 'images/objects/originals/broken drain pipe.png', 'path': 'images/objects/originals/broken drain pipe.png'},
    {'name': 'images/scenes/originals/set053_3.png', 'path': 'images/scenes/originals/set053_3.png'},
    {'name': 'images/objects/originals/dead animal remains.png', 'path': 'images/objects/originals/dead animal remains.png'},
    {'name': 'images/objects/originals/gazelle bone.png', 'path': 'images/objects/originals/gazelle bone.png'},
    {'name': 'images/objects/originals/bloody animal bones.png', 'path': 'images/objects/originals/bloody animal bones.png'},
    {'name': 'images/scenes/originals/set053_5.png', 'path': 'images/scenes/originals/set053_5.png'},
    {'name': 'images/objects/originals/intestines.png', 'path': 'images/objects/originals/intestines.png'},
    {'name': 'images/objects/originals/decapitated deer head.png', 'path': 'images/objects/originals/decapitated deer head.png'},
    {'name': 'images/objects/originals/maggots.png', 'path': 'images/objects/originals/maggots.png'},
    {'name': 'images/scenes/originals/set054_1.png', 'path': 'images/scenes/originals/set054_1.png'},
    {'name': 'images/objects/originals/dirty cat collar.png', 'path': 'images/objects/originals/dirty cat collar.png'},
    {'name': 'images/objects/originals/dirty water bowl.png', 'path': 'images/objects/originals/dirty water bowl.png'},
    {'name': 'images/objects/originals/ointment tube.png', 'path': 'images/objects/originals/ointment tube.png'},
    {'name': 'images/scenes/originals/set055_5.png', 'path': 'images/scenes/originals/set055_5.png'},
    {'name': 'images/objects/originals/food bowl filled with spoiled food.png', 'path': 'images/objects/originals/food bowl filled with spoiled food.png'},
    {'name': 'images/objects/originals/dirty baseball bat.png', 'path': 'images/objects/originals/dirty baseball bat.png'},
    {'name': 'images/objects/originals/dirty small cage.png', 'path': 'images/objects/originals/dirty small cage.png'},
    {'name': 'images/scenes/originals/set056_1.png', 'path': 'images/scenes/originals/set056_1.png'},
    {'name': 'images/objects/originals/bloody gauze.png', 'path': 'images/objects/originals/bloody gauze.png'},
    {'name': 'images/objects/originals/dirty feathers.png', 'path': 'images/objects/originals/dirty feathers.png'},
    {'name': 'images/objects/originals/vital sign monitor.png', 'path': 'images/objects/originals/vital sign monitor.png'},
    {'name': 'images/scenes/originals/set056_2.png', 'path': 'images/scenes/originals/set056_2.png'},
    {'name': 'images/objects/originals/bloody syringe.png', 'path': 'images/objects/originals/bloody syringe.png'},
    {'name': 'images/objects/originals/bloody sterille operational gloves.png', 'path': 'images/objects/originals/bloody sterille operational gloves.png'},
    {'name': 'images/objects/originals/bloody operational tweezers.png', 'path': 'images/objects/originals/bloody operational tweezers.png'},
    {'name': 'images/scenes/originals/set056_3.png', 'path': 'images/scenes/originals/set056_3.png'},
    {'name': 'images/objects/originals/bloody bandage rolls.png', 'path': 'images/objects/originals/bloody bandage rolls.png'},
    {'name': 'images/objects/originals/tranquiliser vial.png', 'path': 'images/objects/originals/tranquiliser vial.png'},
    {'name': 'images/objects/originals/x-ray images.png', 'path': 'images/objects/originals/x-ray images.png'},
    {'name': 'images/scenes/originals/set056_4.png', 'path': 'images/scenes/originals/set056_4.png'},
    {'name': 'images/objects/originals/bloody surgical tapes.png', 'path': 'images/objects/originals/bloody surgical tapes.png'},
    {'name': 'images/objects/originals/try with organ remains.png', 'path': 'images/objects/originals/try with organ remains.png'},
    {'name': 'images/objects/originals/bloody scarpel.png', 'path': 'images/objects/originals/bloody scarpel.png'},
    {'name': 'images/scenes/originals/set059_4.png', 'path': 'images/scenes/originals/set059_4.png'},
    {'name': 'images/objects/originals/bloodstained white sheet.png', 'path': 'images/objects/originals/bloodstained white sheet.png'},
    {'name': 'images/objects/originals/broken tyre.png', 'path': 'images/objects/originals/broken tyre.png'},
    {'name': 'images/objects/originals/broken warning signpost.png', 'path': 'images/objects/originals/broken warning signpost.png'},
    {'name': 'images/scenes/originals/set060_2.png', 'path': 'images/scenes/originals/set060_2.png'},
    {'name': 'images/objects/originals/bloody burlap sack.png', 'path': 'images/objects/originals/bloody burlap sack.png'},
    {'name': 'images/objects/originals/clean stainless steel surgical tray.png', 'path': 'images/objects/originals/clean stainless steel surgical tray.png'},
    {'name': 'images/scenes/originals/set060_3.png', 'path': 'images/scenes/originals/set060_3.png'},
    {'name': 'images/objects/originals/dirty blanket.png', 'path': 'images/objects/originals/dirty blanket.png'},
    {'name': 'images/scenes/originals/set061_1.png', 'path': 'images/scenes/originals/set061_1.png'},
    {'name': 'images/objects/originals/dirty plastic bottles.png', 'path': 'images/objects/originals/dirty plastic bottles.png'},
    {'name': 'images/objects/originals/dirty water foam.png', 'path': 'images/objects/originals/dirty water foam.png'},
    {'name': 'images/objects/originals/dead fish.png', 'path': 'images/objects/originals/dead fish.png'},
    {'name': 'images/scenes/originals/set061_3.png', 'path': 'images/scenes/originals/set061_3.png'},
    {'name': 'images/objects/originals/hunting rifle.png', 'path': 'images/objects/originals/hunting rifle.png'},
    {'name': 'images/objects/originals/rusty beartrap.png', 'path': 'images/objects/originals/rusty beartrap.png'},
    {'name': 'images/scenes/originals/set062_1.png', 'path': 'images/scenes/originals/set062_1.png'},
    {'name': 'images/objects/originals/bloody boots.png', 'path': 'images/objects/originals/bloody boots.png'},
    {'name': 'images/objects/originals/hunting knife.png', 'path': 'images/objects/originals/hunting knife.png'},
    {'name': 'images/scenes/originals/set062_3.png', 'path': 'images/scenes/originals/set062_3.png'},
    {'name': 'images/objects/originals/dead rat bodies.png', 'path': 'images/objects/originals/dead rat bodies.png'},
    {'name': 'images/objects/originals/rusty gas canister.png', 'path': 'images/objects/originals/rusty gas canister.png'},
    {'name': 'images/scenes/originals/set064_3.png', 'path': 'images/scenes/originals/set064_3.png'},
    {'name': 'images/objects/originals/broken car bumper.png', 'path': 'images/objects/originals/broken car bumper.png'},
    {'name': 'images/scenes/originals/set065_1.png', 'path': 'images/scenes/originals/set065_1.png'},
    {'name': 'images/objects/originals/bloody tubes.png', 'path': 'images/objects/originals/bloody tubes.png'},
    {'name': 'images/objects/originals/respitory mask for animals.png', 'path': 'images/objects/originals/respitory mask for animals.png'},
    {'name': 'images/scenes/originals/set065_2.png', 'path': 'images/scenes/originals/set065_2.png'},
    {'name': 'images/objects/originals/rusty hooks.png', 'path': 'images/objects/originals/rusty hooks.png'},
    {'name': 'images/objects/originals/bloody rubbish bag.png', 'path': 'images/objects/originals/bloody rubbish bag.png'},
    {'name': 'images/scenes/originals/set054_3.png', 'path': 'images/scenes/originals/set054_3.png'},
    {'name': 'images/objects/originals/flies.png', 'path': 'images/objects/originals/flies.png'},
    {'name': 'images/scenes/originals/set081_2.png', 'path': 'images/scenes/originals/set081_2.png'},
    {'name': 'images/objects/originals/vulture.png', 'path': 'images/objects/originals/vulture.png'},
    {'name': 'images/objects/originals/animal droppings.png', 'path': 'images/objects/originals/animal droppings.png'},
    {'name': 'images/scenes/originals/set089_2.png', 'path': 'images/scenes/originals/set089_2.png'},
    {'name': 'images/objects/originals/rusty buoy.png', 'path': 'images/objects/originals/rusty buoy.png'},
    {'name': 'images/objects/originals/broken life jacket.png', 'path': 'images/objects/originals/broken life jacket.png'},
    {'name': 'images/scenes/originals/set095_1.png', 'path': 'images/scenes/originals/set095_1.png'},
    {'name': 'images/objects/originals/dead possum.png', 'path': 'images/objects/originals/dead possum.png'},
    {'name': 'images/objects/originals/dead bird.png', 'path': 'images/objects/originals/dead bird.png'},
    {'name': 'images/objects/originals/dirty and holey boots.png', 'path': 'images/objects/originals/dirty and holey boots.png'},
    {'name': 'images/scenes/originals/set104_1.png', 'path': 'images/scenes/originals/set104_1.png'},
    {'name': 'images/objects/originals/dead insect.png', 'path': 'images/objects/originals/dead insect.png'},
    {'name': 'images/objects/originals/empty spider cage.png', 'path': 'images/objects/originals/empty spider cage.png'},
    {'name': 'images/scenes/originals/set107_3.png', 'path': 'images/scenes/originals/set107_3.png'},
    {'name': 'images/objects/originals/animal hunting net.png', 'path': 'images/objects/originals/animal hunting net.png'},
    {'name': 'images/objects/originals/rotten animal meat.png', 'path': 'images/objects/originals/rotten animal meat.png'},
    {'name': 'images/scenes/originals/set109_1.png', 'path': 'images/scenes/originals/set109_1.png'},
    {'name': 'images/objects/originals/broken boat.png', 'path': 'images/objects/originals/broken boat.png'},
    {'name': 'images/scenes/originals/set110_1.png', 'path': 'images/scenes/originals/set110_1.png'},
    {'name': 'images/objects/originals/bloody muzzle.png', 'path': 'images/objects/originals/bloody muzzle.png'},
    {'name': 'images/objects/originals/torn leather glove.png', 'path': 'images/objects/originals/torn leather glove.png'},
    {'name': 'images/scenes/originals/set111_3.png', 'path': 'images/scenes/originals/set111_3.png'},
    {'name': 'images/objects/originals/broken cage.png', 'path': 'images/objects/originals/broken cage.png'},
    {'name': 'images/objects/originals/broken wooden fences.png', 'path': 'images/objects/originals/broken wooden fences.png'},
    {'name': 'images/scenes/originals/set113_3.png', 'path': 'images/scenes/originals/set113_3.png'},
    {'name': 'images/objects/originals/bloody tshirt.png', 'path': 'images/objects/originals/bloody tshirt.png'},
    {'name': 'images/objects/originals/torn jacket.png', 'path': 'images/objects/originals/torn jacket.png'},
    {'name': 'images/scenes/originals/set116_1.png', 'path': 'images/scenes/originals/set116_1.png'},
    {'name': 'images/objects/originals/pile of rubbish.png', 'path': 'images/objects/originals/pile of rubbish.png'},
    {'name': 'images/objects/originals/spoiled fruits.png', 'path': 'images/objects/originals/spoiled fruits.png'},
    {'name': 'images/scenes/originals/set116_3.png', 'path': 'images/scenes/originals/set116_3.png'},
    {'name': 'images/objects/originals/rusty shovel.png', 'path': 'images/objects/originals/rusty shovel.png'},
    {'name': 'images/objects/originals/food waste bin.png', 'path': 'images/objects/originals/food waste bin.png'},
    {'name': 'images/objects/originals/rotten watermelon.png', 'path': 'images/objects/originals/rotten watermelon.png'},
    {'name': 'images/scenes/originals/set132_3.png', 'path': 'images/scenes/originals/set132_3.png'},
    {'name': 'images/objects/originals/burnt animal body.png', 'path': 'images/objects/originals/burnt animal body.png'},
    {'name': 'images/objects/originals/broken smartphone.png', 'path': 'images/objects/originals/broken smartphone.png'},
    {'name': 'images/scenes/originals/set247_5.png', 'path': 'images/scenes/originals/set247_5.png'},
    {'name': 'images/objects/originals/bent car door.png', 'path': 'images/objects/originals/bent car door.png'},
    {'name': 'images/objects/originals/dead cow.png', 'path': 'images/objects/originals/dead cow.png'},
    {'name': 'images/scenes/originals/set252_3.png', 'path': 'images/scenes/originals/set252_3.png'},
    {'name': 'images/objects/originals/burnt trees.png', 'path': 'images/objects/originals/burnt trees.png'},
    {'name': 'images/objects/originals/fire extinguisher.png', 'path': 'images/objects/originals/fire extinguisher.png'},
    {'name': 'images/scenes/originals/set360_1.png', 'path': 'images/scenes/originals/set360_1.png'},
    {'name': 'images/objects/originals/needle pack.png', 'path': 'images/objects/originals/needle pack.png'},
    {'name': 'images/objects/originals/prescription pills.png', 'path': 'images/objects/originals/prescription pills.png'},
    {'name': 'images/scenes/originals/set361_1.png', 'path': 'images/scenes/originals/set361_1.png'},
    {'name': 'images/objects/originals/bloodsplattered mask.png', 'path': 'images/objects/originals/bloodsplattered mask.png'},
    {'name': 'images/objects/originals/bloodsoaked cotten balls.png', 'path': 'images/objects/originals/bloodsoaked cotten balls.png'},
    {'name': 'images/scenes/originals/set443_2.png', 'path': 'images/scenes/originals/set443_2.png'},
    {'name': 'images/objects/originals/bloodstained phone.png', 'path': 'images/objects/originals/bloodstained phone.png'},
    {'name': 'images/scenes/originals/set443_3.png', 'path': 'images/scenes/originals/set443_3.png'},
    {'name': 'images/objects/originals/defibrillator.png', 'path': 'images/objects/originals/defibrillator.png'},
    {'name': 'images/scenes/originals/set453_1.png', 'path': 'images/scenes/originals/set453_1.png'},
    {'name': 'images/objects/originals/bloody bone saw.png', 'path': 'images/objects/originals/bloody bone saw.png'},
    {'name': 'images/objects/originals/blooded bed sheet.png', 'path': 'images/objects/originals/blooded bed sheet.png'},
    {'name': 'images/scenes/originals/set454_1.png', 'path': 'images/scenes/originals/set454_1.png'},
    {'name': 'images/objects/originals/dirty bandage.png', 'path': 'images/objects/originals/dirty bandage.png'},
    {'name': 'images/objects/originals/dirty plaster.png', 'path': 'images/objects/originals/dirty plaster.png'},
    {'name': 'images/objects/originals/skin graft.png', 'path': 'images/objects/originals/skin graft.png'},
    {'name': 'images/scenes/originals/set466_2.png', 'path': 'images/scenes/originals/set466_2.png'},
    {'name': 'images/objects/originals/blood transfusion packs.png', 'path': 'images/objects/originals/blood transfusion packs.png'},
    {'name': 'images/scenes/originals/set466_3.png', 'path': 'images/scenes/originals/set466_3.png'},
    {'name': 'images/objects/originals/bloodied greeen scrubs.png', 'path': 'images/objects/originals/bloodied greeen scrubs.png'},
    {'name': 'images/scenes/originals/set467_3.png', 'path': 'images/scenes/originals/set467_3.png'},
    {'name': 'images/objects/originals/bloody surgical hammer.png', 'path': 'images/objects/originals/bloody surgical hammer.png'},
    {'name': 'images/scenes/originals/set192_4.png', 'path': 'images/scenes/originals/set192_4.png'},
    {'name': 'images/objects/originals/burning hay.png', 'path': 'images/objects/originals/burning hay.png'},
    {'name': 'images/objects/originals/bloody children shoes.png', 'path': 'images/objects/originals/bloody children shoes.png'},
    {'name': 'images/scenes/originals/set654_1.png', 'path': 'images/scenes/originals/set654_1.png'},
    {'name': 'images/objects/originals/vomit.png', 'path': 'images/objects/originals/vomit.png'},
    {'name': 'images/objects/originals/dirty shoes.png', 'path': 'images/objects/originals/dirty shoes.png'},
    {'name': 'images/objects/originals/dirty toilet paper.png', 'path': 'images/objects/originals/dirty toilet paper.png'},
    {'name': 'images/scenes/originals/set654_2.png', 'path': 'images/scenes/originals/set654_2.png'},
    {'name': 'images/objects/originals/damp pile of clothes.png', 'path': 'images/objects/originals/damp pile of clothes.png'},
    {'name': 'images/objects/originals/dirty toilet brush.png', 'path': 'images/objects/originals/dirty toilet brush.png'},
    {'name': 'images/objects/originals/klorix.png', 'path': 'images/objects/originals/klorix.png'},
    {'name': 'images/scenes/originals/set654_3.png', 'path': 'images/scenes/originals/set654_3.png'},
    {'name': 'images/objects/originals/bin with dirty toilet papers.png', 'path': 'images/objects/originals/bin with dirty toilet papers.png'},
    {'name': 'images/scenes/originals/set168_1.png', 'path': 'images/scenes/originals/set168_1.png'},
    {'name': 'images/objects/originals/dirty wooden board.png', 'path': 'images/objects/originals/dirty wooden board.png'},
    {'name': 'images/objects/originals/toppled rubbish bin.png', 'path': 'images/objects/originals/toppled rubbish bin.png'},
    {'name': 'images/scenes/originals/set656_3.png', 'path': 'images/scenes/originals/set656_3.png'},
    {'name': 'images/objects/originals/broken poop bag.png', 'path': 'images/objects/originals/broken poop bag.png'},
    {'name': 'images/objects/originals/rusty rubbish tweezers.png', 'path': 'images/objects/originals/rusty rubbish tweezers.png'},
    {'name': 'images/scenes/originals/set680_1.png', 'path': 'images/scenes/originals/set680_1.png'},
    {'name': 'images/objects/originals/bloodied clothings.png', 'path': 'images/objects/originals/bloodied clothings.png'},
    {'name': 'images/scenes/originals/set170_4.png', 'path': 'images/scenes/originals/set170_4.png'},
    {'name': 'images/objects/originals/mouldy food.png', 'path': 'images/objects/originals/mouldy food.png'},
    {'name': 'images/scenes/originals/set169_1.png', 'path': 'images/scenes/originals/set169_1.png'},
    {'name': 'images/objects/originals/animal eyes extracted.png', 'path': 'images/objects/originals/animal eyes extracted.png'},
    {'name': 'images/scenes/originals/set683_1.png', 'path': 'images/scenes/originals/set683_1.png'},
    {'name': 'images/objects/originals/firetruck.png', 'path': 'images/objects/originals/firetruck.png'},
    {'name': 'images/objects/originals/molten plastic toy.png', 'path': 'images/objects/originals/molten plastic toy.png'},
    {'name': 'images/objects/originals/broken suitcase.png', 'path': 'images/objects/originals/broken suitcase.png'},
    {'name': 'images/scenes/originals/set683_2.png', 'path': 'images/scenes/originals/set683_2.png'},
    {'name': 'images/objects/originals/broken car wheel.png', 'path': 'images/objects/originals/broken car wheel.png'},
    {'name': 'images/scenes/originals/set207_3.png', 'path': 'images/scenes/originals/set207_3.png'},
    {'name': 'images/objects/originals/half-eaten rotten fruit.png', 'path': 'images/objects/originals/half-eaten rotten fruit.png'},
    {'name': 'images/scenes/originals/set691_2.png', 'path': 'images/scenes/originals/set691_2.png'},
    {'name': 'images/objects/originals/dirty abandoned doll.png', 'path': 'images/objects/originals/dirty abandoned doll.png'},
    {'name': 'images/objects/originals/dusty gas mask.png', 'path': 'images/objects/originals/dusty gas mask.png'},
    {'name': 'images/scenes/originals/set692_3.png', 'path': 'images/scenes/originals/set692_3.png'},
    {'name': 'images/objects/originals/dirty sink.png', 'path': 'images/objects/originals/dirty sink.png'},
    {'name': 'images/objects/originals/prison clothing.png', 'path': 'images/objects/originals/prison clothing.png'},
    {'name': 'images/scenes/originals/set695_1.png', 'path': 'images/scenes/originals/set695_1.png'},
    {'name': 'images/objects/originals/atomic bomb.png', 'path': 'images/objects/originals/atomic bomb.png'},
    {'name': 'images/objects/originals/broken goggles.png', 'path': 'images/objects/originals/broken goggles.png'},
    {'name': 'images/scenes/originals/set695_4.png', 'path': 'images/scenes/originals/set695_4.png'},
    {'name': 'images/objects/originals/broken watch.png', 'path': 'images/objects/originals/broken watch.png'},
    {'name': 'images/scenes/originals/set193_2.png', 'path': 'images/scenes/originals/set193_2.png'},
    {'name': 'images/objects/originals/wet and dirty mattress.png', 'path': 'images/objects/originals/wet and dirty mattress.png'},
    {'name': 'default.png', 'path': 'https://pavlovia.org/assets/default/default.png'},
  ]
});

psychoJS.experimentLogger.setLevel(core.Logger.ServerLevel.EXP);


var currentLoop;
var frameDur;
async function updateInfo() {
  currentLoop = psychoJS.experiment;  // right now there are no loops
  expInfo['date'] = util.MonotonicClock.getDateStr();  // add a simple timestamp
  expInfo['expName'] = expName;
  expInfo['psychopyVersion'] = '2023.1.3';
  expInfo['OS'] = window.navigator.platform;


  // store frame rate of monitor if we can measure it successfully
  expInfo['frameRate'] = psychoJS.window.getActualFrameRate();
  if (typeof expInfo['frameRate'] !== 'undefined')
    frameDur = 1.0 / Math.round(expInfo['frameRate']);
  else
    frameDur = 1.0 / 60.0; // couldn't get a reliable measure so guess

  // add info from the URL:
  util.addInfoFromUrl(expInfo);
  

  
  psychoJS.experiment.dataFileName = (("." + "/") + `data/${expInfo["participant"]}_${expName}_${expInfo["date"]}`);


  return Scheduler.Event.NEXT;
}


var introductionClock;
var introduction_text;
var text_introduction_button;
var mouse_2;
var recognitionClock;
var score;
var question_emotional;
var image_top_3;
var image_left;
var image_middle;
var image_right;
var mouse;
var feedbackClock;
var textbox;
var solutionClock;
var image_top_solution;
var image_solution;
var endClock;
var textbox_2;
var textbox_3;
var polygon;
var mouse_3;
var globalClock;
var routineTimer;
async function experimentInit() {
  // Initialize components for Routine "introduction"
  introductionClock = new util.Clock();
  introduction_text = new visual.TextBox({
    win: psychoJS.window,
    name: 'introduction_text',
    text: 'Willkommen zur Online-Version des Experiments! Die Online-Aufgabe ist gleich dem zweiten Teil der Aufgabe, die Sie vor Ort gemacht haben. Sie bekommen diesmal gleich die Szene dargestellt und sollen anschließend jenes Objekt durch Anklicken auswählen, das mit der entsprechenden Szene verbunden war. Danach wird Ihnen wieder kurz die richtige Lösung präsentiert.\nDiese Aufgabe sollen Sie das erste Mal am nächsten Tag und dann alle drei Tage durchführen; d.h. über die kommenden 2 Wochen hinweg insgesamt\xa05-mal.',
    placeholder: 'Type here...',
    font: 'Open Sans',
    pos: [0, 0.1], 
    letterHeight: 0.04,
    lineSpacing: 1.0,
    size: [1.6, 0.5],  units: undefined, 
    color: [(- 1.0), (- 1.0), (- 1.0)], colorSpace: 'rgb',
    fillColor: [0.3255, 0.3255, 0.3255], borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: 0.0 
  });
  
  text_introduction_button = new visual.TextBox({
    win: psychoJS.window,
    name: 'text_introduction_button',
    text: 'Drücken Sie hier, um anzufangen',
    placeholder: 'Type here...',
    font: 'Open Sans',
    pos: [0, (- 0.3)], 
    letterHeight: 0.04,
    lineSpacing: 1.0,
    size: [0.5, 0.25],  units: undefined, 
    color: [(- 1.0), (- 1.0), (- 1.0)], colorSpace: 'rgb',
    fillColor: [0.3255, 0.3255, 0.3255], borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -1.0 
  });
  
  mouse_2 = new core.Mouse({
    win: psychoJS.window,
  });
  mouse_2.mouseClock = new util.Clock();
  // Initialize components for Routine "recognition"
  recognitionClock = new util.Clock();
  // Run 'Begin Experiment' code from feedback_code
  score = 0;
  
  question_emotional = new visual.TextBox({
    win: psychoJS.window,
    name: 'question_emotional',
    text: 'Welches Bild war links unten?',
    placeholder: 'Type here...',
    font: 'Open Sans',
    pos: [0, 0.2], 
    letterHeight: 0.05,
    lineSpacing: 1.2,
    size: [0.75, 0.2],  units: undefined, 
    color: [(- 1.0), (- 1.0), (- 1.0)], colorSpace: 'rgb',
    fillColor: [0.3255, 0.3255, 0.3255], borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -1.0 
  });
  
  image_top_3 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_top_3', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, 0.2], size : [0.6, 0.45],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -2.0 
  });
  image_left = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_left', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [(- 0.6), (- 0.2)], size : [0.5, 0.4],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -3.0 
  });
  image_middle = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_middle', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, (- 0.2)], size : [0.5, 0.4],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -4.0 
  });
  image_right = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_right', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0.6, (- 0.2)], size : [0.5, 0.4],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -5.0 
  });
  mouse = new core.Mouse({
    win: psychoJS.window,
  });
  mouse.mouseClock = new util.Clock();
  // Initialize components for Routine "feedback"
  feedbackClock = new util.Clock();
  textbox = new visual.TextBox({
    win: psychoJS.window,
    name: 'textbox',
    text: '',
    placeholder: 'Type here...',
    font: 'Open Sans',
    pos: [0, 0], 
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.4, 0.2],  units: undefined, 
    color: [(- 1.0), (- 1.0), (- 1.0)], colorSpace: 'rgb',
    fillColor: [0.3255, 0.3255, 0.3255], borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: 0.0 
  });
  
  // Initialize components for Routine "solution"
  solutionClock = new util.Clock();
  image_top_solution = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_top_solution', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, 0.2], size : [0.6, 0.45],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : 0.0 
  });
  image_solution = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_solution', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [(- 0.6), (- 0.2)], size : [0.5, 0.4],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -1.0 
  });
  // Initialize components for Routine "end"
  endClock = new util.Clock();
  textbox_2 = new visual.TextBox({
    win: psychoJS.window,
    name: 'textbox_2',
    text: 'Der Durchgang ist beendet. Drücken Sie auf den roten Kreis, um das Experiment zu beenden.',
    placeholder: 'Type here...',
    font: 'Open Sans',
    pos: [0, 0], 
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.8, 0.3],  units: undefined, 
    color: [(- 1.0), (- 1.0), (- 1.0)], colorSpace: 'rgb',
    fillColor: [0.3255, 0.3255, 0.3255], borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -1.0 
  });
  
  textbox_3 = new visual.TextBox({
    win: psychoJS.window,
    name: 'textbox_3',
    text: '',
    placeholder: 'Type here...',
    font: 'Open Sans',
    pos: [0, (- 0.35)], 
    letterHeight: 0.05,
    lineSpacing: 1.0,
    size: [0.5, 0.2],  units: undefined, 
    color: 'black', colorSpace: 'rgb',
    fillColor: [0.3255, 0.3255, 0.3255], borderColor: undefined,
    languageStyle: 'LTR',
    bold: false, italic: false,
    opacity: undefined,
    padding: 0.0,
    alignment: 'center',
    overflow: 'visible',
    editable: false,
    multiline: true,
    anchor: 'center',
    depth: -2.0 
  });
  
  polygon = new visual.Polygon({
    win: psychoJS.window, name: 'polygon', 
    edges: 100, size:[0.2, 0.2],
    ori: 0.0, pos: [0.75, 0],
    anchor: 'center',
    lineWidth: 1.0, 
    colorSpace: 'rgb',
    lineColor: new util.Color('red'),
    fillColor: new util.Color('red'),
    opacity: undefined, depth: -3, interpolate: true,
  });
  
  mouse_3 = new core.Mouse({
    win: psychoJS.window,
  });
  mouse_3.mouseClock = new util.Clock();
  // Create some handy timers
  globalClock = new util.Clock();  // to track the time since experiment started
  routineTimer = new util.CountdownTimer();  // to track time remaining of each (non-slip) routine
  
  return Scheduler.Event.NEXT;
}


var t;
var frameN;
var continueRoutine;
var gotValidClick;
var introductionComponents;
function introductionRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'introduction' ---
    t = 0;
    introductionClock.reset(); // clock
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    // update component parameters for each repeat
    // setup some python lists for storing info about the mouse_2
    // current position of the mouse:
    mouse_2.x = [];
    mouse_2.y = [];
    mouse_2.leftButton = [];
    mouse_2.midButton = [];
    mouse_2.rightButton = [];
    mouse_2.time = [];
    mouse_2.clicked_name = [];
    gotValidClick = false; // until a click is received
    // keep track of which components have finished
    introductionComponents = [];
    introductionComponents.push(introduction_text);
    introductionComponents.push(text_introduction_button);
    introductionComponents.push(mouse_2);
    
    for (const thisComponent of introductionComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


var prevButtonState;
var _mouseButtons;
var _mouseXYs;
function introductionRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'introduction' ---
    // get current time
    t = introductionClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *introduction_text* updates
    if (t >= 0.0 && introduction_text.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      introduction_text.tStart = t;  // (not accounting for frame time here)
      introduction_text.frameNStart = frameN;  // exact frame index
      
      introduction_text.setAutoDraw(true);
    }

    
    // *text_introduction_button* updates
    if (t >= 0.0 && text_introduction_button.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      text_introduction_button.tStart = t;  // (not accounting for frame time here)
      text_introduction_button.frameNStart = frameN;  // exact frame index
      
      text_introduction_button.setAutoDraw(true);
    }

    // *mouse_2* updates
    if (t >= 0.0 && mouse_2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      mouse_2.tStart = t;  // (not accounting for frame time here)
      mouse_2.frameNStart = frameN;  // exact frame index
      
      mouse_2.status = PsychoJS.Status.STARTED;
      mouse_2.mouseClock.reset();
      prevButtonState = mouse_2.getPressed();  // if button is down already this ISN'T a new click
      }
    if (mouse_2.status === PsychoJS.Status.STARTED) {  // only update if started and not finished!
      _mouseButtons = mouse_2.getPressed();
      if (!_mouseButtons.every( (e,i,) => (e == prevButtonState[i]) )) { // button state changed?
        prevButtonState = _mouseButtons;
        if (_mouseButtons.reduce( (e, acc) => (e+acc) ) > 0) { // state changed to a new click
          // check if the mouse was inside our 'clickable' objects
          gotValidClick = false;
          for (const obj of [text_introduction_button]) {
            if (obj.contains(mouse_2)) {
              gotValidClick = true;
              mouse_2.clicked_name.push(obj.name)
            }
          }
          _mouseXYs = mouse_2.getPos();
          mouse_2.x.push(_mouseXYs[0]);
          mouse_2.y.push(_mouseXYs[1]);
          mouse_2.leftButton.push(_mouseButtons[0]);
          mouse_2.midButton.push(_mouseButtons[1]);
          mouse_2.rightButton.push(_mouseButtons[2]);
          mouse_2.time.push(mouse_2.mouseClock.getTime());
          if (gotValidClick === true) { // end routine on response
            continueRoutine = false;
          }
        }
      }
    }
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of introductionComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function introductionRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'introduction' ---
    for (const thisComponent of introductionComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    // store data for psychoJS.experiment (ExperimentHandler)
    if (mouse_2.x) {  psychoJS.experiment.addData('mouse_2.x', mouse_2.x[0])};
    if (mouse_2.y) {  psychoJS.experiment.addData('mouse_2.y', mouse_2.y[0])};
    if (mouse_2.leftButton) {  psychoJS.experiment.addData('mouse_2.leftButton', mouse_2.leftButton[0])};
    if (mouse_2.midButton) {  psychoJS.experiment.addData('mouse_2.midButton', mouse_2.midButton[0])};
    if (mouse_2.rightButton) {  psychoJS.experiment.addData('mouse_2.rightButton', mouse_2.rightButton[0])};
    if (mouse_2.time) {  psychoJS.experiment.addData('mouse_2.time', mouse_2.time[0])};
    if (mouse_2.clicked_name) {  psychoJS.experiment.addData('mouse_2.clicked_name', mouse_2.clicked_name[0])};
    
    // the Routine "introduction" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var trials;
function trialsLoopBegin(trialsLoopScheduler, snapshot) {
  return async function() {
    TrialHandler.fromSnapshot(snapshot); // update internal variables (.thisN etc) of the loop
    
    // set up handler to look after randomisation of conditions etc
    trials = new TrialHandler({
      psychoJS: psychoJS,
      nReps: 1, method: TrialHandler.Method.RANDOM,
      extraInfo: expInfo, originPath: undefined,
      trialList: 'Excel_online_training_emotional.xlsx',
      seed: undefined, name: 'trials'
    });
    psychoJS.experiment.addLoop(trials); // add the loop to the experiment
    currentLoop = trials;  // we're now the current loop
    
    // Schedule all the trials in the trialList:
    for (const thisTrial of trials) {
      snapshot = trials.getSnapshot();
      trialsLoopScheduler.add(importConditions(snapshot));
      trialsLoopScheduler.add(recognitionRoutineBegin(snapshot));
      trialsLoopScheduler.add(recognitionRoutineEachFrame());
      trialsLoopScheduler.add(recognitionRoutineEnd(snapshot));
      trialsLoopScheduler.add(feedbackRoutineBegin(snapshot));
      trialsLoopScheduler.add(feedbackRoutineEachFrame());
      trialsLoopScheduler.add(feedbackRoutineEnd(snapshot));
      trialsLoopScheduler.add(solutionRoutineBegin(snapshot));
      trialsLoopScheduler.add(solutionRoutineEachFrame());
      trialsLoopScheduler.add(solutionRoutineEnd(snapshot));
      trialsLoopScheduler.add(trialsLoopEndIteration(trialsLoopScheduler, snapshot));
    }
    
    return Scheduler.Event.NEXT;
  }
}


async function trialsLoopEnd() {
  // terminate loop
  psychoJS.experiment.removeLoop(trials);
  // update the current loop from the ExperimentHandler
  if (psychoJS.experiment._unfinishedLoops.length>0)
    currentLoop = psychoJS.experiment._unfinishedLoops.at(-1);
  else
    currentLoop = psychoJS.experiment;  // so we use addData from the experiment
  return Scheduler.Event.NEXT;
}


function trialsLoopEndIteration(scheduler, snapshot) {
  // ------Prepare for next entry------
  return async function () {
    if (typeof snapshot !== 'undefined') {
      // ------Check if user ended loop early------
      if (snapshot.finished) {
        // Check for and save orphaned data
        if (psychoJS.experiment.isEntryEmpty()) {
          psychoJS.experiment.nextEntry(snapshot);
        }
        scheduler.stop();
      } else {
        psychoJS.experiment.nextEntry(snapshot);
      }
    return Scheduler.Event.NEXT;
    }
  };
}


var recognitionComponents;
function recognitionRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'recognition' ---
    t = 0;
    recognitionClock.reset(); // clock
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    // update component parameters for each repeat
    image_top_3.setImage(Picture_Recognition);
    image_left.setImage(Q1_l);
    image_middle.setImage(Q1_m);
    image_right.setImage(Q1_r);
    // setup some python lists for storing info about the mouse
    // current position of the mouse:
    mouse.x = [];
    mouse.y = [];
    mouse.leftButton = [];
    mouse.midButton = [];
    mouse.rightButton = [];
    mouse.time = [];
    mouse.clicked_name = [];
    gotValidClick = false; // until a click is received
    // keep track of which components have finished
    recognitionComponents = [];
    recognitionComponents.push(question_emotional);
    recognitionComponents.push(image_top_3);
    recognitionComponents.push(image_left);
    recognitionComponents.push(image_middle);
    recognitionComponents.push(image_right);
    recognitionComponents.push(mouse);
    
    for (const thisComponent of recognitionComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


var frameRemains;
function recognitionRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'recognition' ---
    // get current time
    t = recognitionClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *question_emotional* updates
    if (t >= 2.1 && question_emotional.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      question_emotional.tStart = t;  // (not accounting for frame time here)
      question_emotional.frameNStart = frameN;  // exact frame index
      
      question_emotional.setAutoDraw(true);
    }

    
    // *image_top_3* updates
    if (t >= 0 && image_top_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      image_top_3.tStart = t;  // (not accounting for frame time here)
      image_top_3.frameNStart = frameN;  // exact frame index
      
      image_top_3.setAutoDraw(true);
    }

    frameRemains = 0 + 1.6 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (image_top_3.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      image_top_3.setAutoDraw(false);
    }
    
    // *image_left* updates
    if (t >= 2.1 && image_left.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      image_left.tStart = t;  // (not accounting for frame time here)
      image_left.frameNStart = frameN;  // exact frame index
      
      image_left.setAutoDraw(true);
    }

    
    // *image_middle* updates
    if (t >= 2.1 && image_middle.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      image_middle.tStart = t;  // (not accounting for frame time here)
      image_middle.frameNStart = frameN;  // exact frame index
      
      image_middle.setAutoDraw(true);
    }

    
    // *image_right* updates
    if (t >= 2.1 && image_right.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      image_right.tStart = t;  // (not accounting for frame time here)
      image_right.frameNStart = frameN;  // exact frame index
      
      image_right.setAutoDraw(true);
    }

    // *mouse* updates
    if (t >= 2.1 && mouse.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      mouse.tStart = t;  // (not accounting for frame time here)
      mouse.frameNStart = frameN;  // exact frame index
      
      mouse.status = PsychoJS.Status.STARTED;
      mouse.mouseClock.reset();
      prevButtonState = mouse.getPressed();  // if button is down already this ISN'T a new click
      }
    if (mouse.status === PsychoJS.Status.STARTED) {  // only update if started and not finished!
      _mouseButtons = mouse.getPressed();
      if (!_mouseButtons.every( (e,i,) => (e == prevButtonState[i]) )) { // button state changed?
        prevButtonState = _mouseButtons;
        if (_mouseButtons.reduce( (e, acc) => (e+acc) ) > 0) { // state changed to a new click
          // check if the mouse was inside our 'clickable' objects
          gotValidClick = false;
          for (const obj of [image_left,image_middle,image_right]) {
            if (obj.contains(mouse)) {
              gotValidClick = true;
              mouse.clicked_name.push(obj.name)
            }
          }
          _mouseXYs = mouse.getPos();
          mouse.x.push(_mouseXYs[0]);
          mouse.y.push(_mouseXYs[1]);
          mouse.leftButton.push(_mouseButtons[0]);
          mouse.midButton.push(_mouseButtons[1]);
          mouse.rightButton.push(_mouseButtons[2]);
          mouse.time.push(mouse.mouseClock.getTime());
          if (gotValidClick === true) { // end routine on response
            continueRoutine = false;
          }
        }
      }
    }
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of recognitionComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


var ID;
var condition;
var stage;
var round0;
var scene;
var correct_object;
var memory_resp;
var memory_rt;
var accuracy;
var x;
var y;
var this_feedback;
function recognitionRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'recognition' ---
    for (const thisComponent of recognitionComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    // Run 'End Routine' code from feedback_code
    ID = expInfo["participant"];
    condition = "e";
    stage = "main";
    round0 = 0;
    scene = Picture_Recognition;
    correct_object = Picture_Recognition_2;
    if ((mouse.clicked_name[0] === "image_left")) {
        memory_resp = Q1_l;
    } else {
        if ((mouse.clicked_name[0] === "image_middle")) {
            memory_resp = Q1_m;
        } else {
            if ((mouse.clicked_name[0] === "image_right")) {
                memory_resp = Q1_r;
            } else {
                throw RuntimeError;
            }
        }
    }
    memory_rt = mouse.time[0];
    if ((memory_resp === correct_object)) {
        accuracy = 1;
    } else {
        accuracy = 0;
    }
    x = mouse.x;
    y = mouse.y;
    if ((accuracy === 1)) {
        this_feedback = "Korrekt";
        score += 1;
    } else {
        this_feedback = "Nicht korrekt";
    }
    trials.addData("condition", condition);
    trials.addData("stage", stage);
    trials.addData("scene", scene);
    trials.addData("correct object", correct_object);
    trials.addData("left option", Q1_l);
    trials.addData("middle option", Q1_m);
    trials.addData("right option", Q1_r);
    trials.addData("memory resp", memory_resp);
    trials.addData("memory rt", memory_rt);
    trials.addData("accuracy", accuracy);
    trials.addData("score", score);
    trials.addData("x mouse", x);
    trials.addData("y mouse", y);
    trials.addData("internal lure", internal_lure);
    trials.addData("external lure", external_lure);
    
    // store data for psychoJS.experiment (ExperimentHandler)
    if (mouse.x) {  psychoJS.experiment.addData('mouse.x', mouse.x[0])};
    if (mouse.y) {  psychoJS.experiment.addData('mouse.y', mouse.y[0])};
    if (mouse.leftButton) {  psychoJS.experiment.addData('mouse.leftButton', mouse.leftButton[0])};
    if (mouse.midButton) {  psychoJS.experiment.addData('mouse.midButton', mouse.midButton[0])};
    if (mouse.rightButton) {  psychoJS.experiment.addData('mouse.rightButton', mouse.rightButton[0])};
    if (mouse.time) {  psychoJS.experiment.addData('mouse.time', mouse.time[0])};
    if (mouse.clicked_name) {  psychoJS.experiment.addData('mouse.clicked_name', mouse.clicked_name[0])};
    
    // the Routine "recognition" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var feedbackComponents;
function feedbackRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'feedback' ---
    t = 0;
    feedbackClock.reset(); // clock
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    routineTimer.add(1.000000);
    // update component parameters for each repeat
    textbox.setText(this_feedback);
    // keep track of which components have finished
    feedbackComponents = [];
    feedbackComponents.push(textbox);
    
    for (const thisComponent of feedbackComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


function feedbackRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'feedback' ---
    // get current time
    t = feedbackClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *textbox* updates
    if (t >= 0.0 && textbox.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textbox.tStart = t;  // (not accounting for frame time here)
      textbox.frameNStart = frameN;  // exact frame index
      
      textbox.setAutoDraw(true);
    }

    frameRemains = 0.0 + 1.0 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (textbox.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      textbox.setAutoDraw(false);
    }
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of feedbackComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine && routineTimer.getTime() > 0) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function feedbackRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'feedback' ---
    for (const thisComponent of feedbackComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var solutionComponents;
function solutionRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'solution' ---
    t = 0;
    solutionClock.reset(); // clock
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    routineTimer.add(3.100000);
    // update component parameters for each repeat
    image_top_solution.setImage(Picture_Recognition);
    image_solution.setImage(Picture_Recognition_2);
    // keep track of which components have finished
    solutionComponents = [];
    solutionComponents.push(image_top_solution);
    solutionComponents.push(image_solution);
    
    for (const thisComponent of solutionComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


function solutionRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'solution' ---
    // get current time
    t = solutionClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *image_top_solution* updates
    if (t >= 1.1 && image_top_solution.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      image_top_solution.tStart = t;  // (not accounting for frame time here)
      image_top_solution.frameNStart = frameN;  // exact frame index
      
      image_top_solution.setAutoDraw(true);
    }

    frameRemains = 1.1 + 2 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (image_top_solution.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      image_top_solution.setAutoDraw(false);
    }
    
    // *image_solution* updates
    if (t >= 1.1 && image_solution.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      image_solution.tStart = t;  // (not accounting for frame time here)
      image_solution.frameNStart = frameN;  // exact frame index
      
      image_solution.setAutoDraw(true);
    }

    frameRemains = 1.1 + 2 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (image_solution.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      image_solution.setAutoDraw(false);
    }
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of solutionComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine && routineTimer.getTime() > 0) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function solutionRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'solution' ---
    for (const thisComponent of solutionComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


var final_score;
var endComponents;
function endRoutineBegin(snapshot) {
  return async function () {
    TrialHandler.fromSnapshot(snapshot); // ensure that .thisN vals are up to date
    
    //--- Prepare to start Routine 'end' ---
    t = 0;
    endClock.reset(); // clock
    frameN = -1;
    continueRoutine = true; // until we're told otherwise
    // update component parameters for each repeat
    // Run 'Begin Routine' code from score
    final_score = `Erreichter Score: ${((score / 60) * 100)}%`;
    
    textbox_3.setText(final_score);
    // setup some python lists for storing info about the mouse_3
    // current position of the mouse:
    mouse_3.x = [];
    mouse_3.y = [];
    mouse_3.leftButton = [];
    mouse_3.midButton = [];
    mouse_3.rightButton = [];
    mouse_3.time = [];
    mouse_3.clicked_name = [];
    gotValidClick = false; // until a click is received
    // keep track of which components have finished
    endComponents = [];
    endComponents.push(textbox_2);
    endComponents.push(textbox_3);
    endComponents.push(polygon);
    endComponents.push(mouse_3);
    
    for (const thisComponent of endComponents)
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
    return Scheduler.Event.NEXT;
  }
}


function endRoutineEachFrame() {
  return async function () {
    //--- Loop for each frame of Routine 'end' ---
    // get current time
    t = endClock.getTime();
    frameN = frameN + 1;// number of completed frames (so 0 is the first frame)
    // update/draw components on each frame
    
    // *textbox_2* updates
    if (t >= 0.0 && textbox_2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textbox_2.tStart = t;  // (not accounting for frame time here)
      textbox_2.frameNStart = frameN;  // exact frame index
      
      textbox_2.setAutoDraw(true);
    }

    
    // *textbox_3* updates
    if (t >= 0.0 && textbox_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      textbox_3.tStart = t;  // (not accounting for frame time here)
      textbox_3.frameNStart = frameN;  // exact frame index
      
      textbox_3.setAutoDraw(true);
    }

    
    // *polygon* updates
    if (t >= 0.0 && polygon.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      polygon.tStart = t;  // (not accounting for frame time here)
      polygon.frameNStart = frameN;  // exact frame index
      
      polygon.setAutoDraw(true);
    }

    // *mouse_3* updates
    if (t >= 0.0 && mouse_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      mouse_3.tStart = t;  // (not accounting for frame time here)
      mouse_3.frameNStart = frameN;  // exact frame index
      
      mouse_3.status = PsychoJS.Status.STARTED;
      mouse_3.mouseClock.reset();
      prevButtonState = mouse_3.getPressed();  // if button is down already this ISN'T a new click
      }
    if (mouse_3.status === PsychoJS.Status.STARTED) {  // only update if started and not finished!
      _mouseButtons = mouse_3.getPressed();
      if (!_mouseButtons.every( (e,i,) => (e == prevButtonState[i]) )) { // button state changed?
        prevButtonState = _mouseButtons;
        if (_mouseButtons.reduce( (e, acc) => (e+acc) ) > 0) { // state changed to a new click
          // check if the mouse was inside our 'clickable' objects
          gotValidClick = false;
          for (const obj of [polygon]) {
            if (obj.contains(mouse_3)) {
              gotValidClick = true;
              mouse_3.clicked_name.push(obj.name)
            }
          }
          _mouseXYs = mouse_3.getPos();
          mouse_3.x.push(_mouseXYs[0]);
          mouse_3.y.push(_mouseXYs[1]);
          mouse_3.leftButton.push(_mouseButtons[0]);
          mouse_3.midButton.push(_mouseButtons[1]);
          mouse_3.rightButton.push(_mouseButtons[2]);
          mouse_3.time.push(mouse_3.mouseClock.getTime());
          if (gotValidClick === true) { // end routine on response
            continueRoutine = false;
          }
        }
      }
    }
    // check for quit (typically the Esc key)
    if (psychoJS.experiment.experimentEnded || psychoJS.eventManager.getKeys({keyList:['escape']}).length > 0) {
      return quitPsychoJS('The [Escape] key was pressed. Goodbye!', false);
    }
    
    // check if the Routine should terminate
    if (!continueRoutine) {  // a component has requested a forced-end of Routine
      return Scheduler.Event.NEXT;
    }
    
    continueRoutine = false;  // reverts to True if at least one component still running
    for (const thisComponent of endComponents)
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
        break;
      }
    
    // refresh the screen if continuing
    if (continueRoutine) {
      return Scheduler.Event.FLIP_REPEAT;
    } else {
      return Scheduler.Event.NEXT;
    }
  };
}


function endRoutineEnd(snapshot) {
  return async function () {
    //--- Ending Routine 'end' ---
    for (const thisComponent of endComponents) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    }
    // store data for psychoJS.experiment (ExperimentHandler)
    if (mouse_3.x) {  psychoJS.experiment.addData('mouse_3.x', mouse_3.x[0])};
    if (mouse_3.y) {  psychoJS.experiment.addData('mouse_3.y', mouse_3.y[0])};
    if (mouse_3.leftButton) {  psychoJS.experiment.addData('mouse_3.leftButton', mouse_3.leftButton[0])};
    if (mouse_3.midButton) {  psychoJS.experiment.addData('mouse_3.midButton', mouse_3.midButton[0])};
    if (mouse_3.rightButton) {  psychoJS.experiment.addData('mouse_3.rightButton', mouse_3.rightButton[0])};
    if (mouse_3.time) {  psychoJS.experiment.addData('mouse_3.time', mouse_3.time[0])};
    if (mouse_3.clicked_name) {  psychoJS.experiment.addData('mouse_3.clicked_name', mouse_3.clicked_name[0])};
    
    // the Routine "end" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset();
    
    // Routines running outside a loop should always advance the datafile row
    if (currentLoop === psychoJS.experiment) {
      psychoJS.experiment.nextEntry(snapshot);
    }
    return Scheduler.Event.NEXT;
  }
}


function importConditions(currentLoop) {
  return async function () {
    psychoJS.importAttributes(currentLoop.getCurrentTrial());
    return Scheduler.Event.NEXT;
    };
}


async function quitPsychoJS(message, isCompleted) {
  // Check for and save orphaned data
  if (psychoJS.experiment.isEntryEmpty()) {
    psychoJS.experiment.nextEntry();
  }
  
  
  
  
  psychoJS.window.close();
  psychoJS.quit({message: message, isCompleted: isCompleted});
  
  return Scheduler.Event.QUIT;
}
