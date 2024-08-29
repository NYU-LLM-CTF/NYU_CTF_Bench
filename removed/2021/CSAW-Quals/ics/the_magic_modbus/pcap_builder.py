from scapy.all import *
from scapy.all import ShortField, ByteField, XByteField, XShortField, BitFieldLenField, FieldListField
from scapy.contrib import modbus
import argparse 
import random
from time import sleep
from multiprocessing.pool import ThreadPool

parser = argparse.ArgumentParser()
# parser.add_argument('file', help="Path to pcap file")

args = parser.parse_args()

SERVER_IP = '192.168.0.2'
CLIENT_IPS = [
    '192.168.0.100',
    '192.168.0.101',
    '192.168.0.102',
    '192.168.0.103',
    '192.168.0.104',
    '192.168.0.105',
]

class ModbusTCP(Packet):
    name = 'ModbusADU'
    fields_desc = [
        ShortField("transId", 0),
        ShortField("protoId", 0),
        ShortField("len", 0),
        ByteField("unitId", 0)
    ]

class ModbusQuery(Packet):    
    name = 'Read Holding Registers'
    fields_desc = [
        XByteField("funcCode", 3),
        XShortField("startAddr", 0),
        XShortField("quantity",1)
    ]

class ModbusResponse(Packet):    
    name = 'Read Holding Registers Response'
    fields_desc = [
        XByteField("funcCode", 3),
        BitFieldLenField("byteCount", 0, 8, count_of="registerVal"),
        FieldListField("registerVal",[0], ShortField('Some test', 0), count_from = lambda pkt: pkt.byteCount / 2)
    ]

def generate_traffic(source, destination, message=None, interval=1):
    src_port = random.randint(1000, 4000)
    seq_num = random.randint(5000, 2937825661)
    ack_num = random.randint(5000, 120046286)

    
    # Change this to work with intevals
    for ctr, ltr in enumerate(message):
        if ctr == 0:
            flags = 'S'
        else:
            flags = 'PA'

        query_ip_layer = IP(dst=destination, src=source)
        query_tcp_layer = TCP(dport=502,sport=src_port, flags=flags, seq=seq_num, ack=ack_num)
        query_modbus_layer = ModbusTCP()
        query_modbus_layer.setfieldval('transId', 1000)     # TODO: Generate actual transaction IDs
        query_modbus_layer.setfieldval('len', 6)            # Requests are always 6 bytes long
        query_modbus_layer.setfieldval('unitId', 100)       # Represents the client ID and should remain static across a session

        query_modbus_data_layer = ModbusQuery()
        query_modbus_data_layer.setfieldval('startAddr', ctr)       # Starting address of register(s) we want to query
        query_modbus_data_layer.setfieldval('quantity', interval)   # Number of registers to query

        query_packet = query_ip_layer/query_tcp_layer/query_modbus_layer/query_modbus_data_layer
        print(query_packet.show())
        send(query_packet)

        resp_ip_layer, resp_tcp_layer = respond_to_pkt(query_packet)
        resp_modbus_layer = ModbusTCP()
        resp_modbus_layer.setfieldval('transId', 1000)     # TODO: Generate actual transaction IDs
        resp_modbus_layer.setfieldval('unitId', 100)       # Represents the client ID and should remain static across a session

        sleep(random.randint(0, 1))
        
        resp_modbus_data_layer = ModbusResponse()
        if query_packet.haslayer('Read Holding Registers'):
            startAddr = query_packet['ModbusADU'].startAddr
            quantity  = query_packet['Read Holding Registers'].quantity
            resp_modbus_data_layer.setfieldval('byteCount', 2 * quantity)
            len_val = 3 + (quantity * 2)
            resp_modbus_layer.setfieldval('len', len_val)

            if startAddr == ctr:
                reg_vals = ord(ltr) * quantity
            resp_modbus_data_layer.setfieldval('registerVal', reg_vals)

            resp_packet = resp_ip_layer/resp_tcp_layer/resp_modbus_layer/resp_modbus_data_layer
            print(resp_packet.show())
            send(resp_packet)

            # Setup Seq/Ack nums for next packet
            ack_num = resp_packet['TCP'].seq + (len(resp_packet['TCP']) - 20)
            seq_num = resp_packet['TCP'].ack
                    

def respond_to_pkt(incoming_pkt):
    ip_layer = IP(dst=incoming_pkt['IP'].src, src=incoming_pkt['IP'].dst)
    tcp_layer = TCP(
        dport = incoming_pkt['TCP'].sport, 
        sport = incoming_pkt['TCP'].dport,
        ack   = incoming_pkt['TCP'].seq + (len(incoming_pkt['TCP']) - 20),
        seq   = incoming_pkt['TCP'].ack,
        flags = 'PA'
    )

    return ip_layer, tcp_layer

if __name__ == "__main__":
    # source ip, dest ip, message
    args = [
        ("192.168.13.100", "192.168.13.129", "OK Bus, do your stuff!"),
        ("192.168.13.101", "192.168.13.124", "flag{Ms_Fr1ZZL3_W0ULD_b3_s0_Pr0UD}"),
        ("192.168.13.102", "192.168.13.127", "If you keep asking questions, you'll keep getting answers!")
    ]

    pool = ThreadPool()
    pool.starmap(generate_traffic, args)
    pool.close()
    pool.join()

    print("All packets sent")
