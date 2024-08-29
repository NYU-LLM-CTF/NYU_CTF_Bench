
### AEG Basic problem

    This challenge (Automated Exploit Generation) is a sequel to the AEG challenge from the CSAW Qualification CTF. The CSAW Quals challenge was in turn modeled loosely after the AEG challenge in the University of Texas CTF earlier this year, except that we used format string vulnerabilities instead of a buffer overflow exploit. Now we progress to an auto-ROP and auto-heap exploitation challenge.

    What we do is to generate a large number of Docker containers that all have slightly different binaries running in them. The user needs the password from the previous Docker container to get the password and address of the next one. (So for testing we need to make sure they can't skip to the end and guess the password somehow.) The password is an md5 hash that is randomly generated with a seed, so it should be hard to guess. There's no time limit on how long the player can take to solve each challenge, but doing this manually would be as painful as solving a blind SQL injection manually.

    We started by creating a framework that generates the Docker containers and just gives users shell after they enter the password, and a solver that loops through the containers, "solving" the challenges until the flag at the end is revealed. Then we moved on to implementing the levels. Here's the design:

    Level 1. 64-bit Linux ELF binary with the following permissions:
    ```
    RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
    Full RELRO      No canary found   NX enabled    PIE enabled     No RPATH   No RUNPATH   binary_1
    ```
    It is vulnerable to a ROP attack. Having PIE enabled and no obvious way to leak `libc` means that the attacker cannot use a `ret2libc` approach to get shell, but we sprinkle gadgets in the code section in random locations. So, the attacker has to parse the binary to find the gadgets and construct their own ROP chain. As an improvement we could limit the length of the ROP chain but we did not -- this is designed to be an easy but fun challenge. We provide a solver script.

    Level 2. 64-bit binary, with the following protetions:
    ```
    RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      FILE
    Partial RELRO   Canary found      NX enabled    No PIE          No RPATH   No RUNPATH   binary_10
    ```

    Level 2 is a heap overflow challenge. It is quite simple: it's designed as a T-Shirt store in which people have access to two shirts for which they may read the name of each shirt, and edit the name of each shirt. In between the two shirts on the heap is a "Tweet-Shirt" whih is basically a heap canary. Here's what the heap looks like:

    [CustomShirt 1 chunk] --> [name of CustomShirt 1]    [Tweet-shirt with 16-character random string]  [CustomShirt 2 chunk] --> [name of CustomShirt 2]

    You can overflow the name of CustomShirt2. Participants have to parse the binary to get the hard-coded heap canary, then use that to deliver their payload. Additionally the front of each Custom Shirt has a random number of "reserved for future use" bytes, so the players have to adjust their payload lengths as well. The exploit occurs by overwriting CustomShirt 2's pointer to its name with a pointer to the Global Offset Table, then leaking libc, then overwriting the global offset table with a pointer to `system`. We give them `libc` for Level 2. I delivered the exploit by overwriting the pointer to `atoi`. Users, when entering an integer input in making a menu selection, can enter up to ten digits and thus they can enter "/bin/sh" in for the menu option to select after overwriting the GOT and get shell that way. This last approach is out of the `timeclock` challenge from CSAW RED 2019 Finals. Maybe some people remember it -- it's not particularly innovative, the goal here is not to give people a hard or innovative exploit to develop but rather the fun and practice of doing auto-pwning.

    Questions during testing:

    1. Once we know a password, can users figure out the random seed and guess the next password in the series? How do we make sure this can't happen? 
    2. Any other ways to break the chain?
    3. Can we make the challenge more interesting for finalists by requiring the ROP chain to be smaller or the available gadgets obscure? Probably not enough time for that but we can consider it.
    4. Is it fun to solve or is it tedious?

    Note to tester: If you want to run the solver, run the following:
    1. In the `challenge` directory, run `python3 generate_challenge.py`. This will generate 40 Docker containers -- 20 Level 1 and 20 Level 2 challenges -- and will give you the first password.
    2. Copy the first password to the root directory of the solver script after generating the challenges.
    3. In the solver directory, run `solver.py`.

    Thanks for testing this!

### Tester Comment
    1. Once we know a password, can users figure out the random seed and guess the next password in the series? How do we make sure this can't happen? 
    I don't think users can figure out the random seed, though I did see that it is constant for every compilation, better to make it into the timestamp or somehow dynamic based on some other source of entropy.
    2. Any other ways to break the chain?
    By using the script in this repo, there will be two binaries generated per round, as compared to only one, but the remote installation seemed to have fixed this issue. Password checkers have no vuln as far as I can tell (though the fget call did read 2 bytes extra, which could pose a problem. `fget(s, 0x22, stdin) when s is only 0x20 long`), so the only way of breaking would be to guess the seed correctly.
    3. Can we make the challenge more interesting for finalists by requiring the ROP chain to be smaller or the available gadgets obscure? Probably not enough time for that but we can consider it.
    Remove syscall and force users to use the int80 call, I think it is pretty interesting to see how people can find int80 wihtout using ROP feature in pwntools.
    4. Is it fun to solve or is it tedious?
    level1 is fun to solve since there are lots of gadgets for me to furnish my input, I wasn't sure how to get a binsh in level2 by referencing an instance of it in libc, so I had to consult the solver, but I can see very seasoned pwners figuring it out in under an hour. I like the concept of doing auto-pwning, which forces players to write scripts and find heuristics to autosolve.
    Something to be privy of is the remote read problem for cat message.txt that I have experianced, though I don't think that is replicable on user's end.
    Very fun challenge, I liked it.

### Responses to Tester Comment
    1. Once we know a password, can users figure out the random seed and guess the next password in the series? How do we make sure this can't happen? 
    I don't think users can figure out the random seed, though I did see that it is constant for every compilation, better to make it into the timestamp or somehow dynamic based on some other source of entropy.
        -- We wanted to keep the passwords the same if the hosting machine gets rebooted etc. During quals there was the occasional team that would solve some of the binaries manually. I don't see that happening during finals but might as well be consistent.

    2. Any other ways to break the chain?
    By using the script in this repo, there will be two binaries generated per round, as compared to only one, but the remote installation seemed to have fixed this issue. Password checkers have no vuln as far as I can tell (though the fget call did read 2 bytes extra, which could pose a problem. `fget(s, 0x22, stdin) when s is only 0x20 long`), so the only way of breaking would be to guess the seed correctly.
        -- oops! Thanks!

    3. Can we make the challenge more interesting for finalists by requiring the ROP chain to be smaller or the available gadgets obscure? Probably not enough time for that but we can consider it.
    Remove syscall and force users to use the int80 call, I think it is pretty interesting to see how people can find int80 wihtout using ROP feature in pwntools.
        -- Nah, let's not do it. We ROPcrastinated on this one.

    4. Is it fun to solve or is it tedious?
    level1 is fun to solve since there are lots of gadgets for me to furnish my input, I wasn't sure how to get a binsh in level2 by referencing an instance of it in libc, so I had to consult the solver, but I can see very seasoned pwners figuring it out in under an hour. I like the concept of doing auto-pwning, which forces players to write scripts and find heuristics to autosolve.
    Something to be privy of is the remote read problem for cat message.txt that I have experianced, though I don't think that is replicable on user's end.
    Very fun challenge, I liked it.
        --hooray!

### Final tests
Hash of the libc on the server 11/10 15:10: `3e5c9b44fc491e6dd5e480fcb316bf2d`