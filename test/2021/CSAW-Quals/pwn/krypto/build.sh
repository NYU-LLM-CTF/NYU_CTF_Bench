#!/bin/sh

cd build

# cleanup any remnants
vagrant destroy -f

for img in dist real; do
    rm -f flag
    cp flag.${img} flag
    vagrant up --provider libvirt
    vagrant halt

    # Flatten onto a new disk.${img}.img
    sudo cp /var/lib/libvirt/images/generic-VAGRANTSLASH-ubuntu2004_vagrant_box_image_3.4.2.img disk.${img}.img
    sudo qemu-img rebase -b $(pwd)/disk.${img}.img /var/lib/libvirt/images/build_default.img
    sudo qemu-img commit /var/lib/libvirt/images/build_default.img
    sudo chown ${USER}:${USER} disk.${img}.img
    chmod 644 disk.${img}.img

    vagrant destroy -f
done

rm -f flag
