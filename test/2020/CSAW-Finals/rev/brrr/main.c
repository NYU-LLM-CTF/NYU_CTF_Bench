#include <stdio.h>
#include <stdlib.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <unistd.h>
#include "antifuzz.h"


void init()
{
    setvbuf(stdout, NULL, _IONBF, 0);
}

//Straight from
//https://github.com/RUB-SysSec/antifuzz/blob/master/antifuzz_test.c

int check(char* fileContent, int filesize)
{
    uint8_t* flag[] = {antifuzzBigZ, antifuzzLittleM, antifuzzLittleX, antifuzzLittleH, antifuzzBigZ, antifuzzDigit3, antifuzzLittleT, antifuzzLittleZ, antifuzzLittleD, antifuzzBigW, antifuzzBigN, antifuzzLittleO, antifuzzBigX, antifuzzDigit3, antifuzzBigB, antifuzzLittleY, antifuzzBigM, antifuzzBigW, antifuzzDigit0, antifuzzLittleX, antifuzzLittleD, antifuzzBigD, antifuzzBigF, antifuzzDigit2, antifuzzBigM, antifuzzDigit1, antifuzzDigit9, antifuzzDigit0, antifuzzBigM, antifuzzDigit2, antifuzzBigN, antifuzzLittleO, antifuzzLittleB, antifuzzLittleJ, antifuzzBigB, antifuzzLittleS, antifuzzBigM, antifuzzBigG, antifuzzLittleD, antifuzzDigit5, antifuzzLittleF, antifuzzBigQ, antifuzzLittleO, antifuzzEqual};

    if (filesize < sizeof(flag)/sizeof(flag[0]))
        return 0;

    int i = 0;
    for (int i = 0; i < sizeof(flag)/sizeof(flag[0]); ++i)
    {
        if (!antifuzz_char_equal(fileContent[i], flag[i]))
            return 0;
    }
    return 1;
}

int main()
{
    init();
    antifuzz_init("brrrito", FLAG_ALL);

    FILE *f = fopen("brrrito", "r");
    if (!f)
    {
        printf("No file found\n");
        return -1;
    }
    fseek(f, 0L, SEEK_END);
    unsigned int filesize = ftell(f);
    fseek(f, 0L, SEEK_SET);
    unsigned char *fileContent = (unsigned char*)malloc(filesize);
    filesize = antifuzz_fread(fileContent, 1, filesize, f);

    if(check(fileContent, filesize)) {
        printf("yay");
        __builtin_trap();
    } else {
        printf("nay");
        antifuzz_onerror();
    }

    return 0;
}
