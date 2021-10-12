#!/bin/bash

trap 'kill $(jobs -pr); kill $(cat audio); kill $(cat alarm); pkill ffmpeg; rm -f audio.fifo alarm.fifo audio alarm' SIGINT SIGTERM EXIT

# Restore dls and slides to regular audio information
#rm -f alarm
#touch audio
#pushd slides/live
#rm -f * && ln -s ../audio/* .
#popd

# Regular audio sub-channel
mkfifo audio.fifo
sleep 1
./ODR-AudioEnc/odr-audioenc -i audio.fifo --fifo-silence -f raw -b 128 -o tcp://localhost:9001 -P srv-audio -p 58 &
sleep 1
./ODR-PadEnc/odr-padenc -o srv-audio -t dls/live.txt -d slides/live -s 0 &

## Alarm audio sub-channel
#mkfifo alarm.fifo
#./ODR-AudioEnc/odr-audioenc -i alarm.fifo --fifo-silence -f raw -b 128 -o tcp://localhost:9002 -P srv-alarm -p 58 &
#./ODR-PadEnc/odr-padenc -o srv-alarm -t dls/alarm.txt -d slides/alarm &

# Multiplexer and modulator
#mkfifo u8.fifo

# Restore audio, dls and slides to regular audio channel
sleep 1
./alarm.sh off
sleep 1

./ODR-DabMux/odr-dabmux dabmux.cfg | dablin/build/src/dablin_gtk
