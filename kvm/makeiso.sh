#!/bin/sh
INITIAL_ISO=/home/bobbytables/isos/debian-11.5.0-amd64-DVD-1.iso
PRESEED_ISO=/home/bobbytables/isos/debian-pan-dev.iso
if [ -d ./isofiles ]; then
	sudo rm -rf ./isofiles
fi
mkdir ./isofiles
xorriso -osirrox on -indev $INITIAL_ISO -extract / isofiles/
chmod +w -R isofiles/install.amd/
gunzip isofiles/install.amd/initrd.gz
echo preseed.cfg |cpio -H newc -o -A -F isofiles/install.amd/initrd
gzip isofiles/install.amd/initrd
chmod -w -R isofiles/install.amd/
cd isofiles/
chmod a+w md5sum.txt
md5sum `find -follow -type f ` > md5sum.txt
chmod a-w md5sum.txt
cd ..
chmod a+w isofiles/isolinux/isolinux.bin
genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $PRESEED_ISO isofiles

cp $PRESEED_ISO /kvm-nvme/
sudo rm -rf ./isofiles

