#!/bin/bash

strings cap.pcap | grep "x=" |sed 's/.*x=\([a-f0-9]*\).*/\1/' > test.txt
xxd -r -p test.txt test.bmp
