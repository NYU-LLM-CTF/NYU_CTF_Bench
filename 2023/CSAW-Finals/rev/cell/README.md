# cell

Author: Aneesh Maganti

This challenge presents itself as a controller testing program written as PS3 homebrew (compiled using PSL1GHT via the flipacholas/ps3devextra docker image). Of course, there's more than meets the eye here. This challenge has three main stages to it: recognizing and setting up the environment required, reversing the challenge to determine what its functionality, and then finally passing the challenge to get the final set of registers. 

The file cell.pkg can refer to many files as outlined [here](https://en.wikipedia.org/wiki/.pkg) - the name itself though is a reference to the [unique](https://en.wikipedia.org/wiki/Cell_(processor)) processor the PS3 had. While this file can be loaded on an actual PS3, it is significantly easier to use an emulator when working. RPCS3 is a popular emulator with high compatibility so it was used when testing.

Loading the file initially presents the user with a controller test program (note: the base controller homebrew came from [here](https://www.psx-place.com/threads/ps3-gamepad-test.144/)). However, every 2 seconds, it will poll for your controller inputs and print out to the TTY console. To progress from here, you will need to decompile the program. The base file, cell.pkg, is a packed version of a digital PSN game so you'll first want to extract it. You can use [PS3 Game Extractor](https://www.psx-place.com/resources/ps3-game-extractor.824/) to unpack the .pkg file; you'll find an eboot.bin file which is the main executable of the program, albeit encrypted. To decrypt the binary, you can use a utility in RPCS3 to decrypt the file, generating an eboot.elf file. To disassemble this, there are scripts both for [IDA](https://github.com/kakaroto/ps3ida) and [Ghidra](https://github.com/clienthax/Ps3GhidraScripts). However, the IDA scripts are pretty oudated now and (to my knowledge) don't allow you to decompile the program; therefore, I went with Ghidra.

You'll want to apply the analysis scripts before analyzing the program. This will show you some of the Cell (not to be confused with the program name) libraries that the PS3 uses for OS functions including drawing to the screen, doing console logs, etc. You can find the entrypoint, start for PS3, which is referred to as TOC_BASE in Ghidra. From here, you can trace down the functions until you find the main function (from the original C source files). You'll need to interpret the general structure from the program here. 

![image](https://github.com/osirislab/CSAW-CTF-2023-Finals/assets/28660350/902b0798-7a39-4a54-8341-34ebf8f7cb3c)

Cell works by polling your inputs every 2 seconds and then comparing this set of inputs to a large buffer part of the binary. Each set is exactly 2 inputs: any of the triggers, L3/R3, no input, and the face buttons. The correct set of inputs is below:

1) Triangle/Cross
2) L1/R1
3) L2/R2
4) Triangle/Start
5) L1/Square
6) R2
7) R1/L3
8) R3

If the inputs are all matched to the end, then cell will hang and ask you to check the registers. You can use RPCS3 to pull up the registers and view them directly. After copying these values, you can then call the python script and enter in the corresponding values; if they all match, you will be presented with the flag.
