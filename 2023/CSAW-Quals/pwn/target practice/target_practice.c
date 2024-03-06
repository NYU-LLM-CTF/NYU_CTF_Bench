#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void cat_flag(){
    system("cat /flag.txt");
}

int main() {
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);
            
    fflush(stdout);
    fflush(stdin);

    uintptr_t address;

    printf("Aim carefully.... ");
    scanf("%lx", &address);

    void (*target)(void) = (void(*)(void))address;

    target();

    return 0;
}
