cd $APP_ROOT/livecdtmp/

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
echo "Now make customizations from the CLI"
echo "If you want to replace the desktop wallpaper, use the instructions related to your window manager. You may have to replace the image somewhere under /usr/share"
echo "If you need to copy in new files to the ISO, use another terminal to copy to remaster/livecdtmp/extract-cd/ as root"
echo "To use apt-get properly, you may have to copy from your /etc/apt/sources.list to this ISO, then run apt-get update and finally resolvconf -u to connect to the internet"
echo "When you are done, just type 'exit' to continue the process"
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
