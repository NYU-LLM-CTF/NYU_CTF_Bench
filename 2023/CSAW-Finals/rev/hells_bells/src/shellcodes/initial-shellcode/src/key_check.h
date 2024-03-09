#ifndef SHELLCODE_CSAW_CHALLENGE1_H
#define SHELLCODE_CSAW_CHALLENGE1_H

#include "util.h"


char * check_key(void * rust_call_space, Oracle * oracle) {
    //    So this readlines call takes some argument. Seems like it is just some allocated space
    //    (even though if you look in the Rust code, no arguments are passed).
    //    To mess with them, I allocate the space in the previous sub and since this is the first call, it will
    //    pass the correct value `ecx` from rust_call_space.

    //    Basically this function will read a line from the console, take the string between all the "_"s, and XOR
    //    them with the first character from the string. Each string needs to be a single character.

    //    The key here is: r_0_L_l_1_n_g_-_t_H_u_n_d_3_r_r_

    typedef char** readLines();
    typedef void call();
    auto** rl = (readLines**)((char *)(oracle->CurrentMod) + 0xC910);
    char * line = (*((*rl)() + 0x1));

    int keys[] = {0xb1,0xf3,0x8f,0xaf,0xf2,0xad,0xa4,0xee,0xb7,0x8b,0xb6,0xad,0xa7,0xf0,0xb1,0xb1};

    for (int i = 1; i < 17; i++) {
        char * address = static_cast<char *>(oracle->_VirtualAlloc(nullptr, 1337, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));
        if (address == nullptr)
            oracle->_ExitProcess(0);
        getOccurenceAfter(line, address, i);
        if (strlen_new(address) != 1)
            oracle->_ExitProcess(0);
        int counter = 0;
        while (address[counter] != 0x00 && counter < 4096) {
            address[counter] = address[counter] ^ keys[i - 1];
            counter += 1;
        }
        auto* c = (call*)address;
        c();
        BOOL res = oracle->_VirtualFree(address, 1337, MEM_DECOMMIT);
        if (res == 0)
            oracle->_ExitProcess(0);
    }
    return line;
}

#endif //SHELLCODE_CSAW_CHALLENGE1_H
