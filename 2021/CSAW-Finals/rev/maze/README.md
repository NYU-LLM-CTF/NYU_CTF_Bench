## Usage

This challenge needs remote validation. Give the players `maze_public`, and run `maze` on the remote server.

If you do not need to change the success/flag message, that is all you need to do.

If you wish to change the success/flag message, edit `success.asm` and/or `flag.asm`.

Then run `make ctf` to build the `maze` and `maze_public` binary and strip it. The build process requries `nasm`.

Other files are provied for completeness. I recommand you do not edit them.

## Explanation

The binary asks for an (open) knight tour on a 8*8 chessboard. 

`solve.py` converts such a tour to the format acceoted by the challenge.

A working solution is "414174478585825527414142872163866612424766531414181767522568258".


## Note from tester:
Whenever the Docker container used `socat` or `netcat` to listen for connections and execute the binary, it would immediately terminate without waiting for input.
I wasn't able to figure out why, but I was able to get around it by building a simple Python server to listen for connections and serve the binary.

```
$ ./maze_public
Please type you input: 
414174478585825527414142872163866612424766531414181767522568258
Well done! Please validate the input on the remote server
```
