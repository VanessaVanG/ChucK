//IPMDA_8_Little_g_ChucKed

//bar2.ck

//Sound chain
ModalBar bar => dac;

//Make MyScales and myBPM objects
MyScales scale;
myBPM beat;

//Parameters
.9 => float myGain; 
myGain => bar.gain;
6 => bar.preset; //preset "Beats"
.1 => bar.stickHardness;
.5 => bar.strikePosition;
0 => bar.directGain;
.7 => bar.masterGain;
.9 => float delGain;

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
    delGain => del[i].gain;
    //Give delay lines half note, 9/16 note, 5/8 note of delay each
    (beat.hNote + i * beat.sNote) => del[i].max => del[i].delay;
}

//Function to play 
fun void bar2Play()
{
    while(true)
    {
        //Randomly pick notes from c Ionian
        scale.cIonianFreq[Math.random2(0,6)] => bar.freq; 
        1 => bar.noteOn;
        beat.qNote  => now;
    }
}

//Function to fade out
fun void fadeOut()
{
    //Decrease a little each loop
    for(0 => int i; i < 200; i++)
    {
        bar.gain() / 2 => bar.gain;
        bar.masterGain() / 2 => bar.masterGain;
    }
 }  

//Function to fade out delay lines
fun void delFadeOut()
{
    //.9 => float delGain;
    for(0 => int i; i < 200; i++)
    {
        delGain / 2 => float newGain;
        
        for(0 => int i; i < 3; i++)
        {
            newGain => del[i].gain;
        }
    }
}

//Spork the functions 
spork ~ bar2Play();
beat.wNote * 5 => now;
spork ~ fadeOut();
spork ~ delFadeOut();
//so sporking works
while(true) second => now;