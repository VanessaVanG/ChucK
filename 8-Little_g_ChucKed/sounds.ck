//IPMDA_8_Little_g_ChucKed

//Sound chain
SndBuf sound1 => Pan2 pan1 => dac;

//Set up the soundfile and params
me.dir(-1) + "/audio/hihat_04.wav" => sound1.read;
sound1.samples() => sound1.pos; //set playhead to 0 so no sound
.025 => sound1.gain;

//Glitch the soundfiles function
fun void glitch( SndBuf myWav, int steps, int rateDivisor, string direction )
{
    //declare variable
    int route;
    
    //This means any string entered that starts with f or F will be forwards
    if(direction.charAt(0) == 'f' || direction.charAt(0) == 'F') {
        1 => route;
    }
    //This means any string entered that starts with b or B will be backwards
    else if(direction.charAt(0) == 'b' || direction.charAt(0) == 'B') {
        -1 => route;
    }
    //If doesn't start with f/F or b/B, error printed and sound will be forwards
    else {
        1 => route;
        <<< "Error. Direction must be entered as 'forwards' or 'backwards'." , "" >>>;
        <<< "Will play forwards unless fixed.", "" >>>;
    }
    
    myWav.samples() / steps => int grain; //get the grain
    (grain / rateDivisor) * route => myWav.rate; //set play rate and make it backwards
    Math.random2(0, myWav.samples() - 1) => myWav.pos; //randomly set grain position
    grain::samp => now; //advance time
}

while(true)
{
    Math.sin(now / 15::second * 2 * pi) => pan1.pan; //sweep the panning
    glitch(sound1, 100, 100, "b"); //call glitch function
}
    