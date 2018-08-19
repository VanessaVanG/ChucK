dac => WvOut2 w => blackhole;

"IPMDA_6_ChucK_Vibe2.wav" => w.wavFilename;
1 => w.record;

// add score.ck
me.dir() + "/score.ck" => string scorePath;
Machine.add(scorePath);
30::second => now;

0 => w.record;
w.closeFile();