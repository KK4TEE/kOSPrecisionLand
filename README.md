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

Note: This script was written with an old version of kOS and Kerbal Space Program, circa 2015. It will take some work to update to the current versions of both, and likely is not functional at all on the current version.

System Organization:
  * [barge.ks](barge.ks) is the primary flight and landing program.
    * It initializes the variables and is the 'main loop' of the program
  * [runmodes.ks](runmodes.ks) is the logic of each flight mode
    * Runs functions through a series of checkpoints, ensuring that each phase of flight is executed in the proper order
    * There are comments in line, and you can follow along with how the rocket operates step by step
  * [test.ks](test.ks) is a readout test program that assists with experimenting
    * Able to run during manual flight or on a seperate kOS unit, this program tests the instrumentation readouts
  * [bb.ks](OLD-LaunchPad-Landing/bb.ks) - "Boost Back" launchpad landing
    * An earlier version of the program, the files in the OLD folder land the 1st stage back at the launchpad
    * Note, this is an even older version of the program and even less tested. For reference only.


TODO:
  * Update to run in modern versions of kOS and Kerbal Space Program
  * Convert [runmodes.ks](runmodes.ks) to use the new functions abilities in kOS
