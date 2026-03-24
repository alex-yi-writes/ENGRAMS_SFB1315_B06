/*************************** 
 * N_Forgetting_Curve Test *
 ***************************/

import { core, data, sound, util, visual, hardware } from './lib/psychojs-2023.1.3.js';
const { PsychoJS } = core;
const { TrialHandler, MultiStairHandler } = data;
const { Scheduler } = util;
//some handy aliases as in the psychopy scripts;
const { abs, sin, cos, PI: pi, sqrt } = Math;
const { round } = util;


// store info about the experiment session:
let expName = 'N_forgetting_curve';  // from the Builder filename that created this script
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
  fullscr: true,
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
    {'name': 'Excel_forgetting_curve_neutral.xlsx', 'path': 'Excel_forgetting_curve_neutral.xlsx'},
    {'name': 'images/scenes/wasserturm.png', 'path': 'images/scenes/wasserturm.png'},
    {'name': 'images/objects/satellit.png', 'path': 'images/objects/satellit.png'},
    {'name': 'images/objects/altes_telefon.png', 'path': 'images/objects/altes_telefon.png'},
    {'name': 'images/objects/alte_holztur.png', 'path': 'images/objects/alte_holztur.png'},
    {'name': 'images/scenes/bushaltestelle.png', 'path': 'images/scenes/bushaltestelle.png'},
    {'name': 'images/objects/reisetasche.png', 'path': 'images/objects/reisetasche.png'},
    {'name': 'images/objects/kutsche.png', 'path': 'images/objects/kutsche.png'},
    {'name': 'images/objects/schulbus.png', 'path': 'images/objects/schulbus.png'},
    {'name': 'images/scenes/altstadt.png', 'path': 'images/scenes/altstadt.png'},
    {'name': 'images/objects/glocken.png', 'path': 'images/objects/glocken.png'},
    {'name': 'images/objects/kopfsteinpflaster.png', 'path': 'images/objects/kopfsteinpflaster.png'},
    {'name': 'images/objects/wasche.png', 'path': 'images/objects/wasche.png'},
    {'name': 'images/scenes/fitnessstudio.png', 'path': 'images/scenes/fitnessstudio.png'},
    {'name': 'images/objects/fon.png', 'path': 'images/objects/fon.png'},
    {'name': 'images/objects/gymnastikball.png', 'path': 'images/objects/gymnastikball.png'},
    {'name': 'images/objects/schlusselbund.png', 'path': 'images/objects/schlusselbund.png'},
    {'name': 'images/scenes/esszimmer.png', 'path': 'images/scenes/esszimmer.png'},
    {'name': 'images/objects/reiskocher.png', 'path': 'images/objects/reiskocher.png'},
    {'name': 'images/objects/kurbis.png', 'path': 'images/objects/kurbis.png'},
    {'name': 'images/objects/weinflasche.png', 'path': 'images/objects/weinflasche.png'},
    {'name': 'images/scenes/arbeitszimmer.png', 'path': 'images/scenes/arbeitszimmer.png'},
    {'name': 'images/objects/leselampe.png', 'path': 'images/objects/leselampe.png'},
    {'name': 'images/objects/bonsai.png', 'path': 'images/objects/bonsai.png'},
    {'name': 'images/objects/usb_stick.png', 'path': 'images/objects/usb_stick.png'},
    {'name': 'images/scenes/waschsalon.png', 'path': 'images/scenes/waschsalon.png'},
    {'name': 'images/objects/bademantel.png', 'path': 'images/objects/bademantel.png'},
    {'name': 'images/objects/socken.png', 'path': 'images/objects/socken.png'},
    {'name': 'images/objects/zeitschriften.png', 'path': 'images/objects/zeitschriften.png'},
    {'name': 'images/scenes/brucke.png', 'path': 'images/scenes/brucke.png'},
    {'name': 'images/objects/auto.png', 'path': 'images/objects/auto.png'},
    {'name': 'images/objects/strassenbahn.png', 'path': 'images/objects/strassenbahn.png'},
    {'name': 'images/objects/roller.png', 'path': 'images/objects/roller.png'},
    {'name': 'images/scenes/supermarkt.png', 'path': 'images/scenes/supermarkt.png'},
    {'name': 'images/objects/karotten.png', 'path': 'images/objects/karotten.png'},
    {'name': 'images/objects/gabelstapler.png', 'path': 'images/objects/gabelstapler.png'},
    {'name': 'images/objects/einkaufswagen.png', 'path': 'images/objects/einkaufswagen.png'},
    {'name': 'images/scenes/nagelstudio.png', 'path': 'images/scenes/nagelstudio.png'},
    {'name': 'images/objects/geld.png', 'path': 'images/objects/geld.png'},
    {'name': 'images/objects/nagelfeile.png', 'path': 'images/objects/nagelfeile.png'},
    {'name': 'images/scenes/strassenschilder.png', 'path': 'images/scenes/strassenschilder.png'},
    {'name': 'images/objects/ziegelsteine.png', 'path': 'images/objects/ziegelsteine.png'},
    {'name': 'images/objects/stadtfahrrader.png', 'path': 'images/objects/stadtfahrrader.png'},
    {'name': 'images/objects/verkehrshutchen.png', 'path': 'images/objects/verkehrshutchen.png'},
    {'name': 'images/scenes/kirche.png', 'path': 'images/scenes/kirche.png'},
    {'name': 'images/objects/geige.png', 'path': 'images/objects/geige.png'},
    {'name': 'images/objects/kreuz.png', 'path': 'images/objects/kreuz.png'},
    {'name': 'images/objects/wasserspeier.png', 'path': 'images/objects/wasserspeier.png'},
    {'name': 'images/scenes/strand.png', 'path': 'images/scenes/strand.png'},
    {'name': 'images/objects/schwimmflugel.png', 'path': 'images/objects/schwimmflugel.png'},
    {'name': 'images/objects/schwimmreifen.png', 'path': 'images/objects/schwimmreifen.png'},
    {'name': 'images/objects/schlauchboot.png', 'path': 'images/objects/schlauchboot.png'},
    {'name': 'images/scenes/see_mit_ruderboot.png', 'path': 'images/scenes/see_mit_ruderboot.png'},
    {'name': 'images/objects/kajak.png', 'path': 'images/objects/kajak.png'},
    {'name': 'images/objects/kaulquappen.png', 'path': 'images/objects/kaulquappen.png'},
    {'name': 'images/scenes/wald.png', 'path': 'images/scenes/wald.png'},
    {'name': 'images/objects/wanderschuhe.png', 'path': 'images/objects/wanderschuhe.png'},
    {'name': 'images/objects/kastanien.png', 'path': 'images/objects/kastanien.png'},
    {'name': 'images/scenes/berge_mit_schnee.png', 'path': 'images/scenes/berge_mit_schnee.png'},
    {'name': 'images/objects/schneemobil.png', 'path': 'images/objects/schneemobil.png'},
    {'name': 'images/objects/verschneiter_tannenbaum.png', 'path': 'images/objects/verschneiter_tannenbaum.png'},
    {'name': 'images/objects/ski.png', 'path': 'images/objects/ski.png'},
    {'name': 'images/scenes/see_mit_steg.png', 'path': 'images/scenes/see_mit_steg.png'},
    {'name': 'images/objects/seerose.png', 'path': 'images/objects/seerose.png'},
    {'name': 'images/objects/libelle.png', 'path': 'images/objects/libelle.png'},
    {'name': 'images/scenes/haus.png', 'path': 'images/scenes/haus.png'},
    {'name': 'images/objects/gabel.png', 'path': 'images/objects/gabel.png'},
    {'name': 'images/objects/turmatte.png', 'path': 'images/objects/turmatte.png'},
    {'name': 'images/scenes/wolken_von_oben.png', 'path': 'images/scenes/wolken_von_oben.png'},
    {'name': 'images/objects/riesenradgondel.png', 'path': 'images/objects/riesenradgondel.png'},
    {'name': 'images/objects/heissluftballon.png', 'path': 'images/objects/heissluftballon.png'},
    {'name': 'images/scenes/berge_sommer.png', 'path': 'images/scenes/berge_sommer.png'},
    {'name': 'images/objects/edelweiss.png', 'path': 'images/objects/edelweiss.png'},
    {'name': 'images/objects/wanderhose.png', 'path': 'images/objects/wanderhose.png'},
    {'name': 'images/objects/milchkanne.png', 'path': 'images/objects/milchkanne.png'},
    {'name': 'images/scenes/parkhaus.png', 'path': 'images/scenes/parkhaus.png'},
    {'name': 'images/objects/schranke.png', 'path': 'images/objects/schranke.png'},
    {'name': 'images/scenes/rolltreppen.png', 'path': 'images/scenes/rolltreppen.png'},
    {'name': 'images/objects/fahrkarten.png', 'path': 'images/objects/fahrkarten.png'},
    {'name': 'images/objects/flugzeug.png', 'path': 'images/objects/flugzeug.png'},
    {'name': 'images/objects/plakatsaule.png', 'path': 'images/objects/plakatsaule.png'},
    {'name': 'images/scenes/fluss_mit_schnee.png', 'path': 'images/scenes/fluss_mit_schnee.png'},
    {'name': 'images/objects/schneeschuhe.png', 'path': 'images/objects/schneeschuhe.png'},
    {'name': 'images/objects/eisscholle.png', 'path': 'images/objects/eisscholle.png'},
    {'name': 'images/scenes/bergsee.png', 'path': 'images/scenes/bergsee.png'},
    {'name': 'images/objects/picknickkorb.png', 'path': 'images/objects/picknickkorb.png'},
    {'name': 'images/objects/frosch.png', 'path': 'images/objects/frosch.png'},
    {'name': 'images/scenes/burg.png', 'path': 'images/scenes/burg.png'},
    {'name': 'images/objects/kronleuchter.png', 'path': 'images/objects/kronleuchter.png'},
    {'name': 'images/objects/bauhelm.png', 'path': 'images/objects/bauhelm.png'},
    {'name': 'images/scenes/orchesterbuhne.png', 'path': 'images/scenes/orchesterbuhne.png'},
    {'name': 'images/objects/scheinwerfer.png', 'path': 'images/objects/scheinwerfer.png'},
    {'name': 'images/objects/stockelschuhe.png', 'path': 'images/objects/stockelschuhe.png'},
    {'name': 'images/objects/mikrofon.png', 'path': 'images/objects/mikrofon.png'},
    {'name': 'images/scenes/tresor.png', 'path': 'images/scenes/tresor.png'},
    {'name': 'images/objects/smaragdring.png', 'path': 'images/objects/smaragdring.png'},
    {'name': 'images/objects/marmorskulptur.png', 'path': 'images/objects/marmorskulptur.png'},
    {'name': 'images/scenes/sandkasten.png', 'path': 'images/scenes/sandkasten.png'},
    {'name': 'images/objects/sonnenschirm.png', 'path': 'images/objects/sonnenschirm.png'},
    {'name': 'images/objects/kinder_schaufel.png', 'path': 'images/objects/kinder_schaufel.png'},
    {'name': 'images/scenes/spielplatz.png', 'path': 'images/scenes/spielplatz.png'},
    {'name': 'images/objects/fussball.png', 'path': 'images/objects/fussball.png'},
    {'name': 'images/objects/wippe.png', 'path': 'images/objects/wippe.png'},
    {'name': 'images/scenes/picknickwiese.png', 'path': 'images/scenes/picknickwiese.png'},
    {'name': 'images/objects/kletterhaus.png', 'path': 'images/objects/kletterhaus.png'},
    {'name': 'images/objects/aufsitzrasenmaher.png', 'path': 'images/objects/aufsitzrasenmaher.png'},
    {'name': 'images/objects/federball.png', 'path': 'images/objects/federball.png'},
    {'name': 'images/scenes/sushi_restaurant.png', 'path': 'images/scenes/sushi_restaurant.png'},
    {'name': 'images/objects/sushi.png', 'path': 'images/objects/sushi.png'},
    {'name': 'images/scenes/garten.png', 'path': 'images/scenes/garten.png'},
    {'name': 'images/objects/blumenzwiebeln.png', 'path': 'images/objects/blumenzwiebeln.png'},
    {'name': 'images/scenes/wilder_fluss.png', 'path': 'images/scenes/wilder_fluss.png'},
    {'name': 'images/objects/angel.png', 'path': 'images/objects/angel.png'},
    {'name': 'images/objects/surfbretter.png', 'path': 'images/objects/surfbretter.png'},
    {'name': 'images/objects/treibholz.png', 'path': 'images/objects/treibholz.png'},
    {'name': 'images/scenes/italienische_stadt.png', 'path': 'images/scenes/italienische_stadt.png'},
    {'name': 'images/objects/crossaint.png', 'path': 'images/objects/crossaint.png'},
    {'name': 'images/scenes/altstadtcafe.png', 'path': 'images/scenes/altstadtcafe.png'},
    {'name': 'images/objects/stehtisch.png', 'path': 'images/objects/stehtisch.png'},
    {'name': 'images/scenes/skigondel.png', 'path': 'images/scenes/skigondel.png'},
    {'name': 'images/objects/rodel.png', 'path': 'images/objects/rodel.png'},
    {'name': 'images/objects/thermoskanne.png', 'path': 'images/objects/thermoskanne.png'},
    {'name': 'images/scenes/spuren_im_schnee.png', 'path': 'images/scenes/spuren_im_schnee.png'},
    {'name': 'images/objects/schneemann.png', 'path': 'images/objects/schneemann.png'},
    {'name': 'images/objects/winterschuh.png', 'path': 'images/objects/winterschuh.png'},
    {'name': 'images/scenes/teich.png', 'path': 'images/scenes/teich.png'},
    {'name': 'images/objects/sandspielzeug.png', 'path': 'images/objects/sandspielzeug.png'},
    {'name': 'images/objects/koi.png', 'path': 'images/objects/koi.png'},
    {'name': 'images/scenes/brandung.png', 'path': 'images/scenes/brandung.png'},
    {'name': 'images/objects/muschel.png', 'path': 'images/objects/muschel.png'},
    {'name': 'images/scenes/wochenmarkt.png', 'path': 'images/scenes/wochenmarkt.png'},
    {'name': 'images/objects/brot.png', 'path': 'images/objects/brot.png'},
    {'name': 'images/objects/kasse.png', 'path': 'images/objects/kasse.png'},
    {'name': 'images/scenes/hochbeet.png', 'path': 'images/scenes/hochbeet.png'},
    {'name': 'images/objects/radieschen.png', 'path': 'images/objects/radieschen.png'},
    {'name': 'images/scenes/schaufenster.png', 'path': 'images/scenes/schaufenster.png'},
    {'name': 'images/objects/gurtel.png', 'path': 'images/objects/gurtel.png'},
    {'name': 'images/objects/einkaufstaschen.png', 'path': 'images/objects/einkaufstaschen.png'},
    {'name': 'images/scenes/stadtbrunnen.png', 'path': 'images/scenes/stadtbrunnen.png'},
    {'name': 'images/objects/osterschmuck.png', 'path': 'images/objects/osterschmuck.png'},
    {'name': 'images/scenes/flohmarkt.png', 'path': 'images/scenes/flohmarkt.png'},
    {'name': 'images/objects/schlosser.png', 'path': 'images/objects/schlosser.png'},
    {'name': 'images/objects/popcorn.png', 'path': 'images/objects/popcorn.png'},
    {'name': 'images/objects/fotoalbum.png', 'path': 'images/objects/fotoalbum.png'},
    {'name': 'images/scenes/fussballplatz.png', 'path': 'images/scenes/fussballplatz.png'},
    {'name': 'images/objects/trillerpfeife.png', 'path': 'images/objects/trillerpfeife.png'},
    {'name': 'images/scenes/volksfest.png', 'path': 'images/scenes/volksfest.png'},
    {'name': 'images/objects/zuckerwatte.png', 'path': 'images/objects/zuckerwatte.png'},
    {'name': 'images/scenes/kinosaal.png', 'path': 'images/scenes/kinosaal.png'},
    {'name': 'images/objects/overhead.png', 'path': 'images/objects/overhead.png'},
    {'name': 'images/objects/nachos.png', 'path': 'images/objects/nachos.png'},
    {'name': 'images/scenes/bibliothek.png', 'path': 'images/scenes/bibliothek.png'},
    {'name': 'images/objects/bibliotheksausweis.png', 'path': 'images/objects/bibliotheksausweis.png'},
    {'name': 'images/objects/teetasse.png', 'path': 'images/objects/teetasse.png'},
    {'name': 'images/scenes/schwimmbad.png', 'path': 'images/scenes/schwimmbad.png'},
    {'name': 'images/objects/handtuch.png', 'path': 'images/objects/handtuch.png'},
    {'name': 'images/objects/boje.png', 'path': 'images/objects/boje.png'},
    {'name': 'images/scenes/skipiste.png', 'path': 'images/scenes/skipiste.png'},
    {'name': 'images/objects/skistock.png', 'path': 'images/objects/skistock.png'},
    {'name': 'images/scenes/japanische_teestube.png', 'path': 'images/scenes/japanische_teestube.png'},
    {'name': 'images/objects/bambus.png', 'path': 'images/objects/bambus.png'},
    {'name': 'images/scenes/weltraum.png', 'path': 'images/scenes/weltraum.png'},
    {'name': 'images/objects/raumschiff.png', 'path': 'images/objects/raumschiff.png'},
    {'name': 'images/scenes/friseursalon.png', 'path': 'images/scenes/friseursalon.png'},
    {'name': 'images/objects/stifte.png', 'path': 'images/objects/stifte.png'},
    {'name': 'images/objects/haarburste.png', 'path': 'images/objects/haarburste.png'},
    {'name': 'images/scenes/kuhstall.png', 'path': 'images/scenes/kuhstall.png'},
    {'name': 'images/objects/kase.png', 'path': 'images/objects/kase.png'},
    {'name': 'images/objects/melkmaschine.png', 'path': 'images/objects/melkmaschine.png'},
    {'name': 'images/scenes/klassenzimmer.png', 'path': 'images/scenes/klassenzimmer.png'},
    {'name': 'images/objects/schultute.png', 'path': 'images/objects/schultute.png'},
    {'name': 'images/scenes/auto_innen.png', 'path': 'images/scenes/auto_innen.png'},
    {'name': 'images/objects/kupplung.png', 'path': 'images/objects/kupplung.png'},
    {'name': 'images/scenes/kaminfeuer.png', 'path': 'images/scenes/kaminfeuer.png'},
    {'name': 'images/objects/kuscheldecke.png', 'path': 'images/objects/kuscheldecke.png'},
    {'name': 'images/scenes/lagerhalle.png', 'path': 'images/scenes/lagerhalle.png'},
    {'name': 'images/objects/hebebuhne.png', 'path': 'images/objects/hebebuhne.png'},
    {'name': 'images/scenes/sauna.png', 'path': 'images/scenes/sauna.png'},
    {'name': 'images/objects/duschgel.png', 'path': 'images/objects/duschgel.png'},
    {'name': 'images/scenes/kunstgalerie.png', 'path': 'images/scenes/kunstgalerie.png'},
    {'name': 'images/objects/podest.png', 'path': 'images/objects/podest.png'},
    {'name': 'default.png', 'path': 'https://pavlovia.org/assets/default/default.png'},
    {'name': 'wasserturm.png', 'path': 'wasserturm.png'},
    {'name': 'images/scenes/wasserturm.png', 'path': 'images/scenes/wasserturm.png'},
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
var mouse_1;
var recognitionClock;
var score;
var question;
var image_top;
var image_left;
var image_middle;
var image_right;
var mouse;
var endClock;
var textbox_2;
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
    text: 'Willkommen zur Online-Version des Experiments! Die Online-Aufgabe ist ähnlich wie die zweite Aufgabe, die Sie vor Ort gemacht haben. Sie bekommen eine Szene dargestellt und sollen anschließend jenes Objekt durch Anklicken auswählen, das Ihrer Erinnerung nach mit der Szene verbunden war. Allerdings sehen Sie danach nicht mehr die richtige Lösung. Es handelt sich hierbei um die Verknüpfungen, die Sie beim zweiten Termin vor Ort gelernt haben.\nDiese Aufgabe sollen Sie das erste Mal am nächsten Tag und dann alle drei Tage durchführen; d.h. über die kommenden 2 Wochen hinweg insgesamt\xa05-mal.',
    placeholder: 'Type here...',
    font: 'Open Sans',
    pos: [0, 0.12], 
    letterHeight: 0.037,
    lineSpacing: 1.0,
    size: [1.5, 0.5],  units: undefined, 
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
    fillColor: [0.3255, 0.3255, 0.3255], borderColor: [0.3255, 0.3255, 0.3255],
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
  
  mouse_1 = new core.Mouse({
    win: psychoJS.window,
  });
  mouse_1.mouseClock = new util.Clock();
  // Initialize components for Routine "recognition"
  recognitionClock = new util.Clock();
  // Run 'Begin Experiment' code from behavioral
  score = 0;
  
  question = new visual.TextBox({
    win: psychoJS.window,
    name: 'question',
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
  
  image_top = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_top', units : undefined, 
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
    depth: 0.0 
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
    opacity: undefined, depth: -1, interpolate: true,
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
    // setup some python lists for storing info about the mouse_1
    // current position of the mouse:
    mouse_1.x = [];
    mouse_1.y = [];
    mouse_1.leftButton = [];
    mouse_1.midButton = [];
    mouse_1.rightButton = [];
    mouse_1.time = [];
    mouse_1.clicked_name = [];
    gotValidClick = false; // until a click is received
    // keep track of which components have finished
    introductionComponents = [];
    introductionComponents.push(introduction_text);
    introductionComponents.push(text_introduction_button);
    introductionComponents.push(mouse_1);
    
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

    // *mouse_1* updates
    if (t >= 0.0 && mouse_1.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      mouse_1.tStart = t;  // (not accounting for frame time here)
      mouse_1.frameNStart = frameN;  // exact frame index
      
      mouse_1.status = PsychoJS.Status.STARTED;
      mouse_1.mouseClock.reset();
      prevButtonState = mouse_1.getPressed();  // if button is down already this ISN'T a new click
      }
    if (mouse_1.status === PsychoJS.Status.STARTED) {  // only update if started and not finished!
      _mouseButtons = mouse_1.getPressed();
      if (!_mouseButtons.every( (e,i,) => (e == prevButtonState[i]) )) { // button state changed?
        prevButtonState = _mouseButtons;
        if (_mouseButtons.reduce( (e, acc) => (e+acc) ) > 0) { // state changed to a new click
          // check if the mouse was inside our 'clickable' objects
          gotValidClick = false;
          for (const obj of [text_introduction_button]) {
            if (obj.contains(mouse_1)) {
              gotValidClick = true;
              mouse_1.clicked_name.push(obj.name)
            }
          }
          _mouseXYs = mouse_1.getPos();
          mouse_1.x.push(_mouseXYs[0]);
          mouse_1.y.push(_mouseXYs[1]);
          mouse_1.leftButton.push(_mouseButtons[0]);
          mouse_1.midButton.push(_mouseButtons[1]);
          mouse_1.rightButton.push(_mouseButtons[2]);
          mouse_1.time.push(mouse_1.mouseClock.getTime());
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
    if (mouse_1.x) {  psychoJS.experiment.addData('mouse_1.x', mouse_1.x[0])};
    if (mouse_1.y) {  psychoJS.experiment.addData('mouse_1.y', mouse_1.y[0])};
    if (mouse_1.leftButton) {  psychoJS.experiment.addData('mouse_1.leftButton', mouse_1.leftButton[0])};
    if (mouse_1.midButton) {  psychoJS.experiment.addData('mouse_1.midButton', mouse_1.midButton[0])};
    if (mouse_1.rightButton) {  psychoJS.experiment.addData('mouse_1.rightButton', mouse_1.rightButton[0])};
    if (mouse_1.time) {  psychoJS.experiment.addData('mouse_1.time', mouse_1.time[0])};
    if (mouse_1.clicked_name) {  psychoJS.experiment.addData('mouse_1.clicked_name', mouse_1.clicked_name[0])};
    
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
      trialList: 'Excel_forgetting_curve_neutral.xlsx',
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
    image_top.setImage(Picture_Recognition);
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
    recognitionComponents.push(question);
    recognitionComponents.push(image_top);
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
    
    // *question* updates
    if (t >= 2.1 && question.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      question.tStart = t;  // (not accounting for frame time here)
      question.frameNStart = frameN;  // exact frame index
      
      question.setAutoDraw(true);
    }

    
    // *image_top* updates
    if (t >= 0 && image_top.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      image_top.tStart = t;  // (not accounting for frame time here)
      image_top.frameNStart = frameN;  // exact frame index
      
      image_top.setAutoDraw(true);
    }

    frameRemains = 0 + 1.6 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (image_top.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      image_top.setAutoDraw(false);
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
    // Run 'End Routine' code from behavioral
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
