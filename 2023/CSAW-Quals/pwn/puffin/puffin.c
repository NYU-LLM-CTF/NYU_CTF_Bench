#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);
    
    fflush(stdout);
    fflush(stdin);
    char buffer[0x20];
    int secret_value = 0;

    printf("The penguins are watching: ");
    fgets(buffer, 0x30, stdin);

    if (secret_value) {
        system("cat /flag.txt");
    } else {
        printf("🐧🐧🐧🐧🐧🐧🐧\n");
    }

    return 0;
}
