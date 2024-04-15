#include <stdint.h>
#include <stdio.h>

#ifdef CHALDEBUG
void encrypt (uint32_t v[2], uint32_t k[4]) {
    uint32_t v0=v[0], v1=v[1], sum=0, i;           /* set up */
    uint32_t delta=0x1337BEEF;                     /* a key schedule constant */
    uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];   /* cache key */
    for (i=0; i<40; i++) {                         /* basic cycle start */
        sum += delta;
        v0 += ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        v1 += ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
    }                                              /* end cycle */
    v[0]=v0; v[1]=v1;
}
#endif

void decrypt (uint32_t v[2], uint32_t k[4]) {
    uint32_t v0=v[0], v1=v[1], sum=0xb5d558, i;  /* set up; sum is 32*delta */
    uint32_t delta=0x1337BEEF;                     /* a key schedule constant */
    uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];   /* cache key */
    for (i=0; i<40; i++) {                         /* basic cycle start */
        v1 -= ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
        v0 -= ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        sum -= delta;
    }                                              /* end cycle */
    v[0]=v0; v[1]=v1;
}

int main(int argc, char **argv) {
    int i;
#ifdef CHALDEBUG
    unsigned char message[] = "flag{fr0m_rU551a_w1th_l0v3}\0\0\0\0";
#else
    unsigned char message[] = {0x1b,0x54,0x8b,0xf4,0x53,0x02,0x97,0xd5,0xce,0x87,0x44,0x4e,0x16,0xc5,0x98,0x23,
                               0xe6,0xf6,0x2e,0x3f,0xef,0xf0,0xe4,0xd2,0x5b,0x94,0xf6,0x61,0xc6,0xa1,0x77,0xd7};
#endif
    uint32_t *mint = (uint32_t *) message;
    uint32_t k[4] = {0x43534157, 0x43534157, 0x43534157, 0x43534157};
#ifdef CHALDEBUG
    printf("Before:   ");
    for (i = 0; i < sizeof(message); i++) {
        printf("%02x", message[i]);
    }
    printf("\n");
    for (i = 0; i < sizeof(message) / 4 ; i += 2) {
        encrypt(mint+i, k);
    }
    printf("After(E): ");
    for (i = 0; i < sizeof(message); i++) {
        printf("%02x", message[i]);
    }
    printf("\n");
#endif
    for (i = 0; i < sizeof(message) / 4 ; i += 2) {
        decrypt(mint+i, k);
    }
    printf("%s\n", message);
    return 0;
}
