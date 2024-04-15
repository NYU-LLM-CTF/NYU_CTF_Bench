mqtt: ctf.o
	$(CC) -I. -g -gdwarf-2 -O0 -m32 $^ -o $@

%.o : %.c
	$(CC) -I. -g -gdwarf-2 -O0 -m32 -c $< -o $@

clean:
	rm -f mqtt *.o

all: mqtt

install:
	rm -rf lava-install
	mkdir lava-install
	cp mqtt lava-install/

