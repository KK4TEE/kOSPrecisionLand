//test.ks

clearscreen.
print "Steering Control Test Article".
RUN library.ks.
BLANKSLATE().
GYROINIT( 25.48, 3). //Set the ship height, maxTargetGeeforce
    set loopcount to 0.
until 0 > 1{
RUN subtest.ks.
}