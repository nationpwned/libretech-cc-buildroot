#!/bin/sh

my_vendor_id=0x19CF
my_product_id=0x104

my_vendor_id_string="Future MPP4 @ Mathieu"
my_product_id_string="Hello world!"

echo "-----------------------------------------------"
echo "  Installing Role Switch Perf Tool"
echo "-----------------------------------------------"

echo "Mounting debugfs in /d..."

mkdir -p /d
mount -t debugfs none /d

echo "Mounting configfs in /sys/kernel/config..."

mount -t configfs none /sys/kernel/config

echo "Setting USB OTG to device mode..."

echo "device" > /sys/class/usb_role/ffe09000.usb-role-switch/role

echo "OK. Waiting 5s..."

sleep 5

echo "Creating USB gadget..."

# go to configfs directory for USB gadgets
CONFIGFS_ROOT=/sys/kernel/config # adapt to your machine
cd "${CONFIGFS_ROOT}"/usb_gadget

# create gadget directory and enter it
mkdir g1
cd g1

echo "USB will have ID [" ${my_vendor_id} ":" ${my_product_id} "]"

# USB ids
echo ${my_vendor_id} > idVendor
echo ${my_product_id} > idProduct

echo "Creating strings for vendorId and productId..."

# USB strings, optional
mkdir strings/0x409 # US English, others rarely seen
echo ${my_vendor_id_string} > strings/0x409/manufacturer
echo ${my_product_id_string} > strings/0x409/product

echo "Creating configuration..."

# create the (only) configuration
mkdir configs/c.1 # dot and number mandatory

# create the (only) function
mkdir functions/ecm.usb0 # .

# assign function to configuration
ln -s functions/ecm.usb0/ configs/c.1/


MY_UDC=$(ls /sys/class/udc)

#read -p 'Select your UDC=' MY_UDC

echo "Binding..."

echo ${MY_UDC} > UDC # ls /sys/class/udc to see available UDCs

echo "-----------------------------------------------"
echo "  Done."
echo "-----------------------------------------------"
