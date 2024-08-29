losing_my_marbles: circ.c main.c common.c Makefile
	clang -o losing_my_marbles circ.c main.c common.c -O0 -lcrypto -march=native
	strip losing_my_marbles

debug: circ.c main.c common.c Makefile
	gcc -g -o debug circ.c main.c common.c -O0 -lcrypto

circ.c: circ.py Makefile
	python circ.py


.PHONY : clean
clean:
	rm -f circ.c losing_my_marbles
