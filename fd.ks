//Flight data
//The original code was given to me by /u/mzerwbo and I've added a bunch on.
//Much thanks to him for helping me out with this. 


clearscreen.
Print "Activating flight data recorder...".
//Setup logging files
print "Deleting previous log...".
print "Press CTRL-C to abort".
wait 2.
set nextLogTime to time.
log "Time" to koslog.csv.
delete koslog.csv.
log "Time" + ", " + "Latitude" + ", " + "Longitude" + ", " + "Roll" + ", " + "Pitch" + ", " + "Heading" + ", " + "Angle of Attack" + ", " + "Pitch Component of AoA" + ", " + "Sideslip" + ", " + "Glideslope" to koslog.csv.


clearscreen.
set northPole to latlng( 90, 0).
lock shipLatLng to SHIP:GEOPOSITION.

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


until false {

set loopStartTime to time.
if northPole:bearing <= 0 {
    set cHeading to ABS(northPole:bearing).
    }
else {
    set cHeading to (180 - northPole:bearing) + 180.
    }

//Print data to the screen
print "################ Flight Data v1.1 ################" at (0,0).
print "  Created by /u/mzerwbo  -  Updated by /u/KK4TEE  " at (0,1).
print "ALL VALUES ARE IN DEGREES" at (5,3).

print "Roll Angle:  "+floor(rollangle)+" " at (5,5).
print "Pitch Angle: "+floor(pitchangle)+" " at (5,6).
print "Heading:     " + floor(cHeading) + "       " at (5,7).

print "Latitude:    " + round(shipLatLng:LAT, 5) + "          " at (5,9).
print "Longitude:   " + round(shipLatLng:LNG, 5) + "          " at (5,10).

print "### Spaceplane Components ###  " at (5,12).
print "Angle of Attack:        "+floor(absaoa)+" " at (5,13).
print "Pitch Component of AoA: "+floor(aoa)+" " at (5,14).
print "Sideslip:               "+floor(sideslip)+" " at (5,15).
print "Glide Slope:            "+floor(glideslope)+" " at (5,16).


if time > nextLogTime {
    //Log data to file
    log loopStartTime + ", " + shipLatLng:LAT + ", " + shipLatLng:LNG + ", " + floor(rollangle) + ", " + floor(pitchangle) + ", " + floor(cHeading) + ", " + floor(absaoa) + ", " + floor(aoa) + ", " + floor(sideslip) + ", " + floor(glideslope) to koslog.csv.
    set nextLogTime to time + 2.
    }


}.
