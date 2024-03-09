#include <stdio.h>
#include <sys/mman.h>
#include <string.h>
#include "program.h"


extern void mcpu_entry(unsigned long RDI, unsigned long RSI);

void true_main(unsigned long RDI,unsigned long RSI,unsigned long RDX,unsigned long RCX,unsigned long R8,unsigned long R9,unsigned long Stack){
    //printf("Hello world! %d %d %d %d %d %d %d\n",RDI, RSI, RDX, RCX, R8, R9, Stack);

    printf("The Obfusicator Watermark 9000\nAuthor: Joel\nCopyright Memes\n\n\n");

    unsigned long pool = (unsigned long)mmap(NULL, 4096 * 20, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_ANON | MAP_SHARED, -1, 0);

    printf("[Debug] pool: %lx\n", pool);

    pool += 4096;

    memcpy((void*)pool, prog, progsize);

    mcpu_entry(pool + 10 * 4096, pool); // never to return...

}
