Here is the solution to this CTF:

- Read the provided launcher.py and see that it sets `LD_PRELOAD` to load the provided file
- Compile a fake library with a hijacked `__libc_start_main` that dumps the contents of `./mystery_boi` binary
- Launch an HTTP server to serve this binary and provide the URL to the challenge server with `nc`
- Obtain and analyze the `./mystery_boi` binary along with the `boi*` binaries
- Run a side-channel analysis on number of instructions executed to brute-force the flag one character at a time
