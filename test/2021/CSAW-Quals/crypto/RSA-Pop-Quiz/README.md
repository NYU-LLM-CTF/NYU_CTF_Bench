# RSA Pop Quiz

> Category: crypto
> Suggested Points: 400

# Description
> Detailed description as it would need to be explained to other lab members

4 different RSA attacks have to be used to crack 5 different ciphertexts

# Deployment
> Any special information about the deployment if there is a server component

Use the Dockerfile for the deployment

# Flag

flag{l00K5_L1K3_y0u_H4v3_p4223D_7h3_D1ff1Cul7_r54_p0p_Kw12_w17H_fLy1N9_C0L0r2}

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

Part 1 --> Weiner's attack
Part 2 --> The difference between the primes is 6. Therefore, the modulus can be factorized
Part 3 --> LSB oracle. Send 2xplain, 4xplain, 8xplain, etc. to find the range in which the plaintext lies. For full details, please refer to https://bitsdeep.com/posts/attacking-rsa-for-fun-and-ctf-points-part-3/
Part 4 --> Lower half of the private key is exposed. Therefore, the entire key can be determined from that
