//Setup logging files
print "Deleting previous log...".
print "Press CTRL-C to abort".
wait 2.
set nextLogTime to time.
log "Time" to koslog.csv.
delete koslog.csv.
log "Time" + ", " + "Latitude" + ", " + "Longitude" + ", " + "Roll" + ", " + "Pitch" + ", " + "Heading" + ", " + "Angle of Attack" + ", " + "Pitch Component of AoA" + ", " + "Sideslip" + ", " + "Glideslope" to koslog.csv.
clearscreen.
