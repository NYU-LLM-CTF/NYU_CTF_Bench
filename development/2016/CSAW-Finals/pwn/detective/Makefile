CC=gcc
CFLAGS=-fpic -pie -m32 -Wl,-z,relro,-z,now -z execstack -Wall 

detective.o: detective.c
	$(CC) $(CFLAGS) -o detective detective.c

clean:
	rm *o detective

