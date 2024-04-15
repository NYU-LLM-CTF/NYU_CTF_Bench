## baby\_mqtt

MQTT client program, 32 bits x86 binary, No PIE.

Given the challenge binary (strip??), libc.so, and Dockerfile.

Added one bug through the Chaff Bug, with controlled 4 bytes write to the return address.
Could reference our [paper](https://arxiv.org/abs/1808.00659) for more details.
Toolchain is hosted at [github](https://github.com/HighW4y2H3ll/chaff/tree/csaw21).
The [tarball](mqtt.tar.gz) holds the source code of the base program and a python script to produce the input.
[ctf.c](ctf.c) is the source code with the bug added (pre-processed).

Originally set the constraint, so that you could only look for ROP gadgets within the challenge
binary (0x0804xxxx), but I didn't find good gadgets... so anyway now, I changed the constraint, so
the you are able to look for gadgets in libc library. libc address is always loaded roughly at
0xf7xxx000. Need to brute force 12 bits. There shouldn't be good one gadget in 32bit libc, so the
my solution is to find a stack pivot gadget, and get shell.

There'll be another chaffed version of this MQTT client as a follow-up.


## Testing Notes
Note: Most of these comments will look identical to comments for the "chaff_mqtt" challenge due to their similarity.

Prior to testing I reorganized the repository so that it would work with our CI/CD pipeline and CTFd. I moved the files from the `deploy` directory into the top level directory and grouped the files to be handed out and placed them in the `public` directory. I then added a `.dockerignore` file and updated the `challenge.json`.

I was then able to confirm that the solver script works remotely on the live instance as well as locally (with the updated public Dockerfile found at `public/Dockerfile`). I've also checked that the flag on the live server matches the one in CTFd.

For anyone looking to test it themselves, I've included the steps below:
- make sure you first create a `log` directory in the folder where you'll be running `exp.py`
- if testing locally, you can run `python exp.py` without any changes
- if testing remotely, you'll need to update the remote connection within `p_remote.py` with the address and port of the remote server
- once the exploit runs (or while it's running), you can grep through the entire `log` directory using `grep -ir flag log/` in search of the flag output
- you may need to rerun the exploit if it doesn't succeed

md5sum for provided files

```
❯ md5sum public/mqtt_strip 
f59a52c46f2098efaaa7853fbfbeb69f  public/mqtt_strip
❯ md5sum public/libc.so.6 
3e5c9b44fc491e6dd5e480fcb316bf2d  public/libc.so.6
```


## Question for Author
It looks like the `pkts-fuzzed-9991` file is used within the solver script. Does this file need to be handed out with the other public files or is it something the user is supposed to generate / figure out on their own?
