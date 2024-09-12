This challenge involves steganography through the IP/TCP protocol. It is commonly referred to as "covert TCP". It involves hiding information through unused fields in either the IP or TCP headers. This could include the IP identification field (16 bits), flags field (3 bits), the TCP initial sequence number (32 bits), or the urgent pointer (16 bits). 

The challenge encodes data in the IP identification field. Each single IP packet over the covert channel contains an identification number that encodes a single ASCII character. 

To solve this challenge, these steps are required:
1. Use TLS keys to decrypt some of the traffic. This will reveal an important http packet containing a python scapy script. This script shows how data is being encoded over the covert channel.
2. Identify the packets containing the manipulated IP identification fields. (This should be obvious as the source IP sending the covert messages is the same IP that accesses the script hint and looks up exfil methods.)
3. Once the covert traffic is identified, take a list of all IP identification numbers. Users must brute force the integer key to find the correct # (shouldn't take long considering the key is 55). Convert each of these numbers to their ASCII equivalent. Once this is completed, the flag will be revealed.

Flag: csawctf{licen$e_t0_tr@nsmit_c0vertTCP$$$}
