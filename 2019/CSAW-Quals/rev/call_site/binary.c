/*
 *		Name:		call_site
 *		Author:		Alan Cao
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#define __USE_GNU
#include <signal.h>
#include <sys/ucontext.h>


typedef struct {
    void (*callsite)(char *);
	char * key;
} func_handler;


/* signal handler, immediately exits when catching SIGSEGV */
void lose(int num, siginfo_t * si, void *vcontext)
{
	ucontext_t * context = (ucontext_t *) vcontext;
	context->uc_mcontext.gregs[REG_RIP]++;

	printf("Wrong!\n");
	exit(1);
}


void win(char *key)
{
	/* finally, check if hashed key is valid */
	if (strcmp(key, "aaGr6xly5gT42")) {
		printf("Wrong!\n");
		exit(1);
	}

	int c;
	FILE *file;
	file = fopen("flag.txt", "r");
	if (file) {
		while ((c = getc(file)) != EOF)
			putchar(c);
		fclose(file);
	}
}


void handler(func_handler fh)
{
	fh.callsite(fh.key);
}


void help(const char *bin)
{
	fprintf(stderr, "Usage: %s <addr> <key>\n", bin);
	exit(1);
}


int main(int argc, char **argv)
{
	if (argc < 3)
		help(argv[0]);

	struct sigaction action;

	memset(&action, 0, sizeof(struct sigaction));
	action.sa_flags = SA_SIGINFO;
	action.sa_sigaction = lose;
	sigaction(SIGSEGV, &action, NULL);

	unsigned long addr;
	func_handler fh;

	/* crypt plaintext key */
	fh.key = crypt(argv[2], "aa");

	/* load address */
	sscanf(argv[1], "%lx", &addr);
	fh.callsite = (void *) addr;

	handler(fh);
	return 0;
}
