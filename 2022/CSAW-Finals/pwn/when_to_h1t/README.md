# when-to-h1t

The player must beat the dealer in a black jack game with house rules more than or equal to 75 times out of 100 rounds.

If player satisfies the above condition, the program prompts the user for inputs which exposes snprintf out-of-bounds vulnerability which can be used to pivot the stack.

The intended solution is to pivot the stack correctly where it leads to the return sled and ROP payload.

Additionally, the player with the highest win rate can edit the king-of-hill and message file in the challenge container which is printed when other players invoke the challenge.

# Solution

Script is in solution dir, success rate: about 1/512

1. The random seed is easy to get so that we can know all the generated number
2. Create a strategy to win more than 80 games in any round
3. snprintf OOB
4. Pivot the Stack 
5. ROP
