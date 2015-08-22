#!/bin/sh

msgdir=/tmp/logbrightnessd

if [ "$1" = "up" ]; then
    >$msgdir/$(($(cat $msgdir/current_brightness)+1))
elif [ "$1" = "down" ]; then
    >$msgdir/$(($(cat $msgdir/current_brightness)-1))
elif [ "$1" -eq "$1" ] 2>/dev/null; then
    >$msgdir/$1
else
    echo "$1 is not an integer."
fi