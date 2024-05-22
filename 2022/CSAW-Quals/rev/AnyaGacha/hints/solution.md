Here is the solution to this CTF:

- Use Wireshark or other network monitors to capture the packet sent by the client when making a draw
- Decode all the base64 and you'll find that for any packet the sha256 of the value in the previous packet is the value of the current packet -- it is actually a hash counter
- Get the first value and do sha256 999 times
- Encoded that value with b64 then send it to the server to get the flag
- The flag is found in the file in plaintext
