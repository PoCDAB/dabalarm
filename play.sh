#!/bin/sh

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
