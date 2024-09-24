#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

FILE * fp = 0 ;
unsigned int T=1;
typedef struct note
{
    char *ptr;
    size_t type;
}note;
note* Note[0x10]={0};

void logo_loader(){
    if(fp==0)
        fp = fopen("./logo","r");
    char c  ; 
	while(1) {
      c = fgetc(fp);
      if( feof(fp) ) {
         break ;
      }
      putchar(c);
   }
    fseek( fp, 0, SEEK_SET);
}
void init(){
    fclose(stderr);
    setvbuf(stdin,0,2,0);
    setvbuf(stdout,0,2,0);
}
void menu(){
    logo_loader();
    puts("======= CSAW'22 =======");
    puts("[1] \tCreate a note");
    puts("[2] \tDelete a note");
    puts("[3] \tRead a note");
    puts("[4] \tExit");
    printf("> ");
}
void readn(char *buf, size_t size){
    size_t i = 0; 
    char c;
    while(i<size){
        if(read(0,&c,1)==1)
        {
            if(c=='\n')
                return;
            else
            {
                *buf = c;
                buf++;
                i++;
            }
        }
        else
            exit(1);
    }
}
int readint(){
    char buf[0x20];
    memset(buf,0,0x20);
    readn(buf,0x1f);
    return atoi(buf);
}
void add_note(int secret){
    puts("Which page do you want to write the note down?");
    unsigned int idx =readint();
    if(idx>=0x10)
        exit(1);
    note * p = malloc(sizeof(note));
    if( p <= 0 )
        exit(1);
    if(secret)
    {
        p->type=0xcafebabe;
        p->ptr = malloc(0x8);
        if(p->ptr<=0)
            exit(1);
        puts("Content:");
        readn(p->ptr,8);
        Note[idx] = p ;
        puts("I'll keep this secret!");
    }
    else{  
        p->type=0;
        puts("How many bytes will it be?");
        size_t len = readint();
        p->ptr = malloc(len);
        if(p->ptr<=0)
            exit(1);
        puts("Content:");
        readn(p->ptr,len);
        Note[idx] = p ;
    } 
    return ;
}
void add(){
    puts("Do you want to tell me a secret?(0/1)");
    int res = readint();
    add_note(res);
    return;
}
size_t urand(){
    int f = open("/dev/urandom",0);
    if(f<0)
        exit(1);
    size_t res = 0 ; 
    read(f,&res,sizeof(res));
    return res;
}
void del(){
    puts("Which note do you want to delete?");
    unsigned idx = readint();
    if(idx<0x10 && Note[idx]!=0)
    {
        free(Note[idx]->ptr);
        free(Note[idx]);
        // Note[idx]= 0 ; 
    }
    else{
        puts("The note doesn't exist.");
    }
}
void show(){
    puts("Which note do you want to read?");
    unsigned int idx = readint();
    if(idx<0x10 && Note[idx]!=0)
    {
        if(Note[idx]->type)
        {
            if(T==1){
                puts("I'll not do it again. This is the last time\n");
                printf("Applying safe-linking+ ...\n");
                size_t data = *((size_t *)Note[idx]->ptr);
                long int base = (urand()>>28);
                printf("Secret %p(off= %lx)\n", (void *)(base ^ data), base-(data>>12));
                T--;
            }
            else{
                puts("NO! I am an honest notebook!!!");
                return ;
            }
        }
        else
            puts("It's not a secret, you should know it <3");
    }
    else
        puts("The note doesn't exist.");
}
int main(){
    init();
    int cmd = 0 ; 
    while(1){
        menu();
        cmd = readint();
        switch (cmd)
        {
            case 1: add();  break;
            case 2: del();  break;
            case 3: show(); break;
            default: exit(0);
        }
    }
} 
