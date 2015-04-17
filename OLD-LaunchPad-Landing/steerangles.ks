	

    //NAME: steerangles.ks
    //Script that gives angle values to the main script, orientvector
    //Variable names are more or less placeholders
     
    SET directionVector to VXCL(SHIP:FACING:FOREVECTOR, steerVector).
     
    IF VANG(SHIP:FACING:STARVECTOR, directionVector) > 90 {
            SET vectorAngle TO VANG(SHIP:FACING:TOPVECTOR,directionVector).
    }
    ELSE { SET vectorAngle TO 360-VANG(SHIP:FACING:TOPVECTOR,directionVector). }.
     
    set facingAngle to VANG(SHIP:FACING:FOREVECTOR, steerVector).
     
    set ov_pitchAngle TO cos(vectorAngle)*facingAngle.
    set yawAngle TO sin(vectorAngle)*facingAngle.

//max(-25, min(25, 
