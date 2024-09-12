import os
import pyshark


# Path to the PCAP file
pcap_file_path = 'chall.pcapng'

# Use TLS keys to decrypt web traffic
capture = pyshark.FileCapture(
    pcap_file_path, use_json=True, include_raw=True,
    override_prefs={'ssl.keylog_file': os.path.abspath('keys.log')})

# Initialize a list to store the IP IDs
ip_ids = []

packet_count=0

# Iterate over each packet in the capture
for packet in capture:
    packet_count += 1

    # This is the source IP of the person sending the covert IP messages
    if 'IP' in packet and packet.ip.src == '172.20.10.5' and packet.ip.dst == '172.57.57.57':
        # Append the IP ID to the list
        ip_ids.append(int(packet.ip.id, 16))


capture.close()

key = 55
flag = ""
# Decode and append each ascii character
for id in ip_ids:
    flag+=chr(id//55)

print("Flag:", flag)