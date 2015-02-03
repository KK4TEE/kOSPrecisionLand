	

    //NAME: orientvector.ks
    //Main script that does most of the magic
     
    /// *** DEPENDENCIES ***
    //steerangles.ks
           
    DECLARE PARAMETER steerVector.
           
    run steerangles.

     
    //SET t0 TO TIME:SECONDS.
    //WAIT 0.05.
    RUN steerangles.
           
    SET t1 TO TIME:SECONDS.
    SET pitchE1 TO ov_pitchAngle.
    SET yawE1 TO yawAngle.
           
    SET dPitch TO (pitchE1 - pitchE0)/(t1 - t0).
    SET dYaw TO (yawE1 - yawE0)/(t1 - t0).
     
    //Useful for debugging
    SET SHIP:CONTROL:PITCH TO (pitchP*pitchE1 + pitchD*dPitch).
    SET SHIP:CONTROL:YAW TO -1*(yawP*yawE1 + yawD*dYaw).
           
   // PRINT "vectorAngle:" + ROUND(vectorAngle,2) at (1,23).
   // PRINT "facingAngle:" + ROUND(facingAngle,2) at (1,24).
           
    //PRINT "Pitch: " + ROUND(pitchP*pitchE1 + pitchD*dPitch,2) at (1,26).
   // PRINT "ov_pitchAngle: " + ROUND(ov_pitchAngle, 2) at (1,27).
           
   // PRINT "Yaw: " + ROUND((yawP*yawE1 + yawD*dYaw),2) at (1,30).
    //PRINT "yawAngle: " + ROUND(yawAngle, 2) at (1,31).

    SET pitchE0 TO ov_pitchAngle.
    SET yawE0 TO yawAngle.
