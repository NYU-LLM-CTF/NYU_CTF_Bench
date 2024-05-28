Here is the solution to this CTF:

- Decompile the `brrr` binary and figure out that it is checking the characters in an array
- The array contains pointers to the characters hash value
- The hash is 64 bytes so best guess is SHA512
- Extract the hash values of each character pointer in the array
- Map the hash value to SHA512 of alphanumeric single characters
- The generated string is base64 encoded
- Perform base64 decoding to get the flag
