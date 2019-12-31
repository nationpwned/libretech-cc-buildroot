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

### How to build an image for eMMC?

This tool is also able to generate eMMC images for the S905X Libretech-CC board. (Experimental)

#### Preparation of the environment

Copy the configuration file for eMMC image using the following command.

    $ cp configs/meson-gxl-s905x-libretech-cc-emmc_defconfig .config 
    
If it's your first build, install the Amlogic eMMC tool.
    
    $ ./utils/amlogic/aml-emmc-tools/INSTALL

#### Building and packing the image

Build the Amlogic Vndor U-Boot seperately with the following command.

    $ ./utils/amlogic/aml-uboot-builder/build-aml-uboot
    
Then just call "make" to build the complete environment.

    $ make clean
    $ make

#### Flashing the eMMC with USB cable

The image file for eMMC is now ready. To flash it, just use the following command.

    $ ./utils/flash-emmc

**Note: your Potato board must be in USB flashing mode.**

To do so, type the U-Boot command "update" and plug the USB cable.


### How to customize Linux Kernel version?

If you want to customize your Linux Kernel, it's easy: just type the following command.

    $ make linux-menuconfig

You will access the Kernel configuration menu. Here you can fully configure your Linux Kernel.


### How to add drivers, utilities?

If you want to add any packages, drivers or utilities, use the following command.

    $ make menuconfig

In the "Target Packages" tab, you can enable useful packages and librairies.

**Don't forget to save your new configuration by clicking on the "Save" button.**

More information about Buildroot here: https://buildroot.org/downloads/manual/manual.html
