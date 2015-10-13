cd $APP_ROOT/livecdtmp

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
sudo mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../$NEW_ISO_NAME extract-cd/
sudo chmod 775 ../$NEW_ISO_NAME

cd ..
isohybrid $NEW_ISO_NAME

echo "You can use root permissions to delete ./livecdtmp now."
