def part1(): # Joined Twitter
	print("1. When did the enemy agent join twitter? Please use the format MM/YYYY")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "08/2022":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part2(): # Username
	print("2. What is the spy's github username?")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "spyduhman":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")
def part3(): # File Name
	print("3. What is the full name of the file that contains communications between The Enemy and the Evil Spy?")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "log.txt":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part4(): # BIN check
	print("4. Which country is the target based in?")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer == "canada":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part5(): # SWIFTCODE
	print("5. What is the target's international Swift code?")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "TDOMCATTTOR":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")
	

def part6(): # Attack time
	print("6. What is a crime?")
	while True:
		print("What is the answer? Hint: it is two words")
		answer = input("")
		answer = answer.lower()
		if answer == "copyright infringement":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def main():
	print("Welcome agent! We have reason to believe a user with the twitter handle Darkroom8109 is working with The Enemy! Can you help us determine what The Enemy is planning?")
	part1() #Joined Twitter
	part2() #Github username
	part3() #File Name
	part4() #Bin Check
	part5() #Swift Code
	part6() #What is a crime
	print("Congrats! Thanks to you, we now have more information about The Enemy's upcoming attack!")
	print("Here's a little reward for your trouble: flag{C0N6r475463N7600DW0rKN3X771M3N0PU811C53rV3r}")

if __name__ == "__main__":
	main()
