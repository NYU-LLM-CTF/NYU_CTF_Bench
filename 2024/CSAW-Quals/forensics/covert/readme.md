# Challenge

> csawctf{licen$e_t0_tr@nsmit_c0vertTCP$$$}

## Description

This challenge involves steganography through the IP/TCP protocol. It is commonly referred to as "covert TCP". It involves hiding information through unused fields in either the IP or TCP headers. This could include the IP identification field (16 bits), flags field (3 bits), the TCP initial sequence number (32 bits), or the urgent pointer (16 bits).

The challenge encodes data in the IP identification field. Each single IP packet over the covert channel contains an identification number that encodes a single ASCII character.

## Tools

These will be needed to help install/solve challenge:

- Wireshark

## Installation

Upload .pcapng file to Wireshark.

## Solution

### Step 1
Use TLS keys to decrypt some of the traffic. This will reveal an important http packet containing a python scapy script. This script shows how data is being encoded over the covert channel.

### Step 2
Identify the packets containing the manipulated IP identification fields. (This should be obvious as the source/destination IPs are revealed in the script defined in step #1. Additionally the actual IP identification numbers are abnormal compared to other traffic.)

### Step 3
Make a list of all IP identification numbers. Divide each number by the pre-defined-key discovered in step #1. Convert each of these numbers to their ASCII equivalent. Once this is completed, the flag will be revealed.

```bash
./solver.py
```
