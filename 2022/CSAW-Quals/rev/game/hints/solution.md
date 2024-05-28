Here is the solution to this CTF:

- Determine from the `game` binary that it requires input of the hash value of 5 random words from the wordlist
- The hash is computed using FNV 1a 32-bit algorithm
- Run the game and traverse the map to reach a paywall
- Based on the path taken, determine the word and hash it
- Input the hash to unlock the paywall and get the flag
