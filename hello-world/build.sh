#!/usr/bin/env bash

if ! [ -f output/vmlinux.bin ]; then
  curl -o output/vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin
fi

if ! [ -f output/rootfs.ext4 ]; then
  curl -o output/rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4
fi