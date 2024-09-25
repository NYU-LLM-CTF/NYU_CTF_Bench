CC = gcc
CFLAGS = -g -Wall -Wshadow -Wextra -std=c99 -m32
DEFINES = -D_GNU_SOURCE

stfu: stfu.c
	$(CC) $(CFLAGS) $(DEFINES) stfu.c -o stfu

release: stfu
	strip -s stfu

clean:
	rm -rf stfu

.PHONY: clean release

