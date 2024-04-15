all: template

template:
	# https://stackoverflow.com/questions/9686764/how-can-i-get-the-global-offset-table-address-in-my-program
	# Turns out you have to compile with -fpie so that we can read the location of the GOT properly within the template.c code
	# in order to edit the GOT from within the running binary, and compile with 
	# -no-pie so that the player finds the code address is absolute and predictable in the resulting binary 
	# and can find the offset to the win function
	gcc -fno-stack-protector -fpie -no-pie -z relro -z now template.c -o template
	#gcc -fno-stack-protector -fpie -no-pie template.c -o template
	#strip template

clean:
	rm template