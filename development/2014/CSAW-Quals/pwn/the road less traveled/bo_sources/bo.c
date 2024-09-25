#include <stdio.h>
#include "ctf.h"

struct stack {
	char buffer[128];
	unsigned int flag;
};

int challenge(int fd){
	struct stack s;
	s.flag = 0;

	ctf_writes(fd, "Welcome to CSAW CTF!\n");
	ctf_writes(fd, "Time to break out IDA Demo and see what's going on inside me.  :]\n\n");

	ctf_readsn(fd, s.buffer, 132);

	if (s.flag) {
		if ( (s.flag > 0x7E7E7E7E) ) {
			ctf_writes(fd, "flag{exploitation_is_easy!}");
		}
	}

	return 0;
}

int main(int argc, char **argv, char **env) {
	int fd;

	fd = ctf_listen(1515, IPPROTO_TCP, 0);
	ctf_server(fd, challenge);

	return 0;
}
