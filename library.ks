//library.ks
//This file will contain my commonly used functions now that .17 supports them

declare function BLANKSLATE {
    wait 0.01.
    clearscreen.
    SAS OFF.
    RCS ON.
    GEAR OFF.
    BRAKES OFF.
    LIGHTS ON.
    UNLOCK STEERING.
    SET SHIP:CONTROL:NEUTRALIZE to TRUE.
    wait 0.01.
    SET SHIP:CONTROL:ROLL TO 0.5.
    wait 0.01.
    SET SHIP:CONTROL:ROLL TO -0.5.
    wait 0.01.
    SET SHIP:CONTROL:ROLL TO 0.
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
    wait 0.01.
    }

declare function COMPASS {
    //Depends on GYROINIT being run at some point prior
    if northPole:bearing <= 0 {
        set cHeading to ABS(northPole:bearing).
        }
    else {
        set cHeading to (180 - northPole:bearing) + 180.
        }
    RETURN cHeading.
    }
declare function  ORIENTTOVECTOR_INIT{
    //Based on the example code from the 0.17 teaser
    //initialize a list containing all the fun stuff for a PID controller
    declare parameter
        Kp, // gain of position
        Ki, // gain of integral
        Kd. // gain of derivative
    declare prevTime to -1. // (old time) start value flags the fact that it hasn't been calculated
    declare prevPitchError to 0.
    declare prevYawError to 0.
    // Because we don't have proper user structures in kOS (yet?)
    // I'll store the pid tracking values in a list like so:
    //
    declare dataArray to list().
    dataArray:add(Kp).           // [0]
    dataArray:add(Ki).           // [1]
    dataArray:add(Kd).           // [2]
    dataArray:add(prevTime).     // [3]
    dataArray:add(prevPitchError).   // [4]
    dataArray:add(prevYawError).     // [5]

  return dataArray.
}.

declare function ORIENTTOVECTOR{
    declare parameter inputVector, dataArray. //Take in a vector
    
    declare Kp                to dataArray[0].
    declare Ki                to dataArray[1].
    declare Kd                to dataArray[2].
    declare prevTime          to dataArray[3]. 
    declare prevPitchError    to dataArray[4].
    declare prevYawError      to dataArray[5].
    
    SET timeDelta TO TIME:SECONDS - prevTime.
    
    if prevTime < 0 {
        // I have never been called yet - so don't trust any
        // of the settings yet.
        set dataArray[3] to TIME:SECONDS.
        } 
    else {
      if timeDelta = 0 { 
        //This is the same physics tic as last time. Do nothing.
        }
      else{ //Timing looks good. Run the controller.
        SET directionVector to VXCL(SHIP:FACING:FOREVECTOR, inputVector).
         
        IF VANG(SHIP:FACING:STARVECTOR, directionVector) > 90 {
            SET vectorAngle TO VANG(SHIP:FACING:TOPVECTOR,directionVector).
            }
        ELSE { 
            SET vectorAngle TO 360-VANG(SHIP:FACING:TOPVECTOR,directionVector). 
            }
         
        set facingAngle to VANG(SHIP:FACING:FOREVECTOR, inputVector).
        set pitchAngleError to cos(vectorAngle) * facingAngle.
        set yawAngleError TO sin(vectorAngle)*facingAngle.

        SET dPitch TO (pitchAngleError - prevPitchError)/timeDelta.
        SET dYaw TO (yawAngleError - prevYawError)/timeDelta.
        //SET dPitch TO (prevPitchError - pitchAngleError)/timeDelta.
        //SET dYaw TO (prevYawError - yawAngleError)/timeDelta.

        SET SHIP:CONTROL:PITCH TO (Kp*pitchAngleError + Kd*dPitch).
        SET SHIP:CONTROL:YAW TO -1*(Kp*yawAngleError + Kd*dYaw).
        
        SET prevPitchError TO pitchAngleError.
        SET prevYawError TO yawAngleError.
        
        // remember old values for next time.
        set dataArray[3] to TIME:SECONDS.
        set dataArray[4] to prevPitchError.
        set dataArray[5] to prevYawError.
        }
    }
}

declare function LOGTOFILEINIT{
    //Setup logging files
    print "Deleting previous log...".
    print "Press CTRL-C to abort".
    wait 0.1.
    set nextLogTime to time.
    log "Time" to koslog.csv.
    delete koslog.csv.
    log "Time" + ", " + "Latitude" + ", " + "Longitude" + ", " + "Roll" + ", " + "Pitch" + ", " + "Heading" + ", " + "Angle of Attack" + ", " + "Pitch Component of AoA" + ", " + "Sideslip" + ", " + "Glideslope" to koslog.csv.
    clearscreen.
    }

//TODO: FINISH CONVERTING LOGTOFILE INTO A FUNCTION
declare function LOGTOFILE {
    //declare parameter inputList.
    if time > nextLogTime {
       //RUN logtofile.ks.
       set nextLogTime to time + 2.
    }
    
    }

declare function gs_distance {
    //This function was inspired by TDW who got the basics from another site
    declare parameter gs_p1, gs_p2. //(point1,point2).
    set resultA to sin((gs_p1:lat-gs_p2:lat)/2)^2 + cos(gs_p1:lat)*cos(gs_p2:lat)*sin((gs_p1:lng-gs_p2:lng)/2)^2.
    set result to body:radius*constant():PI*arctan2(sqrt(resultA),sqrt(1-resultA))/90.
    return result.
    }
    
    
declare function GYROINIT{
    //This sets up a bunch of custom variables.
    //This should be the first function called.
    
    declare parameter shipHeight, maxGeeTarget.
    //SHIP CONFIGURATION
    //set shipHeight to 6.3 - 1.  //Mars Decent Vehicle
    //set shipHeight to 10.3 - 1. //Grasshopper Mk 1
    //set shipHeight to 22.5 - 1. //Falcon K Lower Stage
    //set shipHeight to 25.48. //Falcon K Lower Stage w/ deployed gear
    //set shipHeight to 1.2 - 1. //Dragon Capsule
    //set maxGeeTarget to 3.

    //TODO: REMOVE THE HARD CODING
    //Launch Parameters
    set tAP to 250000.
    set tPe to 250000.
    set atmoHeight to 70000.


    set SEALEVELGRAVITY to (constant():G * body:mass) / body:radius^2.
    lock GRAVITY to SEALEVELGRAVITY / ((body:radius+ALTITUDE) / body:radius)^2.
    set maxGeeTarget to maxGeeTarget * 9.809765 / GRAVITY.
    set NORTHPOLE to latlng( 90, 0).
    set KSCLAUNCHPAD to latlng(-0.0972092543643722, -74.557706433623).  //The launchpad at the KSC
    lock landingtargetLATLNG to target:geoposition.
    lock shipLatLng to SHIP:GEOPOSITION.
    lock surfaceElevation to shipLatLng:TERRAINHEIGHT.
    lock TWR to MAX( 0.001, MAXTHRUST / (MASS*GRAVITY)).
    lock TWRTarget to min( TWR * 0.90, maxGeeTarget).
    lock totalSpeed to SURFACESPEED + ABS(VERTICALSPEED).
    lock betterALTRADAR to max( 0.1, min(ALTITUDE , ALTITUDE - surfaceElevation - shipHeight)).
    lock impactTime to betterALTRADAR / -VERTICALSPEED.
    lock killTime to (totalSpeed/GRAVITY) / (TWRTarget).
    lock fallTime to (-VERTICALSPEED - sqrt( VERTICALSPEED^2-(2 * (-GRAVITY) * (betterALTRADAR - 0))) ) /  ((-GRAVITY)).
    
    //set t0 to TIME:SECONDS. //Previous loop time
    set ENGINESAFETY to 1. //Engage engine safety
    set tval to 0. //Working throttle value
    set FINALtval to 0. //This will be what is written to the throttle

    
    //the following are all vectors, mainly for use in the roll, pitch, and angle of attack calculations
    lock rightrotation to ship:facing*r(0,90,0).
    lock right to rightrotation:vector. //right and left are directly along wings
    lock left to (-1)*right.
    lock up to ship:up:vector. //up and down are skyward and groundward
    lock down to (-1)*up.
    lock fore to ship:facing:vector. //fore and aft point to the nose and tail
    lock aft to (-1)*fore.
    lock righthor to vcrs(up,fore). //right and left horizons
    lock lefthor to (-1)*righthor.
    lock forehor to vcrs(righthor,up). //forward and backward horizons
    lock afthor to (-1)*forehor.
    lock top to vcrs(fore,right). //above the cockpit, through the floor
    lock bottom to (-1)*top.

    //the following are all angles, useful for control programs
    lock absaoa to vang(fore,srfprograde:vector). //absolute angle of attack
    lock aoa to vang(top,srfprograde:vector)-90. //pitch component of angle of attack
    lock sideslip to vang(right,srfprograde:vector)-90. //yaw component of aoa
    lock rollangle to vang(right,righthor)*((90-vang(top,righthor))/abs(90-vang(top,righthor))). //roll angle, 0 at level flight
    lock pitchangle to vang(fore,forehor)*((90-vang(fore,up))/abs(90-vang(fore,up))). //pitch angle, 0 at level flight
    lock glideslope to vang(srfprograde:vector,forehor)*((90-vang(srfprograde:vector,up))/abs(90-vang(srfprograde:vector,up))).

    set loopStartTime to time.
    if northPole:bearing <= 0 {
        set cHeading to ABS(northPole:bearing).
        }
    else {
        set cHeading to (180 - northPole:bearing) + 180.
        }

    }

declare function PRINTTOSCREEN{
    //Print data to the screen
    print "################ Flight Data v2.0 ################" at (0,0).
    print "       Now running as a function call!" at (0,1).
    print "ALL ANGLES ARE IN DEGREES" at (5,3).
    set screenline to 5.
    print "PROGRAM:     "+ RUNMODE +"  " at (5,screenline).
         set screenline to screenline + 1.
    print "Thrust/Weight: " + round(TWR, 2) + "       " at (5,screenline).
         set screenline to screenline + 1.
    print "Target TWR   : " + round(TWRTarget, 2) + "       " at (5,screenline).
         set screenline to screenline + 1.
    print "Throttle Val : " + round(TVAL, 2) + "       " at (5,screenline).
         set screenline to screenline + 1.
         set screenline to screenline + 1.

    print "Roll Angle:  "+floor(rollangle)+" " at (5,screenline).
         set screenline to screenline + 1.
    print "Pitch Angle: "+floor(pitchangle)+" " at (5,screenline).
         set screenline to screenline + 1.
    print "Heading:     " + floor(cHeading) + "       " at (5,screenline).
         set screenline to screenline + 1.
         set screenline to screenline + 1. 

    print "Latitude:    " + round(shipLatLng:LAT, 5) + "          " at (5,screenline).
        set screenline to screenline + 1.
    print "Longitude:   " + round(shipLatLng:LNG, 5) + "          " at (5,screenline).
         set screenline to screenline + 1.
    print "Radar Alt:   " + round(betterALTRADAR, 1) + "          " at (5,screenline).
         set screenline to screenline + 1.
    print "VerticalSpd: " + round(VERTICALSPEED, 1) + "          " at (5,screenline).
         set screenline to screenline + 1.
    print "Surface Spd: " + round(SURFACESPEED, 1) + "          " at (5,screenline).
         set screenline to screenline + 1.
         set screenline to screenline + 1.


    print "### Spaceplane Components ###  " at (5,screenline).
         set screenline to screenline + 1.
    print "Angle of Attack:        "+floor(absaoa)+" " at (5,screenline).
         set screenline to screenline + 1.
    print "Pitch Component of AoA: "+floor(aoa)+" " at (5,screenline).
         set screenline to screenline + 1.
    print "Sideslip:               "+floor(sideslip)+" " at (5,screenline).
         set screenline to screenline + 1.
    print "Glide Slope:            "+floor(glideslope)+" " at (5,screenline).
         set screenline to screenline + 1.
    //print "Distance to KSC:     " + KSCLAUNCHPAD:DISTANCE at (5, screenline).
    //     set screenline to screenline + 1.
    //print "Magnatude of vcProd: " + vcProd:MAG at (5, screenline).
    //     set screenline to screenline + 1.

         set screenline to screenline + 1.
         set screenline to screenline + 1.
    print "### Ground Avoidance Data ###  " at (5,screenline).
         set screenline to screenline + 1.
    print "Grav at cAlt: " + round(GRAVITY, 5) + "       " at (5,screenline).
         set screenline to screenline + 1.
    print "Kill   Time:  " + round(killTime, 2) + "       " at (5,screenline).
         set screenline to screenline + 1.
    print "Impact Time:  " + round(impactTime, 2) + "       " at (5,screenline).
         set screenline to screenline + 1.
    print "Fall Time:    " + round(fallTime, 2) + "       " at (5,screenline).
         set screenline to screenline + 1.
    print "HorizontalTtL:" + round((gs_distance(shipLatLng,landingtargetLATLNG) / SURFACESPEED), 2) + "       " at (5,screenline).
         set screenline to screenline + 1.
    print "SurfDist to Target " + round(gs_distance(shipLatLng,landingtargetLATLNG))/1000 + "km       " at (5,screenline).
         set screenline to screenline + 1.

    }

























