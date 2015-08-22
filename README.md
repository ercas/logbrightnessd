# logbrightnessd
logarithmic brightness daemon based on insight from [lizardthunder](http://github.com/lizardthunder)

dependencies
------------
inotify-tools

synposis
--------
logbrightnessd, a "logarithmic brightness daemon", is a daemon that changes the backlight on a logarithmic scale instead of a linear scale. [lizardthunder](http://github.com/lizardthunder) pointed out that the human senses sense changes on a logarithmic scale, but the most common brightness controls adjust the brightness linearly; this results in almost imperceptible changes at high brightnesses (max to max-1) and very abrupt changes at low brightness (min to min+1).

scripts
-------
logbrightnessd.sh is the main logbrightnessd script and should be run as root. it will control the brightness by watching for file creations in $msgdir (specified in the script), whose names should be integers between 0 and $levels, which is, by default, 10. brightnessd.sh will then read the names of those "messages" and set the brightness accordingly. for example, >$msgdir/0 would set the brightness to 0 and >$msgdir/10 would set the brightness to maximum. logbrightnessd.sh will also create a file named "current_brightness" in $msgdir that contains the current brightness level.

brightness.sh is a simple script that sends "messages" to logbrightnessd. brightness can be set by specifying a brightness level; "up", which changes the brightness level to one level higher; and "down", which changes the brightness level to one level lower.
