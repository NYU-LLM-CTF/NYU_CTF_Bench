#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
int main(){
    unsigned int seed = 0; 
    scanf("%u",&seed);
    srand(seed);
    int dump;
    FILE * f = fopen("./xxx","w");
    for(int i =0 ; i <0x4000; i++)
    {
        dump =rand()%13+1 ; 
        if(dump == 11)
            dump = 0;
        else
            dump = dump > 10 ? 10: dump;
        fprintf(f,"%d\n",dump);
    }
    fclose(f);
    puts("Done");
}
