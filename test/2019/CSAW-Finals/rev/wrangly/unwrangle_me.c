#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>


void win() {

    int i = 0;
    FILE *file;

    char flag[22];
    char *wrangled;

    file = fopen("flag.txt", "r");
    if (!file)
	exit(-1);
    fgets(flag, sizeof(flag), (FILE*) file);

    // wranglin' it up!
    strfry(flag);
    for (int i = 0; i <= 13; i++)
	memfrob(flag, sizeof(flag));

    printf("%s\n", flag);
}


int main() {
    printf("Alright, you win!\n");
    win();
}
