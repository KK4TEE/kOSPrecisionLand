//RUNMODES

if runmode = 1 { //Launch
    run orientvector(UP). 
    set TVAL to 1.

    if alt:radar > 150{
        set runmode to 2.
        set TVAL to (0.2 / TWR / sin(pitchangle)).
        sas off.
        }
    }

if runmode = 2 { //Wait until the ship stops climbing
    run orientvector(UP).
    if verticalspeed < 0 {
        set runmode to 3.
        gear on.
        }
    }

if runmode = 3 { //Hover
    set TVAL to (1 / TWR / sin(pitchangle)).
    //run orientvector(UP). 
    sas on.
    }

if runmode = 10 { //Launch from the pad
    set TVAL to 0.1.
    sas off. RCS off. gear off. lights on.
    wait 1.
    stage.
    wait 1.
    set TVAL to TWRTarget/TWR.
    wait 0.75.
    stage.
    set runmode to 11.
    }

if runmode = 11 { //Launch
    run orientvector(UP). 
    set TVAL to TWRTarget/TWR.

    if verticalspeed > 60 {
        set runmode to 12.
        }
    }
if runmode = 12 { // Initial climb
    set TVAL to TWRTarget/TWR.
    if ALTITUDE < atmoHeight {
        set tPITCH to max(3, 90 * (1-ALT:RADAR/50000)).
        }
    else {
        set tPITCH to 2.
        }
    lock steering to heading(90, tPITCH).
    if SHIP:APOAPSIS > atmoHeight{
	    set RUNMODE to 13.
        }
    else if SHIP:APOAPSIS > tAP{
        set RUNMODE to 14.
        }
    }

if runmode = 13 { // Burn to raise Ap while in space
    set TVAL to TWRTarget/TWR.
    set tPITCH to 2.
    lock steering to heading(90, tPITCH).

    if SHIP:APOAPSIS > tAP{
        set RUNMODE to 14.
        }
    }

if runmode = 14 { // Coast to AP
    set TVAL to 0.
    set tPITCH to 3.
    lock steering to heading(90, tPITCH).

    if ETA:APOAPSIS < 10 or VERTICALSPEED < 0{
        set RUNMODE to 15.
        }
    }

if runmode = 15 { // Burn to raise Pe
    set TVAL to TWRTarget/TWR.
    set tPITCH to 3.
    lock steering to heading(90, tPITCH).

    if SHIP:PERIAPSIS > tPe * 0.95{
        set RUNMODE to 0.
        panels on.
        set TVAL to 0.
        }
    }

if runmode = 30 { //Cruise

    run orientvector(V(0,0,0) - VELOCITY:SURFACE:VEC). 
    
    if KSCLAUNCHPAD:DISTANCE < 60000{ //30000 is the most tested value
        set runmode to 50.
        }
    else if (KSCLAUNCHPAD:DISTANCE > 2 * betterALTRADAR) and SURFACESPEED < 500 {
        set runmode to 80.
        }
    else {
        run rollcontrol(0).
        }
    }

if runmode = 50 { ///Let the fun begin. Get back to the pad.
    set LZDistCUTOFFshort to 100.
    set LZDistCUTOFFlong to 1000.
    set LZTargetAltitude to MIN(40000, MIN(betterALTRADAR - 35 , 200 + KSCLAUNCHPAD:DISTANCE / 4)).
    sas off.
    //set LZVECMODED to KSCLAUNCHPAD:POSITION:VEC. // no longer :NORMALIZED

    // Set landing target
   set LandingSiteVM to KSCLAUNCHPAD:ALTITUDEPOSITION(KSCLAUNCHPAD:TERRAINHEIGHT + LZTargetAltitude).
        set LandingSiteVM:MAG to 2.

    //Surface Velocity
    set SurfaceVelocityVM to VELOCITY:SURFACE.
        set SurfaceVelocityVM:MAG to -2 - MIN(3, ( MAX(0.0, 3 - betterALTRADAR / 500 ))).
        if SURFACESPEED > 300 { 
            //set SurfaceVelocityVM:MAG to SurfaceVelocityVM:MAG - SURFACESPEED / 50.
            }

    //UP Vector
    set UpVectorM to ship:up:vector:normalized.
        if KSCLAUNCHPAD:DISTANCE > LZDistCUTOFFlong*2 {
            set UpVectorM:MAG to 0.4.
            }
        else {
            set UpVectorM:MAG to MIN(5, ( MAX(0.4, 3 - (-VerticalSpeed / 120) - KSCLAUNCHPAD:DISTANCE / 500 ))).
            }
    //Put it all together
    set vcProd to (UpVectorM + SurfaceVelocityVM + LandingSiteVM):VEC.
    //set vcProd:MAG to 1.


    //Steering
    if betterALTRADAR < 2 and SURFACESPEED < 0.25 {
        run orientvector(UP:VEC).
        }
    else if betterALTRADAR < 50 and SURFACESPEED > 0.25 {
        run orientvector((SurfaceVelocityVM:normalized + ship:up:vector:normalized):VEC).
        }
    else if VANG (VCPROD, UP:VEC) > 180{
        //Safety to make sure the ship stays pointing away from the ground
        run orientvector(UP:VEC).
        }
    else {
        run orientvector(VCPROD:VEC).
        }

    //Throttle
    //set TVAL to 0.1/TWR.
    if sin(pitchangle) > 0{
        set tFALLSPEED to max(2, min (500, ((betterALTRADAR+5)^0.7))).

        set TVAL to max( 0.1/TWR, (MIN(1.5/TWR, (1 / TWR)/ sin(pitchangle))) - ((verticalspeed + tFALLSPEED)/20  )).
        print "Base Fall Spd: " + round(tFALLSPEED, 2) + "       " at (5,33).
        }
    if VANG( VCPROD, fore) < 20 {
        if VANG(UP:VEC, LandingSiteVM) > VANG(UP:VEC, VELOCITY:SURFACE) AND KSCLAUNCHPAD:DISTANCE > LZDistCUTOFFlong {
            set TVAL to TVAL + MAX(-1, (-VANG(LandingSiteVM, VELOCITY:SURFACE)))/10 / TWR.
            }
        else if VANG(UP:VEC, LandingSiteVM) < VANG(UP:VEC, VELOCITY:SURFACE)  AND KSCLAUNCHPAD:DISTANCE > LZDistCUTOFFlong{
            set TVAL to TVAL + MIN( TWRTarget, VANG(LandingSiteVM, VELOCITY:SURFACE)/10) / TWR.
            }
       }
    else if VANG( VCPROD, fore) < 20 and vcProd:MAG > 0.5 AND KSCLAUNCHPAD:DISTANCE > 5000{
        set TVAL to MIN(TWRTarget, (vcProd:MAG -0.5 ) * 5)/ TWR.
        }
    else if sin(pitchangle) < 0.01 {
        set TVAL to 0.
        }
    else if KSCLAUNCHPAD:DISTANCE < LZDistCUTOFFlong{
        set TVAL to MAX( TVAL, 0.3/TWR).
        }


    print "RCVec Mag: " + round(vcProd:MAG, 2) + "       " at (5,34).
 print "UP Angle Mag: " + round(UpVectorM:MAG, 2) + "       " at (5,35).
    SET vVCPROD TO VECDRAWARGS(
                  V(0,0,0),
                  vcProd,
                  green, 
                  "VC PRODUCT", 10, true).
    SET vLandingSiteVM  TO VECDRAWARGS(
                  V(0,0,0),
                  LandingSiteVM,
                  RED, 
                  "LZ Alt Target", 10, true).
    if betterALTRADAR < 0.2 AND TOTALSPEED < 0.5{
        set runmode to 99.
        }
    else if impactTime < 8{
        gear on.
        }
    //Abort Handling
    else if ((impactTime < killTime) and KSCLAUNCHPAD:DISTANCE > 30) AND betterALTRADAR < 25{
        set runmode to 80.
        SET vVCPROD:SHOW TO FALSE.
        SET vLandingSiteVM:SHOW TO FALSE.
        gear on.
        }
   else if (KSCLAUNCHPAD:DISTANCE - 5 > betterALTRADAR*1.2) and betterALTRADAR < 5000{ //Abort
        set runmode to 80.
        }
       else if (KSCLAUNCHPAD:DISTANCE > betterALTRADAR * 3.5) and betterALTRADAR > 5000{ //Abort
        set runmode to 80.
        }
    SET SHIP:CONTROL:ROLL TO 0.
    }    

if runmode = 79 { //Wait for landing
    if impacttime < 40 { set RUNMODE to 80.} // 75 seconds works \\60 works w/ thrust modulation
    run orientvector(SHIP:SRFRETROGRADE:VECTOR). 
        run rollcontrol(0).
    }

if runmode = 80 { ///Emergency Landing
    
    if ((killTime * 1.15) - impactTime) < 1 {
        set correctionVector to UP:VEC:NORMALIZED.
        set correctionVector:MAG to MAX(0.15, 0.6 - (SURFACESPEED / 200)).
         run orientvector(SHIP:SRFRETROGRADE:VECTOR:normalized + correctionVector).
         if VANG(SHIP:SRFRETROGRADE:VECTOR, UP:VEC) < 10 {
           SET SHIP:CONTROL:ROLL TO 0.
            }
         else {
            run rollcontrol(0).
            }
        }
    else if ((killTime * 1.15) - impactTime) > 1 {
        set correctionVector to UP:VEC:NORMALIZED.
         set correctionVector:MAG to MAX(0, ((killTime * 1.15) - impactTime) / 30). //40 worked historically
        run orientvector(SHIP:SRFRETROGRADE:VECTOR + correctionVector). 
        run rollcontrol(0).
        }
    else {
        run orientvector(SHIP:SRFRETROGRADE:VECTOR). 
        run rollcontrol(0).
        }

   if VERTICALSPEED < 0 and impactTime < killTime * 1.15 { // Wait until the ship is falling.
        set ENGINESAFETY to 0. 
        }

    

    if ENGINESAFETY = 0 and VERTICALSPEED < 0 and impactTime < killTime * 1.40 {
        set TVAL to (TWRTarget + (killTime * 1.15) - impactTime) / TWR.
        }
    else if ENGINESAFETY = 0 and VERTICALSPEED < 0 {
        set TVAL to 0.1 / TWR. 
        }
    else { 
        set TVAL to 0. 
        }

    if totalSpeed < 75 {
        set runmode to 81.
        }
    }

if runmode = 81 { //Final Touchdown
    gear on. set ENGINESAFETY to 0.
    SET SHIP:CONTROL:ROLL TO 0.
    if VERTICALSPEED < 0 {
        set correctionVector to UP:VEC:NORMALIZED.
         set correctionVector:MAG to MIN(5, ( MAX(1, 5 - ABS(VERTICALSPEED/3)))).
        run orientvector(SHIP:SRFRETROGRADE:VECTOR:NORMALIZED + correctionVector). 
        //run rollcontrol(0).
        }
    else {
        run orientvector(UP:VEC).
        }

    set TVAL to (1 / TWR) - (verticalspeed + max(2, min (75, (betterALTRADAR^1.08 / 10))))/3 / TWR.

    if alt:radar < shipHeight + 2 { //If really close to landing
        set runmode to 99.
        set TVAL to 0.
           SET SHIP:CONTROL:PITCH TO 0.
           SET SHIP:CONTROL:YAW TO 0.
           SET SHIP:CONTROL:ROLL TO 0.
        print "TOUCHDOWN SPEED: " + round(TOTALSPEED,2) + " M/s" at (8, 30).
        SAS ON.
        Wait 2.
        SAS OFF.
        }
    }

if runmode = 99 {
        set TVAL to 0.
        SET SHIP:CONTROL:PITCH TO 0.
        SET SHIP:CONTROL:YAW TO 0.
        SET SHIP:CONTROL:ROLL TO 0.
        print "TOUCHDOWN SPEED: " + round(TOTALSPEED,2) + " M/s" at (8, 30).
        SAS ON.
        Wait 2.
        SAS OFF.
        SET runmode to 0.
        }

set t0 to TIME:SECONDS.
