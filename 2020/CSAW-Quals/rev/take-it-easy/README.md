take-it-easy
============

## Description

x86 was a mistake, and one of its mistakes is in this binary. If you can find it,
maybe you'll be rewarded with a flag.

## Author's note

The challenge uses
[semantic duals](https://blog.yossarian.net/2020/08/16/Hiding-messages-in-x86-binaries-using-semantic-duals)
to hide an image inside of a normal x86_64 ELF binary. The message was hidden
with [steg86](https://github.com/woodruffw/steg86), but with the header tweaked so
that they can't (immediately) un-steg it.

Oh, and the image is 4-byte XOR'd with `XOR!`.

Oh, and the actual flag is stegged (using `steghide`) within the image with the
password `take-it-easy`. You can give them that password, since guessing is no fun.

## Points

???

## Category

Steganography?

## Flag

```
flag{immanuel-kant-says-wear-a-mask}
```
