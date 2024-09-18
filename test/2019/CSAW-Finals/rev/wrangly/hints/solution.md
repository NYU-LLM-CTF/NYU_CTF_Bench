Here is the solution to this CTF:

- Disassemble the binary `unwrangle_me` to see it calls `strfry` and `memfrob` functions
- `strfry` is called first, so it shuffles the flag string in place
- `memfrob` is called an even number of times so it has no impact
- Contact the server to get the shuffled flag
- Unshuffle the flag by guessing different options that make sense
