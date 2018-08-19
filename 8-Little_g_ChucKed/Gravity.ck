//IPMDA_8_Little_g_ChucKed

//Gravity.ck

/* This returns roughly the value for the acceleration of gravity AKA 
"little g" on different planets. g is in feet per seconds squared. I 
used http://www.physicsclassroom.com/class/circles/u6l3e.cfm for my
values. */

public class Gravity
{
    fun int grav(string planet)
    {
        int g;
        
        //Mercury
        //If the 4th character of the string is c
        if(planet.charAt(3) == 'c' || planet.charAt(3) == 'C')
        {
            12 => g;
            return g;
        }
        //Venus 
        //If the 1st character of the string is v
        else if(planet.charAt(0) == 'v' || planet.charAt(0) == 'V')
        {
            29 => g;
            return g;
        }
        //Earth
        else if(planet.charAt(0) == 'e' || planet.charAt(0) == 'E')
        {
            32 => g;
            return g;
        }
        //Moon (I know it's not a planet)
        else if(planet.charAt(1) == 'o' || planet.charAt(1) == 'O')
        {
            5 => g;
            return g;
        }
        //Mars
        else if(planet.charAt(3) == 's' || planet.charAt(3) == 'S')
        {
            12 => g;
            return g;
        }
        //Jupiter
        else if(planet.charAt(0) == 'j' || planet.charAt(0) == 'J')
        {
            85 => g;
            return g;
        }
        //Saturn
        else if(planet.charAt(0) == 's' || planet.charAt(0) == 'S')
        {
            37 => g;
            return g;
        }
        //Uranus
        else if(planet.charAt(0) == 'u' || planet.charAt(0) == 'U')
        {
            34 => g;
            return g;
        }
        //Neptune
        else if(planet.charAt(0) == 'n' || planet.charAt(0) == 'N')
        {
            44 => g;
            return g;
        }
        //Pluto (I know, I know!)
        else if(planet.charAt(0) == 'p' || planet.charAt(0) == 'P')
        {
            2 => g;
            return g;
        }
        else
        {
            32 => g;
            //<<< "Sorry, locale not available. Earth used instead" , "" >>>;
            return g;
        }
    }
}