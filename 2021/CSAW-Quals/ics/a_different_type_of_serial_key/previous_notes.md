
### Firmware implementation for CSAW CTF port of the PLC Firmware Injection challenge

    The original implementation of the firmware was a simple function that took the input parameter (voltage) and computed P = V^2/R with static R, returning P (power). The problem is that the result could be guessed by brute force alone without solving the actual challenge.

    I replaced this with a firmware update that maybe teaches a little about ICS per se in the sense that it's not realistic: it's a one time pad implementation. The user enters a base64-encoded string. That string (the 'user key') and a static global string (the encoded 'local key') get decoded using a base64 decoding function included with the firmware as native C code, then the two decoded keys get XORed together to produce the flag which gets printed as output. 

    That's it. The flag can't be brute-forced, and the user has to recover and reverse engineer the firmware to get the other half of the input key. 

    There's a key generation function commented out in the source code. Recover the flag as follows:

    ./firmware SymMNSZ8KEetsQ41GgdPe2vcpgvJg7bkReOb/Vw=

    And either give that base-64 encoded input string to the user as part of the challenge description (probably what we'll do), or else provide it with the serial communication in some other way. 

    Note that during testing I compiled for an x86-64 architecture, but since we don't use external libraries this shoudl work fine for a 32-bit big-Endian PowerPC architecture. 

    UPDATE 8-31-21: I removed the base64 encoding and decoding methods to reduce the footprint of the `firmware.c` file.

## 08-31-21 Notes from Stephen

Due do the way we are sending this data via S-Record, I have modified the function we are going to be sending to do a tiny bit more than normal XOR, because I figured once people see a long string/character array they may test XORing that with the key they already have without actually pulling apart any of the PowerPC. Note: there will be two different S-Record transfers in the SPI traffic. One containing the base **key_to_send** bytes and the other containing the powerpc compiled **function_to_send**. Nothing from "main" or standard C libraries will be sent. The bytes created from **function_to_send** are located in `powerpc_firmware_function_stripped`. They can be loaded into Ghidra if you want to see the Ghidra disassembly/decompilation of this function.

**Please let me know if this function change is ok with you and if there are any changes you would like me to make before I create the S-Records and SPI traffic.**

As far as the "user key" I figured we could give them an additional serial capture of I2C where they have to decode the user key that way or just give them the user key in the prompt. Let me know which you would prefer!

## 9-1-21 Note from Richard

I like giving them the additional serial capture with the "user key" because that stops people from going straight to trying various combinations of XORing two strings together, bypassing the reverse engineering nature of the challenge and going straight to "guess the firmware function". 

I'm new to this -- I tried opening up `powerpc_firmware_function_stripped` in Ghidra, but Ghidra wasn't able to recognize the architecture automatically and neither was the `file` command. I tried specifying 32-bit PowerPC (default option) but Ghidra choked on that too. Perhaps we should provide some sort of hint to users so they know what architecture **function_to_send** was compiled for? Or perhaps I am too green in this area and I would be able to find the relevant magic bytes with a hex editor with a little more experience.
