
Attempt to create a minimal EDK2 for Xiaomi MI 6.

Based on zhuowei's port for Pixel3XL (https://github.com/Pixel3Dev/edk2-pixel3/).

## Status 

Can load GRUB2 from a fat partition on the UFS.(/firmware is tested,you can also format the useless /cust for it)  
Windows boots with original 8998 ACPI tables, but you'll need to add UseBootProcessorOnly to your BCD boot options,  
as the multi core startup haven't been taken care for now.

### Working
Continuous Display  
UFS Storage  
Vibrator  
...

### Not Working
Clocks   
...

## Building
Tested on Ubuntu 18.04.

First, clone EDK2.

```
cd ..
git clone https://github.com/tianocore/edk2.git --recursive
git clone https://github.com/tianocore/edk2-platforms.git
```

You should have all three directories side by side.

Next, install dependencies:

18.04:

```
sudo apt install build-essential uuid-dev iasl git nasm python python-pip python3-distutils gcc-aarch64-linux-gnu abootimg p7zip bsdiff
sudo pip install uefi_firmware
```

Also see [EDK2 website](https://github.com/tianocore/tianocore.github.io/wiki/Using-EDK-II-with-Native-GCC#Install_required_software_from_apt)

Then, extract the XBL binary from your device (the powerful dd will serve you), name it xbl.elf and put it to current directory.
Execute ./extract-xbl.sh to get the proprietary blobs extracted:

```
./extract-xbl.sh
```

Finally, ./build.sh.

Then fastboot boot uefi.img.

# Credits

This is based on zhuowei's [edk2-pixel3](https://github.com/Pixel3Dev/edk2-pixel3).  
SimpleFbDxe screen driver is from imbushuo's [Lumia950XLPkg](https://github.com/WOA-Project/Lumia950XLPkg).  
Special thanks to @lemon1ice, @gus33000 and @imbushuo for guidance.  
