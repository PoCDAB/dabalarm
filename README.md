Deze repository bevat een aantal programma's en scripts om lokaal of via een
HackRF One een demo van DAB alarm berichten uit te voeren:

- ODR-AudioEnc: DAB/DAB+ audio encoder
- ODR-PadEnc: DLS (Journaline) en Slideshow encoder
- ODR-DabMux: DAB multiplexer
- ODR-DabMod: DAB signaal modulator (alleen voor HackRF One streaming)

# Uitvoeren
Eerst zullen alle bovenstaande programma's apart moeten worden gecompileerd. In
die toekomst zal ik hier wellicht een simpel script voor schrijven.

Vereisten:
- ImageMagick
- ffmpeg
- nmap-ncat
- Alle bovenstaande programma's gecompileerd (maar niet per se geïnstalleerd met
  make install)

Configureer in dabmux.cfg de sub-kanalen. Maak en vul daarnaast de mappenstructuur
besproken in onderstaande sectie.

`./ensemble.sh` start de ensemble
`./play.sh` kan worden gebruikt om

# Mappenstructuur
De `streams/` map bevat alle streams die kunnen worden uitgezonden. `live/`
bevat alle sub-kanalen. Met `streamctl.sh` kan een stream aan een sub-kanaal
worden gekoppeld.

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

Alle audio-formaten ondersteund door de geïnstalleerde versie van ffmpeg worden ook
door deze scripts ondersteund.

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

# Voorbeelden

## Stream (her-)starten
TODO

## Alarm announcement
TODO
