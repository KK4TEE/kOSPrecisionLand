clearscreen.
print "Mars Ascent Vehicle - Launching".

//Setup logging files
print "Deleting previous log...".
print "Press CTRL-C to abort".
wait 2.
set nextLogTime to time.
log "Time" to koslog.csv.
delete koslog.csv.
log "Time" + ", " + "Latitude" + ", " + "Longitude" + ", " + "Roll" + ", " + "Pitch" + ", " + "Heading" + ", " + "Angle of Attack" + ", " + "Pitch Component of AoA" + ", " + "Sideslip" + ", " + "Glideslope" to koslog.csv.


set SAP_MARS_ORBIT_ALTITUDE to 150000.
set SAP_MARS_ORBIT_INCLINATION to 0.

set tAp to SAP_MARS_ORBIT_ALTITUDE.
set tPe to SAP_MARS_ORBIT_ALTITUDE.
set atmoHeight to 130000.
set gravityTurnFlat to 55000. 
	//45km = 044dV
	//50km = 240dV
	//60km = 212dV
set minAscentAngle to 5. //4 has worked well

//minAscentAngle = 5 granted 210m/s reserve fuel to a 150km orbit.

set RUNMODE to 2.
if ALT:RADAR < 50 {set RUNMODE to 1.}
 
sas off.
rcs on.
lights on.


//Set variables dynamically based on planatary body
set GRAVITY to (constant():G * body:mass) / body:radius^2.
when alt:radar > 20 then { gear off.}
set TVAL to 0.
lock throttle to TVAL.


set northPole to latlng( 90, 0).
SET shipLatLng to SHIP:GEOPOSITION.

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


until 0{
set loopStartTime to time.
if northPole:bearing <= 0 {
    set cHeading to ABS(northPole:bearing).
    }
else {
    set cHeading to (180 - northPole:bearing) + 180.
    }

if RUNMODE = 1 { // At launch site
    stage. stage.
    sas on.
    set TVAL to 1.
    //lock steering to HEADING(90, 90).
    print "Launch!".
    set RUNMODE to 2.
    wait 2. sas off.
    set SHIP:CONTROL:PITCH to 1.
    wait 2.
    set SHIP:CONTROL:PITCH to -1.
    wait 1.5.
    set SHIP:CONTROL:PITCH to 0.
    lock steering to HEADING(90, 90).
    sas off.
	}
	
if RUNMODE = 2 { // Initial climb
    set TVAL to 1.
    if ALTITUDE < atmoHeight {
        set tPITCH to max(minAscentAngle, 90 * (1-ALT:RADAR/gravityTurnFlat)).
        }
    else {
        set tPITCH to 2.
        }
    lock steering to heading(90, tPITCH).
    lock throttle to TVAL.
    if ALT:APOAPSIS > atmoHeight {
	set RUNMODE to 3.
        }

 }
 
if RUNMODE = 3 { //Boost to orbit
    lock steering to HEADING(90, 0).
    if ALT:APOAPSIS > atmoHeight and ALT:APOAPSIS < (tAp * 0.9){
        set TVAL to 0.75.
        }
    if ALT:APOAPSIS > (tAp * 0.9) and ALT:APOAPSIS < (tAp * 1){
        set TVAL to 0.1.
        }
    if ALT:APOAPSIS >= (tAp * 1) and ALTITUDE < (tAp * 0.99){
        set TVAL to 0.   
        }
    if ETA:APOAPSIS < 10 and ALT:PERIAPSIS < atmoHeight{
        set TVAL to 0.75.
        }
    if ALTITUDE > (tAp * 0.9) and ALT:PERIAPSIS > (atmoHeight * 0.5) and ALT:PERIAPSIS < (tPe * 0.9){
        set TVAL to 0.25.
        }
    if ALT:PERIAPSIS > (tPe * 0.95){
        lock throttle to 0.
        print "In Orbit".
        panels on.
        unlock steering.
        break.
        }      
  }
    lock throttle to TVAL.
    print "RadarALT: " + round(ALT:RADAR,1)     + "        " at (1,5).
	print "V Speed : " + round(VERTICALSPEED,1) + "        " at (1,6).
	print "Surf Spd: " + round(SHIP:AIRSPEED,1) + "        " at (1,7).
	print "Mach    : " + round(SHIP:AIRSPEED / 340, 1) + "        " at (1,8).
	
	print "Apoapsis: " + round(ALT:APOAPSIS,1)        + "        " at (1,9).
	print "PERIAP  : " + round(ALT:PERIAPSIS,1)           + "        " at (1,10) .
	print "TVAL    : " + round(TVAL,1)             + "        " at (1,11) .
	print "RUNMODE : " + round(RUNMODE,1)             + "        " at (1,12) .


// Log data to file
if time > nextLogTime {
    //Log data to file
    log loopStartTime + ", " + shipLatLng:LAT + ", " + shipLatLng:LNG + ", " + floor(rollangle) + ", " + floor(pitchangle) + ", " + floor(cHeading) + ", " + floor(absaoa) + ", " + floor(aoa) + ", " + floor(sideslip) + ", " + floor(glideslope) to koslog.csv.
    set nextLogTime to time + 2.
    }

//    if STAGE:LIQUIDFUEL < 1 {
//        lock throttle to 0.
 //       stage.
 //       wait 3. 
//	lock throttle to tVAL.
 //       }      

}
