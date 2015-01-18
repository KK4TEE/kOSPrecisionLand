//Set variables dynamically based on planatary body
set GRAVITY to (constant():G * body:mass) / body:radius^2.
set NORTHPOLE to latlng( 90, 0).
set KSCLAUNCHPAD to latlng(-0.0972092543643722, -74.557706433623).
lock shipLatLng to SHIP:GEOPOSITION.
lock TWR to MAXTHRUST / (MASS*GRAVITY).

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
