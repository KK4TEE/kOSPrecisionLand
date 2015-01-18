clearscreen.
print "Grasshopper Test Vehicle - Launching".
RUN gyroinit.ks.
RUN logtofileinit.ks.

set RUNMODE to 4.
if ALT:RADAR < 50 {set RUNMODE to 1. STAGE.}

sas off.
rcs on.
lights on.
when alt:radar > 20 then { gear off.}
set TVAL to 0.
lock throttle to TVAL.
on AG1 { set runmode to 4. sas off.}

SET pitchP TO 0.12.
    SET pitchD TO 0.2.
     
    set yawP TO 0.12.
    set yawD TO 0.2.
set vcProd to V(0,0,0).


until 0{ // Loop Start
    set loopStartTime to time.
    if northPole:bearing <= 0 {
        set cHeading to ABS(northPole:bearing).
        }
    else {
        set cHeading to (180 - northPole:bearing) + 180.
        }
    
    // Get to the good stuff
    RUN runmodes.ks.
    
    
    // Housekeeping 
    //Print data to screen
    RUN printtoscreen.ks.
    
    //Log data to file
    if time > nextLogTime {
       RUN logtofile.ks.
       set nextLogTime to time + 2.
        }
    
    
    // Draw Vectors
    SET vKSCLAUNCHPAD TO VECDRAWARGS(
                  KSCLAUNCHPAD:ALTITUDEPOSITION(KSCLAUNCHPAD:TERRAINHEIGHT+500),
                  KSCLAUNCHPAD:POSITION - KSCLAUNCHPAD:ALTITUDEPOSITION(KSCLAUNCHPAD:TERRAINHEIGHT+500),
                  red, "LANDING TARGET", 1, true).
    
    SET vLANDINGPATH TO VECDRAWARGS(
                  V(0,0,0),
                  KSCLAUNCHPAD:ALTITUDEPOSITION(KSCLAUNCHPAD:TERRAINHEIGHT+10),
                  yellow, 
                  "GO THIS WAY", 1, true).
    
    SET vSURFACEV TO VECDRAWARGS(
                  V(0,0,0),
                  VELOCITY:SURFACE,
                  blue, 
                  "SURFACE VELOCITY", 1, true).

    
} //END OF PROGRAM
