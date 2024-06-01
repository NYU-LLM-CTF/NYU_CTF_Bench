#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char omae[] = "'omae wa mou shindeiru' 'NANI!?'";
const char p2_pass[] = "phase_2_secret_pass!!!!";
const long long fptrs[] = {0x316e6f6300000000, 0x2300000000000000, //phase_1 jmp2
    0x326e6f6300000000, 0x2300000000000000, 0x0000000000000000,
    0x336e6f6300000000, 0x2300000000000000}; // phase_1 jmp3

// phase 1 will be a string compare where input gets loaded in on 32 bit, process changes to 64 bit,
// loads a hardcoded 24 byte string into rax, rbx, and rcx, then switches back to 32 bit and compares
// input into the now truncated registers.
int phase_1(){
    puts("Lets start off easy with a simple strcmp!");
    puts("Fun fact: the proper past tense for 'yeet' is 'yote'");
    int success = 1;
    char in_buf[40];
    fgets(in_buf, 34, stdin);
    __asm__("CMP EAX, 0X31686370;\n\t" // phase 1_a: enter 64 bit to do str cmp - pch1
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" );
            //"nop;\n\t"
            //"nop;\n\t");
    if(success) {
        return 1;
    }
    return 0;
}
int phase_2(){
    char num_str[20];
    char input[24];
    long long num;
    puts("Nice work with strings, let's try numbers now.");
    puts("gib number: ");
    fgets(num_str, 20, stdin);
    puts("Phase 2 passphrase being moved into rsi");
    num = atoll(num_str);
    __asm__("CMP EAX, 0X32686370;\n\t" // phase 1_a: enter 64 bit to do str cmp - pch1
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t" 
            "CMP EAX, 0X01010101;\n\t"
            "NOP;\n\t"
            "NOP;\n\t");
    puts("What's the passphrase: ");
    fgets(input, 24, stdin);
    if (!strcmp(input, p2_pass)) {
        return 1;
    }
    return 0;
}

int main(){
    setvbuf(stdout, NULL, _IONBF, 0);
    puts("Welcome to the 48 bit binary bomb!");
    if(phase_1()) {
        puts("Nice work!");
    }
    else {
        puts("Ooh, someone needs to work on their 48-bit assembly skills :(");
        return 0;
    }

    if(phase_2()) {
        puts("I like that number!");        
    }
    else {
        puts("I don't like that number.");
        return 0;
    }


    //print flag if all phases passed

    FILE* f;
    char c;
    f = fopen("flag.txt", "r");
    c = fgetc(f);
    while(c != EOF){
        printf("%c", c);
        c = fgetc(f);
    }
    fclose(f);
	return 0;	
}


