//IPMDA_7_Krampus_and_St_Nick's_Drumline

//boom.ck

//Make MyScales and myBPM objects
MyScales scale;
myBPM rate;

//Duration variables from myBPM
rate.qNote => dur q;
rate.wNote => dur w;
rate.hNote => dur h;

//--------------Sine Waves--------------
//Declare 3 sin osc array and pan and adsr
SinOsc s[3];
Pan2 sPan[3];
ADSR sEnv;

//set loud quickly
sEnv.set(.01 :: second, .1 :: second, 0.2, 0.05 :: second); 

//Gain variable
.2 => float sGain;

//Connect sin oscs and pan and adsr
for(0 => int i; i < s.cap(); i++)
{
    s[i] => sPan[i] => sEnv => dac;
    //divide up the total sin gain
    sGain / s.cap() => s[i].gain;
}

//Pan each
-.8 => sPan[0].pan; //torward left
0 => sPan[1].pan; //center
.8 => sPan[2].pan; //toward right

//Function for Sine wave sound
fun void sinz(dur on, dur off) 
{
    //Set freqs 1 to 2 octaves lower
    scale.cIonianFreq[2] / 4 => s[0].freq;
    scale.cIonianFreq[0] / 2 => s[1].freq;
    scale.cIonianFreq[3] / 4 => s[2].freq;
    
    //turn on and off adsr env
    1 => sEnv.keyOn;
    on => now;
    1 => sEnv.keyOff;
    off => now;   
}

//--------------Blow Bottle--------------
//Connect to pan
BlowBotl bot => Pan2 botPan => dac;

.6 => botPan.pan; //pan toward right
.02 => bot.gain;
//Std.mtof(28) => bot.freq;
.1 => bot.rate;
.5 => bot.noiseGain;
.2 => bot.vibratoGain;
12 => bot.vibratoFreq;

//Divide to lower octaves
(scale.cIonianFreq[2] / 4)=> bot.freq;

//Function for Blow Bottle
fun void blowBot(dur on, dur off)
{
    1 => bot.startBlowing;
    on => now;
    1 => bot.stopBlowing;
    off => now;
}

//--------------Blow Hole--------------
//Connect to pan
BlowHole hole => Pan2 holePan => dac;

-.6 => holePan.pan; //pan toward left
.7 => hole.reed; //set reed stiffness
.8 => hole.noiseGain;
.003 => hole.gain;

//Divide to lower octaves (incredibly low)
(scale.cIonianFreq[2] / 16) => hole.freq;

//Function for Blow Hole
fun void blowHole(dur on, dur off)
{
    1 => hole.startBlowing;
    on => now;
    1 => hole.stopBlowing;
    off => now;
}

//--------------Play--------------
//Spork the functions
spork ~ sinz((w * 6), q);
spork ~ blowBot((w * 6), w);
spork ~ blowHole((w * 6), w);

//advance time
((w * 5) - q) => now;

//--------------Ending--------------
//Set up loop time length
now + rate.wNote => time ending;

(sGain / 3) => float endGain;

//While loop plays length of ending
while(now < ending)
{
    endGain - .002 => endGain;
    //To make sure gain doesn't go below 0
    if(endGain >= 0)
    {
        for(0 => int i; i < 3; i++)
        {
            //Fade out
            endGain => s[i].gain;
        }
    }
    else
    {
        for(0 => int i; i < 3; i++)
        {
            0 => s[i].gain; 
        }            
    }
    6::ms => now;
}

while(true) second => now;