//IPMDA_6_ChucK_Vibe

//guitar.ck

//Mandolin to array
Mandolin guit[3];

//Set gain variable
.12 => float myGain;

//Connect strings array to dac, pan toward right,
//and adjust gain
for(0 => int i; i < guit.cap(); i++)
{
    //Guitar paramaters
    guit[i] => Pan2 pan => dac;
    //keep gain low so it's not the focus
    myGain / guit.cap() => guit[i].gain;
    .7 => pan.pan; //pan toward right
    .06 => guit[i].bodySize;
    .9 => guit[i].pluckPos;
    .8 => guit[i].stringDamping;
}

//Set up durations
0.625::second => dur q; //quarter note
q / 2 => dur e; //eighth note
q / 3 => dur tr; //triplet
q / 4 => dur s; //sixteenth note
q / 8 => dur ts; //32nd note
q / 16 => dur sf; //64th note
q * 2 => dur h; //half note
q * 4 => dur w; //whole note

//This is to make it easier to assign note times
1::samp => dur x;

//2d scale array for chords
[[53,58,60], [54,58,61], [63,65,68], [48,51,53]] @=> int chords[][];

//functions for each chord

//------------First chord------------
fun void zero()
{
    for(0 => int i; i < 3; i++)
    {
        //Match up chord[0] with guit
        Std.mtof(chords[0][i]) => guit[i].freq;
        //Randomize pluck strength
        Math.random2f(.8, 1) => guit[i].pluck; 
    }
    //use this so timing doesn't get messed up
    x => now;
}
//------------Second chord------------
fun void one()
{
    for(0 => int i; i < 3; i++)
    {
        Std.mtof(chords[1][i]) => guit[i].freq;
        Math.random2f(.6, 1) => guit[i].pluck; 
    }
    x => now;
}
//------------Third Chord------------
fun void two()
{
    for(0 => int i; i < 3; i++)
    {
        Std.mtof(chords[2][i]) => guit[i].freq;
        Math.random2f(.6, 1) => guit[i].pluck; 
    }
    x => now;
}
//------------Fourth Chord------------
fun void three()
{
    for(0 => int i; i < 3; i++)
    {
        Std.mtof(chords[3][i]) => guit[i].freq;
        Math.random2f(.6, 1) => guit[i].pluck; 
    }
    x => now;
}

//Infinite loop
while(true)
{
    //Get random number
    Math.random2(0, 3) => int randNum;
    
    //Possibilities
    
    //------------Only 2nd chord choice------------
    if(randNum == 0 )
    {
        one();
        q => now;
        one();
        e => now;
        one();
        e => now;
        one();
        h - e => now;
        one();
        q => now;
        one();
        q => now;
        one();
        e => now;
        one();
        q => now;
        one();
        q => now;      
    }
    //------------Only 3rd chord choice------------
    else if(randNum == 1)
    {
        two();
        e => now;
        two();
        e => now;
        two();
        s => now;
        two();
        e => now;
        two();
        e => now;
        two();
        q - s => now;
        two();
        s => now;
        two();
        e => now;
        two();
        s => now;
        two();
        e => now;        
    }
    //------------1st and 4th chord choice------------
    else
    {
        three(); 
        q => now;
        zero();
        q => now;
        three();
        e => now;
        zero();
        q => now;
        three(); 
        q => now;
        zero();
        q => now;
        three();
        e => now;
        zero();
        q => now;
    }
}