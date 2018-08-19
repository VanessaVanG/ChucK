//IPMDA_8_Little_g_ChucKed

//bar.ck

//Sound chain
ModalBar bar => dac;

//Make MyScales and myBPM objects
MyScales scale;
myBPM beat;

//Parameters
.5 => float myGain;
myGain => bar.gain;
0 => bar.preset; //preset "Marimba"
.1 => bar.stickHardness;

//Make delay array
Delay del[3];

//Pan each
bar => del[0] => dac.left;
bar => del[1] => dac;
bar => del[2] => dac.right;

//Set up delay lines
for(0 => int i; i < 3; i++)
{
    del[i] => del[i];
    .7 => del[i].gain;
    //Give delay lines half note, 9/16 note, 5/8 note of delay each
    (beat.hNote + i * beat.sNote) => del[i].max => del[i].delay;
}

//Function to play
fun void barPlay()
{
    while(true)
    {
        //Randomly pick notes from c Ionian
        scale.cIonianFreq[Math.random2(0,6)] => bar.freq;
        1 => bar.noteOn;
        beat.qNote => now;
    }
}
//Function to fade out
fun void fadeOut()
{
    //Decrease gain a little for each loop
    for(0 => int i; i < 200; i++)
    { 
        bar.gain() / 4 => bar.gain;
    }
}    

//Spork the functions
spork ~ barPlay();
beat.wNote * 3 => now;
spork ~ fadeOut();
//So sporking works
while(1) second => now;    