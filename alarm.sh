#!/bin/bash

# Script to trigger the alarm message to be ran

# TODO check if is running

function audio {
	# kill the alarm stream
	kill $(cat alarm); pkill ffmpeg
	rm -f alarm
	touch audio
	cat dls/audio.txt > dls/live.txt

	pushd slides/live
	rm -f * && ln -s ../audio/* .
	popd

	ncat localhost 12721 <<EOF
set alarm active 0
set srv-audio label CFNS Radio,CFNS
EOF

	# play the new stream
	(./play.sh audio &)
}

function alarm {
	# kill the normal audio stream
	kill $(cat audio); pkill ffmpeg
	rm -f audio
	touch alarm

	cat dls/alarm.txt > dls/live.txt

	pushd slides/live
	rm -f * && ln -s ../alarm/* .
	popd

	ncat 127.0.0.1 12721 <<EOF
set alarm active 1
set srv-audio label Alarm melding,Alarm
EOF

	# play the new stream
	(./play.sh alarm &)
}

case "$1" in
"toggle")
	if [ -e './alarm' ]; then
		audio
	else
		alarm
	fi
	;;
"off")
	audio
	;;
"on")
	alarm
	;;
*)
	echo 'usage: ./alarm.sh on|off|toggle'
	exit 1
	;;
esac

exit 0
