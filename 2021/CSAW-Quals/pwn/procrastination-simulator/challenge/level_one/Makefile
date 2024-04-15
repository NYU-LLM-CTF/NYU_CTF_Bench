all: level_one

level_one:
	# https://stackoverflow.com/questions/9686764/how-can-i-get-the-global-offset-table-address-in-my-program
	# Turns out you have to compile with -fpie so that we can read the location of the GOT properly within the template.c code
	# in order to edit the GOT from within the running binary, and compile with 
	# -no-pie so that the player finds the code address is absolute and predictable in the resulting binary 
	# and can find the offset to the win function
	gcc -m32 -fno-stack-protector -fpie -no-pie level_one.c -o level_one
	#gcc -fno-stack-protector -fpie -no-pie template.c -o template
	#strip template

clean:
	rm level_one
