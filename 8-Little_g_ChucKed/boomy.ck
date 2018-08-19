//IPMDA_8_Little_g_ChucKed

//boomy.ck

//Make MyScales and myBPM objects
MyScales scale;
myBPM rate;

//Duration variables from myBPM (just so it's faster to type)
rate.qNote => dur q;
rate.wNote => dur w;
rate.hNote => dur h;

//--------------Sine Waves--------------
//Declare 3 sin osc array and pan and adsr
SinOsc s[3];
Pan2 sPan[3];
ADSR sEnv;

//set loud quickly
sEnv.set(.1 :: second, .2 :: second, 0.2, 0.05 :: second); 

//Gain variable
.1 => float sGain;

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
fun void sinz() 
{
    //Set freqs 1 to 2 octaves lower
    scale.cIonianFreq[2] / 4 => s[0].freq;
    scale.cIonianFreq[0] / 2 => s[1].freq;
    scale.cIonianFreq[3] / 4 => s[2].freq;
    
    //turn on adsr env
    1 => sEnv.keyOn;
    second => now;
}

//--------------Blow Bottle--------------
//Connect to pan
BlowBotl bot => Pan2 botPan => dac;

.6 => botPan.pan; //pan toward right
.05 => bot.gain;
//Std.mtof(28) => bot.freq;
.1 => bot.rate;
.5 => bot.noiseGain;
.2 => bot.vibratoGain;
12 => bot.vibratoFreq;

//Divide to lower octaves
(scale.cIonianFreq[2] / 4)=> bot.freq;

//Function for Blow Bottle
fun void blowBot()
{
        1 => bot.startBlowing;
}

//--------------Blow Hole--------------
//Connect to pan
BlowHole hole => Pan2 holePan => dac;

-.6 => holePan.pan; //pan toward left
.7 => hole.reed; //set reed stiffness
.9 => hole.noiseGain;
.01 => hole.gain;

//Divide to lower octaves (incredibly low)
(scale.cIonianFreq[2] / 16) => hole.freq;

//Function for Blow Hole
fun void blowHole()
{
    1 => hole.startBlowing;
    second => now;
}

//-----------Fade Outs-----------------
//Function to fade out bottle and hole
fun void fadeOut()
{
    rate.wNote * 10 => now;
    //Set up loop time length
    now + rate.wNote => time ending;
    
    //While loop plays length of ending
    while(now < ending)
    {
        bot.gain() / 1.02 => bot.gain;
        hole.gain() / 1.01 => hole.gain;
        6::ms => now;
    }
}

//Function to fade out sine waves
fun void sFade()
{
    rate.wNote * 10 => now;
    
    (sGain / 3) => float endGain;
    
    //Set up loop time length
    now + rate.wNote => time ending;

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
}
 
//--------------Play--------------
//Spork the functions
spork ~ sinz();
spork ~ blowBot();
spork ~ blowHole();
spork ~ fadeOut();
spork ~ sFade();
//So sporking works
while(true) second => now;