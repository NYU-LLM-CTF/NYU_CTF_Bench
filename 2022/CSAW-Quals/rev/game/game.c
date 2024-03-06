#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define FNV_32_PRIME ((unsigned int)0x01000193)

// declarations
int case_id;
int states[15][3];
char flag_slice[5][13];
unsigned int pass;
unsigned int choice;

// Help taken to write the hash algorithm from: https://github.com/haipome/fnv/blob/master/fnv.c
unsigned int fnv_1a_32(char *str)
{
    unsigned char *s = (unsigned char *)str;
    unsigned int hval = (unsigned int)0x811c9dc5;
    while (*s){
        hval ^= (unsigned int)*s++;
#if defined(NO_FNV_GCC_OPTIMIZATION)
        hval *= FNV_32_PRIME;
#else
        hval += (hval<<1) + (hval<<4) + (hval<<7) + (hval<<8) + (hval<<24);
#endif
    }
    return hval;
}

int init()
{
    fclose(stderr);
    setvbuf(stdin,  0, 2, 0);
    setvbuf(stdout, 0, 2, 0);

    FILE *flagfile;
    char *flag;
    long numbytes;
    flagfile = fopen("flag.txt", "r");
    if(flagfile == NULL)
        return -2;
    fseek(flagfile, 0L, SEEK_END);
    numbytes = ftell(flagfile);
    fseek(flagfile, 0L, SEEK_SET);
    flag = (char*)calloc(numbytes, sizeof(char));
    if(flag == NULL)
        return -1;
    fread(flag, sizeof(char), numbytes, flagfile);
    fclose(flagfile);

    for(int i = 0; i <= 4; i++) {
        strncpy(flag_slice[i], flag + 12 * i, 12);
        flag_slice[i][12] = '\0';
    }

    // 0 for left, 1 for center, 2 for right
    char buffer[1024];
    char *record,*line;
    int i=0,j=0;
    FILE *fstream = fopen("map.csv","r");
    if(fstream == NULL)
    {
        printf("map file opening failed \n");
        return -1 ;
    }
    while((line=fgets(buffer,sizeof(buffer),fstream))!=NULL){
        record = strtok(line,",");
        while(record != NULL){
            states[i][j++] = atoi(record);
            record = strtok(NULL,",");
        }
        i++;
        j=0;
    }
    fclose(fstream);
}

void level_next(choice)
{
    case_id = states[case_id][choice];
    if(case_id >= 0 && case_id <= 14) {
        level_gen();
        return;
    }
    if(case_id == 15){
        printf("You have reached the exit! You win!\nDid you find all the easter eggs? You can go back and play the game to find all 5 of them\n");
        return;}
    if(case_id >= 100 && case_id <= 104) {
        int flag_id = case_id % 100;
        printf("You have encountered a door which requires a password to enter. What is the password in decimal form?: \n");
        scanf("%u", &pass);
        char keys[5][10] = {"cook", "flawed", "gravel", "king", "decisive"};
        double money = 0.01;
        for (int i = 0; i < flag_id; i++){
            money *= 10;
        }
        if(pass == fnv_1a_32(keys[flag_id]))
            printf("%s", flag_slice[flag_id]);
        else{
            printf("You have entered the wrong password! You can obtain the right password by paying us USD$%.2f to our Patreon page\n", money);}
        return;
    }
    printf("You have hit a dead end. You lose!\n");
}

void level_gen()
{
    printf("\n%d\n", case_id);
    printf("Which cave would you like to take:\n\tThe left cave (1)\n\tThe center cave (2)\n\tThe right cave (3)\nChoice: ");
    scanf("%d", &choice);
    switch(choice){
        case 1:
            printf("You chose the left cave\n");
            level_next(choice - 1);
            break;
        case 2:
            printf("You chose the center cave\n");
            level_next(choice - 1);
            break;
        case 3:
            printf("You chose the right cave\n");
            level_next(choice - 1);
            break;
        default:
            printf("Invalid choice!\n");
    }
}

int main()
{
    init();
    printf("You have encountered a cave system. You need to get to the other side but you don't have enough resources to retrace your steps. Can you make it to the other side?\n");
    case_id = 0;
    level_gen();
    return 0;
}
