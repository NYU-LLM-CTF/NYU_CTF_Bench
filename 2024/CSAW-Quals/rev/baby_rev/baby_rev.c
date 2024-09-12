#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


char flag[20][8];

void init();

int check_message(char* buffer);

int main(int argc, char** argv) {
    char buffer[0x90];
    setvbuf(stdout, NULL, _IONBF, 0);

    init();
    puts("\nThe flag is hidden nearby.\nI can help you check if you got it right!\n");
    printf("> ");
    fgets(buffer, sizeof(buffer), stdin);
    buffer[strcspn(buffer, "\n")] = '\0';

    if (check_message(buffer)) {
        puts("\nNice Job! You got it!");
        puts("Can you read it?\n\n");
        return EXIT_SUCCESS;
    }
    puts("\nNah! That doesn't look like the flag!\n");
    return EXIT_FAILURE;
}


void init() {
    unsigned char data[][8] =
    #include "data.h"

    for (int i = 0; i < 16; i++) {
        for (int j = 0; j < 8; j++) {
            flag[i][j] = data[i][j];
        }
    }
}

int check_message(char* buffer) {
    for (int i = 0; i < 16; i++) {
        for (int j = 0; j < 8; j++) {
            if (*(buffer + j + (i * 8)) != flag[i][j])
                return 0;
        }
    }

    if (strlen(buffer) != 128)
        return 0;

    return 1;
}

