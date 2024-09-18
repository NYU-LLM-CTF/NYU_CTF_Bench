# Gotta Decrypt Them All

> Category: crypto
> Suggested Points: 200 or 300

# Description
> Detailed description as it would need to be explained to other lab members

This challenge has random Pokemon names put through different encoding and encryption schemes that the challenger needs to go through to be able to get the names. After responding with these names, the flag is given.

# Deployment
> Any special information about the deployment if there is a server component

Use the Dockerfile for the deployment

# Flag

flag{We're_ALrEadY_0N_0uR_waY_7HE_j0UrnEY_57aR75_70day!}

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

Each Pokemon name is put through the following sequence in order: ROT13 --> RSA with e=3 --> Base64 --> ASCII numbers --> morse code. Reverse the order (for RSA with e=3, just take cuberoot of ciphertext) and you get each Pokemon name
