dac => WvOut2 w => blackhole;

//conductor/beat-timer class
Machine.add(me.dir() + "/myBPM.ck");

//scales class
Machine.add(me.dir() + "/MyScales.ck");

Machine.add(me.dir() + "/Bouncy.ck");

"IPMDA_8a" => w.wavFilename;
1 => w.record;

// add score.ck
me.dir() + "/score.ck" => string scorePath;
Machine.add(scorePath);
62::second => now;

0 => w.record;
w.closeFile();