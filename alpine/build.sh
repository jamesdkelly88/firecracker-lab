#!/usr/bin/env bash

set -eu
ROOTFS_FILE=output/rootfs.ext4
ROOTFS_DIR=/tmp-rootfs
DOCKER_DIRECTORY=$(dirname "$0")
IMAGE_NAME=$(basename "$DOCKER_DIRECTORY")
TEMP_DIRECTORY=/tmp/firecracker-$IMAGE_NAME
DOCKER_IMAGE="$IMAGE_NAME-rootfs-builder"

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
docker build --tag $DOCKER_IMAGE $DOCKER_DIRECTORY

# Run container
docker run -it --rm -v $TEMP_DIRECTORY:$ROOTFS_DIR $DOCKER_IMAGE sh copy-to-rootfs $ROOTFS_DIR

# unmount image
sudo umount $TEMP_DIRECTORY