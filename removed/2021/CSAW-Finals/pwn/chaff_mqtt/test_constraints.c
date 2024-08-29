#include <stdio.h>
#include <set>
#include <iostream>

#define MOD(X, Y) ((X)%(Y))
#define P2(X, Y) MOD((MOD((X), (Y))*MOD((X), (Y))), (Y))
#define MULTI(X, Y, Z) MOD((MOD((X), (Z))*MOD((Y), (Z))), (Z))
#define P4(X, Y) P2(P2(X, Y), Y)
#define P5(X, Y) MULTI(P4(X, Y), (X), (Y))
#define P8(X, Y) P4(P4(X, Y), Y)
#define P11(X, Y) MULTI(P2(P5(X,Y),Y), (X), (Y))
#define P16(X, Y) P8(P8(X, Y), Y)



void test_constraints() {
    for (int j = 0; j < 0x10000; j++) {
        int tmp = (j<<16);
        float i = 0;
        if ((__builtin_clz(~tmp)<9) && (__builtin_popcount(tmp>>16)<24))
            printf("%x\n", j);
        if ((i=((tmp>>16)&0xffff),i=(__builtin_powif(i,8)+__builtin_powif(i,3)),((*(int*)&i)&0x50505050)==0x40000040))
            printf("%x\n", j);
        if ((i=(tmp>>16),i=(__builtin_powif(i,7)),(*(int*)&i)&1) && (i=((tmp>>16)^0x5555),__builtin_clz(*(int*)&i)))
            printf("%x\n", j);
        if ((i=(tmp>>16)^0x5555,i=(__builtin_powif(i,__builtin_popcount(*(int*)&i)%7)),(__builtin_popcount(*(int*)&i)&0xf)>7))
            printf("%x\n", j);
        if ((i=(tmp>>16),i=__builtin_powif(i,__builtin_ctz(*(int*)&i)),__builtin_parity(*(int*)&i)) && (i=(tmp>>16),i*=1337,(*(int*)&i)&0xf0==0xf0))
            printf("%x\n", j);
        if (((P8(tmp>>16, 349)*P2(tmp>>16, 439))&0xf == (P8(tmp>>16, 349)+P2(tmp>>16, 439))&0xf))
            printf("%x\n", j);
        if ((((P16(tmp>>16, 0x1337)^P5(tmp>>16, 0x1337))&0xf0)==0xf0) && (((P8(tmp>>24, 137)+P11(tmp>>24, 137))&0x55)==0x55))
            printf("%x\n", j);
    }
}

int main() {
    test_constraints();
    return 0;
}
