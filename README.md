# SindenProfiler
GUI Frontend to allow easily swapping of configuration files for the Sinden Lightgun app.

This AHK allows you to easily swap out different Config files to/from the Sinden Lightgun Application (hereafter known as Profiles).
Make sure to place this AHK (or compiled exe) into it's own folder. Doesn't really matter where.
The first time this program is run it will create a Configs folder and prompt you for where the Sinden lightgun app is currently installed.
Choose the exe file (default is Lightgun.exe) in the Sinden Lightgun folder. It will be automatically saved in an ini so is only needed the first time this is ever run.
You can call the new Profiles anything you want from No Recoil to Automatic Recoil to Rambo Mode to Afternoon settings to Night Time Dim. The options are endless.
This program can be run while the Sinden App is still running so you can make a change in the Sinden App, click Save Settings in that app and then click New Profile in here and it will save the values to your new Profile.
Go ahead and change whatever you want (remember to hit Save Settings in Sinden app first) and make as many Profiles as you want!
The Sinden app needs to be shut down when a Profile is loaded however since the Sinden Lightgun app only takes the values on start up.
This AHK can also be be used to load a Profile via another AHK or a command line and skip the GUI with the following call:
SindenProfiler.ahk "Profile Name"
To automatically stop the Sinden App then load the new Profile add -s (Example: SindenProfiler.ahk -s "Profile Name")
To automatically stop the Sinden App, load the new Profile and then restart the Sinden app again add -ss (Example: SindenProfiler.ahk -ss "Profile Name")
If you want to return to your previous Sinden Profile, just send SindenProfiler.ahk Restore and everything will be back the way it was.
This was coded for a single instance of Sinden software however you can have 2 copies (in different folders) and then run 1 for 1 instance of Sinden and another for the 2nd.
If you have any issues or move the Sinden program folder, just delete the SindenProfiler.ini file in the AHK folder and it will start fresh or click Tools - Change Sinden Folder
If you still have any issues, you probably know where to find me. ;) (Likely on the Sinden Discord server.) Have fun! Hexxed
