#!/bin/bash

python3 gen_table.py > table-inc.h
python3 gen_flagcmp.py > flag-inc.h

gcc tablez.c -o tablez
