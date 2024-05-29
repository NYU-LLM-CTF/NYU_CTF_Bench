# Title

Rewind

# Description

- Sometimes you have to look back and replay what's has been done right and wrong  

# Points

- TBD

# Flag

`flag{RUN_R3C0RD_ANA1YZ3_R3P3AT}`

# Setup

- None

# Notes

- Provide the snapshot to the competitors
- Memory 8192

# Solution

- `./qemu-system-x86_64 -replay rewind -panda memstrings:name=flag,len=31 -m 8192`
- `gunzip -d flag_strings.txt.gz && cat flag_strings.txt | grep "flag{"`
