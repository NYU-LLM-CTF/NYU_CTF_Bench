BIN_NAME=shellpointcode
OPTIONS=-Wall -fno-stack-protector -zexecstack


all: chal

chal:
	gcc $(OPTIONS) -o $(BIN_NAME) $(BIN_NAME).c

run: chal
	./$(BIN_NAME)
