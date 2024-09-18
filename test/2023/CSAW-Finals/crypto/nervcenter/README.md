The way `select()` works is you create an `fd_set` and then add file descriptors to it using the `FD_SET()` macro. You can monitor the fds for read, write or exceptions (the last one in practice is only used to indicate TCP OOB data and some weird terminal conditions). Then you call select like:

```c
select(nfds, &readfds, &writefds, &exceptfds, &timeout);
```

And then when it returns you can check the sets using the `FD_ISSET()` macros to find out which fds are in which state.

But what is less well known (though it's documented in the man page) is that the max file descriptor you can monitor this way is hardcoded to `FD_SETSIZE`, which is 1024 – even though modern systems can have many more open files than that:

```
DESCRIPTION
       WARNING: select() can monitor only file descriptors numbers  that  are  less
       than  FD_SETSIZE  (1024)—an  unreasonably low limit for many modern applica‐
       tions—and this limitation will not change.  All modern  applications  should
       instead use poll(2) or epoll(7), which do not suffer this limitation.
```

But it's actually worse than this message indicates. The `fd_set` struct is just a bitset of 1024 bits (128 bytes). So attempting to monitor fds larger than 1024, it will cause memory corruption by writing individual bits past the end of the bitset! Based on asking a couple C programmers I know, the difference between the maximum number of fds enforced by `ulimit` etc. and the `FD_SETSIZE` is not well known.

In the context of a network server, this is especially fun because it means that the exact value you can set in the overflow depends on the status of open network connections; by making a large number of connections and then carefully managing the state they're in, a client can create any bit pattern they want.

So that's the main vuln I'm interested in using. The question is what a fun way to deploy it in a challenge would be. Here are some initial ideas I had:

- Have the overflow be on `exceptfds`, so that the bit pattern is only controllable by sending TCP OOB data on different connections.
- We can limit the range of the overflow (how many bits past 1024 are controllable) by setting a ulimit on the challenge binary, so e.g. if we set it to 1025 they get only one bit of control.
- What should the target of the overflow be? Heap metadata and or some stack struct or function pointer are obvious candidates. But it might be more fun to put something like a cryptographic key there, so that players have to create their own key using the connection status and then having them brute force the remaining bits.
- Elaborating on the crypto idea, another possibility is to only allow a partial key overwrite of a symmetric key and then require a brute-force on the remaining bits.
- Getting even more elaborate with the crypto portion, we could have the bit corruption set some bits in an RSA public key modulus (N). Then using the technique in this paper (Section 3) https://www.usenix.org/system/files/conference/usenixsecurity16/sec16_paper_razavi.pdf the public key becomes easy to factor, allowing decryption.
