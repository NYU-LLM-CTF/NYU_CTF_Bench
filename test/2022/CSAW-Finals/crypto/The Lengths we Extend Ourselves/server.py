def part1(): # Location
	print("What is the hash signature of the message appended with ' P.S. I QUIT!'?:")
	while True:
		print("Please enter your answer:")
		answer = input("")
		if answer == "ba65cf5860ff5a095bbb0ad2c64c08f9adabdff77f4e5ef17d96433f9ddd9ff5":
			print("That's right!")
			break
		else:
			print("Not quite... Please try again!")

      
def main():
	print("Wow, you're really going to do this? Not cool, bud.")
	part1() 
	print("Woah! You did it. Bummer for Alice!")
	with open('flag.txt','r') as f:
		flag = f.read()
	print("Please don't come after my job next..!"+flag)

if __name__ == "__main__":
	main()
