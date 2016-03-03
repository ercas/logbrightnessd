# logbrightnessd
logarithmic brightness daemon based on insight from [lizardthunder](http://github.com/lizardthunder)

dependencies
------------
* inotify-tools
* systemd (if you want to install logbrightnessd as a systemd service)
* upstart (if you want to install logbrightnessd as an upstart service)
* openrc  (if you want to install logbrightnessd as an openrc service)

synposis
--------
logbrightnessd, a "logarithmic brightness daemon", is a daemon that changes the backlight on a logarithmic scale instead of a linear scale. [lizardthunder](http://github.com/lizardthunder) pointed out that the human senses sense changes on a logarithmic scale, but the most common brightness controls adjust the brightness linearly; this results in almost imperceptible changes at high brightnesses (max to max-1) and very abrupt changes at low brightness (min to min+1).

usage
-----
before doing anything, make sure the "iface" variable in logbrightnessd (line 6) is set properly. by default, it is set to use /sys/class/backlight/intel_backlight/.

install.sh will install or uninstall the scripts and should be run as root.

logbrightnessd is the main logbrightnessd script and should be run as root. it will control the brightness by watching for file creations in $msgdir (specified in the script), whose names should be integers between 0 and $levels, which is, by default, 10, and is specified in the script. brightnessd.sh will then read the names of those "messages" and set the brightness accordingly. logbrightnessd will also create a file named "current_brightness" in $msgdir that contains the current brightness level.

to directly send "messages" to logbrightnessd, create files in $msgdir. for example, >$msgdir/0 would set the brightness to 0 and >$msgdir/10 would set the brightness to maximum.

brightness is a simple script that sends "messages" to logbrightnessd for you. brightness can be set by specifying a brightness level, which should be an integer between 0 and $levels. instead of an integer, you can also specify "up", which changes the brightness level to one level higher; and "down", which changes the brightness level to one level lower. for example, after running brightness 10, brightness down, and brightness down, you would end up with a brightness level of 8.

if logbrightnessd won't start properly, check to see if a "logbrightnessd" directory exists in /run/; if it does, remove it. this directory should be removed when logbrightnessd exits, but sometimes it may not be removed.
