//IPMDA_6_ChucK_Vibe

//bass.ck

//Sound Chain including OSCILLATOR
Mandolin bass => ADSR env => PRCRev rev => Pan2 pan => dac;
SinOsc sin => ADSR sinEnv => pan => dac;
sinEnv.set(0.1 :: second, 0.1 :: second, 0.5, 0.1 :: second);

//Sin wave adds depth to bass
.01 => sin.gain;

//Bass parameters
.1 => rev.mix;
.07 => bass.gain;
0.01 => bass.stringDetune;
0.02 => bass.bodySize;
.9 => bass.pluckPos;
-.7 => pan.pan; //PAN TOWARDS LEFT

//Set up durations
0.625::second => dur q; //quarter note
q / 2 => dur e; //eighth note
q / 3 => dur tr; //triplet
q / 4 => dur s; //sixteenth note
q / 8 => dur ts; //32nd note
q / 16 => dur sf; //64th note
q * 2 => dur h; //half note
q * 4 => dur w; //whole note

//Scale arrays
[41, 46, 44, 42, 41, 39] @=> int scale1[];
[44, 49, 48, 46, 44, 42] @=> int scale2[];

//infinite loop
while(true)
{
    //Get random number
    Math.random2(0, 1) => int randNum;
    
    //Possibilities
    
    //-------Scale1 choice-----------
    if(randNum == 0)
    {
        for(0 => int i; i < scale1.cap(); i++)
        {
            //Random note assignment
            Std.mtof(scale1[i]) => bass.freq => sin.freq;
            1 => bass.noteOn;
            //ADSR on
            1 => env.keyOn;
            1 => sinEnv.keyOn;
            //Subtract sf to account for noteOff time
            (q - sf) => now;
            
            1 => bass.noteOff;
            //ADSR off
            1 => env.keyOff;
            1 => sinEnv.keyOff;
            sf => now;
        }
    }
    //------------Scale2 choice------------
    else
    {
        for(0 => int i; i < scale2.cap(); i++)
        {
            Std.mtof(scale2[i] -12) => bass.freq => sin.freq;
            1 => bass.noteOn;
            1 => env.keyOn;
            1 => sinEnv.keyOn;
            (q - sf) => now;
            1 => bass.noteOff;
            1 => env.keyOff;
            1 => sinEnv.keyOff;
            sf => now;
        }
    }
}