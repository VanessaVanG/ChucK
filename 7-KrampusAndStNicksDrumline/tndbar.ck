//IPMDA_7_Krampus_and_St_Nick's_Drumline

//tndbar.ck

//Connect tunedbar to reverb
BandedWG tndbar => JCRev rev => dac;

1 => rev.mix; //reverb mix
0 => tndbar.preset; //tuned bar preset
.08 => tndbar.gain;
//89 => int tndbarNote;

//Make MyScales object
MyScales scale;

//Multiply by 8 to raise octaves
(scale.cIonianFreq[3] * 8) => tndbar.freq;

//Recursive function to do a roll
fun int roll(int x)
{
    if(x >= 25)
    {
        1 => tndbar.noteOn;
        x::ms => now;
        return roll(x - 1);
    }
    else
    {
        return 0;
    }
}

roll(149);