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
OUTPUT_BIN_DIR=${BINARIES_DIR}/tmp

mkdir ${OUTPUT_BIN_DIR}

rm ${OUTPUT_BIN_DIR}/*

set -e

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

# rm -r ${OUTPUT_BIN_DIR}

# write bootloader (u-boot)

# flash u-boot on a copy of sd card <temp>

# cp ${BINARIES_DIR}/sdcard.img ${BINARIES_DIR}/sdcard2.img

# from sandbox/booloader dir
# cp ~/WORK/amlogic/sandbox/bootloader/fip/u-boot.*   ${OUTPUT_BIN_DIR}/

dd if=${BINARIES_DIR}/u-boot.bin.sd.bin of="${BINARIES_DIR}/sdcard.img" conv=fsync,notrunc bs=1 count=442
dd if=${BINARIES_DIR}/u-boot.bin.sd.bin of="${BINARIES_DIR}/sdcard.img" conv=fsync,notrunc bs=512 skip=1 seek=1

# flash u-boot directly on sd card <temp>

# sudo dd if=${BINARIES_DIR}/u-boot.bin.sd.bin of=/dev/sda conv=fsync bs=1 count=442
# sudo dd if=${BINARIES_DIR}/u-boot.bin.sd.bin of=/dev/sda conv=fsync bs=512 skip=1 seek=1