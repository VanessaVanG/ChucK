//Prints title
<<< "IPMDA_2_Assignment_Melodic_Randomness" >>>;
<<< "Please use headphones or good speakers" >>>;

//Sound Network
SinOsc b => dac; //bass line
SinOsc m => Pan2 mpan => dac; //melody

//Set volume and quarter note time
.5 => b.gain;
.4 => m.gain;
.25::second => dur qtr;

//Intro Section (2 seconds)

//Set freq of note
57 => int myNote;
Std.mtof(myNote) => m.freq => b.freq;

//Plays 8 quarter notes increasing in volume
for(.1 => float g; g <= .45; .05 +=> g)
{
    g => b.gain => m.gain;
    qtr => now;
}

/*Main Section (25 seconds)
The melody has clicks when the notes change but I actually
like it at way so didn't try to change
*/

//Declare and Initialize D Dorian Array
[50, 52, 53, 55, 57, 59, 60, 62] @=> int ddorian[];

//Set Seed so song is the same for every play
Math.srandom(13);

//Set up for infinite loop to end after 25 seconds
now + 25::second => time main;

//Infinite Loop 
while(now < main)
{
    //For the Melody
    
    //Make variables for min and max for random range
    0 => int min;
    ddorian.cap() -1 => int max;
    
    //Get a random midi note, convert to frequency #, set as melody frequency
    ddorian[Math.random2(min, max)] => int melMidi; 
    Std.mtof(melMidi) => m.freq;
    
    //Give the melody random panning
    Math.random2f(-1,1) => mpan.pan;
    
    //For the Bass Line   
   
    //Get a random midi note    
    ddorian[Math.random2(min, max)] => int bassMidi;
    
    //Convert to frequency # and put in new variable
    Std.mtof(bassMidi) => float bassFreq;
    
    /* Divide frequency by 4 (this lowers the note by two octaves,
    as permitted in the assignment instructions) */
    4  /=> bassFreq;
    
    //Bass note will have a 1 in 4 chance of changing
    if (Math.random2(1,4) == 1)
    {
       bassFreq => b.freq;
    }
    
    //Play both melody and bass line quarter notes
    qtr => now;
}

//Ending Section (3 seconds)

//Set gain
.4 => m.gain;
0 => b.gain;

//Lower the note 2 octaves
24 -=> myNote;
Std.mtof(myNote) => m.freq;

//Pan from R to L to Middle
1 => float panPosition;
while(panPosition > -1)
{
    panPosition => mpan.pan;
    .01 -=> panPosition;
    .01::second => now;
}

while(panPosition < -.01)
{
    panPosition => mpan.pan;
    panPosition + .01 => panPosition;
    .01::second => now;
}
<<< "Thanks for listening and Evaluating!" >>>;