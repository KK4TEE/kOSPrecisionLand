//Setup logging files
print "Deleting previous log...".
print "Press CTRL-C to abort".
wait 0.1.
set nextLogTime to time.
log "Time" to koslog.csv.
delete koslog.csv.
log "Time" + ", " + "Latitude" + ", " + "Longitude" + ", " + "Roll" + ", " + "Pitch" + ", " + "Heading" + ", " + "Angle of Attack" + ", " + "Pitch Component of AoA" + ", " + "Sideslip" + ", " + "Glideslope" to koslog.csv.
clearscreen.
