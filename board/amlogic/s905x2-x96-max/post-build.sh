#!/bin/sh

#BOARD_DIR="$(dirname $0)"
#MKIMAGE=$HOST_DIR/bin/mkimage

#$MKIMAGE -C none -A arm64 -T script -d $BOARD_DIR/boot.txt $BINARIES_DIR/boot.scr

# vendor u-boot uses uImage
#if [ -e $BINARIES_DIR/Image ]; then
#    $MKIMAGE -A arm64 -O linux -T kernel -C none -a 0x1080000 -e 0x1080000 \
#	     -n linux -d $BINARIES_DIR/Image $BINARIES_DIR/uImage
# fi

#!/bin/sh

BOARD_DIR="$(dirname $0)"
MKIMAGE=utils/amlogic/binaries/mkimage

# for Amlogic U-Boot
if [ "$2" = "emmc" ] 
then
    # for eMMC
    echo "INFO: eMMC aml_autoscript"
    $MKIMAGE -C none -A arm64 -T script -d $BOARD_DIR/boot_from_emmc.cmd $BINARIES_DIR/boot.scr

    $MKIMAGE -C none -A arm64 -T script -d $BOARD_DIR/boot_from_emmc.cmd $BINARIES_DIR/aml_autoscript
else
    # for SD card
    echo "INFO: SD CARD aml_autoscript"
    $MKIMAGE -C none -A arm64 -T script -d $BOARD_DIR/boot_from_sdcard.cmd $BINARIES_DIR/boot.scr

    $MKIMAGE -C none -A arm64 -T script -d $BOARD_DIR/boot_from_sdcard.cmd $BINARIES_DIR/aml_autoscript
fi

# move dtb in amlogic subdir
# mkdir ${BINARIES_DIR}/amlogic
# mv ${BINARIES_DIR}/"meson-gxbb-nexbox-a95x.dtb" ${BINARIES_DIR}/amlogic