#!/bin/bash
for i in mystery_bois/*.o; do
    objcopy --dump-section .text=$(basename $i .o) $i
done
