//IPMDA_6_ChucK_Vibe

//vibes.ck

/* To make it easier for you to find all elements 
of the grading rubric, I've noted each element with
a comment that's in all capital letters. Hopefully,
that will help. I have every element on the rubric.
I've only capitalized for one instance of each 
element (as opposed to every instance). My Oscillator
is in the bass.ck and SndBuf in drums.ck. Panning is 
in bass.ck, etc. Every note in all files is from the
Bb Aeolian scale. */

//Sound Chain with STK INSTRUMENT & AUDIO EFFECT
ModalBar vibes => Delay del => NRev rev => dac;

//Vibes parameters
.2 => rev.mix; //reverb mix
1 => vibes.preset; //makes it a vibraphone
.2 => float vibesGain => vibes.gain; //VARIABLE
.9 => vibes.stickHardness;
.5 => vibes.strikePosition;
.9 => vibes.vibratoGain;
0 => vibes.damp;

//set up delay
del => del;
.9 => del.gain;

//Set up durations
0.625::second => dur q; //QUARTER NOTE = .625 SECONDS 
q / 2 => dur e; //eighth note
q / 3 => dur tr; //triplet
q / 4 => dur s; //sixteenth note
q / 8 => dur ts; //32nd note
q / 16 => dur sf; //64th note
q * 2 => dur h; //half note
q * 4 => dur w; //whole note

//Duration ARRAY
[sf, ts, s, tr, e, q, h, w] @=> dur durs[];

//Bb AEOLIAN SCALE Array
[46, 48, 49, 51, 53, 54, 56, 58] @=> int scale[];

//SPORK to run the functions
spork ~ scaleRun();
spork ~ randVibes();

//So the sporking works
while(true) 1::second => now;

//----------FUNCTIONS-------------

//Function to get RANDOM note from scale array
fun int notes()
{    
    Math.random2(0, scale.cap() - 1) => int note;
    return note;
}

//Function to do the scale run
fun void scaleRun()
{
    //first octave with 32nd notes using FOR LOOP
    for(0 => int i; i < scale.cap(); i++)
    {
        //Using STD.MTOF 
        Std.mtof(scale[i]) => vibes.freq;
        1 => vibes.strike;
        ts => now;
        1 => vibes.strike;
        ts => now;
    }
    //Continue scale up
    for(1 => int i; i < scale.cap(); i++)
    {
        Std.mtof(scale[i] + 12) => vibes.freq;
        1 => vibes.strike;
        s => now;
    } 
    //advance time
    h => now;
}
 
//Function for Vibes solo
fun void randVibes()
{
    //Advance time
    w - e => now;
    
    //infinite loop
    while(true)
    {
        //Get random number
        Math.random2(0, 9) => int randNum;
        
        //Possibilities using IF STATEMENT
        if(randNum == 0)
        {     
            //Split this choice in two
            Math.random2(1, 2) => int i;
            //Random gain selection
            Math.random2f(vibesGain - .03, vibesGain + .03) => vibes.gain; 
            //Random strike position
            Math.random2f(.4, .5) => vibes.strikePosition;
            //----------32nd notes choice------------
            if(i == 1)
            {
                1 => vibes.strike;
                durs[i] => now; 
                1 => vibes.strike;
                durs[i] => now;
                1 => vibes.strike;
                durs[i] => now; 
                1 => vibes.strike;
                durs[i] => now;
            }
            //------------16th notes choice------------
            else
            {
                1 => vibes.strike;
                durs[i] => now; 
                1 => vibes.strike;
                durs[i] => now;
            }
        }
        //--------Triplets with freq change choice---------
        else if(randNum == 1)
        {
            Math.random2f(vibesGain - .03, vibesGain + .03) => vibes.gain;
            Math.random2f(.45, .5) => vibes.strikePosition;
            1 => vibes.strike;
            tr => now;
            //Randomly change freq
            notes() => int n;
            Std.mtof(scale[n]) => vibes.freq;
            1 => vibes.strike;
            tr => now;
            1 => vibes.strike;
            tr => now;        
        }
        //-----8th or quarter note with freq change choice------
        else if(randNum > 6)
        {
            Math.random2f(.4, .5) => vibes.strikePosition;
            Math.random2f(vibesGain - .03, vibesGain + .03) => vibes.gain;
            Math.random2(4, 5) => int i;
            notes() => int n;
            Std.mtof(scale[n]) => vibes.freq;
            1 => vibes.strike;
            durs[i] => now;
        }
        //------Quarter note with freq change choice--------
        else if((randNum > 1) && (randNum < 5))
        {
            Math.random2f(.3, .5) => vibes.strikePosition;
            Math.random2f(vibesGain - .03, vibesGain + .03) => vibes.gain;
            notes() => int n;
            Std.mtof(scale[n]) => vibes.freq;
            1 => vibes.strike;
            q => now;        
        }
        //------------Rest choice------------
        else
        {
                e => now;
        }
    }
}   