
### AEG Basic problem

    This challenge (Automated Exploit Generation) is modeled loosely after the AEG challenge in the University of Texas CTF earlier this year, except that we use format string vulnerabilities instead of a buffer overflow exploit. 

    What we do is generate a large number of Docker containers that all have slightly different binaries running in them. The user needs the password from the previous Docker container to get the password and address of the next one. (So for testing we need to make sure they can't skip to the end and guess the password somehow.) The password is an md5 hash that is randomly generated with a seed, so it should be hard to guess. There's no time limit on how long the player can take to solve each challenge, but doing this manually would be as painful as solving a blind SQL injection manually.

    I started by creating a framework that generates the Docker containers and just gives users shell after they enter the password, and a solver that loops through the containers, "solving" the challenges until the flag at the end is revealed. Then I moved on to implementing the levels. As of the present commit, only Level One is implemented. Here's the design:

    Level 1. 32-bit binary with partial RELRO and no position-independent execution. There is a win() function in a random position and 99 decoy functions. The executable is provided with symbols. The user enters text which is echoed back to them, and then exit(0) is called. They can overwrite the pointer in exit() to jump to win(). There's a solver script.

    Level 2. 64-bit binary, otherwise the same design.

    Level 3. 64-bit binary, but they don't get symbols this time.

    Level 4. 64-bit binary, but with position-independent execution and ASLR but no RELRO (so the GOT is writeable). They get three vulnerable print statements. With the first printf call they can leak the address of a global variable in the BSS section, then calculate the offset to the address of GOT function pointers. Next they leak one or more libc addresses and at that point can fingerprint the libc version to find out it is Ubuntu 20.04 (we don't provide libc). After that they have two options: overwrite the memset function pointer with a pointer to system (I haven't tested this though), or overwrite the puts() pointer in the GOT to jump directly to a one_gadget (which I've tested and it works). For level 4, occasionally an address that they need to put in one of their format strings will have `0x0a` as one of its bytes. I've calculated this and the minimum number of opportunties for this to happen is seven bytes (three for the GOT leak and four for the libc leak). So if my math is right, that means the odds of a particular Level 4 challenge not being solvable are 1 - (254/255)^(3+4) = 3%. But if the exploit fails, the player can just try again and with ASLR they'll get a new set of addresses. Or I was kind to them, they only have five Level 4 challenges so the odds that all five attempts will just work are still 87%. (I decided I didn't want to add an extra layer of frustration.) 

    I'm pretty sure that there are tools online for creating format strings, but I think they're buggy. A previous iteration of pwntools appeared to have a buggy format string exploit generator. I wrote my own functions to solve this challenge. With any luck this will lead to people identifying the bugs in tools like pwntools and fixing them.

    Questions during testing:

    1. Once we know a password, can users figure out the random seed and guess the next password in the series? How do we make sure this can't happen? (Update: I used to just add 1 to go from one random seed to the next, now I use powmod() in gmpy2 with a large power and large modulus so it's pretty much impossible to predict the next hash.)
    2. Any other ways to break the chain?
    3. The current format string buffer might be sized too generously. 
    4. Is it fun to solve or is it tedious?

    Note to tester: If you want to run the solver, run the following:
    1. In the `challenge` directory, run `python3 generate_challenge.py`. This will generate 50 Docker containers -- 15 Level 1, 15 Level 2, 15 Level 3 and 5 Level 4 challenges -- and will give you the first password.
    2. Copy the first password to the root directory of the solver script after generating the challenges.
    3. In the solver directory, run `solver.py`.

## Written when publishing the repo

To the player: check out some comments at the end of `deployment-script.sh` for how to get this challenge set up and running locally. 
