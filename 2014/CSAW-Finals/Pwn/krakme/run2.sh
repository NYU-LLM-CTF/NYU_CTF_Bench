#!/bin/bash
MYFS=$(mktemp)
cp rootfs.ext2 $MYFS
/usr/bin/qemu-system-x86_64 -kernel kernel -hda $MYFS -boot c -m 64M -append "root=/dev/sda rw ip=10.0.2.15:10.0.2.2:10.0.2.2 console=ttyAMA0 console=ttyS0" -serial stdio  -net nic,vlan=0 -net user,vlan=0 -monitor /dev/null -nographic
rm $MYFS
# root password is EkIZafsLndgu8yGVY+tXIvURxIA=
