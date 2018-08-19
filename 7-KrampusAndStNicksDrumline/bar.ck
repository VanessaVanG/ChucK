//IPMDA_7_Krampus_and_St_Nick's_Drumline

//bar.ck

//Connect bar to reverb and pan
BandedWG bar => JCRev rev => Pan2 pan => dac;

1 => rev.mix; //reverb  mix
.5 => pan.pan; //pan toward right
0 => bar.preset; //uniform bar preset (sounds like xylo)
.3 => bar.gain;

//Make MyScales object
MyScales scale;

//Multiply by 4 to raise octaves
(scale.cIonianFreq[0] * 4) => bar.freq;

//Recursive function to do a roll
fun int roll(int x)
{
    if(x >= 25)
    {
        1 => bar.noteOn;
        x::ms => now;
        return roll(x - 1); 
    }
    else
    {
        return 0;
    }
}

//Call roll function
roll(179);