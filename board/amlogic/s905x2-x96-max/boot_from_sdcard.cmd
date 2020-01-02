mmc dev 0
setenv fdtaddr 0x1ffe7000
setenv loadaddr 0x1080000
setenv devtype "mmc"
setenv devnum "0:1"
setenv fdtfile "amlogic/meson-g12a-x96-max.dtb"
setenv bootargs console=ttyAML0 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait console=ttyAML0,115200 no_console_suspend earlyprintf
fatload ${devtype} ${devnum} ${fdtaddr} ${fdtfile}
fatload ${devtype} ${devnum} ${loadaddr} image
booti ${loadaddr} - ${fdtaddr}




1fffc000

1ffe7000