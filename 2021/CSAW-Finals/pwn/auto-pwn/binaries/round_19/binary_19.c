
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <unistd.h>
    #include <sys/mman.h>

    #define PASSWORDLENGTH 32
    #define TRUE 1
    #define FALSE 0
    #define BINARYNAME "binary_19.txt"

    #define CONTENTLENGTH 150

    char* password = "e8003fc36aa0b5abbf48d5b764de9080";
    char* shell = "/bin/sh";


    
        void foo1(){
        	asm volatile(
        		"pop %rsi\n"
            		"ret\n"
        	);
        }

        
        void foo2(){
        	asm volatile(
        		"pop %rdi\n"
            		"ret\n"
        	);
        }

        
        void foo3(){
        	asm volatile(
        		"movq %rax, (%rdx)\n"
            		"ret\n"
        	);
        }

        
        void foo4(){
        	asm volatile(
        		"xor %rax, %rax\n"
            		"ret\n"
        	);
        }

        
        void foo5(){
        	asm volatile(
        		"int $0x80\n"
            		"ret\n"
        	);
        }

        
        void foo6(){
        	asm volatile(
        		"pop %rdx\n"
            		"ret\n"
        	);
        }

        
        void foo7(){
        	asm volatile(
        		"pop %rax\n"
            		"ret\n"
        	);
        }

        
        void foo8(){
        	asm volatile(
        		"syscall\n"
            		"ret\n"
        	);
        }

        
        void foo9(){
        	asm volatile(
        		"inc %rax\n"
            		"ret\n"
        	);
        }

        
        void foo10(){
        	asm volatile(
        		"movl $0xf, %eax\n"
            		"ret\n"
        	);
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
        char s;
        gets(&s);
        return 0;
    }

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
            printf("Main is at %lx\n", **(main));
            fflush(stdout);
            runChallenge();
        }else{
            printf("Incorrect password. :(");
        }
    }
    