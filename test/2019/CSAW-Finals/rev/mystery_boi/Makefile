CC=gcc
CFLAGS=-Wall -fPIC -no-pie -m64 -s

all: modules mystery_boi

mystery_boi: mloader.c
	$(CC) $(CFLAGS) -pthread mloader.c -ldl -o mystery_boi; mv mystery_boi distribute

modules:
	$(CC) -Og -nostdlib -c mystery_bois/*.c; mv *.o mystery_bois; bash dump_text.sh; mv boi* distribute

clean:
	rm mystery_bois/*.o distribute/boi* distribute/mystery_boi
