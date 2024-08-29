#include <stdio.h>

static char* key_to_send = "\x42\x3b\x16\x51\x05\xbd\xaa\xff\x27\xdb\x3b\x5d\x22\x34\x97\xea\x54\x9f\xdc\x4d\x27\x33\x08\x08\xf7\xf9\x5d\x95\xb0";

void function_to_send(char *input, char *output){
    for (int i = 0; i < 29; i++){
        if (i % 2 == 0)
            output[i] = input[i] ^ (key_to_send[i] - 3);
        else if (i % 3 == 0)
            output[i] = input[i] ^ (key_to_send[i] + 5);
        else
            output[i] = input[i]^key_to_send[i];
    }

    output[29] = '\x00';
}


int main(){
    unsigned char input[29] = "\x59\x57\x72\x31\x79\xce\x94\x8d\x15\xd4\x54\x02\x7c\x5c\xa0\x83\x3d\xac\xb7\x2a\x17\x67\x76\x38\x98\x8f\x69\xe8\xd0";
    unsigned char output[30];

    function_to_send(input, output);

    printf("%s\n",output);

    return 0;
}