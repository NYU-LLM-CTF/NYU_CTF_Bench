from random import randint

# Define the ANSI escape sequences for bold text
bold_start = '\033[1m'
bold_end = '\033[0m'
italic_start = '\x1B[3m'
italic_end = '\x1B[0m'

flag = "csawctf{hopefu11y_+he_know1ed9e_diffu5ed_in+o_your_6r@in5}"
safer_sbox = [1,45,226,147,190,69,21,174,120,3,135,164,184,56,207,63,8,103,9,148,235,38,168,107,189,24,52,27,187,191,114,247,64,53,72,156,81,47,59,85,227,192,159,216,211,243,141,177,255,167,62,220,134,119,215,166,17,251,244,186,146,145,100,131,241,51,239,218,44,181,178,43,136,209,153,203,140,132,29,20,129,151,113,202,95,163,139,87,60,130,196,82,92,28,232,160,4,180,133,74,246,19,84,182,223,12,26,142,222,224,57,252,32,155,36,78,169,152,158,171,242,96,208,108,234,250,199,217,0,212,31,110,67,188,236,83,137,254,122,93,73,201,50,194,249,154,248,109,22,219,89,150,68,233,205,230,70,66,143,10,193,204,185,101,176,210,198,172,30,65,98,41,46,14,116,80,2,90,195,37,123,138,42,91,240,6,13,71,111,112,157,126,16,206,18,39,213,76,79,214,121,48,104,54,117,125,228,237,128,106,144,55,162,94,118,170,197,127,61,175,165,229,25,97,253,77,124,183,11,238,173,75,34,245,231,115,35,33,200,5,225,102,221,179,88,105,99,86,15,161,49,149,23,7,58,40]
aes_sbox = [
    0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
    0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
    0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
    0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
    0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
    0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
    0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
    0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
    0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
    0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
    0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
    0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
    0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
    0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
    0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
    0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16,
]
custom_sbox = [152, 158, 42, 231, 197, 251, 250, 79, 39, 1, 96, 57, 146, 137, 178, 133, 170, 32, 212, 154, 73, 97, 78, 7, 204, 218, 9, 195, 88, 149, 71, 235, 199, 247, 211, 124, 33, 0, 219, 185, 77, 2, 81, 201, 164, 224, 76, 102, 69, 198, 181, 20, 28, 210, 147, 115, 226, 180, 80, 189, 150, 46, 166, 171, 248, 37, 227, 21, 13, 63, 228, 216, 191, 143, 103, 40, 184, 121, 246, 207, 61, 26, 98, 249, 174, 156, 155, 10, 176, 44, 123, 114, 100, 240, 70, 130, 188, 104, 252, 126, 15, 131, 239, 234, 122, 229, 134, 214, 31, 8, 127, 236, 65, 208, 255, 128, 93, 190, 83, 135, 47, 183, 22, 173, 112, 241, 106, 186, 53, 49, 193, 64, 237, 36, 16, 153, 94, 92, 165, 203, 116, 144, 12, 138, 172, 177, 5, 202, 215, 56, 66, 117, 132, 142, 59, 209, 17, 11, 27, 206, 151, 111, 162, 87, 225, 161, 159, 160, 244, 108, 67, 243, 253, 196, 140, 51, 107, 113, 84, 230, 118, 34, 220, 89, 6, 68, 213, 163, 58, 141, 221, 200, 54, 23, 182, 217, 14, 24, 222, 60, 62, 110, 38, 55, 74, 129, 50, 148, 72, 167, 136, 35, 30, 109, 205, 90, 238, 29, 194, 254, 41, 187, 85, 82, 101, 119, 192, 145, 157, 125, 223, 19, 4, 175, 45, 139, 232, 18, 86, 179, 95, 245, 91, 99, 105, 48, 120, 168, 3, 43, 233, 75, 25, 242, 52, 169]

def loop_for_answer(prompt, answer):
	while True:
		print(prompt)
		ans = input("")
		if ans.lower() == answer:
			print("That's right!\n")
			break
		else:
			print("Try again!")

def intro():
	print(f"Have you ever wondered what a {bold_start}good{bold_end} cryptographic algorithm is made of and {bold_start}why{bold_end}? Well, certainly there are several mathematical properties involved. One of them is {bold_start}diffusion{bold_end}.")
	print(f"Diffusion refers to the {bold_start}dependence of ciphertext units on plaintext units{bold_end} and, for modern cryptography done in computers, the \"units\" are bits ;)\n")
	print(f"Let {italic_start}x{italic_end} be an input plaintext which we encrypt, giving us the ciphertext {italic_start}y{italic_end}.")
	print(f"Let {italic_start}x'{italic_end} be another input plaintext, which is simply {italic_start}x{italic_end} with some bit changed and all the other bits being the same, and {italic_start}y'{italic_end} be its ciphertext.")
	print(f"How {bold_start}different{bold_end} is {italic_start}y'{italic_end} from {italic_start}y{italic_end}? How does changing {bold_start}a bit of the plaintext{bold_end} influence {bold_start}the resulting ciphertext{bold_end}?")
	print("This is what diffusion is about.")
	print(f"But {bold_start}why does it matter{bold_end}?\n")

def caesar_cipher_minigame():
	passphrase = "Diffusion matters a lot"
	def caesar(text, key=randint(1,25)):
		def cipher(i, low=range(97,123), upper=range(65,91)):
			if i in low or i in upper:
				s = 65 if i in upper else 97
				i = (i - s + key) % 26 + s
			return chr(i)
		return ''.join([cipher(ord(s)) for s in text])
	answer = caesar(passphrase)
	print(f"\nCan you decrypt this? {bold_start}{answer}{bold_end}")
	print(f"Certainly at a first glance you have no clue what this could possibly be, right? However, I'm giving you the {bold_start}encryption device{bold_end}. You can play with it by encrypting your own plaintexts. I wonder if that will help you? Well, it's definitely better than nothing, right? ;)\n")
	while True:
		print("What would you like to encrypt?")
		given = input("")
		enc = caesar(given)
		print(f"Here is your encrypted text: {bold_start}{enc}{bold_end}")
		print("Would you like to continue? (yes/no)")
		ans = input("")
		if ans.lower() == "no":
			break
	print("What was the original text?")
	given = input("")
	if given == passphrase:
		print("You've decrypted it, congrats!")
		return True
	return False

def sbox_intro():
	print(f"\nHave you ever seen an {bold_start}S-Box{bold_end}? Many algorithms, including the famous {bold_start}AES{bold_end}, have one as a component.")
	print(f"{bold_start}S-Boxes{bold_end} can be implemented as integer lookup tables. The AES {bold_start}S-Box{bold_end} for example is a mapping from an 8-bit input to an 8-bit output.")
	print(f"Here's the link to see the AES S-Box as a lookup table --> {italic_start}https://github.com/AnaClaraZoppiSerpa/diffusion-studies-supporting-codes/blob/main/diffusion_analysis_code/aes_sbox_aux.py{italic_end}")
	loop_for_answer("Can you find the last entry of AES S-Box? Please give the answer in hex format with the 0x", "0x16")
	print("Looks like a random integer array, but you're about to find out that it's not...\n")

def anf_boolean():
	print(f"\nAny Boolean function can be uniquely represented by a {bold_start}multivariate polynomial{bold_end} with degree at most 1 in each variable. Each variable of the polynomial corresponds to each input of the Boolean function. For example, let {italic_start}f{italic_end} be a Boolean function with 3 input bits called {italic_start}x1{italic_end}, {italic_start}x2{italic_end}, {italic_start}x3{italic_end}. The ANF shall have 3 variables for each of them, and coefficients for each possible monomial.")
	print(f"The possible monomials are {italic_start}1{italic_end}, {italic_start}x1{italic_end}, {italic_start}x2{italic_end}, {italic_start}x3{italic_end}, {italic_start}x1*x3{italic_end}, {italic_start}x2*x3{italic_end}, {italic_start}x1*x2{italic_end} and {italic_start}x1*x2*x3{italic_end}.")
	print(f"The full ANF expression is {italic_start}f(x1,x2,x3){italic_end} = A + B{italic_start}x1{italic_end} + C{italic_start}x2{italic_end} + D{italic_start}x3{italic_end} + E{italic_start}x1*x3{italic_end} + F{italic_start}x2*x3{italic_end} + G{italic_start}x1*x2{italic_end} + H{italic_start}x1*x2*x3{italic_end}.")
	print(f"Given the truth table of a Boolean function, it is possible to extract its ANF, in other words, find out the values of the coefficients {italic_start}A,...,H{italic_end} for it.")
	print(f"The {italic_start}+{italic_end} symbol is an XOR and the {italic_start}*{italic_end} is an AND.")
	print(f"Can you use {bold_start}anf_extractor.py{bold_end} to obtain the ANF of the function given by the following truth table?")
	print("x = (x1,x2,x3) | f(x)")
	print("---------------------")
	print("000            | 0   ")
	print("001            | 1   ")
	print("010            | 0   ")
	print("011            | 0   ")
	print("100            | 0   ")
	print("101            | 1   ")
	print("110            | 1   ")
	print("111            | 1   ")
	loop_for_answer("Please give it in the exact format as outputted by the anf_extractor code that we have given you", "x3+x2*x3+x1*x2")

def vbf_intro():
	print(f"\nA Vectorial Boolean Function maps {italic_start}n{italic_end} input bits to {italic_start}m{italic_end} output bits which are called coordinates. Each coordinate is a Boolean function. Therefore we can recover the ANF of each coordinate.")
	print("Can you recover the ANFs of all coordinates of the following VBF?")
	print("x = (x1,x2,x3) | f(x)")
	print("---------------------")
	print("000            | 01  ")
	print("001            | 10  ")
	print("010            | 00  ")
	print("011            | 00  ")
	print("100            | 01  ")
	print("101            | 11  ")
	print("110            | 11  ")
	print("111            | 10  ")
	loop_for_answer("What is the answer for bit 1? Please give it in the exact format as outputted by the anf_extractor code that we have given you", "x3+x2*x3+x1*x2")
	loop_for_answer("What is the answer for bit 2? Please give it in the exact format as outputted by the anf_extractor code that we have given you", "1+x3+x2+x2*x3+x1*x3+x1*x2")

def sbox_anf():
	print(f"\nYou have just seen VBFs are a mapping of {italic_start}n{italic_end} bits to {italic_start}m{italic_end} bits.")
	print("Now... Do you remember the definition of an S-Box?")
	print(f"What happens if you think about the {bold_start}binary representation of integers{bold_end}?")
	print("An S-Box is a VBF!")
	print("Here's three S-boxes to analyze (all of them have 8 bits as input and 8 bits as output)")
	print(f"sbox1 = {safer_sbox}")
	print(f"sbox2 = {custom_sbox}")
	print(f"sbox3 = {aes_sbox}")
	loop_for_answer("What is the ANF for output bit 3 of sbox1? Please give it in the exact format as outputted by the anf_extractor code that we have given you", "x8+x7+x6+x5+x5*x6+x5*x6*x8+x5*x6*x7*x8+x4*x7+x4*x7*x8+x4*x6*x8+x4*x6*x7*x8+x4*x5*x7*x8+x4*x5*x6*x8+x3*x7+x3*x7*x8+x3*x6+x3*x6*x7+x3*x6*x7*x8+x3*x5*x7+x3*x5*x6*x8+x3*x5*x6*x7*x8+x3*x4+x3*x4*x8+x3*x4*x7+x3*x4*x7*x8+x3*x4*x6+x3*x4*x6*x7+x3*x4*x6*x7*x8+x3*x4*x5*x8+x3*x4*x5*x7*x8+x3*x4*x5*x6*x8+x3*x4*x5*x6*x7*x8+x2+x2*x8+x2*x7+x2*x7*x8+x2*x6+x2*x6*x7*x8+x2*x5*x7*x8+x2*x5*x6+x2*x5*x6*x8+x2*x4+x2*x4*x7*x8+x2*x4*x6*x7+x2*x4*x5*x8+x2*x4*x5*x6+x2*x4*x5*x6*x8+x2*x4*x5*x6*x7+x2*x3+x2*x3*x8+x2*x3*x7+x2*x3*x7*x8+x2*x3*x6*x7*x8+x2*x3*x5+x2*x3*x5*x8+x2*x3*x5*x7+x2*x3*x5*x6+x2*x3*x4+x2*x3*x4*x8+x2*x3*x4*x6*x8+x2*x3*x4*x6*x7*x8+x2*x3*x4*x5*x7+x1*x8+x1*x7+x1*x7*x8+x1*x6+x1*x6*x8+x1*x6*x7+x1*x6*x7*x8+x1*x5+x1*x5*x8+x1*x5*x7+x1*x5*x7*x8+x1*x5*x6+x1*x5*x6*x8+x1*x5*x6*x7+x1*x5*x6*x7*x8+x1*x4+x1*x4*x8+x1*x4*x7+x1*x4*x7*x8+x1*x4*x6+x1*x4*x6*x8+x1*x4*x6*x7+x1*x4*x6*x7*x8+x1*x4*x5+x1*x4*x5*x8+x1*x4*x5*x7+x1*x4*x5*x7*x8+x1*x4*x5*x6+x1*x4*x5*x6*x8+x1*x4*x5*x6*x7+x1*x4*x5*x6*x7*x8+x1*x3*x5*x8+x1*x3*x5*x7*x8+x1*x3*x5*x6*x8+x1*x3*x5*x6*x7*x8+x1*x3*x4*x5*x8+x1*x3*x4*x5*x7*x8+x1*x3*x4*x5*x6*x8+x1*x3*x4*x5*x6*x7*x8+x1*x2+x1*x2*x8+x1*x2*x7+x1*x2*x7*x8+x1*x2*x6+x1*x2*x6*x8+x1*x2*x6*x7+x1*x2*x6*x7*x8+x1*x2*x5+x1*x2*x5*x8+x1*x2*x5*x7+x1*x2*x5*x7*x8+x1*x2*x5*x6+x1*x2*x5*x6*x8+x1*x2*x5*x6*x7+x1*x2*x5*x6*x7*x8+x1*x2*x4*x5*x6*x7*x8+x1*x2*x3*x5*x8+x1*x2*x3*x5*x7*x8+x1*x2*x3*x4*x5*x6*x8")
	loop_for_answer("What input bits is output bit 3 of sbox1 dependent on? Please give the answer as x1,x2,etc. and in numerical order", "x1,x2,x3,x4,x5,x6,x7,x8")
	loop_for_answer(f"Does output bit 3 of sbox1 {bold_start}achieve complete diffusion{bold_end} with respect to the input bits? (yes/no)", "yes")
	loop_for_answer("What is the ANF for output bit 2 of sbox2? Please give it in the exact format as outputted by the anf_extractor code that we have given you", "x7*x8+x6+x6*x7*x8+x5*x7+x5*x6+x5*x6*x7+x4*x7+x4*x6*x7+x4*x6*x7*x8+x4*x5+x4*x5*x7+x4*x5*x6*x8+x4*x5*x6*x7+x3+x3*x7*x8+x3*x6*x7+x3*x5*x8+x3*x5*x7+x3*x5*x7*x8+x3*x5*x6+x3*x5*x6*x7+x3*x5*x6*x7*x8+x3*x4*x6*x8+x3*x4*x6*x7+x3*x4*x5+x3*x4*x5*x7*x8+x3*x4*x5*x6*x8+x3*x4*x5*x6*x7*x8+x2+x2*x8+x2*x7*x8+x2*x6*x8+x2*x6*x7+x2*x6*x7*x8+x2*x5+x2*x5*x8+x2*x5*x7*x8+x2*x4+x2*x4*x8+x2*x4*x6+x2*x4*x6*x8+x2*x4*x6*x7+x2*x4*x6*x7*x8+x2*x4*x5*x8+x2*x4*x5*x7*x8+x2*x4*x5*x6*x8+x2*x4*x5*x6*x7*x8+x2*x3*x7+x2*x3*x6+x2*x3*x6*x7*x8+x2*x3*x5*x8+x2*x3*x5*x6+x2*x3*x5*x6*x8+x2*x3*x5*x6*x7*x8+x2*x3*x4*x6+x2*x3*x4*x6*x7+x2*x3*x4*x5*x7+x2*x3*x4*x5*x7*x8+x2*x3*x4*x5*x6*x8+x2*x3*x4*x5*x6*x7+x1*x7+x1*x7*x8+x1*x6*x8+x1*x5+x1*x5*x7+x1*x5*x7*x8+x1*x5*x6*x7+x1*x5*x6*x7*x8+x1*x4*x7*x8+x1*x4*x6*x7+x1*x4*x5*x7+x1*x4*x5*x7*x8+x1*x4*x5*x6*x7+x1*x4*x5*x6*x7*x8+x1*x3+x1*x3*x8+x1*x3*x7+x1*x3*x7*x8+x1*x3*x6*x8+x1*x3*x5*x7+x1*x3*x5*x6+x1*x3*x5*x6*x7+x1*x3*x5*x6*x7*x8+x1*x3*x4+x1*x3*x4*x8+x1*x3*x4*x7+x1*x3*x4*x7*x8+x1*x3*x4*x6+x1*x3*x4*x6*x7*x8+x1*x3*x4*x5*x7+x1*x3*x4*x5*x6+x1*x2+x1*x2*x8+x1*x2*x7+x1*x2*x6+x1*x2*x5*x6*x7*x8+x1*x2*x4*x7*x8+x1*x2*x4*x6*x8+x1*x2*x4*x5+x1*x2*x4*x5*x7+x1*x2*x4*x5*x6+x1*x2*x4*x5*x6*x8+x1*x2*x4*x5*x6*x7+x1*x2*x4*x5*x6*x7*x8+x1*x2*x3+x1*x2*x3*x8+x1*x2*x3*x6*x7+x1*x2*x3*x5+x1*x2*x3*x5*x8+x1*x2*x3*x5*x6*x8+x1*x2*x3*x5*x6*x7+x1*x2*x3*x4*x6*x8+x1*x2*x3*x4*x5+x1*x2*x3*x4*x5*x8+x1*x2*x3*x4*x5*x7*x8+x1*x2*x3*x4*x5*x6*x8")
	loop_for_answer("What input bits is output bit 2 of sbox2 dependent on? Please give the answer as x1,x2,etc. and in numerical order", "x1,x2,x3,x4,x5,x6,x7,x8")
	loop_for_answer(f"Does output bit 2 of sbox2 {bold_start}achieve complete diffusion{bold_end} with respect to the input bits? (yes/no)", "yes")
	loop_for_answer("What is the ANF for output bit 6 of sbox3? Please give it in the exact format as outputted by the anf_extractor code that we have given you", "x8+x7+x6*x8+x5*x8+x5*x7*x8+x5*x6+x5*x6*x8+x4*x8+x4*x7+x4*x7*x8+x4*x6*x8+x4*x6*x7+x4*x5+x4*x5*x8+x4*x5*x7+x4*x5*x7*x8+x4*x5*x6+x4*x5*x6*x8+x4*x5*x6*x7+x4*x5*x6*x7*x8+x3+x3*x8+x3*x7*x8+x3*x6*x8+x3*x6*x7+x3*x6*x7*x8+x3*x5*x8+x3*x5*x7+x3*x5*x7*x8+x3*x5*x6*x8+x3*x5*x6*x7+x3*x5*x6*x7*x8+x3*x4*x8+x3*x4*x7+x3*x4*x6+x3*x4*x6*x7*x8+x3*x4*x5+x3*x4*x5*x6*x7+x3*x4*x5*x6*x7*x8+x2*x8+x2*x7*x8+x2*x6*x7+x2*x5*x8+x2*x5*x7*x8+x2*x5*x6+x2*x5*x6*x7+x2*x5*x6*x7*x8+x2*x4*x8+x2*x4*x7*x8+x2*x4*x6*x8+x2*x4*x5+x2*x4*x5*x8+x2*x4*x5*x7*x8+x2*x4*x5*x6+x2*x4*x5*x6*x7+x2*x4*x5*x6*x7*x8+x2*x3+x2*x3*x7+x2*x3*x7*x8+x2*x3*x5+x2*x3*x5*x8+x2*x3*x5*x6+x2*x3*x5*x6*x7*x8+x2*x3*x4*x6+x2*x3*x4*x6*x8+x2*x3*x4*x6*x7+x2*x3*x4*x6*x7*x8+x2*x3*x4*x5+x2*x3*x4*x5*x7+x2*x3*x4*x5*x6*x8+x1+x1*x8+x1*x7*x8+x1*x6*x8+x1*x6*x7+x1*x6*x7*x8+x1*x5*x8+x1*x5*x7+x1*x5*x6+x1*x5*x6*x8+x1*x5*x6*x7*x8+x1*x4+x1*x4*x8+x1*x4*x7+x1*x4*x6*x8+x1*x4*x6*x7+x1*x4*x6*x7*x8+x1*x4*x5*x8+x1*x4*x5*x7*x8+x1*x4*x5*x6+x1*x4*x5*x6*x8+x1*x4*x5*x6*x7*x8+x1*x3*x8+x1*x3*x7+x1*x3*x6*x7+x1*x3*x6*x7*x8+x1*x3*x5*x8+x1*x3*x5*x7+x1*x3*x5*x7*x8+x1*x3*x5*x6*x8+x1*x3*x4*x7+x1*x3*x4*x6+x1*x3*x4*x6*x7+x1*x3*x4*x6*x7*x8+x1*x3*x4*x5*x8+x1*x3*x4*x5*x7*x8+x1*x3*x4*x5*x6*x7+x1*x2+x1*x2*x8+x1*x2*x6+x1*x2*x6*x7+x1*x2*x6*x7*x8+x1*x2*x5*x7+x1*x2*x5*x7*x8+x1*x2*x5*x6*x7+x1*x2*x4+x1*x2*x4*x7*x8+x1*x2*x4*x6+x1*x2*x4*x6*x7+x1*x2*x4*x5*x7+x1*x2*x4*x5*x7*x8+x1*x2*x4*x5*x6+x1*x2*x4*x5*x6*x8+x1*x2*x4*x5*x6*x7+x1*x2*x4*x5*x6*x7*x8+x1*x2*x3*x7+x1*x2*x3*x6+x1*x2*x3*x6*x8+x1*x2*x3*x5+x1*x2*x3*x5*x8+x1*x2*x3*x5*x7+x1*x2*x3*x5*x7*x8+x1*x2*x3*x5*x6+x1*x2*x3*x5*x6*x8+x1*x2*x3*x5*x6*x7*x8+x1*x2*x3*x4+x1*x2*x3*x4*x8+x1*x2*x3*x4*x7+x1*x2*x3*x4*x7*x8+x1*x2*x3*x4*x6*x8+x1*x2*x3*x4*x5+x1*x2*x3*x4*x5*x7*x8+x1*x2*x3*x4*x5*x6+x1*x2*x3*x4*x5*x6*x8+x1*x2*x3*x4*x5*x6*x7")
	loop_for_answer("What input bits is output bit 6 of sbox3 dependent on? Please give the answer as x1,x2,etc. and in numerical order", "x1,x2,x3,x4,x5,x6,x7,x8")
	loop_for_answer(f"Does output bit 6 of sbox3 {bold_start}achieve complete diffusion{bold_end} with respect to the input bits? (yes/no)", "yes")

def sbox_diffusion():
	print(f"\nIf complete diffusion is achieved by all output bits, in other words, each input bit spreads its influence to all output bits, with no exceptions, we say that {bold_start}the given S-Box achieves complete diffusion{bold_end}.")
	loop_for_answer("Does sbox1 achieve complete diffusion? (yes/no)", "no")
	loop_for_answer("Which output bit of sbox1 has the issue? Please give the answer as y1 or y2, etc.", "y7")
	loop_for_answer("What is the ANF for output bit 7 of sbox1? Please give it in the exact format as outputted by the anf_extractor code that we have given you", "x7+x6+x6*x8+x5*x8+x5*x6+x4*x8+x4*x7+x4*x7*x8+x4*x6*x7+x4*x5*x6+x4*x5*x6*x8+x4*x5*x6*x7+x4*x5*x6*x7*x8+x3*x7+x3*x6+x3*x6*x7+x3*x5+x3*x5*x6+x3*x4+x3*x4*x8+x3*x4*x7+x3*x4*x6*x8+x3*x4*x6*x7*x8+x3*x4*x5*x7*x8+x3*x4*x5*x6*x8+x2*x8+x2*x7*x8+x2*x6+x2*x6*x7*x8+x2*x5*x7+x2*x5*x6+x2*x5*x6*x8+x2*x4*x8+x2*x4*x6+x2*x4*x6*x7+x2*x4*x6*x7*x8+x2*x4*x5*x8+x2*x4*x5*x7+x2*x4*x5*x6*x7+x2*x4*x5*x6*x7*x8+x2*x3*x8+x2*x3*x6*x8+x2*x3*x6*x7*x8+x2*x3*x5*x7+x2*x3*x5*x6*x8+x2*x3*x4")
	loop_for_answer("Which input bit is missing from the ANF of output bit 7 of sbox1? Please give the answer as x1 or x2, etc.", "x1")
	loop_for_answer("Does sbox2 achieve complete diffusion? (yes/no)", "yes")
	loop_for_answer("Does sbox3 achieve complete diffusion? (yes/no)", "yes")

def main():
	intro()
	success = caesar_cipher_minigame()
	while not success:
		print("You failed the minigame. Try it again!\n")
		success = caesar_cipher_minigame()
	print("\nWhen a plaintext bit change results in only one ciphertext bit change, it's quite easy to deduce the relationship between them, as is the case of the Caesar cipher you've just cracked.")
	print(f"If a plaintext bit change results in {italic_start}n>1{italic_end} ciphertext bit changes, the relationship gets harder to track - but still doable, depending on the value of {italic_start}n{italic_end}.")
	print(f"When designing cryptographic algorithms, we strive for {bold_start}complete diffusion{bold_end} - meaning that each output bit depends on {bold_start}all{bold_end} input bits.\n")
	sbox_intro()
	print(f"\nA Boolean function of {italic_start}n{italic_end} variables maps {italic_start}n{italic_end} input bits to a single bit. Examples of that are AND, OR and XOR.\n")
	anf_boolean()
	vbf_intro()
	sbox_anf()
	sbox_diffusion()
	print("\nAn S-Box is merely one of the components of a cryptographic algorithm - they're made of several other components. However, it is paramount that it achieves complete diffusion. And now you know that, if you see S-Boxes as VBFs, you can extract their output bit ANFs to verify whether they achieve complete diffusion or not. Congrats!")
	print(f"Here's your flag for completing this challenge --> {flag}\n")
	
if __name__ == "__main__":
	main()