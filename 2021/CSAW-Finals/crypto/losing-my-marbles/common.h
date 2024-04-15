#ifndef COMMON_H
#define COMMON_H 

#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "openssl/sha.h"

typedef __uint128_t elem;

extern elem INPUTS[256];
extern elem OUTPUT[128][2];
extern elem ANDGATE[6400][3];
extern elem INVGATE[2087];
extern uint8_t RESULT[129];

elem HH(elem a, elem b);

typedef struct HNode {
    elem e;
    struct HNode* next;
} HNode;

#define SEEN_MASK 0xfff
extern HNode* seen_before[4096];

#endif /* ifndef COMMON_H */
