#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void win(void) {
    int c;
    FILE *file;
    file = fopen("not_even_real.txt", "r");
    if (file) {
        while ((c = getc(file) != EOF))
            putchar(c);
        fclose(file);
    }
}

int main(int argc, char *argv[]) {
    printf("Just another innocent application, nothing to see here!\n");
	win();
}
