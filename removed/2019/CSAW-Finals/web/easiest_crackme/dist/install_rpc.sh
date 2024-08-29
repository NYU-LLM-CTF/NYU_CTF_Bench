#!/bin/bash

set -e

mkdir -p ~/.config/chromium/NativeMessagingHosts/
NHPATH=~/.config/chromium/NativeMessagingHosts/

cp -r NativeMessagingHosts/* $NHPATH/.
sed -i "s|/etc/chromium/native-messaging-hosts|$NHPATH|" $NHPATH/io.csaw.ctf.crackme_debugger.json

chmod +x $NHPATH/crackme
chmod +x $NHPATH/host.py

# Install the third flag
# gcc -o /flag3.exe flag3.c
# chmod 111 $NHPATH/flag3.exe




