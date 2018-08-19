//IPMDA_7_Krampus_and_St_Nick's_Drumline

//clack.ck

//Connect shaker to reverb and pan
Shakers clack => JCRev rev => Pan2 pan => dac;

12 => clack.preset; //Coke Can preset
.06 => clack.gain;
.8 => pan.pan; //pan toward right
1 => rev.mix; //reverb mix

//Recursive function to do a roll
fun int roll(int x)
{
    if(x >= 26)
    {
        1 => clack.noteOn;
        x::ms => now;
        return roll(x - 1);
    }
    else
    {
        return 0;
    }
}

//Call roll function
roll(165);