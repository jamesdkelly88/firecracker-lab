#!/usr/bin/env bash

set -eu
IMAGE_NAME=$1-$2
ROOTFS_FILE=output/$IMAGE_NAME.ext4
SQUASHFS_FILE=output/$IMAGE_NAME.img
ROOTFS_DIR=/tmp/rootfs
DOCKER_FILE=$1.dockerfile
DOCKER_TAG=$2
TEMP_DIRECTORY=/tmp/firecracker-$IMAGE_NAME
DOCKER_IMAGE=firecracker-rootfs-builder:$IMAGE_NAME

echo "Building $IMAGE_NAME"

# Cleanup from previous attempt
rm -f $ROOTFS_FILE
sudo umount $TEMP_DIRECTORY || true
sudo rm -rf $TEMP_DIRECTORY

# Create output file
dd if=/dev/zero of=$ROOTFS_FILE bs=1M count=1024

# Create empty filesystem
sudo mkfs.ext4 $ROOTFS_FILE

# Create mountpoint
mkdir -p $TEMP_DIRECTORY

# Mount the filesystem
sudo mount $ROOTFS_FILE $TEMP_DIRECTORY

# Build container
docker build --tag $DOCKER_IMAGE -f $DOCKER_FILE --build-arg "VERSION_TAG=$DOCKER_TAG" .

# Run container
docker run -it --rm -v $TEMP_DIRECTORY:$ROOTFS_DIR $DOCKER_IMAGE sh copy-to-rootfs $ROOTFS_DIR

# Create necessary folders for overlayFS
sudo mkdir -p $TEMP_DIRECTORY/overlay/root $TEMP_DIRECTORY/overlay/work $TEMP_DIRECTORY/mnt $TEMP_DIRECTORY/rom

# Copy over the overlay-init script
sudo cp overlay-init $TEMP_DIRECTORY/sbin/overlay-init

# Create a SquashFS out of the old rootfs
sudo mksquashfs $TEMP_DIRECTORY $SQUASHFS_FILE -noappend

# unmount image
sudo umount $TEMP_DIRECTORY