## Buildroot with Amlogic S905X LibreTech-CC "LePotato" support

This version of Buildroot can generated a full environment (amlogic bootloader, U-Boot, Linux Kernel and rootfs) for the Amlogic S905X LibreTech-CC aka "LePotato" board.

### How to install this tool?

Copy the following command to clone this repository to your work environment.

    $ git clone https://github.com/mathieu-lm/libretech-cc-buildroot.git
    $ cd libretech-cc-buildroot

This tool depends on the following packages. To install them, use the following command.

    $ sudo apt install sed make binutils gcc g++ bash patch gzip bzip2 perl tar cpio unzip rsync file bc wget python git
    

### How to build an image for SD card?

First, you need to copy the configuration file from the ./configs folder to .config default configuration file.

Depending on which U-Boot version you want to use, copy the following configuration file.

#### Using Mainline U-Boot (v2020.01-rc5)

    $ cp configs/meson-gxl-s905x-libretech-cc_defconfig .config
    
   
#### Using Amlogic Vendor U-Boot (v2015.01)

    $ cp configs/meson-gxl-s905x-libretech-cc-aml-uboot_defconfig .config

In case of Amlogic Vendor U-Boot, you need to build it seperately by using the following tool.

    $ ./utils/amlogic/aml-uboot-builder/build-aml-uboot.sh


### Building the image
    
Then, you just have to enter the following command to build the full environment.

    $ make

Finally, to flash a SD card, simply use the flash-sdcard tool to burn the image onto your SD card.

    $ ./utils/flash-sdcard


### How to customize Linux Kernel version?

If you want to customize your Linux Kernel, it's easy: just type the following command.

    $ make linux-menuconfig

You will access the Kernel configuration menu. Here you can fully configure your Linux Kernel.


### How to add drivers, utilities?

If you want to add any packages, drivers or utilities, use the following command.

    $ make menuconfig

In the "Target Packages" tab, you can enable some useful packages, like gdb or openssh. Don't forget to save your new configuration by clicking on the "Save" button.
