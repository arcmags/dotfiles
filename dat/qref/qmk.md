# QMK Quick Reference

Build firmare:

    $ qmk compile -kb <KEYBOARD> -km <KEYMAP>

View bootloader ID:

    $ lsusb


## annepro2

Requires annepro2-tools and AnnePro2-Shine.

Put keyboard in boot mode.

Flash firmware:

    # annepro2-tools <FIRMWARE_BIN>
    # annepro2-tools --boot -t led <SHINE_BIN>


## dztech/dz60rgb/v2

Put keyboard in boot mode.

Bootloader ID: `03eb:2ff4`

Flash firmware:

    $ qmk flash <FIRMWARE_HEX>


## dztech/dz60rgb/v2\_1

Put keyboard in boot mode.

Bootloader ID: `03eb:2045`

Flash firmware:

    # mount <DEVICE> /mnt/keyboard
    # dd if=<FIRMWARE_BIN> of=/mnt/keyboard/FLASH.BIN bs=512 conv=notrunc oflag=direct,sync
    # sync
    # umount /mnt/keyboard

Unplug and replug keyboard from USB.


## novelkeys/nk87

Put keyboard in boot mode.

Bootloader ID: `0483:df11`

Flash firmware:

    $ qmk flash -kb novelkeys/nk87 -km <keymap>
