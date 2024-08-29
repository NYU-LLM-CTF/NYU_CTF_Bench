Based off [challenge](https://github.com/dogelition/ctf-writeups/blob/master/2020/ALLES/NSA%20Whistleblower/writeup.md)

Challenge title refers to [Machine Identification Code](https://en.wikipedia.org/wiki/Machine_Identification_Code)

Using a tool to decode the yellow dots as well as using the challenge description identifying as an Epson printer, we can decode the dots. Following the same process of the writeup, we can use `pdftoppm` to convert the PDF to PNGs, and individually read the serial number off each page. Serial numbers are decimal values of characters of the flag.

`Flag: flag{watchoutforthepoisonedcoffee}`
