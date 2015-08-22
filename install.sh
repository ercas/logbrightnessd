#!/bin/sh

! [ $EUID = 0 ] && echo "this script must be run as root." && exit 0
cd "$(dirname "$(readlink -f $0)")"

alias cp="cp -v"
alias ln="ln -v"
alias rm="rm -fv"
usage() {
    cat << EOF
please specify one of the following:

basic        only install the logbrightnessd and brightness scripts
systemd      install the logbrightnessd and brightness scripts and create a new
             systemd service
uninstall    remove everything
EOF
}
controls() {
    cat << EOF

use "brightness" to control logbrightnessd. for more details, see README.md.
EOF
}

if [ -z $1 ]; then
    usage
else
    case $1 in
        basic)
            cp logbrightnessd brightness /usr/local/bin/
            cat << EOF

use "logbrightnessd" to start logbrightnessd.
use "killall logbrightnessd" to stop logbrightnessd.
EOF
            controls
            ;;
        systemd)
            cp logbrightnessd brightness /usr/local/bin/
            cp logbrightnessd.service /lib/systemd/system/
            ln -s /lib/systemd/system/logbrightnessd.service \
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
        uninstall)
            systemctl stop logbrightnessd
            killall logbrightnessd
            rm /usr/local/bin/{logbrightnessd,brightness} \
               /lib/systemd/system/logbrightnessd.service \
               /etc/systemd/system/logbrightnessd.service
            echo -e "\nlogbrightnessd has been removed."
            ;;
        *)
            echo "$1 is not a valid target."; usage
            ;;
    esac
fi