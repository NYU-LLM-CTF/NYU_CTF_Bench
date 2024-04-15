#!/bin/sh

chown root:root /home/vagrant/flag
chmod 400 /home/vagrant/flag

mv /home/vagrant/krypto.ko /lib/modules/$(uname -r)
echo 'krypto' >> /etc/modules
depmod

echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet nosmep nosmap nopti"' >> /etc/default/grub
update-grub

for grp in adm cdrom dip plugdev lxd lpadmin sambashare; do
    gpasswd -d vagrant $grp
done
rm /etc/sudoers.d/vagrant

passwd -d -l root
echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
