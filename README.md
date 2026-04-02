# Firecracker Lab

Repository containing automated build scripts for Firecracker Micro-VMs, utilising Docker containers to build kernel and root filesystem images.

## Downloading a Kernel

- Get Firecracker version (`firecracker --version`)
- Get list of CI kernels ([v.1.13 example](http://spec.ccfc.min.s3.amazonaws.com/?prefix=firecracker-ci/v1.13/x86_64/vmlinux-&list-type=2))
- Download latest to `vmlinux.bin` ([v6.1.141 example](http://spec.ccfc.min.s3.amazonaws.com/firecracker-ci/v1.13/x86_64/vmlinux-6.1.141))

<!-- TODO: bash script to get firecracker version and download major kernels for it -->

## Building a Filesystem

[Alpine](https://hans-pistor.tech/posts/building-a-rootfs-for-firecracker/)

TODO: 
- read-only with overlay
- dhcp on eth0

## Running a VM

TBC