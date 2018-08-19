//IPMDA_7_Krampus_and_St_Nick's_Drumline

//click.ck

//Connect modalbar to reverb and pan
ModalBar click => JCRev rev => Pan2 pan => dac;

//click parameters
5 => click.preset; //Wood2 preset
.04 => click.gain;
-.8 => pan.pan; //pan toward left
1 => rev.mix; //reverb mix

//Make MyScales object
MyScales scale;

//Multiply by 4 to raise octaves
(scale.cIonianFreq[5] * 4) => click.freq;

//Recursive function to do a roll
fun int roll(int x)
{
    if(x >= 25)
    {
        1 => click.noteOn;
        x::ms => now;
        return roll(x - 1);
    }
    else
    {
        return 0;
    }
}

//Call roll function
roll(156);