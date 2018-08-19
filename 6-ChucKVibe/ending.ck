//IPMDA_6_ChucK_Vibe

//ending.ck

//Sound Chain
ModalBar vibes => Delay del => NRev rev => dac;

//Parameters
.2 => rev.mix;
1 => vibes.preset;
.2 => vibes.gain;
.9 => vibes.stickHardness;
.5 => vibes.strikePosition;
.9 => vibes.vibratoGain;
0 => vibes.damp;

//set up delay
del => del;
.9 => del.gain;

//Set up durations
0.625::second => dur q; //quarter note
q / 2 => dur e; //eighth note
q / 3 => dur tr; //triplet
q / 4 => dur s; //sixteenth note
q / 8 => dur ts; //32nd note
q / 16 => dur sf;
q * 2 => dur h; //half note
q * 4 => dur w; //whole note

//-----------Roll on F--------------
//Set freq to midi 53
Std.mtof(53) => vibes.freq;

//repeat 32nd notes
repeat(16)
{
    1 => vibes.strike;
    ts => now;
}

//-----------Final Bb----------------
//Set to Bb
Std.mtof(58) => vibes.freq;

//Play
1 => vibes.strike;
h => now;