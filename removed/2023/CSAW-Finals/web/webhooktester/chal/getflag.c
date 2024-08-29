#include <stdio.h>
int main() {
    FILE *file = fopen("/flag.txt", "r");
    char ch;
    while ((ch = fgetc(file)) != EOF) {
        putchar(ch);
    }
    fclose(file);
    return 0;
}
