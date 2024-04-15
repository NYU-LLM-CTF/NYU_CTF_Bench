
CC = gcc
CFLAGS = -Wall -Wextra -fstack-protector-all -Wstack-protector -fstack-clash-protection -no-pie -Wl,-z,relro,-z,now -Wl,-z,noexecstack -D_FORTIFY_SOURCE=2 -lcrypto
ONAME = tvm

.SILENT:

all: clean
	${CC} ${CFLAGS} tvm.c -o ${ONAME} && \
	strip ${ONAME}

clean:
	rm -f ${ONAME}

