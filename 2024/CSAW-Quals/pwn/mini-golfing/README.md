# mini-golfing
`csawctf{I_doNT_want_t0_g0_901FING_AnymOrE_pl34S3_Thank_you_!!!}`

## Description
Classic pwn "golf" challenge where a program allows to jump to whatever value you give it, except that there is PIE and ASLR blocking static address values. 

compilation: `gcc main.c -o golf -fno-stack-protector`

## Solve
Notice that the address of win in a decompiler will most likely be different than what is going on when running the program. The addresses are being randomized by ASLR / PIE and therefore require a different way to get to the win function

Simply leak out the main function address using format string `%p` and then using a debugger / decompiler calculate the offset of the main function address and the win function address. It should give an offset of `-26`. Simply subtract 26 from the address of main and call the win function when the program prompts you to.

An example solve script is in `solve.py`