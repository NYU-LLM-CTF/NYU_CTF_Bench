BIN=ldw_util
CC=musl-gcc
CFLAGS=-Wall -Wextra

.PHONY: all clean

all: $(BIN)

install: all
	cp $(BIN) ../../ramdisk/
ifneq ($(NOSAVE),yes)
	cd ../..; ./save.sh
endif

clean:
	rm -f *.o $(BIN)

$(BIN): $(BIN).o ldw_rules.o ldw_interactive.o ldw_file.o
