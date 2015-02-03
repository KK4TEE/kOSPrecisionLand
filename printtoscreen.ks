//Print data to the screen
print "################ Flight Data v1.1 ################" at (0,0).
print "FD v1 Created by /u/mzerwbo - Updated by /u/KK4TEE" at (0,1).
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
     set screenline to screenline + 1.
print "Distance to KSC:     " + KSCLAUNCHPAD:DISTANCE at (5, screenline).
     set screenline to screenline + 1.
print "Magnatude of vcProd: " + vcProd:MAG at (5, screenline).
     set screenline to screenline + 1.

     set screenline to screenline + 1.
     set screenline to screenline + 1.
print "Kill   Time:  " + round(killTime, 2) + "       " at (5,screenline).
     set screenline to screenline + 1.
print "Impact Time:  " + round(impactTime, 2) + "       " at (5,screenline).
     set screenline to screenline + 1.

