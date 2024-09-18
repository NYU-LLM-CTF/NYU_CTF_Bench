# Bitwise Overflow

Do we need to have some way to let the client make a bunch of connections without select being called? Each time after select() is called we zero the set (fine since FD_ZERO doesn't overflow) and then use FD_SET to re-add them to the set, which sets the corresponding bit to 1. So during setup we will overflow and set the target data to 0xFF...

Maybe using exceptfds helps here? If we don't handle the OOB data, then it will just get reset to the outstanding bit pattern every time, so it will flip between 0xFF and the bit pattern the client sets.

Yes! If the client never sends non-OOB data and the server never processes the OOB data then select sets readfds to all 0s and we can put whatever we want in exceptfds by sending OOBs.

UPDATE: it's not quite as nice as I hoped. `select()` operates on longs, and it appears to zero out everything except the fds that are actually set. So at least 64 bits will always be overwritten, but if the ulimit max fd is less than 1024+64 not all of those bits will be settable by the attacker. Might have to see if I can peek at the implementation at some point to understand where/why that happens and whether it can be avoided somehow.

# Questions

- IMPORTANT: What is a great name for this challenge? Ideally a pun that combines:
    - Sockets/bitwise operations
    - RSA or cryptography
    - Evangelion
- Does the kernel actually write beyond FD_SETSIZE? YES
- How to get key in a overflowable format? Maybe just copy N into a fixed-size buffer after generating it?
- Control MSB or LSB?
    - Need to do empirical tests: if we try (say) all 2^5 possible 5-bit overflows, how many are factorable in 30 minutes?
        - LSB did somewhat better (24/128 solved vs 19/128 solved) BUT this is misleading because keys where the LSB is 0 (i.e., even numbers) are basically useless--OpenSSL rejects them because it uses Montgomery multiplication, which requires an odd key.
    - Regen key every time they connect?
        - Yes, for now anyway.
- Would elliptic curve signatures work better?
- Rowhammer paper also has attack on DH key exchange, hmm...

# RSA bit fault

For a 1024-bit RSA key, it seems like ~14% of the 7-bit patterns (19/128) result in a key that can be factored very quickly (less than a minute).

Idea from Tommaso Gagliardoni of Kudelski Security: instead of allowing most/least significant bits of N itself to be modified, instead have the exploit let you *extend* the key by a few bytes in the MSB. From email:

> I hadn't thought of the idea of adding MSBs, that could be very interesting! And potentially doable in a fairly "natural" way, by letting them corrupt not the modulus itself, but a 32-bit length field placed before the modulus (this format is in fact what's already used by the mpint data type in the SSH RFC, so it would be unremarkable). This would let them extend the key by a few bytes; the MSBs would be arbitrary data sitting in adjacent memory but I could arrange to have it be something random like a nonce or IV. Thanks for the idea!

If the key format is little endian and we have:

```
[fdset][keylength][keybytes][otherdata]
```

Then overflowing by a tiny bit (maybe only 1-2 bits) allows you to change the length of the key. If we choose the key size carefully so that the length's LSB starts out as zero then corruption can only increase the key length, causing the first couple bytes of `otherdata` to become part of the key. Very nice.

I'm currently running 1-byte extension factorization tests. So far 12/52 can be factored within 60 seconds so it is viable. However, due to the discovery that we have to overwrite 8 whole bytes it's not quite as elegant as I hoped; since they can at least zero 8 bytes they could wipe out the whole length field and drastically *shorten* the key. We can probably hack around it by adding a sanity check in RSA_verify that requires length to be 1024..2048 or something like that though...


# Aesthetics

Scenario is a terminal interface to the [Magi supercomputers from Evangelion](https://evangelion.fandom.com/wiki/Magi). When you connect, it generates a public/private key pair and tells you that the private key will be given to you **out of band**; consult [Dr. Akagi](https://evangelion.fandom.com/wiki/Ritsuko_Akagi) for details (this part is a lie, but the phrase "out of band" is a hint). Aesthetics will be xterm-256color compatible screenshots from the show (what terminal width? Say 100 chars):

* NERV logo on login - DONE
* Screenshot of MAGI interface
* Flag: happy group scene with flag text embedded
* Failed auth attempt: Asuka "pathetic" - DONE
* Maybe we can serve up images of the angels on the client ports? Currently they are somewhat useless.
* Easter eggs: hidden menu option for credits
* Terminal graphics turns out to be surprisingly well studied. Links:
    * notcurses (should have figured Nick Black would have done this)
    * https://github.com/dankamongmen/notcurses/issues/1223
    * https://github.com/csdvrx/derasterize
    * https://hpjansson.org/chafa/
    * mpv tct backend https://github.com/mpv-player/mpv/blob/master/DOCS/man/vo.rst
        * Might get replaced with notcurses: https://github.com/mpv-player/mpv/issues/8344
* Bummer on all the terminal graphics stuff is that the Mac Terminal sucks and is limited to xterm-256color and not much in the way of fancy stuff. Potentially we can have another hidden easter egg to enable 24-bit color graphics (with the caveat that it's up to them to figure out if they can handle it).
* If using notcurses will have to figure out how to dump one of their rendering planes out to a file instead of showing on the terminal. Maybe can just ask Nick Black directly.

# Stray Thoughts

- Inspirations:
    - This QEMU bug: https://lists.nongnu.org/archive/html/qemu-devel/2013-01/msg04655.html which I also ran into when doing Malrec. I still wonder if it is exploitable from within a VM, at least if slirp is enabled?
        - https://news.ycombinator.com/item?id=27216242 => https://0pointer.net/blog/file-descriptor-limits.html
        - Some fun previous CVEs:
            - https://arthurdejong.org/nss-pam-ldapd/CVE-2013-0288 (nss-pam-ldapd)
            - https://www.openwall.com/lists/oss-security/2015/02/06/4 (fcgi)
            -
    - Flip feng shui paper

# TODO

- Playtest. Too hard? Too easy? [IN PROGRESS]

# Done

- Finish and test byte extension variant of the chal [NOT DOING]
- Check w/ CSAW infra people to make sure this port setup is ok [DONE]
- Add administrator menu with some goodies (including flag) [DONE]
- Fuzz, tests, everything you can think of. This thing is a LOT of C code... [DONE]
- Bling up that UI [DONE]
- Consider other functionality for client thread, like actually reading the OOB data (allows bits to be cleared instead of just set) [DONE]
- Test the multi-bit vs the sequential solver
    - DONE; sequential is slightly more reliable
- Sanity checks on key (ban leading zeros?) [DONE]
- Check for fd leaks. Ideally don't want to have to restart the whole server just so that the fds all get cleaned up [DONE]
- Maybe the flag should be transmitted as an image encrypted with the (corrupted) private key? [DONE]
- Hook up a debugger - *why* are all 8 bits getting cleared?
    - Happening inside the kernel, don't exactly know how. Not under our control, though.
    - Done I guess?
