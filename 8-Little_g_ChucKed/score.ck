//IPMDA_8_Little_g_ChucKed

//score.ck

//Make myBPM object and set bpm
myBPM rate;
rate.tempo(120);

//Paths to files
me.dir() + "/sounds.ck" => string soundsPath;
me.dir() + "/bounces.ck" => string bouncesPath;
me.dir() + "/bar.ck" => string barPath;
me.dir() + "/bar2.ck" => string bar2Path;
me.dir() + "/boomy.ck" => string boomyPath;
me.dir() + "/gong.ck" => string gongPath;

//add sounds
Machine.add(soundsPath) => int soundsID;

//add bounces
rate.wNote => now;
Machine.add(bouncesPath) => int bouncesID;

//add boomy and gong
(rate.wNote * 16) - rate.hNote => now;
Machine.add(boomyPath) => int boomyID;
Machine.add(gongPath) => int gongID;

//add bar
rate.wNote => now;
Machine.add(barPath) => int barID;

//add bar2
rate.wNote * 4 => now;
Machine.add(bar2Path) => int bar2ID;

//remove bar, bar2
(rate.wNote * 8) + rate.hNote => now;
Machine.remove(barID);
Machine.remove(bar2ID);

//remove remaining
(rate.wNote ) => now;
Machine.remove(soundsID);
Machine.remove(boomyID);
Machine.remove(bouncesID);