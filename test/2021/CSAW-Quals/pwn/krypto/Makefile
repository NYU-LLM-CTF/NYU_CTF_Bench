obj-m += krypto.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -f solve

solve: solve.c
	$(CC) solve.c -o solve -pthread
