#!/bin/sh

#
# Script to start broadcasting the ensemble
#

# channel configuration
#CH1_FIFO='/tmp/odrdab-ch1.fifo'
#CH1_PID='/tmp/odrdab-ch1.pid'
#CH1_PORT=9001

#trap 'kill $(jobs -pr); pkill ffmpeg; rm -f '"$CH1_FIFO $CH1_PID"'; kill $(cat '$CH1_PID')' SIGINT SIGTERM EXIT

# pipe the ETI frames into dablin-gtk and open it locally
function dablin_stream {
	./ODR-DabMux/odr-dabmux dabmux.cfg | \
		dablin/build/src/dablin_gtk
}

# pipe the ETI frames into netcat
function network_stream {
	./ODR-DabMux/odr-dabmux dabmux.cfg | \
		./ODR-DabMod/odr-dabmod -f /dev/stdout -m 1 -F u8 | ncat -l -k --no-shutdown 0.0.0.0 1234
}

# redirect the ETI frames into a named pipe
function named_pipe_stream {
	mkfifo /tmp/u8.fifo

	./ODR-DabMux/odr-dabmux dabmux.cfg | \
		./ODR-DabMod/odr-dabmod -f /tmp/u8.fifo -m 1 -F u8

	# TODO remove /tmp/u8.fifo
}

# create a named pipe and PID file for the sub-channel
#mkfifo $CH1_FIFO
#touch $CH1_PID

# start encoding audio
#./ODR-AudioEnc/odr-audioenc \
#	--input=$CH1_FIFO \
#	--format=raw \
#	--fifo-silence \
#	--bitrate=128 \
#	--output=tcp://localhost:9001 \
#	--pad-socket=ch1 \
#	--pad=58 &

# start encoding DLS and slideshow information and send it to the audio encoder
#./ODR-PadEnc/odr-padenc \
#	--dls=dls/ch1.txt \
#	--dir=slides/ch1 \
#	--output=ch1 \
#	--sleep=5 &

# Restore audio, dls and slides to regular audio channel
#./ctl.sh ch1 normal

# TODO do a little getopt magic here
dablin_stream
# named_pipe_stream
# network_stream
