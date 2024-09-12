# Define the ANSI escape sequences for bold text
bold_start = '\033[1m'
bold_end = '\033[0m'
italic_start = '\x1B[3m'
italic_end = '\x1B[0m'

flag = "csawctf{1_n0w_und3r5t4nd_435_d1ffu510n}"

def loop_for_answer(prompt, answer):
	while True:
		print(prompt)
		ans = input("")
		if ans.lower() == answer:
			print("That's right!\n")
			break
		else:
			print("Try again!")

def main():
	print("You've certainly heard of AES, the most widely used block cipher in the world.")
	print(f"The AES state is commonly represented as a 4x4 matrix of {bold_start}bytes{bold_end}. The algorithm has 10, 12 or 14 {bold_start}rounds{bold_end} (iterations) depending on the variant (AES-128, AES-192 or AES-256 respectively). Each round comprises steps called {italic_start}AddRoundKey{italic_end}, {italic_start}SubBytes{italic_end}, {italic_start}ShiftRows{italic_end}, {italic_start}MixColumns{italic_end}.")
	print("The following pseudocode represents AES:")
	print(f"""{bold_start}{italic_start}x = plaintext
x = AddRoundKey(x, k0)
for r from 1 to nr - 1 do
	x = SubBytes(x)
	x = ShiftRows(x)
	x = MixColumns(x)
	x = AddRoundKey(x)

// Last round doesn't have MixColumns
x = SubBytes(x)
x = ShiftRows(x)
x = AddRoundKey(x, knr)
return x{italic_end}{bold_end}""")
	print(f"\nLet's focus on the interaction between {italic_start}ShiftRows{italic_end} and {italic_start}MixColumns{italic_end} for now. For that, let's assume the other operations don't exist and reduce AES to this:")
	print(f"""{bold_start}{italic_start}x = plaintext
for r from 1 to nr do
	x = ShiftRows(x)
	x = MixColumns(x)
return x{italic_end}{bold_end}""")
	print(f"\nAssume you have the following {italic_start}x{italic_end} state before a {italic_start}ShiftRows{italic_end} execution:")
	print(f"""{bold_start}{italic_start}state = [['x0', 'x4', 'x8', 'x12'],
         ['x1', 'x5', 'x9', 'x13'],
         ['x2', 'x6', 'x10', 'x14'],
         ['x3', 'x7', 'x11', 'x15']]{italic_end}{bold_end}""")
	loop_for_answer(f"What will the {italic_start}ShiftRows{italic_end} output be? Please give the answer like the state given above except put all the rows in one line when submitting the answer", "[['x0', 'x4', 'x8', 'x12'], ['x5', 'x9', 'x13', 'x1'], ['x10', 'x14', 'x2', 'x6'], ['x15', 'x3', 'x7', 'x11']]")
	loop_for_answer(f"What about after {italic_start}MixColumns{italic_end}? A sample answer for an element within the matrix is {bold_start}'2*x0 + 3*x2 + 1*x7 + 1*x4'{bold_end}. Please give the answer like the state given above except put all the rows in one line when submitting the answer", "[['2*x0 + 3*x5 + 1*x10 + 1*x15', '2*x4 + 3*x9 + 1*x14 + 1*x3', '2*x8 + 3*x13 + 1*x2 + 1*x7', '2*x12 + 3*x1 + 1*x6 + 1*x11'], ['1*x0 + 2*x5 + 3*x10 + 1*x15', '1*x4 + 2*x9 + 3*x14 + 1*x3', '1*x8 + 2*x13 + 3*x2 + 1*x7', '1*x12 + 2*x1 + 3*x6 + 1*x11'], ['1*x0 + 1*x5 + 2*x10 + 3*x15', '1*x4 + 1*x9 + 2*x14 + 3*x3', '1*x8 + 1*x13 + 2*x2 + 3*x7', '1*x12 + 1*x1 + 2*x6 + 3*x11'], ['3*x0 + 1*x5 + 1*x10 + 2*x15', '3*x4 + 1*x9 + 1*x14 + 2*x3', '3*x8 + 1*x13 + 1*x2 + 2*x7', '3*x12 + 1*x1 + 1*x6 + 2*x11']]")
	loop_for_answer("Which old bytes influence the new x0 byte? Please give the answer as x1,x2,etc. and in numerical order", "x0,x5,x10,x15")
	loop_for_answer("Which old bytes influence the new x11 byte? Please give the answer as x1,x2,etc. and in numerical order", "x2,x7,x8,x13")
	loop_for_answer("Has complete diffusion been achieved? (yes/no)", "no")
	loop_for_answer("How many plaintext bytes are not influencing the new x0 byte? Please give a numerical answer", "12")
	print(f"Let's denote as {italic_start}xi:r{italic_end} the byte {italic_start}xi{italic_end} of the state after round {italic_start}r{italic_end}. In other words, new {italic_start}x0{italic_end} can be denoted as {italic_start}x0:1{italic_end} as it is the new {italic_start}x0{italic_end} after one round of our special AES has been performed, whereas old {italic_start}x0{italic_end} would be {italic_start}x0:0{italic_end}.")
	print(f"For the second round, the input is the output of the first round - i.e. the state matrix made of the {italic_start}xi:1{italic_end} bytes.")
	loop_for_answer(f"What bytes from the first round output ({italic_start}xi:1{italic_end} type of bytes) influence {italic_start}x0:2{italic_end}? Please give the answer as x1:1,x2:1,etc. and in numerical order", "x0:1,x5:1,x10:1,x15:1")
	loop_for_answer(f"You know which {italic_start}xi:0{italic_end} bytes influence which {italic_start}xi:1{italic_end} bytes. Thus, which {italic_start}xi:0{italic_end} bytes influence {italic_start}x0:2{italic_end}? Please give the answer as x1:0,x2:0,etc. and in numerical order", "x0:0,x1:0,x2:0,x3:0,x4:0,x5:0,x6:0,x7:0,x8:0,x9:0,x10:0,x11:0,x12:0,x13:0,x14:0,x15:0")
	print("\nIf we reduce the algorithm to this form:")
	print(f"""{bold_start}{italic_start}x = plaintext
for r from 1 to nr do
	x = ShiftRows(x)
return x{italic_end}{bold_end}""")
	loop_for_answer("What is x0:10? Please give the answer as x1,x2,etc. and in numerical order", "x0")
	print("\nWhat about this form?")
	print(f"""{bold_start}{italic_start}x = plaintext
for r from 1 to nr do
	x = MixColumns(x)
return x{italic_end}{bold_end}""")
	loop_for_answer("What is x0:2? Please give the output as you would exactly get from the aes_simulator code", "(2*(2*x0 + 3*x1 + 1*x2 + 1*x3) + 3*(1*x0 + 2*x1 + 3*x2 + 1*x3) + 1*(1*x0 + 1*x1 + 2*x2 + 3*x3) + 1*(3*x0 + 1*x1 + 1*x2 + 2*x3))")
	loop_for_answer("Do we ever achieve complete diffusion?", "no")
	print("As you could observe, AES only achieves complete diffusion in its bytes if ShiftRows and MixColumns are employed together.")
	print(f"Here's your flag for completing this challenge --> {flag}\n")

if __name__ == "__main__":
	main()