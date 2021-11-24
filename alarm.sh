#!/bin/sh

# set the alarm announcement (optionally supported by the receiver)
if [ "$1" = "on" ]; then
	ncat 127.0.0.1 12721 <<EOF
set alarm active 1
set dabch-$CH label Alarm melding,Alarm
EOF
elif [ "$1" = "off" ]; then
	ncat 127.0.0.1 12721 <<EOF
set alarm active 0
set dabch-$CH label Alarm melding,Alarm
EOF
fi
