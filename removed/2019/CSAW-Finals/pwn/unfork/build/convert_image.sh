#!/bin/bash
# This script converts the given docker image into a initrd that kernels can
# boot into.
set -ueo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 DOCKER_IMAGE INITRD_PATH"
    exit 1
fi

DOCKER_IMAGE=$1
INITRD_PATH=$2

SCRIPTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TMPDIR=$(mktemp -d)

dd if=/dev/null of=${INITRD_PATH} bs=1M seek=80
mkfs.ext4 -F ${INITRD_PATH}
mount -t ext4 -o loop ${INITRD_PATH} ${TMPDIR}

docker create --name=img-conversion "${DOCKER_IMAGE}" 2>&1 > /dev/null
docker export img-conversion | tar -C "${TMPDIR}" -xf -
docker rm img-conversion 2>&1 > /dev/null

rm -f "${TMPDIR}/dev/console"

umount ${TMPDIR}

# { cd "${TMPDIR}" && find . -print0 | cpio --null -ov --format=newc; } > ${INITRD_PATH} 2>/dev/null

rm -rf "${TMPDIR}"
