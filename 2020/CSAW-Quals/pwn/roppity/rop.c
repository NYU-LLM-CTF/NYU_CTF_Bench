#include <stdio.h>

void init() {
    setvbuf(stdout, NULL, _IONBF, 0);
}

int main() {
    char buf[0x20];
    init();
    puts("Hello");
    gets(buf);
}
