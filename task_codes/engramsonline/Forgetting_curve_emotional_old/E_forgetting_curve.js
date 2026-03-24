/*************************** 
 * E_Forgetting_Curve Test *
 ***************************/

import { core, data, sound, util, visual, hardware } from './lib/psychojs-2023.1.3.js';
const { PsychoJS } = core;
const { TrialHandler, MultiStairHandler } = data;
const { Scheduler } = util;
//some handy aliases as in the psychopy scripts;
const { abs, sin, cos, PI: pi, sqrt } = Math;
const { round } = util;


// store info about the experiment session:
let expName = 'E_forgetting_curve';  // from the Builder filename that created this script
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
    {'name': 'Excel_forgetting_curve_emotional.xlsx', 'path': 'Excel_forgetting_curve_emotional.xlsx'},
    {'name': 'images/scenes/friedhof.png', 'path': 'images/scenes/friedhof.png'},
    {'name': 'images/objects/friedhofsstatue.png', 'path': 'images/objects/friedhofsstatue.png'},
    {'name': 'images/objects/urne.png', 'path': 'images/objects/urne.png'},
    {'name': 'images/objects/gruselige_puppe.png', 'path': 'images/objects/gruselige_puppe.png'},
    {'name': 'images/scenes/tsunami.png', 'path': 'images/scenes/tsunami.png'},
    {'name': 'images/objects/kaputter_burostuhl.png', 'path': 'images/objects/kaputter_burostuhl.png'},
    {'name': 'images/objects/zerbrochene_uhr.png', 'path': 'images/objects/zerbrochene_uhr.png'},
    {'name': 'images/objects/durchnasster_fussball.png', 'path': 'images/objects/durchnasster_fussball.png'},
    {'name': 'images/scenes/schlachthaus.png', 'path': 'images/scenes/schlachthaus.png'},
    {'name': 'images/objects/messer.png', 'path': 'images/objects/messer.png'},
    {'name': 'images/objects/blutiger_handschuh.png', 'path': 'images/objects/blutiger_handschuh.png'},
    {'name': 'images/objects/blutige_sage.png', 'path': 'images/objects/blutige_sage.png'},
    {'name': 'images/scenes/kaputter_zug.png', 'path': 'images/scenes/kaputter_zug.png'},
    {'name': 'images/objects/kaputter_koffer.png', 'path': 'images/objects/kaputter_koffer.png'},
    {'name': 'images/objects/verunfalltes_auto.png', 'path': 'images/objects/verunfalltes_auto.png'},
    {'name': 'images/objects/zerissene_kleider.png', 'path': 'images/objects/zerissene_kleider.png'},
    {'name': 'images/scenes/uberschwemmung.png', 'path': 'images/scenes/uberschwemmung.png'},
    {'name': 'images/objects/kaputtes_sofa.png', 'path': 'images/objects/kaputtes_sofa.png'},
    {'name': 'images/objects/rettungsboot.png', 'path': 'images/objects/rettungsboot.png'},
    {'name': 'images/objects/dreckiger_teddy.png', 'path': 'images/objects/dreckiger_teddy.png'},
    {'name': 'images/scenes/brennender_lkw.png', 'path': 'images/scenes/brennender_lkw.png'},
    {'name': 'images/objects/verbrannter_toaster.png', 'path': 'images/objects/verbrannter_toaster.png'},
    {'name': 'images/objects/brennender_oltransporter.png', 'path': 'images/objects/brennender_oltransporter.png'},
    {'name': 'images/objects/kartusche.png', 'path': 'images/objects/kartusche.png'},
    {'name': 'images/scenes/brennende_bohrinsel.png', 'path': 'images/scenes/brennende_bohrinsel.png'},
    {'name': 'images/objects/kanister_entzundlich.png', 'path': 'images/objects/kanister_entzundlich.png'},
    {'name': 'images/objects/loschfahrzeug.png', 'path': 'images/objects/loschfahrzeug.png'},
    {'name': 'images/objects/ollache.png', 'path': 'images/objects/ollache.png'},
    {'name': 'images/scenes/haus_nach_erdbeben.png', 'path': 'images/scenes/haus_nach_erdbeben.png'},
    {'name': 'images/objects/puppenkopf.png', 'path': 'images/objects/puppenkopf.png'},
    {'name': 'images/objects/verwahrloste_katze.png', 'path': 'images/objects/verwahrloste_katze.png'},
    {'name': 'images/scenes/absturzender_kampfjet.png', 'path': 'images/scenes/absturzender_kampfjet.png'},
    {'name': 'images/objects/panzer.png', 'path': 'images/objects/panzer.png'},
    {'name': 'images/objects/kampfhelm.png', 'path': 'images/objects/kampfhelm.png'},
    {'name': 'images/objects/motorraduberreste.png', 'path': 'images/objects/motorraduberreste.png'},
    {'name': 'images/scenes/schlachthof.png', 'path': 'images/scenes/schlachthof.png'},
    {'name': 'images/objects/blutiger_schweinekopf.png', 'path': 'images/objects/blutiger_schweinekopf.png'},
    {'name': 'images/objects/kuhzunge.png', 'path': 'images/objects/kuhzunge.png'},
    {'name': 'images/objects/blutige_messer.png', 'path': 'images/objects/blutige_messer.png'},
    {'name': 'images/scenes/intensivstation.png', 'path': 'images/scenes/intensivstation.png'},
    {'name': 'images/objects/blutige_schere.png', 'path': 'images/objects/blutige_schere.png'},
    {'name': 'images/objects/blutspritze.png', 'path': 'images/objects/blutspritze.png'},
    {'name': 'images/objects/uberwachungsmonitor.png', 'path': 'images/objects/uberwachungsmonitor.png'},
    {'name': 'images/scenes/krieg_mit_panzer.png', 'path': 'images/scenes/krieg_mit_panzer.png'},
    {'name': 'images/objects/brennende_fackel.png', 'path': 'images/objects/brennende_fackel.png'},
    {'name': 'images/objects/tarnkleidung.png', 'path': 'images/objects/tarnkleidung.png'},
    {'name': 'images/objects/kaputtes_flugzeug.png', 'path': 'images/objects/kaputtes_flugzeug.png'},
    {'name': 'images/scenes/kerzen_am_boden.png', 'path': 'images/scenes/kerzen_am_boden.png'},
    {'name': 'images/objects/blutiger_kinderschuh.png', 'path': 'images/objects/blutiger_kinderschuh.png'},
    {'name': 'images/objects/verdreckte_kinderkleidung.png', 'path': 'images/objects/verdreckte_kinderkleidung.png'},
    {'name': 'images/scenes/krieg_mit_soldaten.png', 'path': 'images/scenes/krieg_mit_soldaten.png'},
    {'name': 'images/objects/morserbombe.png', 'path': 'images/objects/morserbombe.png'},
    {'name': 'images/objects/gewehrriemen.png', 'path': 'images/objects/gewehrriemen.png'},
    {'name': 'images/objects/armbrust.png', 'path': 'images/objects/armbrust.png'},
    {'name': 'images/scenes/op_saal.png', 'path': 'images/scenes/op_saal.png'},
    {'name': 'images/objects/tabletten.png', 'path': 'images/objects/tabletten.png'},
    {'name': 'images/scenes/leichenhalle.png', 'path': 'images/scenes/leichenhalle.png'},
    {'name': 'images/objects/raucherlunge.png', 'path': 'images/objects/raucherlunge.png'},
    {'name': 'images/objects/beinprothese.png', 'path': 'images/objects/beinprothese.png'},
    {'name': 'images/objects/op_besteck.png', 'path': 'images/objects/op_besteck.png'},
    {'name': 'images/scenes/zerstorte_gebaude.png', 'path': 'images/scenes/zerstorte_gebaude.png'},
    {'name': 'images/objects/kaputter_stuhl.png', 'path': 'images/objects/kaputter_stuhl.png'},
    {'name': 'images/scenes/tote_fische.png', 'path': 'images/scenes/tote_fische.png'},
    {'name': 'images/objects/harpune.png', 'path': 'images/objects/harpune.png'},
    {'name': 'images/objects/toter_seevogel.png', 'path': 'images/objects/toter_seevogel.png'},
    {'name': 'images/scenes/vermullte_wohnung.png', 'path': 'images/scenes/vermullte_wohnung.png'},
    {'name': 'images/objects/verschutteter_kaffee.png', 'path': 'images/objects/verschutteter_kaffee.png'},
    {'name': 'images/objects/pizzauberreste.png', 'path': 'images/objects/pizzauberreste.png'},
    {'name': 'images/objects/verschmutztes_wc.png', 'path': 'images/objects/verschmutztes_wc.png'},
    {'name': 'images/scenes/kuchenbrand.png', 'path': 'images/scenes/kuchenbrand.png'},
    {'name': 'images/objects/verbrannte_pfanne.png', 'path': 'images/objects/verbrannte_pfanne.png'},
    {'name': 'images/scenes/folterkammer.png', 'path': 'images/scenes/folterkammer.png'},
    {'name': 'images/objects/stachliger_baseballschlager.png', 'path': 'images/objects/stachliger_baseballschlager.png'},
    {'name': 'images/objects/satanischer_dolch.png', 'path': 'images/objects/satanischer_dolch.png'},
    {'name': 'images/objects/mundsperre.png', 'path': 'images/objects/mundsperre.png'},
    {'name': 'images/scenes/spinnweben_in_altem_auto.png', 'path': 'images/scenes/spinnweben_in_altem_auto.png'},
    {'name': 'images/objects/fauler_zahn.png', 'path': 'images/objects/fauler_zahn.png'},
    {'name': 'images/objects/hexenhut.png', 'path': 'images/objects/hexenhut.png'},
    {'name': 'images/scenes/unfallstelle_autobahn.png', 'path': 'images/scenes/unfallstelle_autobahn.png'},
    {'name': 'images/objects/erbrochenes.png', 'path': 'images/objects/erbrochenes.png'},
    {'name': 'images/objects/zerfetzter_autoreifen.png', 'path': 'images/objects/zerfetzter_autoreifen.png'},
    {'name': 'images/scenes/absturzendes_flugzeug.png', 'path': 'images/scenes/absturzendes_flugzeug.png'},
    {'name': 'images/objects/kotztute.png', 'path': 'images/objects/kotztute.png'},
    {'name': 'images/scenes/waldbrand.png', 'path': 'images/scenes/waldbrand.png'},
    {'name': 'images/objects/tote_kuh.png', 'path': 'images/objects/tote_kuh.png'},
    {'name': 'images/objects/feuerwehrschlauch.png', 'path': 'images/objects/feuerwehrschlauch.png'},
    {'name': 'images/scenes/vermullter_fluss.png', 'path': 'images/scenes/vermullter_fluss.png'},
    {'name': 'images/objects/besitz_eines_obdachlosen.png', 'path': 'images/objects/besitz_eines_obdachlosen.png'},
    {'name': 'images/objects/abfallcontainer.png', 'path': 'images/objects/abfallcontainer.png'},
    {'name': 'images/scenes/kaputtes_atomkraftwerk.png', 'path': 'images/scenes/kaputtes_atomkraftwerk.png'},
    {'name': 'images/objects/radioaktiver_mull.png', 'path': 'images/objects/radioaktiver_mull.png'},
    {'name': 'images/objects/schutzanzug.png', 'path': 'images/objects/schutzanzug.png'},
    {'name': 'images/scenes/gefangniszelle.png', 'path': 'images/scenes/gefangniszelle.png'},
    {'name': 'images/objects/kakerlake.png', 'path': 'images/objects/kakerlake.png'},
    {'name': 'images/objects/verdrecktes_waschbecken.png', 'path': 'images/objects/verdrecktes_waschbecken.png'},
    {'name': 'images/objects/fixierung.png', 'path': 'images/objects/fixierung.png'},
    {'name': 'images/scenes/plastikteppich_am_strand.png', 'path': 'images/scenes/plastikteppich_am_strand.png'},
    {'name': 'images/objects/tote_schildkrote.png', 'path': 'images/objects/tote_schildkrote.png'},
    {'name': 'images/objects/toter_fisch.png', 'path': 'images/objects/toter_fisch.png'},
    {'name': 'images/objects/tote_qualle.png', 'path': 'images/objects/tote_qualle.png'},
    {'name': 'images/scenes/verwahrlostes_badezimmer.png', 'path': 'images/scenes/verwahrlostes_badezimmer.png'},
    {'name': 'images/objects/spinne.png', 'path': 'images/objects/spinne.png'},
    {'name': 'images/scenes/verlassenes_haus.png', 'path': 'images/scenes/verlassenes_haus.png'},
    {'name': 'images/objects/totenkopf.png', 'path': 'images/objects/totenkopf.png'},
    {'name': 'images/objects/tiergebiss.png', 'path': 'images/objects/tiergebiss.png'},
    {'name': 'images/scenes/verlassenes_haus_im_wald.png', 'path': 'images/scenes/verlassenes_haus_im_wald.png'},
    {'name': 'images/objects/voodoo_puppe.png', 'path': 'images/objects/voodoo_puppe.png'},
    {'name': 'images/objects/waffe.png', 'path': 'images/objects/waffe.png'},
    {'name': 'images/scenes/dreckige_kuche.png', 'path': 'images/scenes/dreckige_kuche.png'},
    {'name': 'images/objects/schimmelnde_erdbeere.png', 'path': 'images/objects/schimmelnde_erdbeere.png'},
    {'name': 'images/objects/schimmelndes_brot.png', 'path': 'images/objects/schimmelndes_brot.png'},
    {'name': 'images/objects/dreckige_tasse.png', 'path': 'images/objects/dreckige_tasse.png'},
    {'name': 'images/scenes/verdorbene_fruchte.png', 'path': 'images/scenes/verdorbene_fruchte.png'},
    {'name': 'images/objects/biomulltonne.png', 'path': 'images/objects/biomulltonne.png'},
    {'name': 'images/objects/fruchtfliegen.png', 'path': 'images/objects/fruchtfliegen.png'},
    {'name': 'images/objects/schimmelnder_kuhlschrank.png', 'path': 'images/objects/schimmelnder_kuhlschrank.png'},
    {'name': 'images/scenes/steinschlag.png', 'path': 'images/scenes/steinschlag.png'},
    {'name': 'images/objects/tote_giraffe.png', 'path': 'images/objects/tote_giraffe.png'},
    {'name': 'images/objects/toter_steinbock.png', 'path': 'images/objects/toter_steinbock.png'},
    {'name': 'images/scenes/zahnarztpraxis.png', 'path': 'images/scenes/zahnarztpraxis.png'},
    {'name': 'images/objects/absauggerat.png', 'path': 'images/objects/absauggerat.png'},
    {'name': 'images/scenes/olverschmutzung.png', 'path': 'images/scenes/olverschmutzung.png'},
    {'name': 'images/objects/umgekipptes_fass.png', 'path': 'images/objects/umgekipptes_fass.png'},
    {'name': 'images/scenes/mulldeponie.png', 'path': 'images/scenes/mulldeponie.png'},
    {'name': 'images/objects/brennendes_motorrad.png', 'path': 'images/objects/brennendes_motorrad.png'},
    {'name': 'images/scenes/unordentlicher_schreibtisch.png', 'path': 'images/scenes/unordentlicher_schreibtisch.png'},
    {'name': 'images/objects/lebensmittelmotten.png', 'path': 'images/objects/lebensmittelmotten.png'},
    {'name': 'images/scenes/offentliche_toilette.png', 'path': 'images/scenes/offentliche_toilette.png'},
    {'name': 'images/objects/ampullen.png', 'path': 'images/objects/ampullen.png'},
    {'name': 'images/scenes/schlafplatz_obdachlose.png', 'path': 'images/scenes/schlafplatz_obdachlose.png'},
    {'name': 'images/objects/nasse_matratze.png', 'path': 'images/objects/nasse_matratze.png'},
    {'name': 'images/objects/tablettenverpackungen.png', 'path': 'images/objects/tablettenverpackungen.png'},
    {'name': 'images/scenes/dunkler_wald.png', 'path': 'images/scenes/dunkler_wald.png'},
    {'name': 'images/objects/blutige_axt.png', 'path': 'images/objects/blutige_axt.png'},
    {'name': 'images/objects/kaputte_vogelscheuche.png', 'path': 'images/objects/kaputte_vogelscheuche.png'},
    {'name': 'images/scenes/unfallstelle.png', 'path': 'images/scenes/unfallstelle.png'},
    {'name': 'images/objects/sarg.png', 'path': 'images/objects/sarg.png'},
    {'name': 'images/objects/dreckige_kinderflasche.png', 'path': 'images/objects/dreckige_kinderflasche.png'},
    {'name': 'images/scenes/kanalisation.png', 'path': 'images/scenes/kanalisation.png'},
    {'name': 'images/objects/tote_schlange.png', 'path': 'images/objects/tote_schlange.png'},
    {'name': 'images/objects/brandwunde.png', 'path': 'images/objects/brandwunde.png'},
    {'name': 'images/scenes/brennende_twin_towers.png', 'path': 'images/scenes/brennende_twin_towers.png'},
    {'name': 'images/objects/gasmaske.png', 'path': 'images/objects/gasmaske.png'},
    {'name': 'images/objects/essensreste.png', 'path': 'images/objects/essensreste.png'},
    {'name': 'images/scenes/schlangeninsel.png', 'path': 'images/scenes/schlangeninsel.png'},
    {'name': 'images/objects/atemschutzmaske.png', 'path': 'images/objects/atemschutzmaske.png'},
    {'name': 'images/scenes/blutiges_bett.png', 'path': 'images/scenes/blutiges_bett.png'},
    {'name': 'images/objects/mauseschadel.png', 'path': 'images/objects/mauseschadel.png'},
    {'name': 'images/scenes/brennende_savanne.png', 'path': 'images/scenes/brennende_savanne.png'},
    {'name': 'images/objects/verbranntes_tier.png', 'path': 'images/objects/verbranntes_tier.png'},
    {'name': 'images/objects/totes_krokodil.png', 'path': 'images/objects/totes_krokodil.png'},
    {'name': 'images/objects/tote_ratte.png', 'path': 'images/objects/tote_ratte.png'},
    {'name': 'images/scenes/umgekippter_schulbus.png', 'path': 'images/scenes/umgekippter_schulbus.png'},
    {'name': 'images/objects/blutiges_taschentuch.png', 'path': 'images/objects/blutiges_taschentuch.png'},
    {'name': 'images/objects/kaputtes_handy.png', 'path': 'images/objects/kaputtes_handy.png'},
    {'name': 'images/scenes/konzentrationslager.png', 'path': 'images/scenes/konzentrationslager.png'},
    {'name': 'images/objects/galgen.png', 'path': 'images/objects/galgen.png'},
    {'name': 'images/objects/haftlingskleidung.png', 'path': 'images/objects/haftlingskleidung.png'},
    {'name': 'images/scenes/kaputter_krankenwagen.png', 'path': 'images/scenes/kaputter_krankenwagen.png'},
    {'name': 'images/objects/blutiges_verbandszeug.png', 'path': 'images/objects/blutiges_verbandszeug.png'},
    {'name': 'images/scenes/hirschjagd.png', 'path': 'images/scenes/hirschjagd.png'},
    {'name': 'images/objects/flinte.png', 'path': 'images/objects/flinte.png'},
    {'name': 'images/scenes/kkk_kreuzverbrennung.png', 'path': 'images/scenes/kkk_kreuzverbrennung.png'},
    {'name': 'images/objects/blutiger_stacheldrahtkranz.png', 'path': 'images/objects/blutiger_stacheldrahtkranz.png'},
    {'name': 'images/objects/judenstern.png', 'path': 'images/objects/judenstern.png'},
    {'name': 'images/objects/feuerstelle.png', 'path': 'images/objects/feuerstelle.png'},
    {'name': 'images/scenes/massengrab.png', 'path': 'images/scenes/massengrab.png'},
    {'name': 'images/objects/gebeine.png', 'path': 'images/objects/gebeine.png'},
    {'name': 'images/scenes/tornado.png', 'path': 'images/scenes/tornado.png'},
    {'name': 'images/objects/umgesturztes_mofa.png', 'path': 'images/objects/umgesturztes_mofa.png'},
    {'name': 'images/scenes/dunkler_korridor.png', 'path': 'images/scenes/dunkler_korridor.png'},
    {'name': 'images/objects/tote_katze.png', 'path': 'images/objects/tote_katze.png'},
    {'name': 'images/scenes/pentagramm.png', 'path': 'images/scenes/pentagramm.png'},
    {'name': 'images/objects/tarotkarten.png', 'path': 'images/objects/tarotkarten.png'},
    {'name': 'images/scenes/achterbahnunfall.png', 'path': 'images/scenes/achterbahnunfall.png'},
    {'name': 'images/objects/gebrochener_arm.png', 'path': 'images/objects/gebrochener_arm.png'},
    {'name': 'images/scenes/vogelspinnenterrarium.png', 'path': 'images/scenes/vogelspinnenterrarium.png'},
    {'name': 'images/objects/toter_frosch.png', 'path': 'images/objects/toter_frosch.png'},
    {'name': 'images/scenes/schimmel_auf_wand.png', 'path': 'images/scenes/schimmel_auf_wand.png'},
    {'name': 'images/objects/kaputte_rohrleitung.png', 'path': 'images/objects/kaputte_rohrleitung.png'},
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
    text: 'Welches Bild war rechts unten?',
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
      trialList: 'Excel_forgetting_curve_emotional.xlsx',
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
