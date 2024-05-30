all: phase4

phase4:
	fasm phase4_64.asm

disasm:
	objdump -bbinary -m i386:x86-64 -Mintel -D phase4_64

clean:
	rm -f phase4_64
