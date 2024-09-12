# ZipZipZipZi........

> Category: misc
> Suggested Points: 250

# Description

> Detailed description as it would need to be explained to other lab members

This challenge covers the technique of technique of encoding an image file to base64 plaintext which can be then separated in the chunks of 5 characters of from the plaintext then put inside a zip file containing each chunks and the next zip file which contains the next chunk and the next zip and goes on .... Then at last when the image is recovered, the flag is present in the bottom right corner where the brightness can be upped a little to see the flag clearly.

# Files

> Any files that is provided

Just the chall.zip file for it should be provided for the players to explore.
Other files like chall.py and solve.py are the scripts that will be used by us to know how the challenge was created and how can it be solved.

# Flag

`csawctf{ez_r3cur5iv3ne55_right7?}`

# Solution

> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

The players are expected to solve the recursive zip and I used `solve.py` script for that ; to accumulate all the chunks and then form the base64 image again .
After the image is retrieved , the player will have to increase the brightness a little or just zoom in a little near bottom right to get the flag.
