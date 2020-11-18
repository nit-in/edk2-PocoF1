# PocoF1
Attempt to create a minimal EDK2 for Poco F1.

## Status
Need to work on
```
Error: Failed to enable MMU
```
### Working
* Nothing
* ...

### Not Working
* ...

## Building
Working on Void Linux

First, clone EDK2:
```
cd ..
for edk2 follow instructions from [here](https://github.com/tianocore/edk2)
git clone https://github.com/tianocore/edk2-platforms.git
```

You should have all three directories (`edk2`, `edk2-platforms` & `edk2-PocoF1`) side by side.

Next, install the dependencies:

Ubuntu 20.04:
```
sudo apt install build-essential uuid-dev acpica-tools git nasm python3-pip gcc-aarch64-linux-gnu abootimg p7zip-full bsdiff
sudo pip3 install uefi_firmware
```

Arch Linux:
```
sudo pacman -S --needed base-devel acpica git nasm python aarch64-linux-gnu-gcc p7zip bsdiff
yay -S --needed abootimg-git uefi-firmware-parser-git
```
Void Linux:

```
sudo xbps-install -Suvy nasm cross-aarch64-linux-gnu abootimg acpica-utils bsdiff p7zip base-devel python3-pip git libuuid libuuid-devel python-devel gcc

```

Then, extract the XBL binary from your device (the powerful `dd` will serve you), name it `xbl.elf` and place it in the current directory.

```
in_file=$(ls -lr /dev/block/by-name | echo $(grep "xbl") | cut -d " " -f 10)
dd if=$in_file of=/sdcard/xbl.elf

```
this should return the xbl block device to internal storage
(tested with terminal emulator with su)


Now execute `./extract-xbl.sh` to get the proprietary blobs extracted.  
If you just cloned this, also run `./firstrun.sh`.  
Finally, `./build.sh`.

Then `fastboot boot uefi.img`.

# Credits
This is based on fxsheep's [edk2-sagit](https://github.com/UEFI4Phone/edk2-sagit), which is based on zhuowei's [edk2-pixel3](https://github.com/Pixel3Dev/edk2-pixel3).  
SimpleFbDxe screen driver is from imbushuo's [Lumia950XLPkg](https://github.com/WOA-Project/Lumia950XLPkg).  
Special thanks to @lemon1ice, @gus33000 and @imbushuo for guidance.
