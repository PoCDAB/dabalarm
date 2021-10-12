#!/bin/sh

#
# Script to play all files in a channel's music/ directory
# Not to be invoked manually, only by other scripts or programs
#

# check number of arguments
if [ "$#" -ne 1 ]; then
	echo "usage: ./play.sh CHANNEL"
	exit 1
fi

# check if the channel directory exists
if [ ! -d "live/$1" ]; then
	echo "$0: $1: channel doesn't exist!"
	exit 1
fi

# write our PID to a file so that we can stop the infinite loop from other scripts/programs
echo $$ > /tmp/dabch$1-play.pid

# loop through all files in the channel's audio directory
while true; do
	find live/$1/audio/* | xargs -I $ ffmpeg -y -i $ \
		-f u16le -acodec pcm_s16le -ac 2 -ar 48000 -vn /tmp/dabch$1-audio.fifo -hide_banner -loglevel error
done
