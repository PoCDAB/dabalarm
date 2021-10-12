#!/bin/sh

#
# Script to start the ensemble broadcast
#

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

# TODO do a little getopt magic here
dablin_stream
# named_pipe_stream
# network_stream
