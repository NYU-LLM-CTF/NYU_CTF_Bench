all: guest.img

guest.img: guest.o dont_obf.o obf.o huffman.o
	$(LD) -T guest.ld $^ -o $@
obf.o: obf.c
	../../obfuscator-build/bin/clang -mllvm -fla -m64 -ffreestanding -fno-pic -c -o $@ $^
huffman.o: huffman.c
	$(CC) -m64 -ffreestanding -fno-pic -c -o $@ $^
dont_obf.o: dont_obf.c
	$(CC) -m64 -ffreestanding -fno-pic -c -o $@ $^
guest.o: guest.c
	$(CC) -m64 -ffreestanding -fno-pic -c -o $@ $^
tbl: guest-tbl.c
	$(CC) guest-tbl.c -c

clean:
	rm -f guest.o guest-tbl.o dont_obf.o obf.o huffman.o
.PHONY: clean
