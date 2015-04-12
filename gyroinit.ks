//Set variables dynamically based on planatary body


//SHIP CONFIGURATION
//set shipHeight to 6.3 - 1.  //Mars Decent Vehicle
//set shipHeight to 10.3 - 1. //Grasshopper Mk 1
//set shipHeight to 22.5 - 1. //Falcon K Lower Stage
set shipHeight to 25.48. //Falcon K Lower Stage w/ deployed gear
//set shipHeight to 1.2 - 1. //Dragon Capsule
set maxGeeTarget to 3.


//Launch Parameters
set tAP to 250000.
set tPe to 250000.
set atmoHeight to 70000.


set GRAVITY to (constant():G * body:mass) / body:radius^2.
set maxGeeTarget to maxGeeTarget * 9.809765 / GRAVITY.
set NORTHPOLE to latlng( 90, 0).
set KSCLAUNCHPAD to latlng(-0.0972092543643722, -74.557706433623).
lock shipLatLng to SHIP:GEOPOSITION.
lock surfaceElevation to shipLatLng:TERRAINHEIGHT.
lock TWR to MAX( 0.001, MAXTHRUST / (MASS*GRAVITY)).
lock TWRTarget to min( TWR * 0.90, maxGeeTarget).
lock totalSpeed to SURFACESPEED + ABS(VERTICALSPEED).
lock betterALTRADAR to max( 0.1, ALTITUDE - surfaceElevation - shipHeight).
lock impactTime to betterALTRADAR / -VERTICALSPEED.
lock killTime to (totalSpeed/GRAVITY) / (TWRTarget).
set t0 to TIME:SECONDS. //Previous loop time
set ENGINESAFETY to 1. //Engage engine safety


    SET pitchE0 TO 0.
    SET yawE0 TO 0.
    SET rollE0 TO 0.
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
