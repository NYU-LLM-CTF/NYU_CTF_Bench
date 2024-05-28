from scapy.all import *
from scapy.contrib import modbus
import argparse 

parser = argparse.ArgumentParser()
parser.add_argument('file', help="Path to pcap file")

args = parser.parse_args()


if __name__ == "__main__":
    packets = rdpcap(args.file)
    msgs = {}

    for p in packets:
        print(p.show2())
        print(p['IP'].src)
        print(p['IP'].dst)
        print(len(p['TCP']))

        # Check to see if this is a Modbus Read Registers Query (FuncCode 3)
        if p.haslayer('Read Holding Registers'):
            print(p['ModbusADU'].funcCode)
            print(p['ModbusADU'].startAddr)
            print(p['ModbusADU'].quantity)
        # Check to see if this is a Modbus Read Registers Response
        elif p.haslayer('Read Holding Registers Response'):
            key = p['IP'].src + p['IP'].dst
            if key not in msgs:
                msgs[key] = []

            print(p['ModbusADU'].transId)
            print(p['ModbusADU'].byteCount)
            print(p['ModbusADU'].registerVal)
            for r in p['ModbusADU'].registerVal:
                msgs[key].append(chr(r))

    print("\nMessages:")
    for msg in msgs.values():
        print(''.join(msg))
