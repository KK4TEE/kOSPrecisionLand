//kk.ks

RUN library.ks.
BLANKSLATE().

print "KK Test Article".
//set steeringData to ORIENTTOVECTOR_INIT(0.015, 0.05, 0.05).
set steeringData to ORIENTTOVECTOR_INIT(0.05, 0.05, 0.3).
GYROINIT( 25.48, 3). //Set the ship height, maxTargetGeeforce
LOGTOFILEINIT(). //Logging is not yet functional
set RUNMODE to 19.
set BoostBackTimelimit to 145.//The amount of time it should take to coast back
    //horizontally after the boost back burn is complete.
    //TODO: THIS MUST BE REPROGRAMED TO RUN DYNAMICALLY. THERE ARE TOO MANY OTHER VARIABLES TO PROGRAM THIS STATICALLY
if ALT:RADAR < 170 {set RUNMODE to 1. stage.} //Probably just starting out.

ON AG10 {SET RUNMODE to -1. } //End program

until RUNMODE < 0 {

    set cHeading to COMPASS().
    
    RUN runmodes.ks.
    
    lock throttle to TVAL.
    PRINTTOSCREEN().
    LOGTOFILE(). //Not yet functional
    wait 0.001.
}