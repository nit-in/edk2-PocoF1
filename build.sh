#!/bin/bash
# based on the instructions from edk2-platform
set -e
. build_common.sh
# not actually GCC5; it's GCC7 on Ubuntu 18.04.
GCC5_AARCH64_PREFIX=aarch64-linux-gnu- build -s -n 0 -a AARCH64 -t GCC5 -p OnePlus5Pkg/OnePlus5Pkg.dsc
gzip -c < workspace/Build/OnePlus5Pkg/DEBUG_GCC5/FV/ONEPLUS5PKG_UEFI.fd > uefi_image
cat cheeseburger.dtb >> uefi_image
[ -e ramdisk-null ] || echo 'dummy' > ramdisk-null
abootimg --create uefi.img -k uefi_image -r ramdisk-null -f bootimg.cfg
