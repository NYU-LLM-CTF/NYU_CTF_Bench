#!/usr/bin/env python3
import socket
import re
import random
from creditcard import luhn

s = socket.socket()
s.connect(('localhost', 8096))

# prevent duplicate cards as they want unique cards
card_database = []

def getCardOfType(card):
    with open(f'./cards/{card}.csv', 'r') as f:
        for line in f:
            card_no = line.split(',')[1]
            if card_no not in card_database:
                card_database.append(card_no)
                return card_no.strip()

def generateCardStartsWith(digits):
    digits = list(map(lambda x: int(x), list(digits)))
    length = 16 - len(digits)

    for i in range(length-1):
        digits.append(random.randint(0, 9))
    digits.append(luhn.get_check_digit(''.join(map(str, digits))))

    return ''.join(map(str, digits))

def generateCardEndsWith(digits):
    while True:
        result = luhn.generate(length=16)
        if result.endswith(str(digits)):
            return result

while True:
    data = s.recv(4096).decode().strip()
    if not data:
        continue

    print("Received:", data)

    if 'I need to know if' in data and 'is valid! (0 = No, 1 = Yes)' in data:
        card_no = re.search('I need to know if (.+) is valid!', data).group(1)
        valid = luhn.is_valid(card_no)
        print(f'Sending valid: {valid}')
        s.send(b'1\n' if valid else b'0\n')

    if 'I need a new card that starts with ' in data:
        card_startswith = re.search('I need a new card that starts with (.+)!', data).group(1)
        card_no = generateCardStartsWith(card_startswith)
        print(f'Sending starts with {card_startswith}: {card_no}')
        s.send(card_no.encode())
        s.send(b'\n')

    elif 'I need a new card which ends with ' in data:
        card_endswith = re.search('I need a new card which ends with (.+)!', data).group(1)
        card_no = generateCardEndsWith(card_endswith)
        print(f'Sending ends with {card_endswith}: {card_no}')
        s.send(card_no.encode())
        s.send(b'\n')

    elif 'I need a new' in data:
        card_type = re.search('I need a new (.+)!', data).group(1)
        card_no = getCardOfType(card_type)
        print(f'Sending {card_type}: {card_no}')
        s.send(card_no.encode())
        s.send(b'\n')

    elif 'flag' in data:
        quit()
