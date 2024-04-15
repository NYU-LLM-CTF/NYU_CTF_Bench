def part1(): # Hostname/Computer Name
	print("1. Hostname of the machine")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "5P3C7r3-1MP3r1UM":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")

def part2(): # Timezone and Region
	print("2. Region the machine belong to")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "Singapore":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")

def part3(): # User
	print("3a. User registered on the machine")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "Spectre":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("3b. GUID of the user from 3a")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "S-1-5-21-4228526091-1870561526-3973218081-1001":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("3c. Last login time of user from 3a using the timezone of found in 2. (Use format HH:MM:SS MM/DD/YYYY)")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "09:01:28 11/01/2021":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("3d. Other accounts enabled on the machine")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "Administrator":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")

def part4(): # Attached USB
	print("4a. Name of USB attached to the machine")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "3v1L_Dr1v3":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("4b. Letter assigned to USB attached to the machine")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "E":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("4c. Serial number of USB attached to the machine")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer.lower() == "04016cd7fe9bdb2e12fdc62886a111831a8be58c0143f781b2179f053e9682a":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("4d. Timestamp of first connection of USB to the machine using the timezone of found in 2. (Use format HH:MM:SS MM/DD/YYYY)")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "04:36:59 10/31/2021":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("4e. Timestamp of last connection of USB to the machine using the timezone of found in 2. (Use format HH:MM:SS MM/DD/YYYY)")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "15:49:01 11/01/2021":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("4f. Timestamp of last write to USB attached to the machine using the timezone of found in 2. (Use format HH:MM:SS MM/DD/YYYY)")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "15:49:13 11/01/2021":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("4g. GUID of USB attached to the machine")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer.lower() == "d53e38d0-36db-11ec-ae51-080027ec0de9":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")

def part5(): # System Questions
	print("5a. Windows Activation Key")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "VK7JG-NPHTM-C97JM-9MPGT-3V66T":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("5b. Windows Edition")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "Windows 10 Pro":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("5c. Windows Version")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "21H1":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("5d. Windows Registered Owner")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "Spectre":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")
	print("5e. Windows Install Date using the timezone of found in 2. (Use format HH:MM:SS MM/DD/YYYY)")
	while True:
		print("What is the answer?")
		answer = input("")
		if answer == "16:02:09 10/26/2021":
			print("That's right!")
			break
		else:
			print("Uh, this doesn't track with some of the other pieces of data that we have. Please try again!")

def main():
	print("Welcome agent! We will be needing your help with analyzing these files.")
	print("As you enter each piece of information, we will be cross-checking it with our other sources. If something doesn't make sense on our end, we will let you know.\nLet us begin:\n")
	part1()
	part2()
	part3()
	part4()
	part5()
	print("Congrats! You have done well agent! 007 is very pleased with you and he was able to recover the following information that helped take down the enemy.")
	print("Here it is for you to see: flag{H1570rY 12'N7 k1ND 70 7h053 wh0 Pl4Y g0d}")

if __name__ == "__main__":
	main()
