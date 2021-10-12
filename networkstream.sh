./ODR-DabMux/odr-dabmux dabmux.cfg | ./ODR-DabMod/odr-dabmod -f /dev/stdout -m 1 -F u8 | ncat -l -k --no-shutdown 0.0.0.0 1235
