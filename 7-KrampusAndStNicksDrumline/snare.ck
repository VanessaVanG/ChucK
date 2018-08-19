//IPMDA_7_Krampus_and_St_Nick's_Drumline

//snare.ck

//Connect to reverb and pan
SndBuf snare => JCRev rev => Pan2 pan => dac;

1 => rev.mix; //reverb mix

//read in sound file
me.dir(-1) + "/audio/snare_01.wav" => snare.read;
//set playhead to zero so no sound
snare.samples() => snare.pos;

.02 => snare.gain;
-.5 => pan.pan; //pan toward left

//Recursive function to do a roll
fun int roll(int x)
{
    if(x >= 25)
    {
        0 => snare.pos;
        x::ms => now;
        return roll(x - 1);
    }
    else
    {
        return 0;
    }
}

//Call roll function
roll(172);