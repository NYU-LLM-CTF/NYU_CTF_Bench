# The Magic Modbus
### Overview
Modbus is a protocol which uses TCP to transmit data in ICS environments. The master/server node will query slave/client nodes about their status, which is then used to make decisions about the environment, such as turning off a compressor or opening a
valve to release pressure. 

Because of the latency requirements, this data is often unencrypted, so in this challenge I've just simulated a Server node
querying a single client using the Read Register function code. The data is sent across as decimal so competitors need
to convert the register values into ASCII.

There are a few ways to increase complexity:
- We can add additional nodes so there is more traffic making the flag harder to identify
- In the response, there is no reference to the register value, so we can shuffle the flag to make it so competitors 

---

### TODO:
- pcap_build.py to support changing transId for both query/response packets
- Export packets to a PCAP file, rather than having to capture with Wireshark

---

### September 7, 2021 Update:
- added a flag and description
- edited the PCAP builder file so that it sends multiple messages (one of which is the flag) between pairs of IPs
- edited the PCAP reader file so that it now keeps track of and prints multiple messages
- PCAP still needs to be manually captured (and optionally anonymized) with Wireshark

To install dependencies run:
```pip install -r requirements_dev.txt```

Usage:

To build the PCAP (right now this has to be captured in Wireshark):
```python3 pcap_builder.py```

To print the PCAP data and the simple flag:
```python3 pcap_reader.py <path_to_pcap>```
