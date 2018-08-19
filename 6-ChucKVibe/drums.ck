//IPMDA_6_ChucK_Vibe

//drums.ck

//Set up shaker
Shakers shak => PRCRev rev => Pan2 shakPan => dac;
.1 => rev.mix;
11 => shak.preset;
.7 => shak.gain;
.9 => shakPan.pan; //Pan towards right

//Set up durations
0.625::second => dur q; //quarter note
q / 2 => dur e; //eighth note
q / 3 => dur tr; //triplet
q / 4 => dur s; //sixteenth note
q / 8 => dur ts; //32nd note
q / 16 => dur sf; //64th note
q * 2 => dur h; //half note
q * 4 => dur w; //whole note

//Snare Setup using SNDBUF
SndBuf snare => NRev snareRev => Pan2 snarePan => dac;
//Read in sound file
me.dir(-1) + "/audio/snare_03.wav" => snare.read;
//Set playhead to end so no sound
snare.samples() => snare.pos;
//Snare parameters
.2 => snare.gain;
-.9 => snarePan.pan; //pan towards left
.08 => snareRev.mix;

//Spork the functions
spork ~ shaker();
spork ~ click();
//so sporking works
while(true) 1::second => now;

//------------Functions------------
//shaker function
fun void shaker()
{
    while(true)
    {
        1 => shak.noteOn;
        e => now;
    }
}
//Snare function
fun void click()
{
    while(true)
    {
        0 => snare.pos;
        q => now;
        0 => snare.pos;
        q + e => now;
        0 => snare.pos;
        q => now;
    }
}