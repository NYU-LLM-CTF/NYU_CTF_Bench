#include <stdio.h>
#include <stdlib.h>

#define PASSWORDLENGTH 33
#define TRUE 1
#define FALSE 0
#define FILENAME "binary_1.txt"

char* password = "80ff3b7a7b2e64f427cd8e27cb7b41d8";

char equalArrays(char a[], char b[], int size){
    for(int i = 0; i < size; i++){
        if(a[i]!=b[i]){
            return FALSE;
        }
    }
    return TRUE;
}

void printBinary(){
    char c;
    FILE * f;
    f = fopen(FILENAME, "r");
    if(f == NULL){
        puts("Error reading hex of binary");
        exit(0);
    }
    c = fgetc(f);
    while (c != EOF){
        printf("%c", c);
        c = fgetc(f);
    }
    fclose(f);
    return;
}
int password_is_correct(char* user_input){
    return equalArrays(password, user_input, PASSWORDLENGTH-1);
}

int main(int argc, char** argv){
    puts("Welcome to the AEG challenges!");
    char user_input[PASSWORDLENGTH];
    puts("Input password to continue:");
    fflush(stdout);
    fgets(user_input, PASSWORDLENGTH, stdin);
    if (password_is_correct(user_input)){
        puts("Correct password! :)");
        puts("Here is the binary that is currently running on this box: ");
        puts("-------------------------------------------------------------------");
        printBinary();
        puts("-------------------------------------------------------------------");
        fflush(stdout);
        system("/bin/sh");
    }else{
        printf("Incorrect password. :(");
    }
    return 0;
}