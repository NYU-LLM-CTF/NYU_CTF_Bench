from Crypto.Util.number import getPrime, bytes_to_long
import random, codecs, base64
from inputimeout import inputimeout, TimeoutOccurred

num = 5 #Number of Pokemon to send
time = 10

MORSE_CODE_DICT = { 'A':'.-', 'B':'-...',
                    'C':'-.-.', 'D':'-..', 'E':'.',
                    'F':'..-.', 'G':'--.', 'H':'....',
                    'I':'..', 'J':'.---', 'K':'-.-',
                    'L':'.-..', 'M':'--', 'N':'-.',
                    'O':'---', 'P':'.--.', 'Q':'--.-',
                    'R':'.-.', 'S':'...', 'T':'-',
                    'U':'..-', 'V':'...-', 'W':'.--',
                    'X':'-..-', 'Y':'-.--', 'Z':'--..',
                    '1':'.----', '2':'..---', '3':'...--',
                    '4':'....-', '5':'.....', '6':'-....',
                    '7':'--...', '8':'---..', '9':'----.',
                    '0':'-----', ', ':'--..--', '.':'.-.-.-',
                    '?':'..--..', '/':'-..-.', '-':'-....-',
                    '(':'-.--.', ')':'-.--.-'}

with open("flag.txt",'r') as f:
	flag = f.read()

with open("Pokemon_names.txt",'r') as f:
	data = f.read()
	pokemon = data.split('\n')[:-1]

def encryption(name):
	rot = codecs.encode(name,'rot_13')
	N = getPrime(512)*getPrime(512)
	c = pow(bytes_to_long(bytes(rot,'utf-8')),3,N)
	rsa = "N = "+str(N)+"\ne = 3\nc = "+str(c)
	message_bytes = rsa.encode('ascii')
	dec = ' '.join([str(b) for b in base64.b64encode(message_bytes)])
	enc = ''
	for letter in dec:
		if letter != ' ':
			enc += MORSE_CODE_DICT[letter] + ' '
		else:
			enc += '/'
	return enc

def main():
	print("Can you decrypt them all to prove yourself?\n")
	correct = 0
	for i in range(num+1):
		if i == 0:
			picked = "Pokemon Names"
		else: 
			index = random.randint(0,len(pokemon)-1)
			picked = pokemon[index]
		print("What does this mean?")
		print(encryption(picked))
		try:
			reply = inputimeout(prompt='>> ', timeout=time)
		except TimeoutOccurred:
			print("Oof! Not fast enough!\n")
			break
		if reply == picked:
			print("You are correct!\n")
			correct += 1
		else:
			print("You are wrong!\n")
			break
	if correct == num+1:
		print("Congrats! The GPS is activated and here's a message from your friends:",flag)
	else:
		print("Looks like things didn't work out for you! Wah, wah, wah!")

if __name__ == "__main__":
	main()
