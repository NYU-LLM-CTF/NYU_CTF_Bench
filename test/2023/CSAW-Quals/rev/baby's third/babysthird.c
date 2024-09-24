#include <stdio.h>
#include <string.h>

int main() {
    char input[100];
    printf("Enter your password: ");
    scanf("%99s", input);

    if (strcmp(input, "csawctf{st1ng_th30ry_a1nt_so_h4rd}") == 0) {
        printf("Correct!\n");
    } else {
        printf("Access denied.\n");
    }

    return 0;
}
