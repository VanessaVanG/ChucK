//IPMDA_7_Krampus_and_St_Nick's_Drumline

//MyScales.ck
/*This holds a midi array for scales and then converts
them to the corresponding freq and puts them in another
array. After this assignment, I'll add more scales. */

public class MyScales
{
    //C Ionian midi array
    [48, 50, 52, 53, 55, 57, 59] @=> int cIonian[];
   // 0, 1 , 2 , 3 , 4 , 5 , 6 *for me*
    
    //C Ionian frequency array 
    float cIonianFreq[7];
    for(0 => int i; i < cIonian.cap(); i++)
    {
        Std.mtof(cIonian[i]) => cIonianFreq[i];
    } 
}