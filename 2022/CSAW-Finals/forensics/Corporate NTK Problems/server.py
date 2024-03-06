array_6_7 = ["b383b191dd43beb620cd1e8adf8e6f8032842f9f935c492e45cd5f2f9934bba1", "6b32444e3ec51e9ddb6e25695a006e4b51253967e7f124414ed0c7e1f86fa9b2"]
array_8_9 = ["aa773fbd9bb1ce1b9aabc98e6a6f7f7391999fdfdf422b9ee583da7de46b38a7", "2c5d0c6611016b35e85ee0944f21198b3e3f616da077faf3849d673eefbb6938"]

# HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/ComputerName/ComputerName/ComputerName
def part1(): # System Hostname
	print("1. What is the hostname of this system?")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.upper()
		if answer == "BIGCORPLT978":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

# HKEY_LOCAL_MACHINE/SOFTWARE/Microsoft/Windows NT/CurrentVersion/ProfileList
# Some can also just the emails to see the names being passed back and forth along with the email itself
def part2(): # User's Name
	print("2. Who is the user of this system")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "John Smith":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

# HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/TimeZoneInformation/TimeZoneKeyName
def part3(): # System Timezone
	print("3. What timezone is this system set to? Answer in full name format (e.g. Universal Time Coordinated)")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "Pacific Standard Time":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

#HKEY_LOCAL_MACHINE/SOFTWARE/Microsoft/Windows NT/CurrentVersion
#	Install Time: 8:36AM PST 10/01/2022
#		2022-10-01 08:36:47 -07:00 | 1664638607
def part4(): # Installation Time
	print("4. When was this OS installed? Format YYYY-MM-DD HH:MM:SS and Time in local Timezone)")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "2022-10-01 08:36:47":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part5(): # Did you find evidence of mishandled classified documents?
	print("5. Did you find evidence of mishandled classified documents?")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer == "yes":
			print("That's right!")
			break
		elif answer == "no":
			print("Cool, here's the ... flag. Yeah, let's call it that: notflag{Try_again} :-P")
			break
		else:
			print("Not quite... Please try again!")

def part6(): # What is the first evidence of mishandled data?
	print("6. What is the first evidence of mishandled data? Pleae enter the SHA-256 Hash for the evidence. Write 'none' if there is none.")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer in array_6_7:
			print("That's right!")
			array_6_7.remove(answer)
			break
		else:
			print("Not quite... Please try again!")

def part7(): # What is the second evidence of mishandled data?
	print("7. What is the second evidence of mishandled data? Pleae enter the SHA-256 Hash for the evidence. Write 'none' if there is none.")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer in array_6_7:
			print("That's right!")
			array_6_7.remove(answer)
			break
		else:
			print("Not quite... Please try again!")

def part8(): # What is the third evidence of mishandled data?
	print("8. What is the third evidence of mishandled data? Pleae enter the SHA-256 Hash for the evidence. Write 'none' if there is none.")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer == "none":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part9(): # What is the first leaked document in Future Nuclear Power Plans.pdf?
	print("9. For evidence 'Future Nuclear Power Plans.pdf', what is the first confidential data that was leaked? Pleae enter the SHA-256 Hash for the evidence. Write 'none' if there is none.")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer in array_8_9:
			print("That's right!")
			array_8_9.remove(answer)
			break
		else:
			print("Not quite... Please try again!")

def part10(): # What is the second leaked document in Future Nuclear Power Plans.pdf?
	print("10. For evidence 'Future Nuclear Power Plans.pdf', what is the second confidential data that was leaked? Pleae enter the SHA-256 Hash for the evidence. Write 'none' if there is none.")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer in array_8_9:
			print("That's right!")
			array_8_9.remove(answer)
			break
		else:
			print("Not quite... Please try again!")

def part11(): # What is the third leaked document in Future Nuclear Power Plans.pdf?
	print("11. For evidence 'Future Nuclear Power Plans.pdf', what is the third confidential data that was leaked? Pleae enter the SHA-256 Hash for the evidence. Write 'none' if there is none.")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer == "none":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part12(): # What is the first leaked document in ML092650379.pdf?
	print("12. For evidence 'ML092650379.pdf', what is the first confidential data that was leaked? Pleae enter the SHA-256 Hash for the evidence. Write 'none' if there is none.")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()		
		if answer == "0ae25651d1a1ecb5facd059a81c764b051e7280cacc02ad62075957b1aaad997":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part13(): # What is the second leaked document in ML092650379.pdf?
	print("13. For evidence 'ML092650379.pdf', what is the second confidential data that was leaked? Pleae enter the SHA-256 Hash for the evidence. Write 'none' if there is none.")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "none":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def main():
	print("We need to know if our classified information is still safe. Can you help us?")
	part1() 
	part2() 
	part3() 
	part4() 
	part5() 
	part6() 
	part7() 
	part8() 
	part9() 
	part10() 
	part11() 
	part12() 
	part13() 

	print("Nice Job! Remember that we all have a part to keep our secrets safe!")
	with open('flag.txt','r') as f:
		flag = f.read()
	print("Here you go! "+flag)

if __name__ == "__main__":
	main()