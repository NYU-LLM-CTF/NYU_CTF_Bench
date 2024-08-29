#include <Windows.h>
#include <cstdio>
#define ROTR32(value, shift) (((DWORD) value >> (BYTE) shift) | ((DWORD) value << (32 - (BYTE) shift)))
#define ROTL32(value, shift) (((DWORD) value << (BYTE) shift) | ((DWORD) value >> (32 - (BYTE) shift)))

// VirtualAlloc
int virtual_alloc[] = {4800, 4416, 5248, 4992, 4416, 4864, 3264, 3200, 2944, 4352, 4864, 4864, 00};
char virtual_alloc_s[] = "VirtualAlloc\0";


int check_rotr(int shift) {
    int counter = 0;
    while (virtual_alloc_s[counter] != '\0') {
        if (ROTR32(virtual_alloc_s[counter], shift) != virtual_alloc[counter]) {
            return 1;
        }
        counter++;
    }
    return 0;
}


void check_rotl(int shift) {
    int counter = 0;
    int l = 0;
    while (virtual_alloc[l] != 0x0)
        l++;
    char output[l + 1];
    output[l] = 0x0;

    while (virtual_alloc[counter] != 0x0) {
        int c = ROTL32(virtual_alloc[counter], shift);
        if (c > 32 && c < 128) {
            output[counter] = c;
            counter++;
        } else {
            return;
        }
    }
    printf("Potential solution: %d, %s\n", shift, output);
}


int main() {
    // Check printable chars only
    printf("Checking with known plaintext.\n\n");
    for (int i = 32; i < 128; i++) {
        if (check_rotr(i) == 0) {
            printf("Found key %d\n", i);
        }
    }
    printf("\nTesting potential solutions without known plaintext.\n\n");
    for (int i = 32; i < 128; i++) {
        check_rotl(i);
    }
}