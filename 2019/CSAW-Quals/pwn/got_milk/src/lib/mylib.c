#include "mylib.h"


void win(void)
{
	int c;
	FILE *file;
	file = fopen("flag.txt", "r");
	if (file) {
		while ((c = getc(file)) != EOF)
			putchar(c);
		fclose(file);
	}
}


void lose(void)
{
	__asm__ goto (""::::win);
	goto fail;

	// sike!
	win:
		win();

	fail: ;
	printf("\nNo flag for you!\n");
}
