#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#define PASSWORDLENGTH 32
#define TRUE 1
#define FALSE 0
#define BINARYNAME "binary_1.txt"

#define CONTENTLENGTH 200


char* password = "c43277249e73244ed4ec051363fac62d";

int report_number;


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
    f = fopen(BINARYNAME, "r");
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

int password_is_correct(char* user_input, char* password){
    return equalArrays(password, user_input, PASSWORDLENGTH-1);
}

void runChallenge(){
    char userinput[CONTENTLENGTH];
    //report_number = 0;
    int * report_number_location = &report_number;
    //void ** printf_GOT;
    //void * GOT_page_start;
    printf("*** Procrastination Simulator Level Four ***\n\n");
    while (report_number < 3){
        printf("   Help! I need to write twenty reports by Sunday afternoon and I'm doing four reports at once. Give me some content and I will generate Report %d in this batch!!", *report_number_location+1);
        puts("");
        printf("> ");
        fflush(stdout);
        fgets(userinput, CONTENTLENGTH, stdin);
        printf("Thanks! Here are the contents of report %d:\n", *report_number_location+1);
        printf(userinput);
        puts("Time to go write this!");
        report_number += 1;
        memset(userinput, 0, CONTENTLENGTH);
    }

    exit(0);
}

int main(int argc, char **argv){
    puts("Welcome to the AEG challenges!");
    char user_input[PASSWORDLENGTH];
    puts("Input password to continue:");
    printf("> ");
    fflush(stdout);
    fgets(user_input, PASSWORDLENGTH+2, stdin);
    if (password_is_correct(user_input, password)){
        puts("Correct password! :)");
        puts("Here is the binary that is currently running on this box: ");
        puts("-------------------------------------------------------------------");
        printBinary();
        puts("-------------------------------------------------------------------");
        puts("\nProceeding to the challenge...\n");
        fflush(stdout);
        runChallenge();
    }else{
        printf("Incorrect password. :(");
    }
    //system("/bin/sh");
    return 0;
}


