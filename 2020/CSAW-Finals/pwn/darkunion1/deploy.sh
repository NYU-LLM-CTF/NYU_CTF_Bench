#!/bin/bash
rm -rf handout
mkdir handout
cp -r bzImage libcap.patch ramdisk.img run.sh whitelist/ pow.c pow solve handout
cp flag.public.img handout/flag.img
rm -f handout.tar.gz
tar -acf handout.tar.gz handout/
