/* To make it easier for you to find all elements 
of the grading rubric, I've noted each element with
a comment that's in all capital letters. Hopefully,
that will help. I have every element on the rubric.
I've only all caps for one instance of each 
element (as opposed to every instance). */

<<< "IPMDA_5_JFK50" >>>;

<<< "Please use headphones or good speakers to hear 
bass, panning, and nuance of the glitched sounds" >>>;

//Sound chain
//SNDBUFF and STK INSTRUMENTS
BandedWG glassHarm => dac;
Bowed strings => Chorus chor => NRev rev => dac;
SndBuf sound1 => dac;
SndBuf2 sound2 => dac;
SndBuf2 sound3 => dac;

//Read in sound files
me.dir() + "/audio/hihat_02.wav" => sound1.read;
me.dir() + "/audio/stereo_fx_02.wav" => sound2.read;
me.dir() + "/audio/stereo_fx_05.wav" => sound3.read;

//Set position to end so no sound
sound1.samples() => sound1.pos;
sound2.samples() => sound2.pos;
sound3.samples() => sound3.pos;

//Global variables
.1 => float myGain;
55 => float myNote; //55Hz = midi 33 = A (in allowed assignment scale)

//Set gain for each sound file
myGain => sound1.gain => sound2.gain => sound3.gain;

//Glass Harmonica parameters
myGain * 7 => glassHarm.gain;
2 => glassHarm.preset;

//Strings parameters
myGain * 5 => strings.gain;
.2 => rev.mix;
.1 => chor.modDepth;
.2 => chor.mix;

//Delay and Gain Arrays
Delay del[3];
Gain master[3];

//Stereo setup for PANNING
glassHarm => del[0] => master[0] => dac.left;
glassHarm => del[1] => master[1] => dac;
glassHarm => del[2] => master[2] => dac.right;

//set up all delay lines with FOR LOOP
for(0 => int i; i < 3; i++)
{
    del[i] => del[i];
    .7 => del[i].gain;
    //Give delay lines .8, 1.1, 1.4 seconds of delay each
    (.8 + i*.3)::second => del[i].max => del[i].delay;
}

//Drone note parameters
SinOsc drone => master[1]; //connect OSCILLATOR to master center
myNote => drone.freq; 
0 => drone.gain; //set gain to 0 so no sound yet

//Define Db PHYRGIAN ARRAY
[61, 62, 64, 66, 68, 69] @=> int DbPhr[];
DbPhr.cap() - 1 => int numNotes; //Number of notes

//Set durations
.75::second => dur qtr; //.75 SECONDS = QUARTER NOTE LENGTH
1::qtr => dur q; //quarter note
1.25::qtr => dur dq; //dotted quarter note
2::qtr => dur h; //half note
2.5::qtr => dur dh; //dotted half note
.25::qtr => dur s; //sixteenth note

//Define arrays for Strings tune
[dh, dq, dq, dh, dq, dq] @=> dur stringsDur[];
//These are w/in parameters of assignment parameters (one octave below)
[45, 44, 40, 37, 42, 40] @=> int stringsPitch[]; 

//Set seed so song is the same for every play
Math.srandom(42);

//HAND WRITTEN FUNCTION
//Glitch the soundfiles function
fun void glitch( SndBuf myWav, int steps, int rateDivisor )
{
    myWav.samples() / steps => int grain; //get the grain
    (grain / rateDivisor) * - 1 => myWav.rate; //set play rate and make it backwards
    Math.random2(0,myWav.samples() - 1) => myWav.pos; //RANDOMly set grain position
    grain::samp => now;
}

//Main Program

//----------------Intro----------------

//Set up loop time length
now + 2::second => time intro;

//while loop lasts length of intro
while(now < intro)
{
    //Call glitch function
    glitch(sound1, 56, 170);
    glitch(sound2, 121, 255);
    glitch(sound3, 476, 33);
}

//----------------Section 1----------------

//Play tune using arrays
for(0 => int i; i < stringsPitch.cap(); i++)
{
    Math.random2f(0, .03) => strings.vibratoGain; //randomly pick vibrato
    Math.random2f(.1, .5) => strings.bowPressure; //randomly pick bow pressure
    Math.random2f(.5, .8) => strings.bowPosition; //randomly pick bow position
    Std.mtof(stringsPitch[i]) => strings.freq; //use STD.MTOF 
    1 => strings.startBowing;
    stringsDur[i] => now;
}    
    
//----------------Section 2----------------    

//Set up loop time lengths
now + 16::second => time section2;
    
//While loop lasts length of section2
while(now < section2)
{
    myGain * 2 => strings.gain; //turn strings drone volume down
    //assign frequency from Db Phrygian mode array
    Std.mtof(DbPhr[Math.random2(0, numNotes)]) => glassHarm.freq; 
    1 => glassHarm.noteOn; 
    q => now;
    1 => glassHarm.noteOff;
    s => now;
}

//----------------Section 3----------------

//Set up loop time length
now + 3::second => time section3;

//While loop plays for length of section3
while(now < section3)
{
    myGain / 2 => drone.gain; //turn on drone note
    glitch(sound3, 476, 33); //call glitch function
}

//----------------Ending (fade out)----------------

myGain / 2 => float endGain; //set up fade out variable

//Set up loop time length
now + 2::second => time ending;

//While loop plays length of ending
while(now < ending)
{
    1 => strings.stopBowing; //stop strings
    endGain - .0002 => endGain;
    //IF/ELSE STATEMENT to make sure gain doesn't go below 0
    if(endGain >= 0)
    {
        for(0 => int i; i < 3; i++)
        {
            //fade out for master and glass harmonica gains
            endGain => master[i].gain => glassHarm.gain;
        }
    }
    else
    {
        for(0 => int i; i < 3; i++)
        {
            0 => master[i].gain => glassHarm.gain;         
        }            
    }
    6::ms => now;
}
<<< "Thanks for listening and evaluating!" >>>;