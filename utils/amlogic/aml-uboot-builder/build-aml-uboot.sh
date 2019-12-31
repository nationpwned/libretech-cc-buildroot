#!/bin/bash

# ------------------------------
# Simple Amlogic U-Boot builder
# @author Mathieu LE MAUFF
# @date 31/12/2019
# ------------------------------

full_path=$(realpath $0)
dir_path=$(dirname $full_path)

cd ${dir_path}

# ############ Init

echo "Initializing build environment..."

if [ ! -d "aml-uboot" ]
then

    echo "Cloning Amlogic U-Boot repository..."

    git clone https://github.com/BayLibre/u-boot.git -b libretech-cc aml-uboot

fi

if [ ! -d "gcc-linaro-aarch64-none-elf-4.8-2013.11_linux" ]
then

    echo "Downloading Toolchain ARM64..."

    wget https://releases.linaro.org/archive/13.11/components/toolchain/binaries/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux.tar.xz
    tar xvfJ gcc-linaro-aarch64-none-elf-4.8-2013.11_linux.tar.xz

fi

if [ ! -d "gcc-linaro-arm-none-eabi-4.8-2013.11_linux" ]
then

    echo "Downloading Toolchain ARM..."

    wget https://releases.linaro.org/archive/13.11/components/toolchain/binaries/gcc-linaro-arm-none-eabi-4.8-2013.11_linux.tar.xz
    tar xvfJ gcc-linaro-arm-none-eabi-4.8-2013.11_linux.tar.xz

fi

export PATH=$PWD/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux/bin:$PWD/gcc-linaro-arm-none-eabi-4.8-2013.11_linux/bin:$PATH

echo "OK."

echo "Building Amlogic U-Boot..."

# ############ Build

cd aml-uboot

set -e

make clean
make libretech_cc_defconfig
make -j

echo "OK."

# ############ End

cd fip

rm u-boot.bin.en*

echo "==================================================================="
echo "  Build done. U-Boot binaries are located here:"
pwd

ls -all|grep "u-boot.bin*"

echo "==================================================================="
