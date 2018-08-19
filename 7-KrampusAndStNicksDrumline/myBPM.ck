//IPMDA_7_Krampus_and_St_Nick's_Drumline

//myBPM.ck
//CLASS FILE FROM LECTURE (slightly changed)

public class myBPM
{
    //global member variables
    static dur myDur[];
    static dur wNote, hNote, qNote, eNote, sNote, tsNote;
    
    fun static void tempo(float beat)
    {
        //beat is BPM
        
        60.0 / (beat) => float SPB; //seconds per beat
        SPB::second => qNote; // quarter note
        qNote * .5 => eNote;  // 8th note
        eNote * .5 => sNote;  // 16th note
        sNote * .5 => tsNote; // 32nd note
        qNote * 2 => hNote;   // whole note
        hNote * 2 => wNote;   // half note
        
        //store data in array
        [wNote, hNote, qNote, eNote, sNote, tsNote] @=> myDur;
    }
}