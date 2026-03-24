/************************** 
 * N_Online_Training Test *
 **************************/


// store info about the experiment session:
let expName = 'N_online_training';  // from the Builder filename that created this script
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
    {'name': 'Excel_online_training_neutral.xlsx', 'path': 'Excel_online_training_neutral.xlsx'},
    {'name': 'images/scenes/wasserturm.png', 'path': 'images/scenes/wasserturm.png'},
    {'name': 'images/objects/scheinwerfer.png', 'path': 'images/objects/scheinwerfer.png'},
    {'name': 'images/objects/ziegelsteine.png', 'path': 'images/objects/ziegelsteine.png'},
    {'name': 'images/objects/rostige_tur.png', 'path': 'images/objects/rostige_tur.png'},
    {'name': 'images/scenes/bushaltestelle.png', 'path': 'images/scenes/bushaltestelle.png'},
    {'name': 'images/objects/fahrkarten.png', 'path': 'images/objects/fahrkarten.png'},
    {'name': 'images/objects/auto.png', 'path': 'images/objects/auto.png'},
    {'name': 'images/objects/ampel.png', 'path': 'images/objects/ampel.png'},
    {'name': 'images/scenes/altstadt.png', 'path': 'images/scenes/altstadt.png'},
    {'name': 'images/objects/kutsche.png', 'path': 'images/objects/kutsche.png'},
    {'name': 'images/objects/kirchturm.png', 'path': 'images/objects/kirchturm.png'},
    {'name': 'images/objects/stadtfahrrader.png', 'path': 'images/objects/stadtfahrrader.png'},
    {'name': 'images/scenes/fitnessstudio.png', 'path': 'images/scenes/fitnessstudio.png'},
    {'name': 'images/objects/handtuch.png', 'path': 'images/objects/handtuch.png'},
    {'name': 'images/objects/laufband.png', 'path': 'images/objects/laufband.png'},
    {'name': 'images/objects/reisetasche.png', 'path': 'images/objects/reisetasche.png'},
    {'name': 'images/scenes/esszimmer.png', 'path': 'images/scenes/esszimmer.png'},
    {'name': 'images/objects/gabel.png', 'path': 'images/objects/gabel.png'},
    {'name': 'images/objects/milchkanne.png', 'path': 'images/objects/milchkanne.png'},
    {'name': 'images/objects/hangeleuchte.png', 'path': 'images/objects/hangeleuchte.png'},
    {'name': 'images/scenes/arbeitszimmer.png', 'path': 'images/scenes/arbeitszimmer.png'},
    {'name': 'images/objects/stifte.png', 'path': 'images/objects/stifte.png'},
    {'name': 'images/objects/overhead.png', 'path': 'images/objects/overhead.png'},
    {'name': 'images/objects/ordner.png', 'path': 'images/objects/ordner.png'},
    {'name': 'images/scenes/waschsalon.png', 'path': 'images/scenes/waschsalon.png'},
    {'name': 'images/objects/wasche.png', 'path': 'images/objects/wasche.png'},
    {'name': 'images/objects/waschmittel.png', 'path': 'images/objects/waschmittel.png'},
    {'name': 'images/scenes/brucke.png', 'path': 'images/scenes/brucke.png'},
    {'name': 'images/objects/schlosser.png', 'path': 'images/objects/schlosser.png'},
    {'name': 'images/objects/bauhelm.png', 'path': 'images/objects/bauhelm.png'},
    {'name': 'images/objects/absperrband.png', 'path': 'images/objects/absperrband.png'},
    {'name': 'images/scenes/supermarkt.png', 'path': 'images/scenes/supermarkt.png'},
    {'name': 'images/objects/kasse.png', 'path': 'images/objects/kasse.png'},
    {'name': 'images/objects/kassenzettel.png', 'path': 'images/objects/kassenzettel.png'},
    {'name': 'images/objects/kase.png', 'path': 'images/objects/kase.png'},
    {'name': 'images/scenes/nagelstudio.png', 'path': 'images/scenes/nagelstudio.png'},
    {'name': 'images/objects/zeitschriften.png', 'path': 'images/objects/zeitschriften.png'},
    {'name': 'images/objects/nagellackentferner.png', 'path': 'images/objects/nagellackentferner.png'},
    {'name': 'images/objects/einkaufstaschen.png', 'path': 'images/objects/einkaufstaschen.png'},
    {'name': 'images/scenes/strassenschilder.png', 'path': 'images/scenes/strassenschilder.png'},
    {'name': 'images/objects/gabelstapler.png', 'path': 'images/objects/gabelstapler.png'},
    {'name': 'images/objects/baugerust.png', 'path': 'images/objects/baugerust.png'},
    {'name': 'images/scenes/kirche.png', 'path': 'images/scenes/kirche.png'},
    {'name': 'images/objects/glocken.png', 'path': 'images/objects/glocken.png'},
    {'name': 'images/objects/bibel.png', 'path': 'images/objects/bibel.png'},
    {'name': 'images/scenes/strand.png', 'path': 'images/scenes/strand.png'},
    {'name': 'images/objects/sonnenschirm.png', 'path': 'images/objects/sonnenschirm.png'},
    {'name': 'images/objects/badehandtuch.png', 'path': 'images/objects/badehandtuch.png'},
    {'name': 'images/objects/surfbretter.png', 'path': 'images/objects/surfbretter.png'},
    {'name': 'images/scenes/see_mit_ruderboot.png', 'path': 'images/scenes/see_mit_ruderboot.png'},
    {'name': 'images/objects/angel.png', 'path': 'images/objects/angel.png'},
    {'name': 'images/objects/picknickkorb.png', 'path': 'images/objects/picknickkorb.png'},
    {'name': 'images/objects/holzboot.png', 'path': 'images/objects/holzboot.png'},
    {'name': 'images/scenes/wald.png', 'path': 'images/scenes/wald.png'},
    {'name': 'images/objects/kurbis.png', 'path': 'images/objects/kurbis.png'},
    {'name': 'images/objects/karotten.png', 'path': 'images/objects/karotten.png'},
    {'name': 'images/objects/moos.png', 'path': 'images/objects/moos.png'},
    {'name': 'images/scenes/berge_mit_schnee.png', 'path': 'images/scenes/berge_mit_schnee.png'},
    {'name': 'images/objects/rodel.png', 'path': 'images/objects/rodel.png'},
    {'name': 'images/objects/schneemann.png', 'path': 'images/objects/schneemann.png'},
    {'name': 'images/objects/schneeflocke.png', 'path': 'images/objects/schneeflocke.png'},
    {'name': 'images/scenes/see_mit_steg.png', 'path': 'images/scenes/see_mit_steg.png'},
    {'name': 'images/objects/schwimmreifen.png', 'path': 'images/objects/schwimmreifen.png'},
    {'name': 'images/objects/badehose.png', 'path': 'images/objects/badehose.png'},
    {'name': 'images/objects/kajak.png', 'path': 'images/objects/kajak.png'},
    {'name': 'images/scenes/haus.png', 'path': 'images/scenes/haus.png'},
    {'name': 'images/objects/schlusselbund.png', 'path': 'images/objects/schlusselbund.png'},
    {'name': 'images/objects/schlussel.png', 'path': 'images/objects/schlussel.png'},
    {'name': 'images/objects/reiskocher.png', 'path': 'images/objects/reiskocher.png'},
    {'name': 'images/scenes/wolken_von_oben.png', 'path': 'images/scenes/wolken_von_oben.png'},
    {'name': 'images/objects/flugzeug.png', 'path': 'images/objects/flugzeug.png'},
    {'name': 'images/objects/satellit.png', 'path': 'images/objects/satellit.png'},
    {'name': 'images/objects/fallschirm.png', 'path': 'images/objects/fallschirm.png'},
    {'name': 'images/scenes/berge_sommer.png', 'path': 'images/scenes/berge_sommer.png'},
    {'name': 'images/objects/wanderschuhe.png', 'path': 'images/objects/wanderschuhe.png'},
    {'name': 'images/objects/wegweiser.png', 'path': 'images/objects/wegweiser.png'},
    {'name': 'images/scenes/parkhaus.png', 'path': 'images/scenes/parkhaus.png'},
    {'name': 'images/objects/roller.png', 'path': 'images/objects/roller.png'},
    {'name': 'images/objects/zahlautomat.png', 'path': 'images/objects/zahlautomat.png'},
    {'name': 'images/scenes/rolltreppen.png', 'path': 'images/scenes/rolltreppen.png'},
    {'name': 'images/objects/gelander.png', 'path': 'images/objects/gelander.png'},
    {'name': 'images/scenes/fluss_mit_schnee.png', 'path': 'images/scenes/fluss_mit_schnee.png'},
    {'name': 'images/objects/eiszapfen.png', 'path': 'images/objects/eiszapfen.png'},
    {'name': 'images/scenes/bergsee.png', 'path': 'images/scenes/bergsee.png'},
    {'name': 'images/objects/edelweiss.png', 'path': 'images/objects/edelweiss.png'},
    {'name': 'images/objects/trinkflasche.png', 'path': 'images/objects/trinkflasche.png'},
    {'name': 'images/scenes/burg.png', 'path': 'images/scenes/burg.png'},
    {'name': 'images/objects/ritterrustung.png', 'path': 'images/objects/ritterrustung.png'},
    {'name': 'images/objects/seerose.png', 'path': 'images/objects/seerose.png'},
    {'name': 'images/scenes/orchesterbuhne.png', 'path': 'images/scenes/orchesterbuhne.png'},
    {'name': 'images/objects/geige.png', 'path': 'images/objects/geige.png'},
    {'name': 'images/objects/altes_telefon.png', 'path': 'images/objects/altes_telefon.png'},
    {'name': 'images/objects/cello.png', 'path': 'images/objects/cello.png'},
    {'name': 'images/scenes/tresor.png', 'path': 'images/scenes/tresor.png'},
    {'name': 'images/objects/geld.png', 'path': 'images/objects/geld.png'},
    {'name': 'images/objects/gold.png', 'path': 'images/objects/gold.png'},
    {'name': 'images/scenes/sandkasten.png', 'path': 'images/scenes/sandkasten.png'},
    {'name': 'images/objects/sandspielzeug.png', 'path': 'images/objects/sandspielzeug.png'},
    {'name': 'images/objects/kletterhaus.png', 'path': 'images/objects/kletterhaus.png'},
    {'name': 'images/objects/sandburg.png', 'path': 'images/objects/sandburg.png'},
    {'name': 'images/scenes/spielplatz.png', 'path': 'images/scenes/spielplatz.png'},
    {'name': 'images/objects/schaukel.png', 'path': 'images/objects/schaukel.png'},
    {'name': 'images/scenes/picknickwiese.png', 'path': 'images/scenes/picknickwiese.png'},
    {'name': 'images/objects/riesenradgondel.png', 'path': 'images/objects/riesenradgondel.png'},
    {'name': 'images/objects/picknickdecke.png', 'path': 'images/objects/picknickdecke.png'},
    {'name': 'images/scenes/sushi_restaurant.png', 'path': 'images/scenes/sushi_restaurant.png'},
    {'name': 'images/objects/sojasauce.png', 'path': 'images/objects/sojasauce.png'},
    {'name': 'images/objects/bonsai.png', 'path': 'images/objects/bonsai.png'},
    {'name': 'images/scenes/garten.png', 'path': 'images/scenes/garten.png'},
    {'name': 'images/objects/aufsitzrasenmaher.png', 'path': 'images/objects/aufsitzrasenmaher.png'},
    {'name': 'images/objects/gartenschere.png', 'path': 'images/objects/gartenschere.png'},
    {'name': 'images/scenes/wilder_fluss.png', 'path': 'images/scenes/wilder_fluss.png'},
    {'name': 'images/objects/schwimmflugel.png', 'path': 'images/objects/schwimmflugel.png'},
    {'name': 'images/objects/schwimmweste.png', 'path': 'images/objects/schwimmweste.png'},
    {'name': 'images/scenes/italienische_stadt.png', 'path': 'images/scenes/italienische_stadt.png'},
    {'name': 'images/objects/eis.png', 'path': 'images/objects/eis.png'},
    {'name': 'images/scenes/altstadtcafe.png', 'path': 'images/scenes/altstadtcafe.png'},
    {'name': 'images/objects/stuhl.png', 'path': 'images/objects/stuhl.png'},
    {'name': 'images/scenes/skigondel.png', 'path': 'images/scenes/skigondel.png'},
    {'name': 'images/objects/ski.png', 'path': 'images/objects/ski.png'},
    {'name': 'images/objects/schneemobil.png', 'path': 'images/objects/schneemobil.png'},
    {'name': 'images/objects/lift.png', 'path': 'images/objects/lift.png'},
    {'name': 'images/scenes/spuren_im_schnee.png', 'path': 'images/scenes/spuren_im_schnee.png'},
    {'name': 'images/objects/schneeschuhe.png', 'path': 'images/objects/schneeschuhe.png'},
    {'name': 'images/objects/skijacke.png', 'path': 'images/objects/skijacke.png'},
    {'name': 'images/scenes/teich.png', 'path': 'images/scenes/teich.png'},
    {'name': 'images/objects/schilf.png', 'path': 'images/objects/schilf.png'},
    {'name': 'images/scenes/brandung.png', 'path': 'images/scenes/brandung.png'},
    {'name': 'images/objects/rettungsleine.png', 'path': 'images/objects/rettungsleine.png'},
    {'name': 'images/scenes/wochenmarkt.png', 'path': 'images/scenes/wochenmarkt.png'},
    {'name': 'images/objects/blumen.png', 'path': 'images/objects/blumen.png'},
    {'name': 'images/scenes/hochbeet.png', 'path': 'images/scenes/hochbeet.png'},
    {'name': 'images/objects/salat.png', 'path': 'images/objects/salat.png'},
    {'name': 'images/scenes/schaufenster.png', 'path': 'images/scenes/schaufenster.png'},
    {'name': 'images/objects/stockelschuhe.png', 'path': 'images/objects/stockelschuhe.png'},
    {'name': 'images/objects/flip_flops.png', 'path': 'images/objects/flip_flops.png'},
    {'name': 'images/scenes/stadtbrunnen.png', 'path': 'images/scenes/stadtbrunnen.png'},
    {'name': 'images/objects/wasserspeier.png', 'path': 'images/objects/wasserspeier.png'},
    {'name': 'images/objects/marmorskulptur.png', 'path': 'images/objects/marmorskulptur.png'},
    {'name': 'images/objects/kleingeld.png', 'path': 'images/objects/kleingeld.png'},
    {'name': 'images/scenes/flohmarkt.png', 'path': 'images/scenes/flohmarkt.png'},
    {'name': 'images/objects/taschenuhr.png', 'path': 'images/objects/taschenuhr.png'},
    {'name': 'images/objects/leselampe.png', 'path': 'images/objects/leselampe.png'},
    {'name': 'images/scenes/fussballplatz.png', 'path': 'images/scenes/fussballplatz.png'},
    {'name': 'images/objects/fussball.png', 'path': 'images/objects/fussball.png'},
    {'name': 'images/objects/popcorn.png', 'path': 'images/objects/popcorn.png'},
    {'name': 'images/objects/fussballschuhe.png', 'path': 'images/objects/fussballschuhe.png'},
    {'name': 'images/scenes/volksfest.png', 'path': 'images/scenes/volksfest.png'},
    {'name': 'images/objects/festzelt.png', 'path': 'images/objects/festzelt.png'},
    {'name': 'images/scenes/kinosaal.png', 'path': 'images/scenes/kinosaal.png'},
    {'name': 'images/objects/kinosessel.png', 'path': 'images/objects/kinosessel.png'},
    {'name': 'images/scenes/bibliothek.png', 'path': 'images/scenes/bibliothek.png'},
    {'name': 'images/objects/laptop.png', 'path': 'images/objects/laptop.png'},
    {'name': 'images/scenes/schwimmbad.png', 'path': 'images/scenes/schwimmbad.png'},
    {'name': 'images/objects/fon.png', 'path': 'images/objects/fon.png'},
    {'name': 'images/objects/kiosk.png', 'path': 'images/objects/kiosk.png'},
    {'name': 'images/scenes/skipiste.png', 'path': 'images/scenes/skipiste.png'},
    {'name': 'images/objects/skihandschuh.png', 'path': 'images/objects/skihandschuh.png'},
    {'name': 'images/scenes/japanische_teestube.png', 'path': 'images/scenes/japanische_teestube.png'},
    {'name': 'images/objects/kimono.png', 'path': 'images/objects/kimono.png'},
    {'name': 'images/scenes/weltraum.png', 'path': 'images/scenes/weltraum.png'},
    {'name': 'images/objects/mond.png', 'path': 'images/objects/mond.png'},
    {'name': 'images/scenes/friseursalon.png', 'path': 'images/scenes/friseursalon.png'},
    {'name': 'images/objects/lockenwickler.png', 'path': 'images/objects/lockenwickler.png'},
    {'name': 'images/scenes/kuhstall.png', 'path': 'images/scenes/kuhstall.png'},
    {'name': 'images/objects/heu.png', 'path': 'images/objects/heu.png'},
    {'name': 'images/scenes/klassenzimmer.png', 'path': 'images/scenes/klassenzimmer.png'},
    {'name': 'images/objects/tafel.png', 'path': 'images/objects/tafel.png'},
    {'name': 'images/scenes/auto_innen.png', 'path': 'images/scenes/auto_innen.png'},
    {'name': 'images/objects/reifen.png', 'path': 'images/objects/reifen.png'},
    {'name': 'images/scenes/kaminfeuer.png', 'path': 'images/scenes/kaminfeuer.png'},
    {'name': 'images/objects/teetasse.png', 'path': 'images/objects/teetasse.png'},
    {'name': 'images/objects/bademantel.png', 'path': 'images/objects/bademantel.png'},
    {'name': 'images/objects/sessel.png', 'path': 'images/objects/sessel.png'},
    {'name': 'images/scenes/lagerhalle.png', 'path': 'images/scenes/lagerhalle.png'},
    {'name': 'images/objects/mahdrescher.png', 'path': 'images/objects/mahdrescher.png'},
    {'name': 'images/scenes/sauna.png', 'path': 'images/scenes/sauna.png'},
    {'name': 'images/objects/badeschlappen.png', 'path': 'images/objects/badeschlappen.png'},
    {'name': 'images/scenes/kunstgalerie.png', 'path': 'images/scenes/kunstgalerie.png'},
    {'name': 'images/objects/gemalde.png', 'path': 'images/objects/gemalde.png'},
    {'name': 'images/background.bmp', 'path': 'images/background.bmp'},
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
var background;
var introduction_text;
var text_introduction_button;
var mouse_2;
var recognitionClock;
var score;
var background_2;
var question_emotional;
var image_top_3;
var image_left;
var image_middle;
var image_right;
var mouse;
var feedbackClock;
var background_3;
var textbox;
var solutionClock;
var background_4;
var image_top_solution;
var image_solution;
var endClock;
var background_5;
var textbox_2;
var textbox_3;
var polygon;
var mouse_3;
var globalClock;
var routineTimer;
async function experimentInit() {
  // Initialize components for Routine "introduction"
  introductionClock = new util.Clock();
  background = new visual.ImageStim({
    win : psychoJS.window,
    name : 'background', units : undefined, 
    image : 'images/background.bmp', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, 0], size : [2, 2],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : 0.0 
  });
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
    depth: -1.0 
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
    depth: -2.0 
  });
  
  mouse_2 = new core.Mouse({
    win: psychoJS.window,
  });
  mouse_2.mouseClock = new util.Clock();
  // Initialize components for Routine "recognition"
  recognitionClock = new util.Clock();
  // Run 'Begin Experiment' code from feedback_code
  score = 0;
  
  background_2 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'background_2', units : undefined, 
    image : 'images/background.bmp', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, 0], size : [2, 2],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -1.0 
  });
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
    depth: -2.0 
  });
  
  image_top_3 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_top_3', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, 0.2], size : [0.6, 0.45],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -3.0 
  });
  image_left = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_left', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [(- 0.6), (- 0.2)], size : [0.5, 0.4],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -4.0 
  });
  image_middle = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_middle', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, (- 0.2)], size : [0.5, 0.4],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -5.0 
  });
  image_right = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_right', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0.6, (- 0.2)], size : [0.5, 0.4],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -6.0 
  });
  mouse = new core.Mouse({
    win: psychoJS.window,
  });
  mouse.mouseClock = new util.Clock();
  // Initialize components for Routine "feedback"
  feedbackClock = new util.Clock();
  background_3 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'background_3', units : undefined, 
    image : 'images/background.bmp', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, 0], size : [2, 2],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : 0.0 
  });
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
    depth: -1.0 
  });
  
  // Initialize components for Routine "solution"
  solutionClock = new util.Clock();
  background_4 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'background_4', units : undefined, 
    image : 'images/background.bmp', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, 0], size : [2, 2],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : 0.0 
  });
  image_top_solution = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_top_solution', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, 0.2], size : [0.6, 0.45],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -1.0 
  });
  image_solution = new visual.ImageStim({
    win : psychoJS.window,
    name : 'image_solution', units : undefined, 
    image : 'default.png', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [(- 0.6), (- 0.2)], size : [0.5, 0.4],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -2.0 
  });
  // Initialize components for Routine "end"
  endClock = new util.Clock();
  background_5 = new visual.ImageStim({
    win : psychoJS.window,
    name : 'background_5', units : undefined, 
    image : 'images/background.bmp', mask : undefined,
    anchor : 'center',
    ori : 0.0, pos : [0, 0], size : [2, 2],
    color : new util.Color([1,1,1]), opacity : undefined,
    flipHoriz : false, flipVert : false,
    texRes : 128.0, interpolate : true, depth : -1.0 
  });
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
    depth: -2.0 
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
    depth: -3.0 
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
    opacity: undefined, depth: -4, interpolate: true,
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
    introductionComponents.push(background);
    introductionComponents.push(introduction_text);
    introductionComponents.push(text_introduction_button);
    introductionComponents.push(mouse_2);
    
    introductionComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
       });
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
    
    // *background* updates
    if (t >= 0.0 && background.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      background.tStart = t;  // (not accounting for frame time here)
      background.frameNStart = frameN;  // exact frame index
      
      background.setAutoDraw(true);
    }

    
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
    introductionComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
      }
    });
    
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
    introductionComponents.forEach( function(thisComponent) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    });
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
      trialList: 'Excel_online_training_neutral.xlsx',
      seed: undefined, name: 'trials'
    });
    psychoJS.experiment.addLoop(trials); // add the loop to the experiment
    currentLoop = trials;  // we're now the current loop
    
    // Schedule all the trials in the trialList:
    trials.forEach(function() {
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
    });
    
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
    recognitionComponents.push(background_2);
    recognitionComponents.push(question_emotional);
    recognitionComponents.push(image_top_3);
    recognitionComponents.push(image_left);
    recognitionComponents.push(image_middle);
    recognitionComponents.push(image_right);
    recognitionComponents.push(mouse);
    
    recognitionComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
       });
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
    
    // *background_2* updates
    if (t >= 0.0 && background_2.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      background_2.tStart = t;  // (not accounting for frame time here)
      background_2.frameNStart = frameN;  // exact frame index
      
      background_2.setAutoDraw(true);
    }

    
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
    recognitionComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
      }
    });
    
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
    recognitionComponents.forEach( function(thisComponent) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    });
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
    feedbackComponents.push(background_3);
    feedbackComponents.push(textbox);
    
    feedbackComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
       });
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
    
    // *background_3* updates
    if (t >= 0.0 && background_3.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      background_3.tStart = t;  // (not accounting for frame time here)
      background_3.frameNStart = frameN;  // exact frame index
      
      background_3.setAutoDraw(true);
    }

    frameRemains = 0.0 + 1 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (background_3.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      background_3.setAutoDraw(false);
    }
    
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
    feedbackComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
      }
    });
    
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
    feedbackComponents.forEach( function(thisComponent) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    });
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
    solutionComponents.push(background_4);
    solutionComponents.push(image_top_solution);
    solutionComponents.push(image_solution);
    
    solutionComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
       });
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
    
    // *background_4* updates
    if (t >= 0.0 && background_4.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      background_4.tStart = t;  // (not accounting for frame time here)
      background_4.frameNStart = frameN;  // exact frame index
      
      background_4.setAutoDraw(true);
    }

    frameRemains = 0.0 + 3.1 - psychoJS.window.monitorFramePeriod * 0.75;  // most of one frame period left
    if (background_4.status === PsychoJS.Status.STARTED && t >= frameRemains) {
      background_4.setAutoDraw(false);
    }
    
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
    solutionComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
      }
    });
    
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
    solutionComponents.forEach( function(thisComponent) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    });
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
    endComponents.push(background_5);
    endComponents.push(textbox_2);
    endComponents.push(textbox_3);
    endComponents.push(polygon);
    endComponents.push(mouse_3);
    
    endComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent)
        thisComponent.status = PsychoJS.Status.NOT_STARTED;
       });
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
    
    // *background_5* updates
    if (t >= 0.0 && background_5.status === PsychoJS.Status.NOT_STARTED) {
      // keep track of start time/frame for later
      background_5.tStart = t;  // (not accounting for frame time here)
      background_5.frameNStart = frameN;  // exact frame index
      
      background_5.setAutoDraw(true);
    }

    
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
    endComponents.forEach( function(thisComponent) {
      if ('status' in thisComponent && thisComponent.status !== PsychoJS.Status.FINISHED) {
        continueRoutine = true;
      }
    });
    
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
    endComponents.forEach( function(thisComponent) {
      if (typeof thisComponent.setAutoDraw === 'function') {
        thisComponent.setAutoDraw(false);
      }
    });
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
