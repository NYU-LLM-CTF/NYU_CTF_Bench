# Gotta Crack Them All

> Category: crypto
> Suggested Points: 200

# Description
> Detailed description as it would need to be explained to other lab members

The goal of this challenge is to create a wordlist and brute-force all of the passwords using the wordlist. Using that knowledge of plaintext-ciphertext pairs, we can crack the admin's password which is the flag.

# Deployment
> Any special information about the deployment if there is a server component

Use the Dockerfile for the deployment

# Flag
1n53cu2357234mc1ph32

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

They way the solution works is that you figure out that the wordlist consists of the Pokemon's name and their typings (all joined with hypens). Then, using that wordlist and the server, you find the ciphertext for each password and crack the key. Using that key, you can crack the admin's password and submit it as the flag. The script to solve this is in `solve.py`.
