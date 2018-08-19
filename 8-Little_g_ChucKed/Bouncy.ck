//IPMDA_8_Little_g_ChucKed

//Bouncy.ck

/*This roughly calculates the time between sounds as if the sound were from 
an object that was dropped. This class is not meant to be an accurate physics 
representation but rather a close approximation of the sounds resulting from
dropping objects. This also allows for different gravity on other 
planets. */

public class Bouncy
{
    //Make Gravity object
    Gravity locale;
    
    //For Impulse 
    fun float bounceImp(float h, float e, int bounces, string planet, Impulse imp)
    /* h = height in feet
       bounces = the number of bounces you want to hear
       planet = the planet where the object(s) is dropped
       e = coefficient of restitution AKA the square root of the
    drop height divided by the rebound height. So as e gets
    closer to 1, the longer the ball will take to stop bouncing.
    See http://en.wikipedia.org/wiki/Coefficient_of_restitution
    for more detail. */

    {
        locale.grav(planet) => int g;
        0 => int n; //number of bounces
        imp.gain() => float origGain; //So it can reset gain
        float t; //declare time variable
        
        while(n <= bounces) //so not infinite
        {
            1 => imp.next; //sound
            
            /*Formula that calculates time between bounces
            www.sosmath.com/calculus/geoser/bounce/bounce.html 
            and www.math.ufl.edu/~kees/SimpleBouncingBall.pdf
            for more info */
            (2*(Math.pow(e, n)))*(Math.sqrt((2 * h)/g)) => t;
            /* pow is e to the power of n
            sqrt is square root of */
            
            t::second => now; //advance time
            //slowly decrease volume for each bounce
            imp.gain() / 1.2 => imp.gain; 
            
            n++; //increment n
        }
        origGain => imp.gain; //reset gain
    }
    //Same but for Sound Files
    fun float bounceBuf(float h, float e, int bounces, string planet, SndBuf snd)
    {
        locale.grav(planet) => int g; 
        0 => int n;
        snd.gain() => float origGain;
        float t;
        
        while(n <= bounces) 
        {
            0 => snd.pos;
            (2*(Math.pow(e, n)))*(Math.sqrt((2 * h)/g)) => t;
            t::second => now;
            snd.gain() / 1.09 => snd.gain;
            n++;
        }
        snd.samples() => snd.pos;
        origGain => snd.gain;
    }
    //Same but for StkInstruments
    fun float bounceStk(float h, float e, int bounces, string planet, StkInstrument instr)
    {
        locale.grav(planet) => int g; 
        0 => int n;
        instr.gain() => float origGain;
        float t;
        
        while(n <= bounces) 
        {
            1 => instr.noteOn; 
            (2*(Math.pow(e, n)))*(Math.sqrt((2 * h)/g)) => t;
            t::second => now; 
            instr.gain() / 1.2 => instr.gain;
            n++;
        }
        1 => instr.noteOff;
        origGain => instr.gain;
    }
}