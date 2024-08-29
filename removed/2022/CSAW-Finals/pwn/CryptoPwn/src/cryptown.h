int XRound=0x100;
double R = 0.32;
size_t L = 500;
char*   challenge_plaintext[4]= {0};

typedef struct random_bytes{
    short *pos;
    size_t cur;
    size_t limit; 
} random_bytes; 
typedef struct key_struct{
    random_bytes *rb;
    size_t key_len;
    uint8_t  *key;
    size_t in_use;
} key_struct; 


key_struct *KList = 0;
size_t KNum = 0 ; 