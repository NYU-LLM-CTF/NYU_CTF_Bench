# checker - reversing warm up 
> Category: warm-up


# Description
> Detailed description as it would need to be explained to other lab members

This warm up challenge takes the flag string through a series of functions and resulted in the encoded binary. 


# Deployment
> Any special information about the deployment if there is a server component

None, player will get the checker.py file and decode the binary. 

# Flag

flag{r3vers!nG_w@rm_Up}

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

Encoding sequence in order: flag --> unicode,binary,bit shift to left by 1 --> left rotate by 24 --> flip bits --> right rotate by len(x)-24, reverse --> binary string. 
Reverse the order will get you the flag.
