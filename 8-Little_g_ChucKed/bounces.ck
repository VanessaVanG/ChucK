//IPMDA_8_Little_g_ChucKed

//bounces.ck

//This plays the sounds of different objects dropping

//Set locale
//Choose from Mercury - Pluto (including Moon)
"Earth" => string planet;

//Make objects for Bouncy, MyScales and myBPM
MyScales scale;
Bouncy bouncy;
myBPM rate;

//Set up gain
.6 => float myGain;

//Impulse sound chain and parameters
Impulse imp => ResonZ filt => NRev impRev => Pan2 impPan => dac;
200 => filt.Q => filt.gain;
.5 => impRev.mix;
scale.cIonianFreq[5] * 2 => filt.freq;
myGain => imp.gain;
-.3 => impPan.pan; //pan toward left

//Kick drum hookup and parameters
SndBuf kick => NRev sndRev => Pan2 sndPan => dac;
myGain / 5 => kick.gain;
.2 => sndRev.mix;
0 => sndPan.pan; //no pan
me.dir(-1) + "/audio/kick_02.wav" => kick.read;
kick.samples() => kick.pos;

//Shakers sound chain and parameters
Shakers shake => NRev instrRev => Pan2 instrPan => dac;
myGain / 5 => shake.gain;
12 => shake.preset; //preset "Coke Can"
.7 => instrPan.pan; //pan toward right
.5 => instrRev.mix;

//ModalBar sound chain and parameters
ModalBar bar => instrRev => impPan => dac;
myGain / 4 => bar.gain;
8 => bar.preset; //Preset "Clump"
.1 => bar.stickHardness;
scale.cIonianFreq[0] => bar.freq;

//Spork to play sounds falling
spork ~ bouncy.bounceBuf(5, .9, 40, planet, kick);
rate.wNote * 4 => now;
spork ~ bouncy.bounceStk(5, .8, 20, planet, shake);
rate.wNote * 3 => now;
spork ~ bouncy.bounceImp(7, .8, 20, planet, imp);
rate.wNote * 2=> now;
spork ~ bouncy.bounceStk(6, .9, 25, planet, bar);
rate.wNote => now;
spork ~ bouncy.bounceBuf(5, .9, 40, planet, kick);
rate.hNote => now;
spork ~ bouncy.bounceStk(5, .8, 20, planet, shake); 
rate.qNote => now; 
imp.gain() * 1.5 => imp.gain; 
scale.cIonianFreq[5] => filt.freq;
spork~ bouncy.bounceImp(9, .8, 40, planet, imp);
//So sporking works
while(true) 1::second => now;