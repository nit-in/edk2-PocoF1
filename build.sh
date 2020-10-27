#!/bin/bash
# based on the instructions from edk2-platform
set -e
. build_common.sh
# not actually GCC5; it's GCC7 on Ubuntu 18.04.
GCC5_AARCH64_PREFIX=cross-aarch64-linux-gnu- build -s -n 0 -a AARCH64 -t GCC5 -p PocoF1Pkg/PocoF1Pkg.dsc
gzip -c < workspace/Build/PocoF1Pkg/DEBUG_GCC5/FV/POCOF1PKG_UEFI.fd > uefi_image
cat beryllium.dtb >> uefi_image
[ -e ramdisk-null ] || echo 'dummy' > ramdisk-null
abootimg --create uefi.img -k uefi_image -r ramdisk-null -f bootimg.cfg
