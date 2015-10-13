# Step 1:
# Make a parent directory for our Live USB
mkdir -p $APP_ROOT/livecdtmp
cd $APP_ROOT/livecdtmp

if [[ -f "../$ORIGINAL_ISO_NAME" ]]; then
    ORIGINAL_ISO_NAME="../$ORIGINAL_ISO_NAME"
elif [[ ! -f "$ORIGINAL_ISO_NAME" ]]; then
    echo "$PWD/$ORIGINAL_FILE_NAME cannot be found. Please specify its full path with the --iniso parameter." >&2
    exit 2
fi

# Step 2:
mkdir -p mnt
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
