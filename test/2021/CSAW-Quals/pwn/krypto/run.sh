#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"

port=$(comm -23 \
<(seq "30000" "30100" | sort) \
<(ss -tan | awk '{print $4}' | cut -d':' -f2 | grep '[0-9]\{1,5\}' | sort -u) \
| shuf | head -n 1)

if [ -z "$port" ]; then
    echo "No ports available... try again later or contact the admins if this isn't the first time you're seeing this"
    exit 1
fi

echo "Starting VM... wait about 30 seconds, then SSH on port ${port} with creds vagrant:vagrant. VMs auto terminate after 10 minutes."

# TODO: timeout?

timeout -k 0 10m qemu-system-x86_64 -monitor /dev/null \
    -smp 2 \
    -m 1024 \
    -nographic -no-reboot \
    -drive file="${DIR}/disk.real.img",format=qcow2,if=virtio -snapshot \
    -device e1000,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::${port}-:22 >/dev/null 2>&1 &

qemu=$!

echo "Send any character to terminate QEMU"

read -n1
kill -9 ${qemu}
