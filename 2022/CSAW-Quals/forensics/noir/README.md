# noir

## Description
I am a forest, and a night of dark trees: but he who is not afraid of my
darkness, will find banks full of roses under my cypresses.

## Solution
The image is a webm encoded as rgb24 rawvideo. This can be transcoded to webm
using ffmpeg. The flag is encoded in the headlights of the train as morse.

## Walkthrough
```
#!/bin/bash

ffmpeg -i noir.png -pix_fmt rgb24 -f rawvideo noir.webm
```

Morse: https://en.wikipedia.org/wiki/Morse_code

The format for the flag in the video is `(flag)sil3nt_refl3ct1on` repeated twice. Note that the open and close parentheses are the same symbol, `-.--.`. 

## Notes

See the Excel spreadsheet translating the Morse back to letters. 
[morse.xlsx](https://github.com/osirislab/CSAW-CTF-2021-Finals/files/7504114/morse.xlsx)
The morse code message repeats a few times in the video. We tried to note (for most of the characters) the approximate begin/end time for when they're shown in the video based on the timestamp. We are able to 
successfully decode the message to (flag)sil3nt_refl3ct1on.
