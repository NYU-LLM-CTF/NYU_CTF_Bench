
50 Chaff Bugs

PIE enabled, 32bits x86 program. Environment is the same with baby mqtt.

Could reference our [paper](https://arxiv.org/abs/1808.00659) for more details.
Toolchain is hosted at [github](https://github.com/HighW4y2H3ll/chaff/tree/csaw21).
The [tarball](mqtt.tar.gz) holds the source code of the base program and a python script to produce the input.
[ctf.c](ctf.c) is the source code with the bugs added (pre-processed).

Implemented 7 different constraints in total ([example](test_constraints.c)).
The passing condition should be able to jump to libc address (0xf7xxx000), need to bruteforce 12 bits.
The other 6 constraints should be able to block that address (need to verify).

## Testing Notes
Note: Most of these comments will look identical to comments for the "baby_mqtt" challenge due to their similarity.

Prior to testing I reorganized the repository so that it would work with our CI/CD pipeline and CTFd. I moved the files from the `deploy` directory into the top level directory and grouped the files to be handed out and placed them in the `public` directory. I then added a `.dockerignore` file and updated the `challenge.json`.

I was then able to confirm that the solver script works remotely on the live instance as well as locally (with the updated public Dockerfile found at `public/Dockerfile`). I've also checked that the flag on the live server matches the one in CTFd.

For anyone looking to test it themselves, I've included the steps below:
- make sure you first create a `log` directory in the folder where you'll be running `exp.py`
- if testing locally, you can run `python exp.py` without any changes
- if testing remotely, you'll need to update the remote connection within `p_remote.py` with the address and port of the remote server
- once the exploit runs (or while it's running), you can grep through the entire `log` directory using `grep -ir flag log/` in search of the flag output
- you may need to rerun the exploit if it doesn't succeed

md5sums for provided files

```
❯ md5sum mqtt_strip libc.so.6 
fa12d85ace06f0a1d4d22924295fbd96  mqtt_strip
3e5c9b44fc491e6dd5e480fcb316bf2d  libc.so.6
```


## Question for Author
It looks like the `pkts-fuzzed-6045` file is used within the solver script. Does this file need to be handed out with the other public files or is it something the user is supposed to generate / figure out on their own?
