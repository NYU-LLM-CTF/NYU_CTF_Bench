CC		=	gcc
BIN 	=	got_milk

FLAGS 	= 	-m32 -fno-stack-protector -no-pie -g

all:
	$(CC) $(FLAGS) -c lib/mylib.c -o lib/mylib.o
	$(CC) $(FLAGS) -shared lib/mylib.o -o lib/libmylib.so
	$(CC) $(FLAGS) -Ilib -Llib binary.c -o $(BIN) -lmylib

clean:
	rm $(BIN)
	rm lib/mylib.o
	rm lib/libmylib.so
