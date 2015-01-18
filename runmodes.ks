//RUNMODES

if runmode = 1 {
    run orientvector(UP). 
    set TVAL to 1.

    if alt:radar > 150{
        set runmode to 2.
        set TVAL to (0.2 / TWR / sin(pitchangle)).
        sas off.
        }
    }

if runmode = 2 {
    run orientvector(UP).
    if verticalspeed < 0 {
        set runmode to 3.
        gear on.
        }
    }

if runmode = 3 { //Hover
    set TVAL to (1 / TWR / sin(pitchangle)). //  + ((150/ALT:RADAR) - 1)/5
    //run orientvector(UP). 
    sas on.
    }




if runmode = 4 { ///Let the fun begin. Get back to the pad.
    sas off.
    //set LZVECMODED to KSCLAUNCHPAD:POSITION:VEC. // no longer :NORMALIZED

    if KSCLAUNCHPAD:DISTANCE > 100{
        set LZVECMODED toKSCLAUNCHPAD:ALTITUDEPOSITION(KSCLAUNCHPAD:TERRAINHEIGHT + (KSCLAUNCHPAD:DISTANCE / 15)).
        }
    else {
        set LZVECMODED toKSCLAUNCHPAD:ALTITUDEPOSITION(KSCLAUNCHPAD:TERRAINHEIGHT+10).
        }
    set LZVECMODED:MAG to max( 1, LZVECMODED:MAG / 1000).
    //Surface Velocity
    set SVVECMODDED to VELOCITY:SURFACE.
    set SVVECMODDED:MAG to max( 1, SVVECMODDED:MAG / 200).
    //UP Vector
    set SUVECMODDED to ship:up:vector:normalized.
    set SUVECMODDED:MAG to 1. //MAX(1, SVVECMODDED:MAG / 10). 

    set vcProd to ((SUVECMODDED - VELOCITY:SURFACE) + LZVECMODED):VEC.

    SET vVCPROD TO VECDRAWARGS(
                  V(0,0,0),
                  vcProd,
                  green, 
                  "VC PRODUCT", 10, true).

    if VANG (VCPROD, UP:VEC) > 110{
        run orientvector(UP:VEC).
        }
    else {
        run orientvector(VCPROD:VEC).
        }
set angVUPvVS to VANG(ship:up:vector, VELOCITY:SURFACE).
set angVUPvLZ to VANG(ship:up:vector, KSCLAUNCHPAD:POSITION:VEC).
    if (angVUPvVS > angVUPvLZ) and (VANG(ship:up:vector, vcProd) > 90) {
        set TVAL to ((0.95 / TWR) + ((VCPROD:MAG-1.0) / 10))/ sin(pitchangle).
        }
    else if VANG( VCPROD, fore) < 20 and sin(pitchangle) > 0{
        set TVAL to ((0.95 / TWR) + ((VCPROD:MAG-1.0) / 10))/ sin(pitchangle).
        }
    else if VANG( VCPROD, fore) < 20{
        set TVAL to ((0.95 / TWR) + ((VCPROD:MAG-1.0) / 10)).
        }
    else{
        set TVAL to 0.
        }

    if alt:radar < 12 {
        set runmode to 0.
        set TVAL to 0.
        }
    else if KSCLAUNCHPAD:DISTANCE < 100{
        set runmode to 5.
        }
    //else if alt:radar < 150 and KSCLAUNCHPAD:DISTANCE > 500{
       // set runmode to 5.
       // }
    }    

if runmode = 5 { ///Failsafe Landing

    if verticalspeed > -3 {
        run orientvector(UP).
        }
    else {
        run orientvector(SHIP:SRFRETROGRADE:VECTOR). 
        }
    
    if alt:radar < 150 and verticalspeed < -5 {
        set TVAL to 1.15 / TWR / sin(pitchangle).
        }
    else {
        set TVAL to (0.9 / TWR / sin(pitchangle)).
        }
    if alt:radar < 11 {
        set runmode to 0.
        set TVAL to 0.
        }
    
    }
