#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include "utils.h"

void    panic(const char *s)
{
    puts(s);
    exit(1);
}
int     readint(){
    char buf[0x10];
    memset(buf,0,sizeof(buf));
    int tmp  = read(0,buf,sizeof(buf)-1);
    if(tmp<=0)
        panic("Read error");
    return atoi(buf);
}
size_t  readn(char *ptr, size_t len){
  int tmp = read(0, ptr, len);
  if ( tmp <= 0 )
    panic("Read error");
  if ( ptr[tmp - 1] == 10 )
    ptr[tmp - 1] = 0;
  return tmp;
}
uint8_t urand_byte(int f){
    uint8_t r;
    read(f,&r,1);
    return r;    
}
void *  secure_malloc(size_t size){
    void * p = malloc(size);
    if(p<=0)
        panic("Malloc error");
    return p ; 
}
void *  secure_realloc(void * p, size_t size){
    p = realloc(p,size);
    if(p<=0)
        panic("Realloc error");
    return p ; 
}
int     secure_open(const char * fname){
    int f = open(fname,0);
    if(f<0)
        panic("Open error");
    return f;
}
uint8_t random_uint8(int fd, size_t down,size_t up){//return [down,up)
    uint8_t res = urand_byte(fd);
    while(res>=up || res<down){ 
        res = urand_byte(fd);
    }
    return res;
}