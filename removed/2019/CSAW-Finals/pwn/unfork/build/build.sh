#!/bin/sh
docker build -t unfork_initramfs -f Dockerfile.initramfs .
#./convert_image.sh unfork_initramfs initramfs.cpio
#gzip -f initramfs.cpio
./convert_image.sh unfork_initramfs disk.img
