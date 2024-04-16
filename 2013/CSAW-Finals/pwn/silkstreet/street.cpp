#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <string>
#include <vector>
#include <ctime>
#include <sys/mman.h>
#include <stdlib.h>
#include <malloc.h>
#include <errno.h>
#include <unistd.h>
using namespace std;

// global stuff for stock
const int numItems = 5;
const char* stock[] = {"heroin", "LSD", "cannabis", "credit cards", "assassination"};
const int prices[] = {5, 2, 1, 3, 1670};
vector<int> cart;
int cartprice;
bool hasHit;
//classes
class User
{
    public:
        virtual void orderHit(const char *name)
        {
            printf("ok, the hit is out on, %s, give it 24h!\n", name);
        }
};


//declariation
void getVictim(User* user);
void printHelp();
void buyMenu();
void printStock();

int main(int argc, char **argv)
{
    cout << "sup nublets" << endl;
    printf("sup nublets\n");
    printf("Welcome to the famous...\n");
    printf("         _   __   __                   \n");
    printf("        (_) [  | [  |  _               \n");
    printf(" .--.   __   | |  | | / ]              \n");
    printf("( (`\\] [  |  | |  | '' <               \n");
    printf(" `'.'.  | |  | |  | |`\\ \\              \n");
    printf("[\\__) )[___][___][__|  \\_]        _    \n");
    printf("       / |_                      / |_  \n");
    printf(" .--. `| |-'_ .--.  .---.  .---.`| |-' \n");
    printf("( (`\\] | | [ `/'`\\]/ /__\\\\/ /__\\\\| |   \n");
    printf(" `'.'. | |, | |    | \\__.,| \\__.,| |,  \n");
    printf("[\\__) )\\__/[___]    '.__.' '.__.'\\__/  \n");
    printf("          ...a new online marketplace\n");
    
    cartprice = 0;
    hasHit = false;
    
    printHelp();
    bool quits = 0;
    char c;
    char* cmd = new char[8];
    while(!quits)
    {
        if(c != '\n')
        {
            printf("input command. : ");
        }
        fgets(cmd, 8, stdin);
        c = cmd[0];
        cmd[8] = 0;
        switch(c)
        {
            case 'h':
                printHelp();
                break;
            case 'q':
                return 0;
                break;
            case 'b':
                buyMenu();
                break;
            case 'c':
                quits = true;
                break;
            default:
                printf(cmd); //this guy can leak a heap address
                printf("error %c: %c not found\n", '!', c);
                break;
        }
    }
    printf("checking out!\n");
    printf("do you agree to do nothing illegal in this transaction(y/n): ");
    srand(time(NULL));
    int wallet = rand()%1600 + 1680; //something fun, doesn't really do much
    User u;
    char agree[64];
    gets(agree); /* OVERFLOW THIS BITCH to overwrite user's vtable pointer */
    if (strcmp(agree, "y") == 0) 
    {
        if(wallet >= cartprice)
        {
            if(hasHit)
            {
                getVictim(&u); //call the hit, this is where you can drop the shellcode
            }
            printf("thanks for the order!\n");
        }
        else
        {
            printf("you only have %d BTC, this costs %d BTC!\n", wallet, cartprice);
            printf("you don't have enough money, goodbye!\n");
        }
        return 0;
    } 
    else 
    {
        printf("sorry br0, I can't let you do illegal stuff\n");
        printf("got to keep it legal\n");
        return 1;
    }
}

void printHelp()
{
    printf("silk street help\n");
    printf("h: print this help message\n");
    printf("b: buy item\n");
    printf("c: checkout\n");
    printf("q: quit\n");
}

void buyMenu()
{
   printStock();
   printf("buy number : ");
   char ch = getchar();
   ch = ch - 0x30;
   switch(ch)
   {
       case 0:
       case 1:
       case 2:
       case 3:
       case 4:
           printf("bought %s for %d BTC\n", stock[ch], prices[ch]);
           cart.push_back((int)ch);
           cartprice += prices[ch];
           break;
       default:
           printf("I don't know what that is!\n");
           break;
   }
   if(ch == 4)
   {
       hasHit = true;
   }
   getchar();
}

void printStock()
{
    printf("enter the number of the item you want to buy\n");
    for(int ii = 0; ii < numItems; ii++)
    {
        printf("%d : %s : %d BTC\n", ii, stock[ii], prices[ii]);
    }
}

void getVictim(User* user)
{
    int psize = getpagesize();
    char* clean;
    posix_memalign((void**)&clean, psize, psize);
    if(mprotect(clean, psize*sizeof(char), PROT_EXEC | PROT_READ | PROT_WRITE) == -1)
    {
        perror("mprotect");
        int errsv = errno;
        printf("%x\n", errno);
    }

    printf("%s", "great! ");
    printf("Any special instructions? ");
    fgets((char*)clean, 10000, stdin); //dump your shellcode to the RWX buffer
    char name[100];
    printf("Who do you need the hit out on? ");
    fgets(name, 100, stdin);
    name[strlen(name)-1] = '\0';
    user->orderHit(name);
    printf("your special instructions say to have it %s\n", (char*)clean);
}

