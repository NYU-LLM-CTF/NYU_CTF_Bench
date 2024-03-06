#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void _alarm() 
{
    puts("TIME OUT");
    exit(-1);
}

void init() 
{
    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);
    signal(SIGALRM, _alarm);
    alarm(30);
    puts("=====================================");
    puts("=                                   =");
    puts("=       Subway Account System       =");
    puts("=                                   =");
    puts("=====================================");
}

void view_account(unsigned char *account, int idx) 
{
    printf("Index %d : %02x\n", idx, account[idx]);
}

void print_menu() 
{
    puts("[F]ill account info");
    puts("[V]iew account info");
    puts("[E]xit");
    printf("> ");
}

void print_flag() 
{
    system("cat ./flag");
}

int main(int argc, char *argv[]) 
{
    unsigned char account[0x40] = {};
    char name[0x40] = {};
    char choice[2] = {};
    int idx = 0;
    int name_len = 0;

    init();
    
    while(1) 
    {
        print_menu();
        read(0, choice, 2);
        if (choice[0] == 'F')
        {
            printf("Data : ");
            read(0, account, sizeof(account));
        }
        else if (choice[0] == 'V') 
        {
            printf("Index : ");
            scanf("%d", &idx);
            view_account(account, idx);
        }
        else if (choice[0] == 'E') 
        {
            printf("Name Size : ");
            scanf("%d", &name_len);
            printf("Name : ");
            read(0, name, name_len);
            return 0;
        }
        else 
        {
            puts("Invalid choice");
        }
    }
    return 0;
}
