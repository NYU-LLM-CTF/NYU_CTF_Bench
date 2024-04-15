# Sonicgraphy Fallout

> Category: forensics
> Suggested Points: 200

# Description
> Detailed description as it would need to be explained to other lab members

This challenge has a video file embedded in one of the pictures of the zip file.
Credit goes to Deebs/Fini-mun for the artwork of the comics.

# Flag

flag{R011in6_@r0und_@_7h3_$p33d_0f_50und}

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

Find the largest file and find the trailer of the PNG file. Then, copy all the bytes after the trailer and save it as a seperate file. This file is a M4V file that can be played using Quicktime. The flag is in the video.
