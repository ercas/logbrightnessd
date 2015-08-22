#!/bin/sh

########## settings

levels=10
iface=/sys/class/backlight/intel_backlight/
msgdir=/tmp/logbrightnessd

########## defaults

factor=$(echo "$(cat $iface/max_brightness)/(2^$levels)" | bc -l)

#for brightness in $(seq $levels); do
#    sleep 0.5
#    echo "(2^$brightness)*$factor" | bc | cut -d "." -f1 > $iface/brightness
#done

########## setup

if [ $EUID = 0 ]; then
    chmod g+r $iface/brightness
else
    echo "this script must be run as root."; exit 1
fi
shopt -s dotglob # just in case people try to spam $msgdir with dotfiles
mkdir -p $msgdir
chmod a+rwx $msgdir
echo 10 >$msgdir/current_brightness

########## logbrightnessd

rm -rf $msgdir/*
while inotifywait -q -e CREATE $msgdir > /dev/null; do
    for f in $msgdir/*; do
        level=${f##*/}
        if ! [ "$level" = "current_brightness" ]; then # ignore the "log"
            rm -rf $f
            if [ "$level" -eq "$level" ] 2>/dev/null; then # only integers
                level=$([ $level -lt 0 ] && echo 0 || \
                    [ $level -gt $levels ] && echo $levels || \
                    echo $level)
                echo "(2^$(echo $level | awk '{printf $1}'))*$factor" | \
                     bc | cut -d "." -f1 > $iface/brightness
                echo $level > $msgdir/current_brightness
                echo "changed brightness to $level"
            fi
        fi
    done
done