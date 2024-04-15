CC=musl-gcc
CXX=musl-g++
CFLAGS=-Wall -Wextra -fno-pie
LDFLAGS=-no-pie

all: exp-race rooter root-exp

clean:
	rm -f exp-race rooter root-exp *.o


root-exp: root-exp.o ../whitelist/libldw/ldw_rules.o

%: %.asm
	nasm $^
