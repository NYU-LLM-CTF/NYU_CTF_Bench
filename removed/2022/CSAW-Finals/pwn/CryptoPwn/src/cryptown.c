#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "base64.h"
#include "cryptown.h"
#include "utils.h"
#include <sys/mman.h>

void base64_output(char *buf,size_t len){
    size_t size = Base64encode_len(len);
    char *tmp = secure_malloc(size);
    memset(tmp,0,size);
    int out_len = Base64encode(tmp,buf,len);
    if(size < out_len || out_len<=1)
        panic("oob");
    puts(tmp);
    free(tmp);
}

void enc(uint8_t *plaintext, size_t plaintext_len , key_struct * k){
    int f       = 0 ;
    uint8_t * p = 0 ;
    size_t ct   = 0 ;
    size_t rct  = 0 ;
    uint8_t * e = 0 ;
    uint8_t * key = k->key;
    size_t key_len = k->key_len;
    size_t e_len_max = plaintext_len;

    f   = secure_open("/dev/urandom");
    p   = plaintext; 
    
    e   = mmap(NULL, 0x2000 , PROT_READ|PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);
    memset(e,0,0x2000);

    if(k->rb)
    {
        if(k->rb->pos)
            free(k->rb->pos);
        free(k->rb);
        
    }
    
    k->rb = secure_malloc(sizeof(random_bytes));
    
    memset(k->rb,0,sizeof(random_bytes));
    
        

    random_bytes * rb = k->rb;
    while( ct-rct < plaintext_len )
    {
        if(urand_byte(f)<= R * 0x100)
        {
            if(rb->cur >= rb->limit)
            {
                if( rct > plaintext_len)
                    puts("Meaningless Setting, why don't you use OTP?"); 
                else{
                    size_t old_size = sizeof(short) * rb->limit;
                    rb->limit += 0x10;
                    size_t new_size = sizeof(short) * rb->limit;
                    void *  p = secure_malloc(new_size);
                    memset(p , 0 , new_size);
                    memcpy(p, rb->pos , old_size);
                    free(rb->pos);
                    rb->pos = p;
                }
            }
            rb->cur++;
            rb->pos[rct++] = ct ;
            e[ct++] = urand_byte(f); // append a random byte
        }
        else{
            e[ct++] = key[(ct-rct)%(key_len)] ^ p[ct-rct];
        }
        if(ct >= 0x2000)
            panic("Ciphertext oob");
    }
    
    close(f);
    puts("Ciphertext:");
    base64_output(e,ct);
    munmap(e,0x2000);
}
void dec(uint8_t *ciphertext, size_t c_len, key_struct *key){
    size_t ct               = 0 ; 
    size_t kl               = key->key_len;
    uint8_t * key_string    = key->key;
    uint8_t * raw           = secure_malloc(Base64decode_len(ciphertext));
    size_t raw_len          = Base64decode(raw,ciphertext);
    if(!raw_len)
        panic("Decode");
    puts("Plaintext:");
    for(int i=0 ; i< raw_len-1 ;i++)
    {
        if( ct < key->rb->cur);
        {
            if(i==key->rb->pos[ct])
            {
                ct++;
                continue;
            }
        }
        uint8_t n = raw[i] ^ key_string[(i-ct)%kl];
        write(1,&n,1);
    }
    free(raw);
}
void menu(){
    puts(" ========================= ");
    puts("0. Key Management");
    puts("1. Encode");
    puts("2. Decode");
    puts("3. Challenge");
    puts("4. Leave");
    puts(" ========================= ");
    printf("> ");
}
void key_list(int flag){
    int ct = 0 ; 
    if(flag)
        puts(" ************************* ");
    for(int i = 0 ; i< KNum; i++)
    {
        if(KList[i].in_use)
        {
            if(flag)
            {
                printf(" Key[ %d ], len = %lu \n", i , KList[i].key_len);
            }
            ct++;
        }
    }
    if( !ct  && flag)
        puts("\tNone");
    if(flag)
        puts(" ************************* ");
    if(ct == KNum)
    {
        size_t old_size = KNum * sizeof(key_struct);
        KNum *=2 ; 
        size_t new_size = KNum*sizeof(key_struct);
        void * old_ptr = KList;
        KList = secure_malloc( new_size );
        memset(KList,0,new_size);
        memcpy(KList,old_ptr,old_size);
        free(old_ptr);
    }
}
void key_edit(){
    printf("Chose a key: ");
    size_t idx = readint() ;
    if(idx >= KNum || !KList[idx].in_use)
    {
        puts("[-] Improper Index");
        return ; 
    }
    printf("Old key:\n");
    write(1,KList[idx].key,KList[idx].key_len);
    puts("");
    printf("New key: ");
    readn(KList[idx].key,KList[idx].key_len);
    puts("[+] Key Edit Done");
    return ; 
}
void key_del(){
    printf("Chose a key: ");
    size_t idx = readint() ;
    if(idx >= KNum || !KList[idx].in_use)
    {
        puts("[-] Improper Index");
        return ; 
    }
    if(KList[idx].rb)
    {
        if(KList[idx].rb->pos)
            free(KList[idx].rb->pos);
        free(KList[idx].rb);
        KList[idx].rb = 0 ; 
    }
    if(KList[idx].key)
    {
        free(KList[idx].key);
        KList[idx].key =0 ; 
    }
    KList[idx].key_len = 0 ; 
    KList[idx].in_use = 0 ;
    puts("[+] Key Del Done");
}
void key_gen(){
    key_list(0);
    size_t idx = 0 ; 
    size_t key_len = 0;
    printf("Index: ");
    idx = readint();
    if(idx >= KNum || KList[idx].in_use)
    {
        puts("[-] Improper Index");
        return ; 
    }
    printf("Size: ");
    key_len = readint() ;
    if(key_len == 0  || key_len > 26)
        panic("Invalid data");
    uint8_t * key = secure_malloc(key_len) ;
    printf("Key string: ");
    key_len = readn(key,key_len);
    
    
    KList[idx].rb = 0;
    KList[idx].key = key;
    KList[idx].key_len = key_len;
    KList[idx].in_use = 1;
    puts("[+] Key Gen Done");
}
void key_menu(){
    puts(" =========================");
    puts("0. Add a Key");
    puts("1. Del a Key");
    puts("2. Show all Keys");
    puts("3. Edit a Key");
    puts("4. Return");
    puts(" ========================= ");
    printf("> ");
}
void key_management(){
    while(1)
    {
        key_menu();
        switch (readint())
        {
            case 0:
                key_gen();
                break;
            case 1:
                key_del();
                break;
            case 2:
                key_list(1);
                break;
            case 3:
                key_edit();
                break;
            default:
                return ;
        }
    }
}
void encode(){
    key_list(1);
    printf("Which key do you want to use: ");
    size_t idx = readint();
    if(idx >= KNum || !KList[idx].in_use)
    {
        puts("[-] Improper Index");
        return ; 
    }
    printf("The length of your plaintext: ");
    size_t p_len = readint();
    if(!p_len)
        return ;
    if(p_len>0x1000)
        panic("Too long to keep it secure"); // This is actually a hint!
    uint8_t *plaintext  = (uint8_t *)secure_malloc(p_len);
    printf("Plaintext: ");
    p_len = readn(plaintext,p_len);
    if(p_len<=0x21)
        return ;
    enc(plaintext,p_len,&KList[idx]);
    free(plaintext);
    puts("\n[+] Encode Done");
}
void decode(){
    key_list(1);
    printf("Which key do you want to use: ");
    size_t idx = readint();
    if(idx >= KNum || KList[idx].in_use || KList[idx].rb==0 || KList[idx].rb->pos==0)
    {
        puts("[-] Improper Index");
        return ; 
    }
    printf("The length of your ciphertext: ");
    size_t c_len = readint();
    if(!c_len)
        return; 
    if(c_len>0x2000)
        panic("Invalid data");
    uint8_t *c = secure_malloc(c_len+1);
    printf("Ciphertext: ");
    c_len = readn(c,c_len);
    c[c_len] = 0 ; 

    dec(c,c_len,&KList[idx]);
    free(c);
    puts("\n[+] Decode Done");
}
int  singleR(){
    int     rnd     = secure_open("/dev/urandom");
    uint8_t orecal  = urand_byte(rnd)%4;
    uint8_t key_len = random_uint8(rnd,1,26);
    uint8_t * key   = secure_malloc(key_len+1);
    for(int i =0 ; i<key_len; i++)
        key[i] = urand_byte(rnd) ;
    key[key_len] = 0 ; 

    key_struct *k  =  secure_malloc(sizeof(key_struct));
    k->key = key ; 
    k->key_len = key_len;
    k->rb = secure_malloc(sizeof(random_bytes));
    memset(k->rb,0,sizeof(random_bytes));
    k->in_use = 1;

    enc(challenge_plaintext[orecal],L,k);
    free(k->rb->pos);
    free(k->rb);
    free(k);
    free(key);
    close(rnd);

    puts("\nWhich one is the plaintext:");
    size_t ans = readint();
    if(ans == orecal){
        return 1;
    }
    return 0;
}
void challge(){
    for(int i =0 ; i < 0x4 ; i++)
    {
        printf("Plaintext %d :\n",i);
        puts(challenge_plaintext[i]);
        puts("");
    }
    size_t win = 0 ; 
    for(int i = 0 ; i < XRound ; i++)
    {
        printf("Round %d: \n",i);
        if(singleR())
            win++;
    }
    if(win != XRound)
        panic("Try more");
    else{
        puts("I am pretty sure you are qualified, and can now challenge more difficult versions.");
        puts("New Randomness: ");
        scanf("%lf",&R);
        puts("How many rounds do you want to test: ");
        scanf("%d", &XRound);
    }
}
void play_ground(){
    while(1)
    {
        menu();
        switch (readint())
        {
        case 0:
            key_management();
            break;
        case 1:
            encode();
            break;
        case 2:
            decode();
            break;
        case 3:
            challge();
            break;
        default:
            exit(0);
        }
    }
}
void logo_loader(){
    char buf[0x100] ; 
    memset(buf,0,sizeof(buf));
    int f =  secure_open("./logo");
    size_t res = read(f,buf,sizeof(buf));
    if(res>sizeof(buf))
        panic("Read error");
    puts(buf);
}
void init_challenge_plaintext()
{
    int urd     = secure_open("/dev/urandom");
    FILE * fp   = fopen("./samples", "r");
    if (fp == NULL)
        panic("Fopen error");

    for(int i = 0 ; i<0x4; i++)
    {
        challenge_plaintext[i] = secure_malloc(L+1);
        size_t idx = random_uint8(urd,0,100);
        fseek(fp, idx*(L+1) , SEEK_SET);
        fread(challenge_plaintext[i],L,1,fp);
        challenge_plaintext[i][L] = 0 ;
    }
    close(urd);
    fclose(fp);
    return ;
}
void init_keytable(){
    KNum  = 0x10;
    KList = secure_malloc(KNum * sizeof(key_struct));
    memset(KList,0,KNum *sizeof(key_struct));
}
void init(){
    fclose(stderr);
    setvbuf(stdin,  0, 2, 0);
    setvbuf(stdout, 0, 2, 0);
    init_challenge_plaintext();
    init_keytable();
    logo_loader();
}
int main(){
    alarm(1200); //I'll set the alarm in set-up.sh so I can remove this.
    init();
    play_ground();
}