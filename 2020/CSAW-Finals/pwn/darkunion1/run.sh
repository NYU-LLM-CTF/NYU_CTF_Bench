#!/bin/bash -e

set -e

if [ "$2" == 'run' ]; then
  ulimit -t 100

  if [ "$1" == "-d" ]; then
    echo '[+] Running in Debug-mode'
    QEMU_FLAGS="-s -S"
    APPEND_FLAGS="debug"
  elif [ "$1" == "-l" ]; then
    echo '[+] Running in Local-mode'
    QEMU_FLAGS=
    APPEND_FLAGS="debug"
  elif [ "$1" == "-n" ]; then
    echo '[+] Running in Normal-mode'
    APPEND_FLAGS="loglevel=3 oops=panic panic=1"
    QEMU_FLAGS="-monitor none"
  else
    cat <<EOF
Usage: $0 {-n|-d|-l}

Runs the qemu box. You must choose a mode to run in. Note that when you run this
locally, we will set the interrupt control to '^]' so that you don't
accidentally kill qemu with '^C' (and so that you can kill processes inside
qemu).

  -n    Normal mode: this is what remote is gonna run as
  -l    Local mode: run qemu box as root for ease of testing. Also allows you to
        enable qemu monitoring (not that it would be much use)
  -d    Debug mode:  run qemu box as root, AND enables a gdbserver endpoint on
        port 1234.
EOF
    exit 1
  fi

  timeout --foreground 600 qemu-system-x86_64 -kernel bzImage \
    -smp 2 \
    -cpu max,+smap,+smep,check \
    -append "root=/dev/ram0 console=ttyS0 $APPEND_FLAGS" \
    -nographic -m 100M \
    -initrd ramdisk.img \
    -drive format=raw,media=cdrom,readonly,file=flag.img \
    $QEMU_FLAGS
  # flag.img is actually just a ext4 fs image file. cdrom allows us to make it
  # readonly
else
  stty intr '^]' # So that you don't accidentally kill qemu
  "$0" "$1" run || true
  stty sane
  stty intr ^C # Reset to sane interrupt
fi

