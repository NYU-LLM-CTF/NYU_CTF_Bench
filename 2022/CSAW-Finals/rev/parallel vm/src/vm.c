#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<pthread.h>

typedef unsigned char BOOL;

pthread_t reg_thread[10];
pthread_t pc_thread;
pthread_t text_thread;
pthread_t ram_thread;

int order[10]={0,1,2,3,4,5,6,7,8,9};


struct REG{
    unsigned int value;
    BOOL isset;
};

struct PC
{
    unsigned int value;
    BOOL isset;
};

struct TEXT
{
    unsigned char value[1024];
    BOOL isset;
};

struct RAM
{
    unsigned char value[200];
    BOOL isset;
};

struct slice
{
    struct REG regs[10];
    struct PC pc;
    struct TEXT text;
    struct RAM ram;
}Slices[100000];

int get_instr(int level,unsigned int offset){
    unsigned int a=offset/8;
    unsigned int b=offset%8;
    unsigned int mask=(1<<(b-3))-1;
    if(b<=3)
        return (Slices[level].text.value[a]>>b)&0x1f;
    else
        return (Slices[level].text.value[a]>>b)|((Slices[level].text.value[a+1]&mask)<<(8-b));
}

int get_regnum(int level,unsigned int offset){
    unsigned int a=offset/8;
    unsigned int b=offset%8;
    unsigned int mask=(1<<(b-4))-1;
    if(b<=4)
        return (Slices[level].text.value[a]>>b)&0xf;
    else
        return (Slices[level].text.value[a]>>b)|((Slices[level].text.value[a+1]&mask)<<(8-b));
}

unsigned int get_imm(int level,unsigned int offset){
    unsigned int a=offset/8;
    unsigned int b=offset%8;
    unsigned int mask=(1<<b)-1;
    if(b)
        return (Slices[level].text.value[a]>>b)|(Slices[level].text.value[a+1]<<(8-b))|((Slices[level].text.value[a+2]&mask)<<(16-b));
    else 
        return Slices[level].text.value[a]|(Slices[level].text.value[a+1]<<8);
}

void* func_r(void *arg){
    int regnum=*(int*)arg;
    int level=1;
    while(level<10000){
        Slices[level].regs[regnum].value=Slices[level-1].regs[regnum].value;
        while(!Slices[level-1].pc.isset);
        while(!Slices[level-1].text.isset);
        int instr=get_instr(level-1,Slices[level-1].pc.value);

        if(instr==0x1d&&regnum==0){
            Slices[level].regs[regnum].value=(unsigned int)getchar();
        }
        else if(instr==0x1f){
            break;
        }
        else if(get_regnum(level-1,Slices[level-1].pc.value+5)==regnum){
            if((instr&0x18)==0){
                int rb=get_regnum(level-1,Slices[level-1].pc.value+9);
                while(!Slices[level-1].regs[rb].isset);
                switch (instr&0x7)
                {
                case 0:
                    Slices[level].regs[regnum].value=Slices[level-1].regs[regnum].value+Slices[level-1].regs[rb].value;
                    break;
                case 1:
                    Slices[level].regs[regnum].value=Slices[level-1].regs[regnum].value-Slices[level-1].regs[rb].value;
                    break;
                case 2:
                    Slices[level].regs[regnum].value=Slices[level-1].regs[rb].value;
                    break;
                case 3:
                    Slices[level].regs[regnum].value=Slices[level-1].regs[regnum].value^Slices[level-1].regs[rb].value;
                    break;

                default:
                    break;
                }
            }
            else if((instr&0x18)==8){
                int imm=get_imm(level-1,Slices[level-1].pc.value+9);
                switch (instr&0x7)
                {
                case 0:
                    Slices[level].regs[regnum].value=Slices[level-1].regs[regnum].value+imm;
                    break;
                case 1:
                    Slices[level].regs[regnum].value=Slices[level-1].regs[regnum].value-imm;
                    break;
                case 2:
                    Slices[level].regs[regnum].value=imm;
                    break;
                case 3:
                    Slices[level].regs[regnum].value=Slices[level-1].regs[regnum].value<<imm;
                    break;
                case 4:
                    Slices[level].regs[regnum].value=Slices[level-1].regs[regnum].value>>imm;
                    break;

                default:
                    break;
                }
            }
            else if(instr==0x10){
                int rb=get_regnum(level-1,Slices[level-1].pc.value+9);
                while(!Slices[level-1].regs[rb].isset||!Slices[level-1].ram.isset);
                Slices[level].regs[regnum].value=(unsigned int)Slices[level-1].ram.value[Slices[level-1].regs[rb].value];
            }
        }
        Slices[level].regs[regnum].isset=1;
        level+=1;
    }
    pthread_exit(NULL);
}

void *func_pc(){
    int level=1;
    while(level<10000){
        Slices[level].pc.value=Slices[level-1].pc.value;
        while(!Slices[level-1].text.isset);
        int instr=get_instr(level-1,Slices[level-1].pc.value);
        if((instr&0x18)==0||(instr&0x18)==0x10){
            Slices[level].pc.value=Slices[level-1].pc.value+13;
        }
        else if((instr&0x18)==0x18){
            Slices[level].pc.value=Slices[level-1].pc.value+5;
            if(instr==0x1c){
                while(!Slices[level-1].regs[0].isset);
                putchar((char)Slices[level-1].regs[0].value);
            }
            if(instr==0x1f){
                break;
            }
        }
        else if((instr&0x18)==8){
            Slices[level].pc.value=Slices[level-1].pc.value+25;
            if(instr==0xf){
                int ra=get_regnum(level-1,Slices[level-1].pc.value+5);
                while(!Slices[level-1].regs[ra].isset);
                if(Slices[level-1].regs[ra].value){
                    Slices[level].pc.value=get_imm(level-1,Slices[level-1].pc.value+9);
                }
            }
        }
        Slices[level].pc.isset=1;
        level+=1;
    }
    pthread_exit(NULL);
}

void *func_txt(){
    int level=1;
    while(level<10000){
        memcpy(Slices[level].text.value,Slices[level-1].text.value,1024);
        Slices[level].text.isset=1;
        level+=1;
    }
    pthread_exit(NULL);
}

void *func_ram(){
    int level=1;
    while(level<10000){
        memcpy(Slices[level].ram.value,Slices[level-1].ram.value,200);
        while(!Slices[level-1].pc.isset);
        while(!Slices[level-1].text.isset);
        int instr=get_instr(level-1,Slices[level-1].pc.value);
        if(instr==0x11){
            int ra=get_regnum(level-1,Slices[level-1].pc.value+5);
            int rb=get_regnum(level-1,Slices[level-1].pc.value+9);
            while(!Slices[level-1].regs[ra].isset||!Slices[level-1].regs[rb].isset);
            Slices[level].ram.value[Slices[level-1].regs[rb].value]=Slices[level-1].regs[ra].value;
        }
        else if(instr==0x1f){
            break;
        }
        Slices[level].ram.isset=1;
        level+=1;
    }
    pthread_exit(NULL);
}


void init()
{
    for(int i=0;i<10;i++)
        Slices[0].regs[i].isset=1;
    Slices[0].pc.isset=1;
    Slices[0].text.isset=1;
    Slices[0].ram.isset=1;
    unsigned char tmp[1024]={0x2a,0x10,0x0,0x7a,0x8a,0x0,0x80,0x8,0xf1,0x22,0x3,0x60,0x88,0xa8,0xb9,0xf1,0x5c,0x3,0x1,0xa0,0x28,0x37,0x6f,0xc,0xa9,0x20,0x0,0x18,0x44,0xb0,0x62,0x11,0x2,0xc0,0xa0,0x42,0x11,0x0,0x20,0x2a,0x52,0x21,0x0,0xbc,0x42,0x7,0x50,0x1,0x0,0x30,0xaa,0xa0,0xc5,0x2a,0x4,0x80,0x51,0x86,0x22,0x0,0x40,0x58,0x24,0x23,0x0,0x78,0x96,0x19,0xa0,0x2,0x4,0x0,0xc8,0x8,0xab,0x65,0x4,0x0,0xa,0x8,0x0,0xc6,0x1d,0x82,0x3,0x80,0x75,0x8,0x0,0x10,0x61,0x1c,0x26,0x40,0x0,0x78,0x60,0x29,0x0,0xec,0xc4,0x9,0xb8,0x1a,0x76,0xe2,0x8a,0x5d,0x1,0x80,0x2,0x2,0x80,0x81,0x88,0x60,0x1,0x60,0x21,0x2,0x0,0x4c,0x18,0x98,0x9,0x18,0x0,0x1e,0x50,0xe,0x80,0xc3,0x61,0x7,0xc8,0x84,0xd1,0x32,0x2,0x0,0x5,0x4,0x0,0xe3,0xe,0xc1,0x3,0xc0,0x3a,0x4,0x0,0x88,0x30,0xe,0x13,0x40,0x0,0x3c,0x28,0x24,0x0,0x76,0xe2,0x4,0x1c,0xd,0x3b,0x71,0xc4,0xae,0x0,0x40,0x1,0x1,0xc0,0x40,0x44,0x30,0x1,0xb0,0x10,0x1,0x0,0x26,0xc,0xcc,0x4,0x14,0x0,0xf,0x6,0xb,0xc0,0xe1,0xb0,0x3,0x65,0x29,0x2,0x0,0x5e,0xf4,0x8,0x28,0xc1,0xd5,0x5f,0x2,0x1,0xa0,0x6,0x1f,0x7a,0xc8,0x4,0x92,0x47,0x7,0x8,0x4a,0x8a,0x35,0x97,0x40,0x0,0xa8,0x89,0x54,0x1f,0x32,0xa1,0xe4,0xd5,0x1,0x82,0xa,0xc,0x0,0x8,0xc1,0x51,0x4,0x0,0x40,0x8,0x8e,0x22,0x0,0x0,0x42,0x70,0x14,0x1,0x0,0x10,0x82,0x7f,0x15,0x1c,0x0,0x10,0x82,0xa3,0x8,0x0,0x80,0x10,0x1c,0x45,0x0,0x0,0x84,0xe0,0x28,0x2,0x0,0x20,0x4,0xff};
    memcpy(Slices[0].text.value,tmp,1024);
    unsigned char *ram=Slices[0].ram.value;
    ram[24]='w';
    ram[25]='i';
    ram[26]='n';
    ram[27]='!';
    ram[28]='f';
    ram[29]='a';
    ram[30]='i';
    ram[31]='l';
    ram[8]=0x1;
    ram[12]=0x5;
    ram[16]=0x8;
    ram[20]=0xf;
}

void vm_exec()
{
    for(int i=0;i<10;i++)
        pthread_create(&reg_thread[i],NULL,func_r,(void*)(order+i));
    pthread_create(&pc_thread,NULL,func_pc,NULL);
    pthread_create(&text_thread,NULL,func_txt,NULL);
    pthread_create(&ram_thread,NULL,func_ram,NULL);
    for(int i=0;i<10;i++)
        pthread_join(reg_thread[i],NULL);
    pthread_join(pc_thread,NULL);
    pthread_join(text_thread,NULL);
    pthread_join(ram_thread,NULL);
}

int main()
{
    printf("Welcome! Please keep patient.\n");
    init();
    vm_exec();
    putchar('\n');
}