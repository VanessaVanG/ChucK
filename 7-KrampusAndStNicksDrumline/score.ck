//IPMDA_7_Krampus_and_St_Nick's_Drumline

//score.ck

//Make myBPM object and set tempo to 96 bpm
myBPM rate;
rate.tempo(96);

//add bar
Machine.add(me.dir() + "/bar.ck") => int barID;

//add snare
rate.hNote => now;
Machine.add(me.dir() + "/snare.ck") => int snareID;

//add clack
rate.hNote => now;
Machine.add(me.dir() + "/clack.ck") => int clackID;

//add click
rate.hNote => now;
Machine.add(me.dir() + "/click.ck") => int clickID;

//add tunedbar
rate.hNote => now;
Machine.add(me.dir() + "/tndbar.ck") => int tndbarID;

//add boom
((5 * rate.wNote) - rate.qNote) => now;
Machine.add(me.dir() + "/boom.ck") => int boomID;

//add xylophone
(rate.wNote + rate.hNote) => now;
Machine.add(me.dir() + "/xylo.ck") => int xyloID;

(5 * rate.wNote) => now;