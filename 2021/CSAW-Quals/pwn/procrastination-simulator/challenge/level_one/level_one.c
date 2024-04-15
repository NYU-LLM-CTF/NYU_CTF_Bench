#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>


#define PASSWORDLENGTH 32
#define TRUE 1
#define FALSE 0
#define BINARYNAME "binary_1.txt"

#define CONTENTLENGTH 400
extern void *_GLOBAL_OFFSET_TABLE_;
#define PRINTF_GOT_OFFSET 4

char* password = "c43277249e73244ed4ec051363fac62d";


void function1(){
    exit(0);
}
void function2(){
    exit(0);
}
void function3(){
    exit(0);
}
void function4(){
    exit(0);
}
void function5(){
    exit(0);
}
void win(){
    system("/bin/sh");
    exit(0);
}
void function6(){
    exit(0);
}
void function7(){
    exit(0);
}
void function8(){
    exit(0);
}
void function9(){
    exit(0);
}
void function10(){
    exit(0);
}

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

int password_is_correct(char* user_input){
    return equalArrays(password, user_input, PASSWORDLENGTH-1);
}

void runChallenge(){
    char userinput[CONTENTLENGTH];
    //void ** printf_GOT;
    //void * GOT_page_start;
    printf("*** Procrastination Simulator Level One ***\n\n");
    printf("   Help! I need to write forty reports by Sunday afternoon. Give me some content and I will generate a report!!");
    puts("");
    printf("> ");
    fflush(stdout);
    fgets(userinput, CONTENTLENGTH, stdin);
    puts("Thanks! I\'ll work with the following:\n");
    printf(userinput);
    puts("Time to go write this!");
    exit(0);

    // head of the GOT, points to _DYNAMIC
    //printf("_GLOBAL_OFFSET_TABLE = %p\n", &_GLOBAL_OFFSET_TABLE_);
    //printf_GOT = (&_GLOBAL_OFFSET_TABLE_)+PRINTF_GOT_OFFSET;
    // location of printf in the GOT
    //printf("_GLOBAL_OFFSET_TABLE = %p\n", printf_GOT);// + 4*sizeof(void *))); // Should be printf
    // This prints the location of printf in libc
    //printf("_GLOBAL_OFFSET_TABLE = %p\n", *printf_GOT);// + 4*sizeof(void *))); // Should be printf

    // Overwrite the pointer to printf in the GOT with null bytes. Make the memory writeable first
    //GOT_page_start = (void *) ((long unsigned)(printf_GOT) - (long unsigned)(printf_GOT) % 0x1000);
    //printf("Changing memory protection at address %p\n", GOT_page_start);
    //mprotect(GOT_page_start, 0x1000, PROT_READ | PROT_WRITE);
    //printf("Writing null pointer...\n");
    //*printf_GOT = 0;
    //printf("Writing complete.\n");
    //mprotect(GOT_page_start, 0x1000, PROT_READ);
    //printf("Memory protected.\n");

    // Future calls to printf will now seg fault.
    //printf("_GLOBAL_OFFSET_TABLE = %p\n", *printf_GOT);// + 4*sizeof(void *))); // Should be printf
    //return;
}

// This is the template but we want the generator for this code to use command-line arguments to populate these fields:
// 1. DOCUMENT
int main(int argc, char **argv){
    puts("Welcome to the AEG challenges!");
    char user_input[PASSWORDLENGTH];
    puts("Input password to continue:");
    printf("> ");
    fflush(stdout);
    fgets(user_input, PASSWORDLENGTH+2, stdin);
    if (password_is_correct(user_input)){
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


