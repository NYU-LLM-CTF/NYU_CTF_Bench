CC = gcc
CFLAGS = -Wall -Wextra
LDFLAGS = 

SRC_FILES = $(wildcard *.c)
OBJ_FILES = $(patsubst %.c, %.o, $(SRC_FILES))
EXECUTABLE = my_program

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJ_FILES)
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJ_FILES) $(EXECUTABLE)

.PHONY: all clean
