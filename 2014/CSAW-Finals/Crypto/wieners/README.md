# Wieners
## Author
Antoniewicz
## Points
400
## Category
Crypto
## Description
Logic Analyzer -> RE -> Morse Code -> Key
## Flag
`key{http://imgur.com/XYlLNrk}`
## Solution
In `solution/`
Files:
- CreateSketch - Python script to create the sketch directives to make the shit blink
- CSAW-CTF14_-_Reversing.cpp.hex - assembled bytecode of the image
- CSAW-CTF14_-_Reversing.ino - Intial Sketch
- logicparser - python script to parse out the logic data.

The contestants are given a dump from a Logic Analyzer. Which can be viewed using [Saleae's Logic Tool](https://www.saleae.com/downloads)
Once opened the contestants need to figure out which channel actually matters. Although channel 4 might contain the data they're looking for, really channel 6 is where its at.
Next contestants need to apply the Async Serial Analyzer to the channel, select autobaud, and have it decode the data as hex.
From there contestants can export to CSV for more analysis.
Within the data is the firmware image that will be written to the device. The students will have to figure that out, then extract the firmware. An example script to demonstrate this is in "logicparser"
Next, with the image extracted, it needs to be put in a format that will be supported by a disassembler. logicparser does this already, converting it to Intel Hex, however contestants may choose whatevez
Finally, with the assembly ready, they can start reversing. IDA or ReAVR can be used:
[http://www.avrfreaks.net/projects/reavr?module=Freaks%20Academy&func=viewItem&item_id=56&item_type=project](http://www.avrfreaks.net/projects/reavr?module=Freaks%20Academy&func=viewItem&item_id=56&item_type=project)
Eventually the contestant may realize that its just a series of repeated calls that raise and lower a pin on the board. Each raise/lower is separated with a lower. with the disassembly from ReAVR, the contestant can parse out just the useful bits with this horrific mess:
`grep -v ":" a | awk '/lds r24,D0100/{getline; print}' | cut -d ',' -f 2 | cut -c 3 | awk ' NR % 2 == 1 { print }' | tr -d "\n"`
And finally... they'll get a big long binary string of:
`01011001010011110101010100100000010001000100100101000100001000000100100101010100001000010010000001010111011000010111100100100000011101000110111100100000011001110110111100100000011010110110100101101100011011000110000101101000001000010010000001101011011001010111100101111011011010000111010001110100011100000011101000101111001011110110100101101101011001110111010101110010001011100110001101101111011011010010111101011000010110010110110001001100010011100111001001101011011111011`
which translates to the key: `YOU DID IT! Way to go killah! key{http://imgur.com/XYlLNrk}` which is a plate of wieners
## Setup
Distribute `wieners.7z`
