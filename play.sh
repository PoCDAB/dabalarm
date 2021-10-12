#!/bin/sh

echo $$ > $1

while true; do
	find music/$1/* | xargs -I $ ffmpeg -y -i $ \
		-f u16le -acodec pcm_s16le -ac 2 -ar 48000 -vn audio.fifo -hide_banner -loglevel error
done
