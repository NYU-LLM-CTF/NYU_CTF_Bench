tacOS.bin:
	$(eval num_sectors := $(shell BLOCKSIZE=512 du $(realpath ) tacOS-base.bin | cut -f1))
	dd bs=512 if=tacOS-base.bin of=tacOS.bin
	dd bs=512 seek=$(num_sectors) if=untrusted-code.bin of=tacOS.bin


# To build from source uncomment:
# tacOS-base.bin: stage-1.asm stage-2.bin
# 	$(eval num_sectors := $(shell BLOCKSIZE=512 du $(realpath stage-2.bin) | cut -f1))
# 	nasm -Wall -D NUM_SECTORS=$(num_sectors) -f bin -o stage-1.bin stage-1.asm
# 	dd bs=512        if=stage-1.bin of=tacOS-base.bin
# 	dd bs=512 seek=1 if=stage-2.bin of=tacOS-base.bin

# stage-2.bin: # Note, not one of the files provided during the competition
# 	nasm -Wall -f bin -o stage-2.bin stage-2.asm

clean:
	rm -f stage-1.bin stage-2.bin untrusted-code.bin
