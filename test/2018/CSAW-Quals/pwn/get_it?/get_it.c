#include <stdio.h>
#include <stdlib.h>

void give_shell(){
    system("/bin/bash");
}

int main(int argc, char ** argv){
    char buf[20];
    puts("Do you gets it??");
    gets(buf);
}
