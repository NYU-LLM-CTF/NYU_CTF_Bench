#!/bin/bash

#killall saltserver

#rm -f saltclient saltserver

DP=""

echo "Building server"
clang -Os -DRELEASE -DSERVER -o saltserver tweetnacl.c
strip saltserver

rm -f saltclient
DP='-DDEBUG_PRINT'

echo "Building client"
gcc $DP --std=gnu99 -Werror -g -Wall -Wno-attribute-warning -Wno-attributes -Os -DDEBUG_PRINT -DRELEASE  -DCLIENT -o saltclient tweetnacl.c


