#!/usr/bin/env python3
import socket


def uart_frame_to_ascii(frame):
    """
    Parse the UART frame to ascii character.
    Returns None if needs retransmission
    """
    start_bit = frame[0]
    stop_bit = frame[-1]

    # check if frame start and stop bits are correct
    if start_bit != '0':
        return None

    if stop_bit != '1':
        return None

    char_bits_with_parity = frame[1:-1]
    parity_count = char_bits_with_parity.count('1')
    print(parity_count)
    # check even parity is correct
    if parity_count % 2 == 0:
        char_bits = char_bits_with_parity[0:-1]
        return chr(int(char_bits, 2))

    return None


s = socket.socket()
s.connect(('localhost', 8100))

flag = ''
while True:
    data = s.recv(4096).decode().strip()
    if not data:
        continue

    print("Received:", data)

    if '8-1-1 even parity' in data:
        data = data.split('\n')[1]

    character = uart_frame_to_ascii(data)
    if character is None:
        # retransmit
        print('Retransmit')
        s.send(b'0\n')
    else:
        # next char
        flag += character
        print('Success -', flag)
        s.send(b'1\n')
