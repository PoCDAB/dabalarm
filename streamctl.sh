#!/bin/bash

#
#    CFNS - Rijkswaterstaat CIV, Delft © 2021 - 2022 <cfns@rws.nl>
#
#    Copyright 2021 - 2022 Bastiaan Teeuwen <bastiaan@mkcl.nl>
#
#    This file is part of dabalarm
#
#    dabalarm is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    dabalarm is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with dabalarm.  If not, see <https://www.gnu.org/licenses/>.
#

#
# Script to bind a new stream to a channel
#

CH="$1"
STREAM="$3"

# channel must be a number, quit otherwise
case $CH in
''|*[!0-9]*)
	echo "$0: $CH: channel must be a number"
	exit 1
	;;
*)
	;;
esac

FIFO="/tmp/dabch$CH-audio.fifo"
PLAY_PID="/tmp/dabch$CH-play.pid"
AUDIOENC_PID="/tmp/dabch$CH-audioenc.pid"
PADENC_PID="/tmp/dabch$CH-padenc.pid"

# quit all programs if a stop command was issued
if [ "$2" = "stop" ]; then
	# TODO check if we're even started in the first place

	kill $(cat "$PLAY_PID")
	pkill ffmpeg # TODO kill by PID
	kill $(cat "$AUDIOENC_PID")
	kill $(cat "$PADENC_PID")

	rm "$FIFO" "$PLAY_PID" "$AUDIOENC_PID" "$PADENC_PID" "/tmp/dabch$CH.audioenc" "/tmp/dabch$CH.padenc"

	# unbind folder links and remove DLS information
	rm -f live/$CH/audio/* live/$CH/slides/* live/$CH/dls.txt

	exit 0
fi

# check number of arguments
if [ "$#" -ne 3 ]; then
	echo "usage: $0 CHANNEL start|stop [STREAM] [alarm]"
	exit 1
fi
# TODO use a little getopt magic here instead of this crappy parsing

# start the audio encoder and DLS/MOT encoder as needed
if [ ! -p "/tmp/dabch$CH-audio.fifo" ]; then
	# create a named pipe for the audio stream to flow through
	mkfifo "$FIFO"

	# start encoding audio
	./bin/odr-audioenc \
		--input="$FIFO" \
		--format=raw \
		--fifo-silence \
		--bitrate=128 \
		--output=tcp://localhost:9001 \
		--pad-socket=dabch$CH \
		--pad=58 & echo $! > "$AUDIOENC_PID"

	# start encoding DLS and MOT slideshow information and send it to the audio encoder
	./bin/odr-padenc \
		--dls=live/$CH/dls.txt \
		--dir=live/$CH/slides \
		--output=dabch$CH \
		--sleep=0 & echo $! > "$PADENC_PID"
fi

# stop the current audio stream
if [ -f "$PLAY_PID" ]; then
	kill $(cat "$PLAY_PID")
fi
pkill ffmpeg # TODO kill by PID

# delete the old channel stream (if present)
rm -f live/$CH/audio/* live/$CH/slides/*

# link in the new streams
ln -sr streams/$STREAM/audio/* live/$CH/audio/.
ln -sr streams/$STREAM/slides/* live/$CH/slides/.
cat streams/$STREAM/dls.txt > live/$CH/dls.txt

# play the new stream
(./play.sh $CH &)

# set the alarm announcement (optionally supported by the receiver)
#ncat 127.0.0.1 12721 <<EOF
#set alarm active 1
#set dabch-$CH label Alarm melding,Alarm
#EOF
