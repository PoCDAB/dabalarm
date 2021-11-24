This repository contains a number of scripts to demo the sending of DAB
emergency messages without DAB-EWF (at this moment). The demo can be run
entirely locally, alternatively a HackRF One can be used to transmit an
ensemble on-air.

I want to thank the Opendigitalradio association for their excellent
open-source DAB tools and documentation. This demo couldn't have been possible
without their software.

# Compiling
I have provided a script to compile several of Opendigitalradio's tools, on
which the provided demo depends.

Other prerequisites are:
- ImageMagick
- ffmpeg

To start compiling, run:
```
$ ./bootstrap.sh
```

# Configuration
Configure sub-channels and other ensemble properties in `dabmux.cfg`. In
addition, several folders have to be created. This is described in detail in the
following subsections.

## Streams
The `streams/` folder contains all streams to be broadcasted. The
folder structure is as follows. A stream is bound to a sub-channel to provide it
with audio, slides and DLS (Journaline) data. Which stream is bound to which
sub-channel is configured at runtime using the `streamctl.sh` script. This is
discussed in detail later.

```
streams
└── [stream]
    ├── audio
    │   ├── 1.mp3
    │   ├── 2.opus
    │   ├── ...
    │   └── n.flac
    ├── slides
    │   ├── 1.jpg
    │   ├── 2.png
    │   ├── ...
    │   └── 3.txt
    └── dls.txt
```

All audio-formats supported by the system-installed version of ffmpeg are also
supported in the `audio/` folder.

All image-formats supported by the system-installed version of ImageMagick are
also supported in the `slides/` folder.

## Sub-channels
`live/` contains all sub-channels. These folders must be empty before before
starting the ensemble. The folder structure is as follows:

```
live
└── [sub-channel]
    ├── audio
    └── slides
```

# Running

The ensemble has to be started first. This can be done in various ways depending
on how you want the stream to be received.

The global flow of data between the different components of this setup is shown
below. On the far right, the different supported methods of receiving are shown.

![](images/dabalarm-demo.png)

The output of ODR-DabMux is in the format of ETI frames. This is a standardized
format in which DAB multiplexers deliver output. This is described in [ETS 300 799](https://www.etsi.org/deliver/etsi_i_ets/300700_300799/300799/01_30_9733/ets_300799e01v.pdf).

ODR-DabMod can output in/to various different formats and drivers. The examples
below cover some examples of the most commonly used ones. Output can form
example be written to a file, Unix pipe or network stream as I/Q samples.\
This can all be configured in `dabmod.ini`. The provided example file is meant
for the HackRF One. More examples can be found in the example file in the
[ODR-DabMod repository](https://github.com/Opendigitalradio/ODR-DabMod/blob/master/doc/example.ini).

## Locally with DABlin
DABlin is a basic DAB/DAB+ SDR decoder and receiver.
First, download and compile dablin by running:
```
$ ./bootstrap.sh dablin
```

To receive ETI frames locally and pipe them live into DABlin, run:

```
$ ./bin/odr-dabmux dabmux.cfg | ./bin/dablin_gtk
```

## Locally with welle.io
Welle.io is another DAB/DAB+ SDR receiver that can be used to play the live
stream.

Download and compile welle.io first using:
```
$ ./bootstrap.sh welle-io
```

Then setup a named pipe for the I/Q frames to be piped through. Then run
welle.io and configure it to read from the pipe in the settings:
```
$ mkfifo /tmp/welle-io.fifo
$ ./bin/odr-dabmux dabmux.cfg | ./bin/odr-dabmod -f /tmp/welle-io.fifo -m 1 -F u8
$ ./bin/welle-io
```

## With a HackRF One
The HackRF One is a low-power transceiver capable of transmitting a DAB/DAB+
ensemble with a range of a few meters.
Beware that most countries require a license to broadcast on the default DAB
frequencies!\
A configuration file for ODR-DabMod is attached (dabmod.ini). Don't forget to
change the channel/frequency!

TODO

## Streaming over the network
I/Q samples or ETI frames can be streamed over the network to be received by
another computer for broadcasting or local playback.

NOTE: nmap-ncat is required for this example to work.

```
$ ./bootstrap.sh welle-io
```

For instance on the sending side:
```
$ odr-dabmux dabmux.cfg | odr-dabmod -f /dev/stdout -m 1 -F u8 | ncat -l -k
--no-shutdown 0.0.0.0 1234
```

And on the receiving side:
```
TODO
```

TODO sending odr-dabmux EDI frames over network

# Stream multiplexing
`./streamctl.sh` is used to bind a stream to a sub-channel. A stream provides a
sub-channel with audio, MOT and DLS data.

For example, to bind a a stream named "radio" to sub-channel 1:
```
$ ./streamctl.sh 1 start radio
```

If a stream is already bound to a sub-channel, this stream is automatically
unbound before the new stream is bound.

To unbind a stream and therefore cut the audio, MOT and DLS data from the
sub-channel, run:
```
$ ./streamctl.sh 1 stop
```

## Alarm stream
This demo aims to provide an emergency announcement functionality without the
use of DAB-EWF. This is achieved by switching the streams of all sub-channels
without changing the automatically channel using a DAB Alarm announcement.

The benefit of this method is that it works on all receivers, even if they
don't support DAB-EWF.

The disadvantage is that DAB-EWF features like automatically powering on the
receiver from stand-by or switching from a different input method to DAB
automatically won't work.

# TODO
- Finish bootstrap.sh

# Example
TODO
