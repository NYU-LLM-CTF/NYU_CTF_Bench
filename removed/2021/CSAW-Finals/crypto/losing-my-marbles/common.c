#include "common.h"

elem INPUTS[256] = {0};
elem OUTPUT[128][2] = {0};
elem ANDGATE[6400][3] = {0};
elem INVGATE[2087] = {0};
uint8_t RESULT[129] = {0};


elem HH(elem a, elem b) {
    uint8_t buf[32];
    memcpy(buf, (uint8_t*)&a, 16);
    memcpy(buf + 16, (uint8_t*)&b, 16);
    uint8_t hash[SHA256_DIGEST_LENGTH];
    SHA256_CTX ctx;
    SHA256_Init(&ctx);
    SHA256_Update(&ctx, buf, 32);
    SHA256_Final(hash, &ctx);
    return *(elem*)hash;
}

HNode* seen_before[4096] = {NULL};
