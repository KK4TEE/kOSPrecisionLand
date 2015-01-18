//Print data to the screen
print "################ Flight Data v1.1 ################" at (0,0).
print "FD v1 Created by /u/mzerwbo - Updated by /u/KK4TEE" at (0,1).
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


print "Distance to KSC:     " + KSCLAUNCHPAD:DISTANCE at (5, 20).
print "Magnatude of vcProd: " + vcProd:MAG at (5, 21).
