Deze repository bevat een aantal programma's en scripts om lokaal of via een
HackRF One een demo van DAB alarm berichten uit te voeren:

- ODR-AudioEnc: DAB/DAB+ audio encoder
- ODR-PadEnc: DLS (Journaline) en Slideshow encoder
- ODR-DabMux: DAB multiplexer
- ODR-DabMod: DAB signaal modulator (alleen voor HackRF One streaming)

# Uitvoeren
Aanvankelijk zullen alle bovenstaande programma's apart moeten worden
gecompileerd. In die toekomst zal ik hier wellicht een simpel script voor
schrijven.

Vereisten:
- ImageMagick
- ffmpeg
- nmap-ncat
- Alle bovenstaande programma's gecompileerd (maar niet per se geïnstalleerd met
  `make install`)

Configureer in dabmux.cfg de sub-kanalen. Maak en vul daarnaast de
mappenstructuur toegelicht in onderstaande sectie.

`./ensemble.sh` start de ensemble
`./streamctl.sh` kan worden gebruikt om een stream aan een sub-kanaal te
koppelen. Om bijvoorbeeld een stream genaamd "radio" te koppelen aan sub-kanaal
1:

```
$ ./streamctl.sh 1 start radio
```

Als er al een stream op het sub-kanaal loopt, wordt deze automatisch gestopt.

Om een sub-kanaal te stoppen, kan het volgende commando worden gebruikt:

```
$ ./streamctl.sh 1 stop
```

# Alarm stream
Het idee van deze demo is dat door een "alarm" stream aan te maken, hier per
kanaal naar kan worden overgeswitcht zonder gebruikt te maken van DAB-EWF. Dit
is voordelig voor goedkope draadloze ontvangers die geen DAB-EWF ondersteunen.

# Mappenstructuur
De `streams/` map bevat alle streams die kunnen worden uitgezonden. `live/`
bevat alle sub-kanalen.

## Streams
`streams/` heeft de volgende mappenstructuur:

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

Alle audio-formaten ondersteund door de geïnstalleerde versie van ffmpeg worden
ook door deze scripts ondersteund.

Alle slide-formaten ondersteund door de geïnstalleerde versie van ImageMagick
worden ook door deze scripts ondersteund.

## Live
`live/` heeft de volgende mappenstructuur:

```
live
└── [sub-kanaal]
    ├── audio
    ├── slides
    └── dls.txt
```

Bestanden worden automatisch met symbolic links aan de juiste mappen gelinkt.
