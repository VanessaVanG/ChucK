//IPMDA_8_Little_g_ChucKed

//gong.ck
//Somewhat gong-like (but not really)

//Sound chain
BandedWG gong => dac;
BandedWG gong2 => dac;

//Make class objects
MyScales scale;
myBPM beat;

//Parameters
.1 => float myGain;
3 => gong.preset => gong2.preset; //preset "Tibetan Bowl"
myGain  => gong.gain;
myGain * 2 => gong2.gain;
scale.cIonianFreq[5]   => gong.freq;
(scale.cIonianFreq[2] / 6) => gong2.freq;

//Function to play gong
fun void dora()
{
    //Strike bowl
    1 => gong.noteOn;
    //Start bowing bowl
    1 => gong.startBowing;
    //Loop to increase bowing pressure
    for(0 => int i; i < 12; i++)
    {
        .1 * i => gong.bowPressure;
        beat.hNote => now;
    }
}

//Function to play gong2
fun void dora2()
{
    1 => gong2.noteOn;
    beat.qNote => now;//pass some time before bowing
    1 => gong2.startBowing;
    for(0 => int i; i < 12; i++)
    {
        .1 * i => gong2.bowPressure;
        beat.hNote => now;
    }
}

//Spork the functions
spork ~ dora();
spork ~ dora2();
//So sporking works
beat.wNote * 5 => now;