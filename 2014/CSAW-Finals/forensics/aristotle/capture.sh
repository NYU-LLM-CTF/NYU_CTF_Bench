#!/bin/bash
sudo discoveryutil udnsflushcaches
sudo discoveryutil mdnsflushcache
#sudo tcpdump -i en0 -s0 -w dns-and-plato.pcap 'port 53 or port 5004'
#sudo tcpdump -i en0 -s0 -w dns-and-plato.pcap 'port 53 or port 8005'
