import random

#Create randomized base stream (true_stream)
def base_stream():
	rand_stream = ''
	for _ in range(256):
		base = random.randint(0, 1)
		if base == 0:
			rand_stream += chr(120)
		else:
			rand_stream += chr(43)
	return rand_stream


#Checking challenger's stream of bases
def stream_check(true_stream):
	errs = 0
	#Enter the number of bases you'd like to check
	print("How many bases would you like to check? ")
	str_len = int(input())
	#Enter the string of bases you want be checked, no quotes
	print("Please enter your " + str(str_len) + " bases: ")
	input_str = input()
	if len(input_str) == str_len:
		for i in range(0, str_len):
			if true_stream[i] != input_str[i]:
				errs += 1
	elif len(input_str) != str_len:
		print("You have not entered " + str(str_len) + " bases. Please try again.")
	print("Errors: " + str(errs))

	if (errs == 0) and (str_len == len(true_stream)):
		#give key
		return True
	return False

#Check if arrows are correct
def get_arrows(basis, bit):
	if basis == '+':
		if bit == '1':
			print('0.0 + 1.0i')
		else: # bit == '0'
			print('1.0 + 0.0i')
	else: # basis == 'x'
		if bit == '1':
			print('-0.707 + 0.707i')
		else: # bit == '0'
			print('0.707 + 0.707i')

def main():
	our_basis = base_stream()
	with open('key.txt','r') as f:
		key = f.read()
	with open('flag.txt','r') as f:
		flag = f.read()
	while True:
		if stream_check(our_basis):
			res = ''.join(format(ord(i), '08b') for i in key)
			for i in range(256):
				get_arrows(our_basis[i], res[i])
			break
		else:
			continue
	print('What is the key?: ')
	key_input = input('')
	if key_input==key:
		print(flag)
	else:
		print('You failed Perry the Platypus! I, Heinz Doofenshmirtz, have won!!!')

if __name__ == "__main__":
	main()
