#!/bin/bash

full_path=$(realpath $0)
dir_path=$(dirname $full_path)

cd ${dir_path}

set -x

echo "Cleaning binaries..."

rm -r ${dir_path}/aml-uboot/fip

echo "Cleaning toolchains..."

rm -r ${dir_path}/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux
rm -r ${dir_path}/gcc-linaro-arm-none-eabi-4.8-2013.11_linux

rm *.xz

echo "Cleaning Amlogic U-Boot repo..."

rm -rf ${dir_path}/aml-uboot

echo "Done."