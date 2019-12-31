#!/bin/sh

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# set -x

rm -rf "${GENIMAGE_TMP}"

# generate image

genimage                               \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

# merge bootloaders

AML_BIN_DIR=utils/amlogic/u-boot
AML_UBOOT_BINARIES=utils/amlogic/aml-uboot-builder/aml-uboot/fip
OUTPUT_BIN_DIR=${BINARIES_DIR}/tmp
BOARD_DIR=board/amlogic/s905x-libretech-cc

mkdir ${OUTPUT_BIN_DIR}
rm ${OUTPUT_BIN_DIR}/*

set -e

##########################################
# 	Mainline U-Boot (build by Buildroot)
##########################################
if [ "$2" = "mainline_uboot" ]
then 

	echo "========================================================================"
	echo "INFO: U-Boot used: <mainline> (build by Buildroot)"
	echo "========================================================================"

	cp ${AML_BIN_DIR}/gxl/bl2.bin   ${OUTPUT_BIN_DIR}/;
	cp ${AML_BIN_DIR}/gxl/acs.bin   ${OUTPUT_BIN_DIR}/;
	cp ${AML_BIN_DIR}/gxl/bl21.bin  ${OUTPUT_BIN_DIR}/;
	cp ${AML_BIN_DIR}/gxl/bl30.bin  ${OUTPUT_BIN_DIR}/;
	cp ${AML_BIN_DIR}/gxl/bl301.bin ${OUTPUT_BIN_DIR}/;
	cp ${AML_BIN_DIR}/gxl/bl31.img  ${OUTPUT_BIN_DIR}/;
	cp ${BINARIES_DIR}/u-boot.bin   ${OUTPUT_BIN_DIR}/bl33.bin

	${AML_BIN_DIR}/blx_fix.sh						\
				${OUTPUT_BIN_DIR}/bl30.bin 			\
				${OUTPUT_BIN_DIR}/zero_tmp 			\
				${OUTPUT_BIN_DIR}/bl30_zero.bin 		\
				${OUTPUT_BIN_DIR}/bl301.bin 			\
				${OUTPUT_BIN_DIR}/bl301_zero.bin 		\
				${OUTPUT_BIN_DIR}/bl30_new.bin			\
				bl30

	python ${AML_BIN_DIR}/acs_tool.pyc 					\
				${OUTPUT_BIN_DIR}/bl2.bin 				\
				${OUTPUT_BIN_DIR}/bl2_acs.bin 			\
				${OUTPUT_BIN_DIR}/acs.bin 				\
				0

	${AML_BIN_DIR}/blx_fix.sh 						\
				${OUTPUT_BIN_DIR}/bl2_acs.bin 			\
				${OUTPUT_BIN_DIR}/zero_tmp 			\
				${OUTPUT_BIN_DIR}/bl2_zero.bin 			\
				${OUTPUT_BIN_DIR}/bl21.bin 			\
				${OUTPUT_BIN_DIR}/bl21_zero.bin 		\
				${OUTPUT_BIN_DIR}/bl2_new.bin 			\
				bl2

	# encrypt bootloader

	${AML_BIN_DIR}/gxl/aml_encrypt_gxl					\
				--bl3enc					\
				--input ${OUTPUT_BIN_DIR}/bl30_new.bin

	${AML_BIN_DIR}/gxl/aml_encrypt_gxl					\
				--bl3enc 					\
				--input ${OUTPUT_BIN_DIR}/bl31.img

	${AML_BIN_DIR}/gxl/aml_encrypt_gxl					\
				--bl3enc 					\
				--input ${OUTPUT_BIN_DIR}/bl33.bin

	${AML_BIN_DIR}/gxl/aml_encrypt_gxl					\
				--bl2sig 					\
				--input ${OUTPUT_BIN_DIR}/bl2_new.bin 		\
				--output ${OUTPUT_BIN_DIR}/bl2.n.bin.sig

	${AML_BIN_DIR}/gxl/aml_encrypt_gxl					\
				--bootmk 					\
				--output ${OUTPUT_BIN_DIR}/u-boot.bin 		\
				--bl2    ${OUTPUT_BIN_DIR}/bl2.n.bin.sig 	\
				--bl30   ${OUTPUT_BIN_DIR}/bl30_new.bin.enc 	\
				--bl31   ${OUTPUT_BIN_DIR}/bl31.img.enc		\
				--bl33   ${OUTPUT_BIN_DIR}/bl33.bin.enc

	cp ${OUTPUT_BIN_DIR}/u-boot.bin.* ${BINARIES_DIR}/

##########################################
# 	Amlogic VENDOR U-Boot
##########################################
elif [ "$2" = "aml_uboot" ]
then

	echo "========================================================================"
	echo "	INFO: U-Boot used: <vendor> (must be built before)"
	echo "========================================================================"

	if [ ! -f ${AML_UBOOT_BINARIES}/u-boot.bin ]
	then
	
		echo "	ERR: Unable to find Amlogic U-Boot binaries."
		echo "	Build them by calling the following script:"
		echo "	$ ./utils/amlogic/aml-uboot-builder/build-aml-uboot.sh"

	fi

	cp ${AML_UBOOT_BINARIES}/u-boot.bin.* ${BINARIES_DIR}/

	echo "Amlogic U-Boot binaries found."

else # ??? error

echo "========================================================================"
echo "	ERROR <post-image.sh>: unknown parameter: " $2
echo "========================================================================"

exit

fi

echo "Adding bootloader to SD card image..."

dd if=${BINARIES_DIR}/u-boot.bin.sd.bin of="${BINARIES_DIR}/sdcard.img" conv=fsync,notrunc bs=1 count=442 status=progress
dd if=${BINARIES_DIR}/u-boot.bin.sd.bin of="${BINARIES_DIR}/sdcard.img" conv=fsync,notrunc bs=512 skip=1 seek=1 status=progress

# flash u-boot directly on sd card <temp>

echo "========================================================================"
echo "	Done. Please run $ ./utils/flash-sdcard to flash image "
echo "========================================================================"

# sudo dd if=${BINARIES_DIR}/u-boot.bin.sd.bin of=/dev/sda conv=fsync bs=1 count=442
# sudo dd if=${BINARIES_DIR}/u-boot.bin.sd.bin of=/dev/sda conv=fsync bs=512 skip=1 seek=1
