#!/bin/sh

trap 'kill $(jobs -pr) && rm -f audio.fifo alarm.fifo u8.fifo' SIGINT SIGTERM EXIT

# Regular audio sub-channel
mkfifo audio.fifo
./ODR-AudioEnc/odr-audioenc -i audio.fifo --fifo-silence -f raw -b 128 -o tcp://localhost:9001 -P srv-audio -p 58 &

## Alarm audio sub-channel
#mkfifo alarm.fifo
#./ODR-AudioEnc/odr-audioenc -i alarm.fifo --fifo-silence -f raw -b 128 -o tcp://localhost:9002 -P srv-alarm -p 58 &

# Multiplexer and modulator
mkfifo u8.fifo
./ODR-DabMux/odr-dabmux dabmux.cfg | ./ODR-DabMod/odr-dabmod -f u8.fifo -m 1 -F u8
