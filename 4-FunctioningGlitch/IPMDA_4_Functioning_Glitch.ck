/* To make it easier for you to find all elements 
of the grading rubric, I've noted each element with
a comment that's in all capital letters. Hopefully,
that will help. I have every element on the rubric.
I've only all caps for one instance of each 
element (as opposed to every instance). */

/*This is getting closer to my type of "music" genre
and I know many of my peers evaluating this are 
probably not familiar with glitch/experimental/minimal
music. I'd like to ask you to keep an open mind and
check out some music in that genre if you are interested. */

//Prints title
<<< "IPMDA_4_Functioning_Glitch" >>>;

<<< "Please use headphones or good speakers to hear 
bass, panning, and nuance of the glitched sounds" >>>;

//Sound chain 
//SNDBUF and OSC
SinOsc sin => dac;
TriOsc tri => dac;
SinOsc chord[3];
SndBuf2 sound1 => dac;
SndBuf sound2 => dac;
SndBuf2 sound3 => dac;
Noise noise => Pan2 noisePan => dac;


//Read soundfile
me.dir() + "/audio/stereo_fx_04.wav" => sound1.read;
me.dir() + "/audio/hihat_04.wav" => sound2.read;
me.dir() + "/audio/stereo_fx_02.wav" => sound3.read;

//Set playheads to 0 and Oscs/noise to 0 gain so no sound is made
sound1.samples() => sound1.pos;
sound2.samples() => sound2.pos;
sound3.samples() => sound3.pos;
0 => sin.gain => tri.gain => noise.gain;

//Declare global VARIABLES
.3 => float myGain;
56 => int myNote;

//Set gain for soundfiles
myGain / 2 => sound1.gain => sound3.gain;
myGain  * 2 => sound2.gain;

//Set durations
.6::second => dur qtr; //.6 SECONDS = QUARTER NOTE LENGTH
1::qtr => dur q; //quarter note
2::qtr => dur h; //half note
.5::qtr => dur e; //eighth note
.25::qtr => dur s; //sixteenth note
.125::qtr => dur t; //32nd note

//Declare and initialize Eb MIXOLYDIAN mode ARRAY 
[51, 53, 55, 56, 58, 60, 61, 63] @=> int EbMix[];

//Set Seed so song is the same for every play
Math.srandom(42);

//FIRST FUNCTION - MY OWN
//Glitch the soundfiles function
fun void glitch( SndBuf myWav, int steps, int rateDivisor )
{
    myWav.samples() / steps => int grain; //get the grain
    (grain / rateDivisor) * - 1 => myWav.rate; //set play rate and make it backwards
    Math.random2(0,myWav.samples() - 1) => myWav.pos; //RANDOMly set grain position
    grain::samp => now;
}

//SECOND FUNCTION - from lecture
//Volume Swell function
fun void swell( float begin, float end, float grain )
{ 
    //swell up
    for( begin => float j; j < end; j + grain => j)
    {
        j => tri.gain; //set volume
        .01::second => now;
    }
    
    //swell down
    for( end => float j; j > begin; j - grain => j)
    {
        j => tri.gain; 
        .01::second => now;
    }
}

//THIRD FUNCTION - from lecture
//function plays a chord
fun void playchord( int root, string quality, dur length)
{
    //function will make major or minor chords
    
    //root
    Std.mtof(root) => chord[0].freq; //Use STD.MTOF
    
    //third
    if( quality == "major" )
    {
        Std.mtof(root + 4) => chord[1].freq;
    }
    else if( quality == "minor" )
    {
        Std.mtof(root + 3 ) => chord[1].freq;
    }
    else
    {
        <<< "Must specify 'major' or 'minor' " >>>;
    }
    
    //fifth
    Std.mtof(root + 7) => chord[2].freq;
    length => now;
}

//Main Program

//----------------Intro----------------

//Intro note array
[61,0,61,0,61,0,60,0,55,0,56] @=> int introNote[];
//Intro duration array
[s,s,s,s,e,t,q,t,q,t,h] @=> dur introDur[];
//Play intro with FOR LOOP
for(0 => int i; i < introNote.cap(); i++)
{
    myGain / 100 => noise.gain; //turn on noise
    -.5 => noisePan.pan; //PAN noise toward the left
    Std.mtof(introNote[i]) => tri.freq; //convert midi to freq# and assign
    swell(.05, .2, .01); //call swell function
    introDur[i] => now; //play
}

//----------------First Section----------------
//Set up loop time lengths
now + 7::second => time firstSection;

//WHILE LOOP lasts the length of firstSection
while(now < firstSection)
{ 
    //Lower tri volume for drone note
    myGain / 15 => tri.gain;  
    
    //Turn off noise
    0 => noise.gain;
    
    //For the Bass Line (clicks are intentional)
    Std.mtof(myNote - 24) => sin.freq; //set bass freq for 2 octaves below
    myGain / 2 => sin.gain; //turns on bass
    
    //Make variables for min and max for random range
    0 => int min;
    EbMix.cap() -1 => int max;
    
    //Get a random midi note    
    EbMix[Math.random2(min, max)] => int bassMidi;
    
    //Convert to frequency # and put in new variable
    Std.mtof(bassMidi) => float bassFreq;
    
    /* Divide frequency by 4 (this lowers the note by two octaves,
    as permitted in the assignment instructions) */
    4  /=> bassFreq;
    
    //Bass note will have a 1 in 6 chance of changing
    //IF LOOP
    if (Math.random2(1,6) == 1)
    {
       bassFreq => sin.freq;
    }
    
    //Use glitch function on soundfiles
    glitch(sound1, 90, 155);
    glitch(sound2, 160, 120);
    glitch(sound3, 240, 65); 
}

//----------------Second Section----------------
//loop for secondSection
now + 6::second => time secondSection;
while(now < secondSection)
{
    //For bass (continues as drone note)
    myGain / 4 => sin.gain; //lower volume
    
    //Turn off tri Osc
    0 => tri.gain;
        
    //Use glitch function on soundfiles
    glitch(sound2, 150, 120);
    glitch(sound3, 220, 65);
}

//----------------Ending Part 1-------------------------
//Connect each element of chord array to dac and adjust gain
for(0 => int i; i < chord.cap(); i++)
{
    chord[i] => dac;
    (myGain -.1) / chord.cap() => chord[i].gain;
}

//Play intro array again as chord for ending
for(0 => int i; i < introNote.cap(); i++)
{
    playchord(introNote[i], "minor", introDur[i]);
} 

//----------------Ending Part 2----------------
//Lower chord volume
for(0 => int i; i < chord.cap(); i++)
{
    //chord[i] => dac;
    (myGain - .2) / chord.cap() => chord[i].gain;
}
//Play intro again for ending
for(0 => int i; i < introNote.cap(); i++)
{
    myGain / 100 => noise.gain; //turn on noise
    .5 => noisePan.pan; //pan toward right
    Std.mtof(introNote[i]) => tri.freq;
    swell(.05, .2, .01);
    introDur[i] => now;
}   

<<< "Thanks for listening and evaluating!" >>>;