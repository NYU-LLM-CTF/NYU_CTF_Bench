void    panic(const char *s);
int     readint();
size_t  readn(char *ptr, size_t len);
uint8_t urand_byte(int f);
void *  secure_malloc(size_t size);
void *  secure_realloc(void * p, size_t size);
int     secure_open(const char * fname);
uint8_t random_uint8(int fd, size_t down,size_t up);