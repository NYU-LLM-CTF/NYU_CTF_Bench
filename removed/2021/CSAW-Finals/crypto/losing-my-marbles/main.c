#include <stdio.h>
#include <openssl/evp.h>
#include "common.h"

void run_circuit();

void parse_input() {
    fread(INPUTS, sizeof(elem), 128, stdin);
}

void read_flag() {
    FILE* flag = fopen("flag.txt", "r");
    char buf[2 * sizeof(elem)];
    elem* out = &INPUTS[128];
    for (int j = 0; j < 16; j++) {
        char f = fgetc(flag);
        for (int i = 0; i < 8; i++) {
            fread(buf, sizeof(elem), 2, stdin);
            if (((elem*)buf)[0] == ((elem*)buf)[1]) abort();
            *(out++) = ((elem*)buf)[f & 1];
            f >>= 1;
        }
    }
    fclose(flag);
}

void parse_and_gates() {
    fread(ANDGATE, sizeof(elem), 6400 * 3, stdin);
}

void parse_inv_gates() {
    fread(INVGATE, sizeof(elem), 2087, stdin);
}

void parse_output() {
    fread(OUTPUT, sizeof(elem), 128 * 2, stdin);
}

int enc(EVP_CIPHER_CTX *ctx, unsigned char* out, char* str) {
    int outl = 0;
    EVP_EncryptUpdate(ctx, out, &outl, (unsigned char*) str, strlen(str));
    return outl;
}

void output() {
    char* key[16], iv[16], ciphertext[256];
    
    // Read key
    FILE* key_file = fopen("key", "r");
    fread(key, 1, 16, key_file);
    fclose(key_file);

    // Random IV
    FILE* urandom = fopen("/dev/urandom", "r");
    fread(iv, 1, 16, urandom);
    fclose(urandom);

    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), NULL, (unsigned char*)key, (unsigned char*)iv);
    int l = 0, tmpl = 0;
    l += enc(ctx, (unsigned char*)ciphertext, "Here you go: ");
    l += enc(ctx, (unsigned char*)&ciphertext[l], (char*)RESULT);
    EVP_EncryptFinal_ex(ctx, (unsigned char*)&ciphertext[l], &tmpl);
    l += tmpl;
    EVP_CIPHER_CTX_free(ctx);

    for (int i = 0; i < 16; i++) {
        printf("%02hhx", (unsigned char)iv[i]);
    }
    for (int i = 0; i < l; i++) {
        printf("%02hhx", (unsigned char)ciphertext[i]);
    }
    printf("\n");
}

int main() {
    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);

    parse_input();
    read_flag();
    parse_and_gates();
    parse_inv_gates();
    parse_output();
    run_circuit();
    output();
}
