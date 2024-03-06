from pwn import *
from Crypto.Util.number import bytes_to_long, long_to_bytes
from math import gcd

card_value_dict = {0: "Zero", 1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine", 10: "Ten", 11: "Jack", 12: "Queen", 13: "King", 14: "Ace", 15: "Joker"}
card_rank_dict = {"Zero": 0, "One": 1, "Two": 2, "Three": 3, "Four": 4, "Five": 5, "Six": 6, "Seven": 7, "Eight": 8, "Nine": 9, "Ten": 10, "Jack": 11, "Queen": 12, "King": 13, "Ace": 14, "Joker": 15}

class PRNG:
	def __init__(self, seed):
		self.seed = seed
		self.state = [self.seed]
		self.index = 64
		for i in range(63):
			self.state.append((3 * (self.state[i] ^ (self.state[i-1] >> 4)) + i+1)%64)
	
	def __str__(self):
		return f"{self.state}"
	
	def getnum(self):
		if self.index >= 64:
			for i in range(64):
				y = (self.state[i] & 0x20) + (self.state[(i+1)%64] & 0x1f)
				val = y >> 1
				val = val ^ self.state[(i+42)%64]
				if y & 1:
					val = val ^ 37
				self.state[i] = val
			self.index = 0
		seed = self.state[self.index]
		self.index += 1
		return (seed*15 + 17)%(2**6)

class Card:
	def __init__(self, suit, rank):
		self.suit = suit
		self.value = card_value_dict[rank]
		self.rank = rank
	
	def __str__(self):
		return f"{self.value} of {self.suit}"

og_deck = []
for suit in ["Spades", "Hearts", "Diamonds", "Clubs"]:
	for i in range(16):
		og_deck.append(str(Card(suit, i)))
server = process(['python3','server.py'])
#server = remote("localhost",5000)
server.recvline()
server.recvline()
p, q = [int(x) for x in server.recvline().split(b' --> ')[1].decode().split(',')]
N = p*q
phi = (p-1)*(q-1)
server.recvline()
server.sendline(b'1')
server.recvline()
server.recvline()
server.sendline(b'1')
print(p,q)

server.recvline()
print(server.recvline().decode(),end="")
og_enc_deck = eval(server.recvline().split(b' --> ')[1].decode())
enc_deck_dict = {}
server.recvline()
for card in og_enc_deck:
	server.recvuntil(b'>> ')
	server.sendline(str(card).encode())
	if card not in enc_deck_dict:
		enc_deck_dict[card] = None
	else:
		print(card)
computer_hand = server.recvline().decode().split(' is ')[1].split('\t-->\t')[0].split(', ')
print(computer_hand)
for i in range(len(computer_hand)):
	enc_deck_dict[og_enc_deck[i]] = [computer_hand[i], i, og_deck.index(computer_hand[i])]
player_hand = server.recvline().decode().split(' is ')[1].split('\t-->\t')[0].split(', ')
print(player_hand)
for i in range(len(player_hand)):
	enc_deck_dict[og_enc_deck[i+5]] = [player_hand[i], i+5, og_deck.index(player_hand[i])]
print(server.recvline().decode(),end="")

enc_index = []
proper_index = []
for key,value in enc_deck_dict.items():
	if value is not None:
		enc_index.append(value[1])
		proper_index.append(value[2])
possible_random_values = []
for i in range(len(enc_index)):
	if enc_index[i] == proper_index[i]: # checking for case 2 of shuffling
		possible_random_values.append([enc_index[i]]+proper_index[:i])
	elif enc_index[i] in proper_index[:i]: # checking for case 3 of shuffling
		possible_random_values.append([proper_index[i]]+proper_index[:i])
	else: # only case 1 of shuffling possible
		possible_random_values.append([proper_index[i]])
possible_seeds = []
for x in range(2**10):
	rng = PRNG(x)
	if rng.getnum() in possible_random_values[0]:
		possible_seeds.append(x)
for seed in possible_seeds:
	rng = PRNG(seed)
	for _ in range(64):
		num = rng.getnum()
	computer_e, computer_d = -1, 0
	while computer_e < 2 or computer_d < 1:
		e_array = []
		for _ in range(6):
			e_array.append(str(rng.getnum()))
		computer_e = int(''.join(e_array))
		if gcd(computer_e, phi) == 1:
			computer_d = pow(computer_e,-1,phi)
	found_value = True
	for x in og_enc_deck:
		try:
			card = long_to_bytes(pow(x,computer_d,N)).decode()
			if card not in og_deck:
				found_value = False
				break
		except UnicodeDecodeError:
			found_value = False
			break
	if found_value:
		print('\nFigured out the public and private key of the computer!\n')
		print(computer_e, computer_d)
		print()
		break

streak = 0
while streak < 9:
	server.recvline()
	data = server.recvline().decode()
	print(data,end="")
	streak = int(data.split('*'*10)[1].split(' ')[-2])
	server.recvline()
	for card in og_deck:
		server.recvuntil(b'>> ')
		server.sendline(str(pow(bytes_to_long(card.encode()),computer_e,N)).encode())
	computer_hand = server.recvline().decode().split(' is ')[1].split('\t-->\t')[0].split(', ')
	print(computer_hand)
	player_hand = server.recvline().decode().split(' is ')[1].split('\t-->\t')[0].split(', ')
	print(player_hand)
	print(server.recvline().decode(),end="")

print(server.recvline().decode(),end="")
print(server.recvline().decode(),end="")
enc_flag = eval(server.recvline().decode())
print(enc_flag)
print(f"The flag is {long_to_bytes(pow(bytes_to_long(enc_flag),computer_d,N)).decode()}")
server.close()