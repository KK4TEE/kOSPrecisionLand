# kOS Precision Land

Putting rockets into the sky, then turning around and landing them again! Using the kOS mod for Kerbal Space Program.
![Landing on a barge](doc/img/2015-04-17-Barge_Landing.png?raw=true "Landing on a barge")

This script launches a two stage rocket into low kerbin orbit and lands the first stage on a barge east of the KSC. A craft file is included, and reccomended to start. The PID controlers and ship height settings will need to be adjusted for other vessels.

Video of the script in action: [Youtube](https://youtu.be/sqqQy8cIVFY)
 
Instructions:
  * Unzip the files and place them in the scripts directory
  * Set the landing location as the target vessel
  * From the launchpad, run [barge.ks](barge.ks) (The Boost Back program). 
  * If you're on the pad it will launch the rocket like a normal mission, otherwise it will attempt a final landing sequence. 
  * Take a look at [runmodes.ks](runmodes.ks) to see the various modes it runs in. Be sure to set a target ship to land on before running the latest code, or change the "landingtargetLATLNG" variable in [library.ks](library.ks) function "GYROINIT" to your LAT/LNG of choice. Enjoy!

TODO:
  * Update to run in modern versions of kOS and Kerbal Space Program
  * Convert [runmodes.ks](runmodes.ks) to use the new functions abilities in kOS
