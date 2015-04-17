//subtest.ks

if loopcount = 0 {
    set firstEstimate to fallTime.
    set firstTime to TIME:SECONDS.
    lock landingtargetLATLNG to target:geoposition.
    }
    
    
print "Gravity:     " + round(GRAVITY, 5) + "m/s^2       " at (5,1).
print "SL Gravity:  " + round(SEALEVELGRAVITY, 5) + "m/s^2       " at (5,2).
print "BetterRADAR: " + round(betterALTRADAR, 3) + "m       " at (5,3).
print "VERTICALSPD: " + round(VERTICALSPEED, 2) + "m/s       " at (5,4).
print "Fall time:   " + round(fallTime, 3) + "s       " at (5,5).
print "First Estimate:   " + round(firstEstimate, 3) + "s       " at (5,6).
print "Difference:       " + round(firstEstimate-(TIME:SECONDS-firstTime)-fallTime, 3) + "s       " at (5,7).


print "Body Radius:          " + round(body:radius / 1000, 3) + "km       " at (5,8).
print "SeaLevelDistance      " + round(gs_distance(shipLatLng,KSCLAUNCHPAD)) + "m       " at (5,9).
print "Target TERRAINHEIGHT: " + round(landingtargetLATLNG:TERRAINHEIGHT) + "m       " at (5,10).

set loopcount to loopcount + 1.