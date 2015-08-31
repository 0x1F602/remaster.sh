#!/bin/bash

ORIGINAL_ISO_NAME=$1
NEW_ISO_NAME=$2

echo "Installing or updating squashfs-tools"
sudo apt-get update && sudo apt-get install squashfs-tools

# Step 1:
# Make a parent directory for our Live USB
mkdir ./livecdtmp
cp $ORIGINAL_ISO_NAME ./livecdtmp
cd ./livecdtmp

# Step 2:
mkdir mnt
echo "Logging into root"
sudo su -c "echo 'SUDO Logged in'"
# Mount the ISO as a loop filesystem to ./livecdtmp/mnt
# This will allow us to look at its insides, basically
sudo mount -o loop $ORIGINAL_ISO_NAME mnt
sudo mkdir extract-cd
# Copy all the ISO's innards except for filesystem.squashfs to extract-cd/
sudo rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
# Expand the squashed filesystem and put it into ./livecdtmp/edit so we can update the squashed filesystem with our new values it needs to boot and install properly
sudo unsquashfs mnt/casper/filesystem.squashfs
sudo mv squashfs-root edit

# Step 3:
# This makes our terminal's "perspective" come from ./livecdtmp/edit/
sudo mount -o bind /run edit/run
sudo chroot edit mount -t proc none /proc
sudo chroot edit mount -t sysfs none /sys
sudo mount -o bind /dev/pts edit/dev/pts

#sudo chroot edit export HOME=/root
#sudo chroot edit export LC_ALL=C

# Step 4:
# Normally this is where you'd do your customizations.
# I recommend copying from your main system's /etc/apt/sources.list to your ISO's sources.list.
sudo echo "SUDO Now make customizations from the CLI"
sudo echo "SUDO You may have to copy from your /etc/apt/sources.list to use apt properly"
sudo chroot edit

# Step 5:
# Back out of the chroot
#sudo chroot edit umount /proc || sudo chroot edit umount -lf /proc
echo "Backing out of the chroot"
sudo chroot edit umount /proc
sudo chroot edit umount /sys
#sudo chroot edit umount /dev/pts
sudo umount mnt
sudo umount edit/run
sudo umount edit/dev/pts

# Step 6:
sudo chmod +w extract-cd/casper/filesystem.manifest
echo "chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest" | sudo sh >> ./remaster.log
sudo cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' extract-cd/casper/filesystem.manifest-desktop
sudo rm extract-cd/casper/filesystem.squashfs
sudo mksquashfs edit extract-cd/casper/filesystem.squashfs
ISO_SIZE=`sudo du -sx --block-size=1 edit | cut -f1`
echo "printf $ISO_SIZE > extract-cd/casper/filesystem.size" | sudo sh >> ./remaster.log
sudo nano extract-cd/README.diskdefines
sudo rm extract-cd/md5sum.txt
echo "find extract-cd/ -type f -print0 | xargs -0 md5sum | grep -v extract-cd/isolinux/boot.cat | tee extract-cd/md5sum.txt" | sudo sh >> ./remaster.log
IMAGE_NAME='Custom ISO'
sudo mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../$2 extract-cd/
sudo chmod 775 ../$2

echo "You can use root permissions to delete ./livecdtmp now."
