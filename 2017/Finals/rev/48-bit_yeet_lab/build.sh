gcc bomblab.c -masm=intel -m32 -o bomblab
fasm phase1_64.asm
fasm phase2_64.asm
python patcher.py
