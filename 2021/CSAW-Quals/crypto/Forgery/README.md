# Forgery

> Category: crypto
> Suggested Points: 200

# Description
> Detailed description as it would need to be explained to other lab members

This is a elgamal signature forgery challenge. The mistake made with the signing process is that the message is not hashed before being signed.

# Deployment
> Any special information about the deployment if there is a server component

Use the Dockerfile for the deployment. Give forgery.py as a part of the challenge

# Flag

flag{7h3_4rr0wv3r53_15_4w350M3!}

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

Do a one-parameter existential forgery. Select an e such that 1 < e < p-1. Set r = (g^e * y) mod p and s = (-r) mod (p-1). Then the tuple (r,s) is a valid signature for  the message m = (e*s) mod (p-1)
