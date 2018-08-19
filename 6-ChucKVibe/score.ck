//IPMDA_6_ChucK_Vibe

//score.ck

// paths to chuck files
me.dir() + "/vibes.ck" => string vibesPath;
me.dir() + "/bass.ck" => string bassPath;
me.dir() + "/drums.ck" => string drumsPath;
me.dir() + "/guitar.ck" => string guitarPath;
me.dir() + "/ending.ck" => string endingPath;

//USE MACHINE.ADD TO LAUNCH FILES
//start vibes (Main instrument)
Machine.add(vibesPath) => int vibesID;

//start bass
Machine.add(bassPath) => int bassID;

//start drums
Machine.add(drumsPath) => int drumsID;

//start guitar
Machine.add(guitarPath) => int guitarID;

27.5::second => now;

//Remove vibes, bass, and guitar files
Machine.remove(vibesID);
Machine.remove(bassID);
Machine.remove(guitarID);

//start ending
Machine.add(endingPath) => int endingID;

1.25::second => now;

//Remove drums file
Machine.remove(drumsID);

1.25::second => now;

//remove ending file
Machine.remove(endingID);

