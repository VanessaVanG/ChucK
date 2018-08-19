<<< "IPMDA_3_Assignment_Techno_for_NES" >>>;
<<< "Please use headphones or good speakers to hear panning and bass" >>>;

//Sound Chain
TriOsc tri => Pan2 tripan => dac;
SawOsc saw => Pan2 sawpan => dac;
SinOsc sin => dac;

SndBuf kick => dac;
SndBuf hat => dac;
SndBuf snare => Pan2 snarepan => dac;
SndBuf2 stereoSound => dac;

//Array of strings to load sound files (per requirement)
string snareSamps[2];
me.dir() + "/audio/snare_01.wav" => snareSamps[0];
me.dir() + "/audio/snare_03.wav" => snareSamps[1];

//load other soundfiles
me.dir() + "/audio/kick_01.wav" => kick.read;
me.dir() + "/audio/hihat_02.wav" => hat.read;
me.dir() + "/audio/stereo_fx_01.wav" => stereoSound.read;

//set all (except stereoSound)playheads to end so no sound is made
kick.samples() => kick.pos;
hat.samples() => hat.pos;
//stereoSound.samples() => stereoSound.pos; 

//Set sound files gain
.2 => snare.gain;
.2 => kick.gain;
.1 => hat.gain;
.3 => stereoSound.gain;

//Set Oscillators volume to zero
0 => tri.gain => saw.gain => sin.gain;

//Declare and Initialize D Dorian Array
[50, 52, 53, 55, 57, 59, 60, 62] @=> int ddorian[];

//Initialize variables
0 => int counter;
19 => float timeLength; //time length desired for main
.25 => float qtrLength; //quarter note length
timeLength / qtrLength => float loopNum;
0 => float myNote;
0 => int offGain;
.010 => float onGain;
stereoSound.samples() => int numSamples;

//Set Seed so song is the same for every play
Math.srandom(173);

//Make variables for ddorian min and max for random range 
0 => int min;
ddorian.cap() -1 => int max;

//Little Diddy (2 seconds)
//Note array
[69, 0, 65, 0, 62, 0, 62, 0, 65, 0, 69] @=> int diddy[];

//Set durations
.25::second => dur qtr;
1::qtr => dur q; //quarter note
2::qtr => dur h; //half note
.5::qtr => dur e; //eight note
.25::qtr => dur s; //sixteenth note

//duration array
[h, s, h, s, h, s, e, s, e, s, q] @=> dur diddyDur[];

for( 0 => int i; i < diddy.cap(); i++)
{
    Std.mtof(diddy[i]) => tri.freq => saw.freq;
    onGain => tri.gain => saw.gain;
    diddyDur[i] => now; 
}

//Main Section

//Loop plays for 
while(counter <= loopNum)
{
    //8 beats
    counter % 8 => int beat;
    
    //kick on 0, 2, 4, 6
    if((beat == 0) || (beat == 2) || (beat == 4) || (beat == 6))
    {
        0 => kick.pos;
    }
    
    //Randomize snare selection for beats 2 and 6
    if((beat == 2) || (beat == 6))
    {
        Math.random2(0, snareSamps.cap() - 1) => int which; //0 or 1
        snareSamps[which] => snare.read; //read in the sample
        Math.random2f(-1,1) => snarepan.pan; //random panning
        0 => snare.pos; 
    }
    
    //hihat on 1, 3, 5, and 7
    if((beat == 1) || (beat == 3) || (beat == 5) || (beat ==7))
    {
        0 => hat.pos;
    }
    
    //For the Bass Line     
    //Get a random midi note    
    ddorian[Math.random2(min, max)] => int bassMidi;
    
    //Convert to frequency # and put in new variable
    Std.mtof(bassMidi) => float bassFreq;
    
    /* Divide frequency by 4 (this lowers the note by two octaves,
    as permitted in the assignment instructions) */
    4  /=> bassFreq;
    
    //Bass note will have a 1 in 4 chance of changing
    if (Math.random2(1,3) == 1)
    {
       bassFreq => sin.freq;
       .2 => sin.gain;
    }
    
   //Saw and Tri Oscillators sound a little tune
        
        if((beat == 0) || (beat == 7))
        {
            -1 => tripan.pan => sawpan.pan; //pan left
            69 => myNote;
            Std.mtof(myNote) => float tsfreq;
            tsfreq => tri.freq => saw.freq;
            onGain => tri.gain => saw.gain;
        }
        
        if((beat == 2) || (beat == 6))
        {
            1 => tripan.pan => sawpan.pan; //pan right
            65 => myNote;
            Std.mtof(myNote) => float tsfreq;
            tsfreq => tri.freq => saw.freq;
            onGain => tri.gain => saw.gain;
        }
        
        if((beat == 4) || (beat ==5))
        {
            0 => tripan.pan => sawpan.pan; //pan center
            62 => myNote;
            Std.mtof(myNote) => float tsfreq;
            tsfreq => tri.freq => saw.freq;
            onGain => tri.gain => saw.gain;
        }
        
        if((beat == 1) || (beat == 3))
        {
            offGain => tri.gain => saw.gain;
        }
      
    
    //Add 1 to counter
    counter++;
    
    //play
    qtr => now;
}

//Ending

//set gain and freq of Sin Oscillator
24 -=> myNote;
Std.mtof(myNote) => sin.freq;
.2 => sin.gain;

//tri and saw gain set
onGain / 2 => saw.gain => tri.gain;

//Play stereoSound backwards
numSamples => stereoSound.pos;
-1 => stereoSound.rate;
.5 => stereoSound.gain;
numSamples::samp => now;



<<< "Thanks for listening and evaluating!" >>>;



    