#!/bin/bash
DOCKER_CONTAINER_ID="$1"
OUTPUT_DIR="libs/"

declare -a LIBS_TO_COPY=(
  "/usr/local/lib/libgnustep-base.so.1.25.0"
  "/usr/lib/x86_64-linux-gnu/libobjc.so.4.0.0"
  "/lib/x86_64-linux-gnu/libm-2.19.so"
  "/lib/x86_64-linux-gnu/libgcc_s.so.1"
  "/lib/x86_64-linux-gnu/libpthread-2.19.so"
  "/lib/x86_64-linux-gnu/libc-2.19.so"
  "/usr/lib/x86_64-linux-gnu/libxslt.so.1.1.28"
  "/usr/lib/x86_64-linux-gnu/libxml2.so.2.9.1"
  "/usr/lib/x86_64-linux-gnu/libffi.so.6.0.2"
  "/lib/x86_64-linux-gnu/librt-2.19.so"
  "/lib/x86_64-linux-gnu/libdl-2.19.so"
  "/lib/x86_64-linux-gnu/libz.so.1.2.8"
  "/usr/lib/x86_64-linux-gnu/libicui18n.so.52.1"
  "/usr/lib/x86_64-linux-gnu/libicuuc.so.52.1"
  "/usr/lib/x86_64-linux-gnu/libicudata.so.52.1"
  "/lib/x86_64-linux-gnu/ld-2.19.so"
  "/lib/x86_64-linux-gnu/liblzma.so.5.0.0"
  "/usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.20"
)

declare -a LDD_NAME=(
	"libgnustep-base.so.1.25"
	"libobjc.so.4"
	"libm.so.6"
	"libgcc_s.so.1"
	"libpthread.so.0"
	"libc.so.6"
	"libxslt.so.1"
	"libxml2.so.2"
	"libffi.so.6"
	"librt.so.1"
	"libdl.so.2"
	"libz.so.1"
	"libicui18n.so.52"
	"libicuuc.so.52"
	"libicudata.so.52"
	"ld-linux-x86-64.so.2"
	"liblzma.so.5"
	"libstdc++.so.6"
  )

cd "$OUTPUT_DIR"
for (( i=0; i<${#LIBS_TO_COPY[@]} ; i+=1 )) ; do
  lib="${LIBS_TO_COPY[i]}"
  dst="${LDD_NAME[i]}"
  echo "Copying $lib..."
  docker cp "$DOCKER_CONTAINER_ID:$lib" .
  ln -s $(basename -- $lib) "$dst"
done

