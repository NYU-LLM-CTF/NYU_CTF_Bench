# Rebug 1: 
> Category: Rev
> Suggested Points: 200

# Description

A simple rev challenge where the user inpects the binary code to figure out the desired input for the flag.

# Flag

`csawctf{c20ad4d76fe97759aa27a0c99bff6710}``

# Solution

open the binary file in Ghidra.

Look at the exports folder to see the exported functions from the binary. There you will find the main function.

Once you have the main function in the decompiler window, you will see the string of the terminal ouput. This will prove that you are in the main function.

You will see that there is for loop incrementing with the number of char variables inside the user's input. 

The variable is then checked in a conditional to see if it matches the hex value "0xc", which is 12 in decimal. 

Once you submit a 12-character long input, it will execute the correct code block in the if-else statement. This will return the flag, with is the md5 encoding of the string "12".
