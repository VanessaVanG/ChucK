//IPMDA_7_Krampus_and_St_Nick's_Drumline

//xylo.ck

//Connect to reverb
BandedWG xylo => NRev rev => dac;

.4 => rev.mix; //reverb mix
0 => xylo.preset; //Uniform Bar (sounds like xylophone)
.5 => xylo.gain;

//Make MyScales and myBPM objects
MyScales scale;
myBPM rate;

//Function to get random note from scale array
fun int notes()
{    
    Math.random2(0, scale.cIonianFreq.cap() - 1) => int note;
    return note;
}

//Set up loop length
now + ((rate.wNote * 4) - rate.hNote) => time melody;

//Play tune
while(now < melody)
{
    notes() => int n;
    scale.cIonianFreq[n] * 4 => xylo.freq;
    Math.random2f(.4, 1) => xylo.noteOn;
    rate.sNote => now;
}

//Play ending roll
scale.cIonianFreq[0] * 4 => xylo.freq;
repeat(16)
{
    1 => xylo.noteOn;
    rate.tsNote => now;
}
1 => xylo.noteOff;
rate.wNote => now;
