#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void run_cmd(char * cmd){
    system(cmd);
}

int main(int argc, char ** argv){
    struct { //order enforcement from josh offsec
        char buf[17];
        int32_t x;
        int32_t y;
    } _holder = {
        {0},
        0xdeadbeef,
 	}; 
    puts("Are you a big boiiiii??");
    read(0,_holder.buf, 0x18);
    if (_holder.x == 0xcaf3baee)
        run_cmd("/bin/bash");
    else{
        run_cmd("/bin/date");
    }
    return 0;
}
