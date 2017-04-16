#!/bin/bash

prefix=/usr/local

! [ $EUID = 0 ] && echo "this script must be run as root." && exit 0
cd "$(dirname "$(readlink -f $0)")"

function usage() {
    cat << EOF
please specify one of the following:

basic        only install the logbrightnessd and brightness scripts
systemd      install basic and create a new systemd service
upstart      install basic and create a new upstart service
openrc       install basic and create a new openrc service
uninstall    remove everything
EOF
}
function controls() {
    cat << EOF

use "brightness" to control logbrightnessd. for more details, see README.md.
EOF
}
function checkcmd() {
    if ! command -v $1 > /dev/null; then
        echo "$1 is not available."
        exit 1
    fi
}

checkcmd inotifywait
if [ -z $1 ]; then
    usage
else
    case $1 in
        basic)
            cp -v logbrightnessd brightness $prefix/bin/
            mkdir -p $prefix/man/man1
            cp -v brightness.1 $prefix/man/man1
            cat << EOF

use "logbrightnessd" to start logbrightnessd.
use "killall logbrightnessd" to stop logbrightnessd.
EOF
            controls
            ;;
        systemd)
            checkcmd systemctl
            cp -v logbrightnessd brightness $prefix/bin/
            mkdir -p $prefix/man/man1
            cp -v brightness.1 $prefix/man/man1
            cp -v init/logbrightnessd.service /lib/systemd/system/
            ln -vs /lib/systemd/system/logbrightnessd.service \
                  /etc/systemd/system/logbrightnessd.service
            systemctl daemon-reload
            cat << EOF

use "systemctl start logbrightnessd.service" to start logbrightnessd.
use "systemctl enable logbrightnessd.service" to have logbrightnessd
    automatically start after booting.
use "systemctl stop logbrightnessd.service" to stop logbrightnessd.
EOF
            controls
            ;;
        upstart)
            checkcmd initctl
            cp -v logbrightnessd brightness $prefix/bin/
            mkdir -p $prefix/man/man1
            cp -v brightness.1 $prefix/man/man1
            cp -v init/logbrightnessd.conf /etc/init/
            initctl reload-configuration
            cat << EOF

logbrightnessd will now be automatically started after booting.
use "initctl start logbrightnessd" to start logbrightnessd.
use "initctl stop logbrightnessd" to stop logbrightnessd.
EOF
            controls
            ;;
        openrc)
            checkcmd openrc
            cp -v logbrightnessd brightness /usr/local/bin/
            cp -v init/logbrightnessd.openrc /etc/init.d/logbrightnessd
            chmod a+x /etc/init.d/logbrightnessd
            rc-update add logbrightnessd default
            cat << EOF

logbrightnessd will now be automatically started after booting.
use "rc-service logbrightnessd start" to start logbrightnessd.
use "rc-service logbrightnessd stop" to stop logbrightnessd.
EOF
            controls
            ;;
        uninstall)
            systemctl stop logbrightnessd 2>/dev/null
            systemctl disable logbrightnessd 2>/dev/null
            initctl stop logbrightnessd 2>/dev/null
            rc-service logbrightnessd stop 2>/dev/null
            killall logbrightnessd 2>/dev/null
            rm -v $prefix/bin/{logbrightnessd,brightness} \
               $prefix/man/man1/brightness.1
               /lib/systemd/system/logbrightnessd.service \
               /etc/systemd/system/logbrightnessd.service \
               /etc/init.d/logbrightnessd 2>/dev/null
            systemctl daemon-reload 2>/dev/null
            initctl reload-configuration 2>/dev/null
            rc-update delete logbrightnessd default 2>/dev/null
            echo -e "\nlogbrightnessd has been removed."
            ;;
        *)
            echo "$1 is not a valid target."; usage
            ;;
    esac
fi
