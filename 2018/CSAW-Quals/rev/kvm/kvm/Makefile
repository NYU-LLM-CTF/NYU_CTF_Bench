CFLAGS = -Wall -Wextra -Werror

challenge: challenge.o payload.o ../chal/guest-tbl.o
	$(CC) $^ -o $@ $(CFLAGS)
	strip challenge

challenge.o: challenge.c
	$(CC) -c challenge.c $(CFLAGS)

payload.o: payload.ld guest.o
	$(LD) -T $< -o $@

guest.o: ../chal/guest.img
	$(LD) -b binary -r $^ -o $@

.PHONY: clean
clean:
	$(RM) challenge challenge.o payload.o guest.o
