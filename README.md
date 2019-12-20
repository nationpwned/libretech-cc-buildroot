## Buildroot with Amlogic S905X LibreTech-CC "LePotato" support

This version of Buildroot can generated a full environment (amlogic bootloader, U-Boot, Linux Kernel and rootfs) for the Amlogic S905X LibreTech-CC aka "LePotato" board.

### How to build an image for SD card?

First, you need to copy the configuration file from the ./configs folder to .config default configuration file.

    $ cp configs/meson-gxl-s905x-libretech-cc_defconfig .config

Then, you just have to enter the following command to build the full environment.

    $ make

Finally, to flash a SD card, simply use the flash-sdcard tool to burn the image onto your SD card.
  
     $ ./utils/flash-sdcard


