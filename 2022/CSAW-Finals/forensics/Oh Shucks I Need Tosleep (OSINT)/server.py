def part1(): # Location
	print("1. Go look at that picture. Where was it filmed? Please use the format 123 Name Street North:")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer == "301 keawe street":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part2(): # Restraining Order File Number
	print("2. On March 29th, a 2022 temporary restraining order was filed against the person wearing white. What is the case id for the TRO? Please use the format XXXX-XX-XXXXXXX:")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "3DSS-22-0000203":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")
      
def part3(): # Marriage Cert Number
	print("3. Ezra Miller's 2017 costar later married a woman with the initials J.L.L. What is the certificate number on that marriage license?")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "202207160041807":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part4(): # Producer Name
	print("4. In 2009 ben Affleck played a character named Neil in another movie. One of the producers of that movie is currently married to a popular talk show host. What is the producer’s name? Please use the format John Doe: ")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer == "nancy juvonen":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part5(): # Address #2
	print("5. In 2022 Nancy Juvonen and her husband Jimmy filed a BOTH RPTT AND RETT document regarding a New York property. In this document, what address is listed under 'GRANTOR/SELLER:'? Please use the format 123 Name Street North:")
	while True:
		print("Please enter your answer:")
		answer = input("")
		answer = answer.lower()
		if answer == "200 park avenue south":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part6(): # DOS number
	print("6. What is the DOS number of Jimmy’s business that is listed at that address?")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "4839348":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")


def part7(): # IP Address
	print("7. That company has it's own website! What is the website's ip address?")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "23.236.62.147":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

def part8(): # Old Site
	print("8. What name is listed as that site's domain registrant?")
	while True:
		print("Please enter your answer:")
		answer = input("").upper()
		if answer == "PERFECT PRIVACY, LLC":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")
      
def main():
	print("What are you still doing up? None of this information will ever be useful! After this you really need to get some sleep!")
	part1() #Location
	part2() #File Number
	part3() #Cert Number
	part4() #Producer Name
	part5() #Address
	part6() #DOS number
	part7() #IP address
	part8() #Website registrant
	print("Wow you dove deep into that osint rabbit hole!!")
	with open('flag.txt','r') as f:
		flag = f.read()
	print("Hopefully now you can get some rest!"+flag)

if __name__ == "__main__":
	main()
