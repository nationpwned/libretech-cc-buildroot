mmc dev 1
setenv fdtaddr 0x01008000
setenv loadaddr 0x1080000

setenv devtype "mmc"
setenv devnum "1:5"

setenv fdtfile "amlogic/meson-gxl-s905x-libretech-cc.dtb"
setenv bootargs console=ttyAML0 root=/dev/mmcblk1p2 rootfstype=ext4 rootwait console=ttyAML0,115200 no_console_suspend

fatload ${devtype} ${devnum} ${fdtaddr} ${fdtfile}
fatload ${devtype} ${devnum} ${loadaddr} image

booti ${loadaddr} - ${fdtaddr}
