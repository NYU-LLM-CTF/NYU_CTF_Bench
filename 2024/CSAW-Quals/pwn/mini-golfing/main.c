#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define MAX_STRINGS 32

void win() {
    system("cat /flag.txt");
}

int main() {
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);
            
    fflush(stdout);
    fflush(stdin);

    uintptr_t address;
    char *all_strings[MAX_STRINGS] = {NULL};
	char buf[1024] = {'\0'};

    printf("Welcome to PWN GOLF.\n");
    printf("Would you like to enter your name? ");
   
    fgets(buf, 1024, stdin);
    printf("hello: ");
	printf(buf);
   
    printf("\nAlright! Tell me the address you want to aim at!: ");
    scanf("%lx", &address);
    void (*target)(void) = (void(*))address;
    printf("Ok jumping to that address...");
    target();

    return 0;
}


