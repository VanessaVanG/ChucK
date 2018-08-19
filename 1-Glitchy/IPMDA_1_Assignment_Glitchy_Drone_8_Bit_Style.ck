//Prints title
<<< "IPMDA_1_Assignment_Glitchy_Drone_8_Bit_Style" >>>;

//Sound Network
SinOsc s => dac;
SinOsc ss => dac;
SqrOsc t => dac;

//Sets s frequency to C2
65.41 => s.freq;

//Silences t and ss
0 => t.gain;
0 => ss.gain;

//*For Loop Portion*

//Plays sine wave tuned to C2 for 6 seconds, increasing in volume, with clicks (b/c it's a sine wave)
for( .1 => float g; g < .7; g + .1 => g)
{
    g => s.gain;
    1::second => now;
}

//*If Else Portion*
//(Only included because it's a requirement of the assignment)

//Continues the sound for 3 seconds
3 => int i;

if( i == 3 )
{
    3::second => now;
}

else
{
    1::second => now;
}

//Sets volume for ss (C2 continues as drone note)
.4 => ss.gain;

//*While Loop Portion*

//Sets freq to G2
98 => int f;

//G2 rises up an octave to G3 in 3 seconds
while( f <= 196)
{
    f => ss.freq;
    .0306::second => now; // 3 divided by 98
    f++;
}

//Continues C2 and G3 for 3 seconds
3::second => now;

//Brings G3 down an octave to G2 in 3 seconds
while( f >= 98)
{
    f => ss.freq;
    .0306::second => now;
    f--;
}

//Continues C2 and G2 for 3 seconds
3::second => now;

//Sets t frequency to Eflat2
77.78 => t.freq;

//Plays 3 glitch sounds over 3 seconds, with C2 and G2 continuing
.05 => t.gain;
.75::second => now;
0 => t.gain;
.25::second =>now;

.05 => t.gain;
.75::second => now;
0 => t.gain;
.25::second => now;

.05 => t.gain;
.75::second => now;
0 => t.gain;
.25::second => now;

//Sets t frequency to Eflat1
38.89 => t.freq;

//Plays 6 glitch sounds over 3 seconds, volume increasing with C2 and G2 continuing
.1 => t.gain;
.375::second => now;
0 => t.gain;
.125::second => now;

.1 => t.gain;
.375::second => now;
0 => t.gain;
.125::second => now;

.15 => t.gain;
.375::second => now;
0 => t.gain;
.125::second => now;

.15 => t.gain;
.375::second => now;
0 => t.gain;
.125::second => now;

.2 => t.gain;
.375::second => now;
0 => t.gain;
.125::second => now;

.2 => t.gain;
.375::second => now;
0 => t.gain;
.125::second => now;

//Plays all three notes for 1 second
.25 => t.gain;
1::second => now;

//Plays C2 and Eflat1 for 1 second
0 => ss.gain;
1::second => now;

//Plays Eflat1 for 1 second
0 => s.gain;
1::second => now;

<<< "Thanks for listening and evaluating!" >>>;