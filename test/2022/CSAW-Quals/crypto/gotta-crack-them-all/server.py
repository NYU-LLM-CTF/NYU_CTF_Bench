from encrypt import *
from inputimeout import inputimeout, TimeoutOccurred

with open('list.txt') as f:
	passwords = f.read().split('\n')[:-1]

def main():
	print("You can encrypt a pre-approved password using this service.\n")
	while True:
		print("What is the password you would like to encrypt?\n")
		try:
			reply = inputimeout(prompt='>> ', timeout=60)
		except TimeoutOccurred:
			print("Oof! Not fast enough!\n")
			break
		if reply in passwords:
			print("The encrypted password is:", encrypt(reply))
			print("Would you like to go again? (Y/N)\n")
			try:
				response = inputimeout(prompt='>> ', timeout=60)
			except TimeoutOccurred:
				print("Oof! Not fast enough!\n")
				break
			if response != 'Y' and response != 'y':
				break
		else:
			print("This is not a pre-approved password! >:(\nIt will not be encrypted.\n")
			break

if __name__ == "__main__":
	main()
