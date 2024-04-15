# Description

Exploit differences in alignment between two similar structs to overflow a buffer of bards. Bypass the canary by exploiting alignment padding, leak libc with ROP, return to main, then One Gadget to victory.

# TODO

Just needs to be tested once it's running in CTFd. Also note that I have it running on port 8000, following the example of other challenges waiting to be assigned unique port numbers
