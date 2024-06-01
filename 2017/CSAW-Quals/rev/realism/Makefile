main.bin: main.s
	nasm -f bin -o main.bin main.s

run: main.bin
	xxd main.bin
	qemu-system-i386 -drive format=raw,file=main.bin

dbg: main.bin
	xxd main.bin
	qemu-system-i386 -S -s -drive format=raw,file=main.bin
