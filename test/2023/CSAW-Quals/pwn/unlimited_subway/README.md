# Unlimited Subway

Unlimited Subway is a pwn challenge focused on bypassing canary in 32-bit environment.

The binary has an arbitrary read vulnerability in view_account method that prints an arbitrary index of account info. This can be used to reveal the contents of canary.

Choice "Fill account info" can't really be used to do anything but to fill the account buffer. However, choice "Exit" reveals a way to set the length of the following input which can be used to trigger buffer over flow. With a well crafted payload, one can overwrite the return address to print_flag method to print the flag of the challenge.

# Solution

There are two parts to the solution.

The first part is to leak the canary by taking advantage of the infinite loop of the program.

After leaking the canary, one can supply the payload composed with dummies, canary, and the return address to solve the challenge.

The intended solution can be found at [folder][1]

Run `python3 solution.py` to solve.


[1]: ./solution
