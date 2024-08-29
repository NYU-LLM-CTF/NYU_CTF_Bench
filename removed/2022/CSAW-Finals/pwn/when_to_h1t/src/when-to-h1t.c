#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
int won = 0;
int dealer_total = 0;
int player_total = 0;
typedef struct node
{
    char name[0x20];
    char msg[0x400];
} node;
int init()
{
    fclose(stderr);
    setvbuf(stdin, 0, 2, 0);
    setvbuf(stdout, 0, 2, 0);
}
int readint()
{
    char buf[0x20];
    memset(buf, 0, sizeof(buf));
    int tmp = read(0, buf, sizeof(buf) - 1);
    if (tmp <= 0)
        exit(1);
    return atoi(buf);
}
size_t readn(char *ptr, size_t len)
{
    int tmp = read(0, ptr, len);
    if (tmp <= 0)
        exit(1);
    if (ptr[tmp - 1] == 10)
        ptr[tmp - 1] = 0;
    return tmp;
}
void panic(char *s)
{
    puts(s);
    exit(1);
}
void rules()
{
    puts("Welcome to the CSAW Online Blackjack!");
    puts("\nThe house rules are:\n");
    puts("Each card has a value.\n");
    puts("Number cards 1 to 10 hold a value of their number.\n");
    puts("J, Q, and K cards hold a value of 10.\n");
    puts("Ace cards hold a value of 11 or 1, the program will decide in favor of you.\n");
    puts("\nThe goal of this game is to reach a card value total of 21.\n");
    puts("The dealer will give you a card.\n");
    puts("Forget about doubles and splits, you must decide whether to HIT or STAY.\n");
    puts("Staying will keep you safe, hitting will add a card.\n");
    puts("Because you are competing against the dealer, you must beat his hand.\n");
    puts("Cuidado, if your total goes over 21, you will LOSE!.\n");
    puts("But don't worry, because you'll always have more money to blow!\n");
}
int randcard() // Generates random card
{
    int k = rand() % 13 + 1;
    if (k <= 9) // If random number is 9 or less, print card with that number
    {
        // Spade Card
        puts("-------");
        puts("|     |");
        printf("|  %d  |\n", k);
        puts("|     |");
        puts("-------");
    }
    if (k == 10) // If random number is 10, print card with J (Jack) on face
    {
        // Spade Card
        puts("-------");
        puts("|     |");
        puts("|  J  |");
        puts("|     |");
        puts("-------");
    }
    if (k == 11) // If random number is 11, print card with A (Ace) on face
    {
        // Spade Card
        puts("-------");
        puts("|     |");
        puts("|  A  |");
        puts("|     |");
        puts("-------");
        if (player_total <= 10) // If random number is Ace, change value to 11 or 1 depending on dealer total
            k = 11;
        else
            k = 1;
    }
    if (k == 12) // If random number is 12, print card with Q (Queen) on face
    {
        // Spade Card
        puts("-------");
        puts("|     |");
        puts("|  Q  |");
        puts("|     |");
        puts("-------");
        k = 10; // Set card value to 10
    }
    if (k == 13) // If random number is 13, print card with K (King) on face
    {
        // Spade Card
        puts("-------");
        puts("|     |");
        puts("|  K  |");
        puts("|     |");
        puts("-------");
        k = 10; // Set card value to 10
    }
    return k;
} // End Function
void dealer() // Function to play for dealer AI
{
    puts("\nDealer draws.");
    dealer_total += randcard();
    printf("The dealer has a total of %d.\n", dealer_total); // Prints dealer total
}
void player()
{
    player_total += randcard(); // Generates random card
    printf("\nYour total is %d.\n", player_total);
}
void clean_data()
{
    dealer_total = 0;
    player_total = 0;
    return;
}
void dealer_win(char *s)
{
    puts(s);
    clean_data();
    return;
}
void player_win(char *s)
{
    puts(s);
    won = won + 1;
    clean_data();
    return;
}
void stay()
{
    dealer(); // If stay selected, dealer continues going
    if (dealer_total >= 17)
    {
        if (dealer_total > 21) // If dealer total is over 21, win
        {
            player_win("\nDealer Has Went Over!. You Win!");
            return;
        }
        else if (player_total >= dealer_total) // If player's total is more than dealer's total, win
        {
            player_win("\nUnbelievable! You Win!");
            printf("\nYou have %d wins. Awesome!\n", won);
            return;
        }
        else
        {
            dealer_win("\nDealer has a better hand. You lose.");
            return;
        }
    }
    else
        stay();
}
void play() // Plays game
{
    // int p = 0; // holds value of player_total
    char choice[8];
    memset(choice, 0, 8);
    player();
    dealer();
    while (1)
    {
        if (player_total == 21) // If user total is 21, win
        {
            player_win("\nUnbelievable! You Win!");
            return;
        }
        else if (player_total > 21) // If player total is over 21, loss
        {
            dealer_win("\nWoah busted buddy, You went WAY over.");
            return;
        }
        else // If player total is less than 21, ask to hit or stay
        {
            puts("\n\nWould you like to hit or stay?");
            char *c = choice;
            // If invalid choice entered
            do
            {
                puts("\nPlease enter 'h' to hit or 's' to stay.");
                readn(choice, sizeof(choice) - 1);
            } while ((*c != 'H') && (*c != 'h') && (*c != 'S') && (*c != 's'));

            if ((*c == 'H') || (*c == 'h')) // If Hit, continues
            {
                player_total += randcard();
                printf("Your total is %d.\n", player_total);
                if (player_total == 21) // If user total is 21, win
                {
                    player_win("\nUnbelievable! You Win!");
                    return;
                }
                else if (player_total > 21) // If player total is over 21, loss
                {
                    dealer_win("\nWoah busted buddy, you went WAY over.\nDealer wins.");
                    return;
                }
                dealer();
                if (dealer_total == 21) // Is dealer total is 21, loss
                {
                    dealer_win("\nDealer has the better hand. You lose.");
                    return;
                }
                else if (dealer_total > 21) // If dealer total is over 21, win
                {
                    player_win("\nDealer has went over!. You win!");
                    return;
                }
            }
            else // If Stay, does not continue
            {
                printf("\nYou have chosen to stay at %d. Wise decision!\n", player_total);
                stay();
                return;
            }
        }
    }
} // End Function
void arena()
{
    rules();
    won = 0;
    for (int i = 0; i < 20; i++)
    {
        puts("\nEnter 1 to Begin the Greatest Game Ever Made.");
        puts("Enter 2 to See a Complete Listing of Rules.");
        puts("Enter 3 to Exit Game.");
        puts("Choice: ");
        int choice = readint();           // Prompts user for choice
        if ((choice < 1) || (choice > 3)) // If invalid choice entered
            panic("\nIncorrect Choice. Please enter 1, 2 or 3");
        switch (choice) // Switch case for different choices
        {
        case 1: // Case to begin game
            play();
            break;
        case 2: // Case to see rules
            rules();
            break;
        case 3: // Case to exit game
            puts("\nYour day could have been perfect.\nBye!\n");
            return;
        default:
            panic("\nInvalid Input");
        } // End switch case
    }
}
int get_koh()
{
    char buf[0x20];
    memset(buf, 0, 0x20);
    int f = open("./koh", 0);
    if (f < 0)
        panic("Fail to open ./koh");
    int res = read(f, buf, sizeof(buf) - 1);
    if (res <= 0)
        panic("Fail to get best score");
    close(f);
    return atoi(buf);
}
int report(node *tmp)
{
    char buf[0x20];
    int f = -1;
    int res = -1;
    int score = get_koh();
    memset(buf, 0, 0x20);
    if (won >= score)
    {
        memset(buf, 0, 0x20);
        sprintf(buf, "%d", won);
        f = open("./koh", 1);
        if (f < 0)
            panic("Fail to open ./koh");
        res = write(f, buf, 0x20);
        if (res != 0x20)
            panic("Fail to renew the best score");
        close(f);

        f = open("./msg", 1);
        if (f < 0)
            panic("Fail to open ./msg");
        if (write(f, tmp->name, sizeof(tmp->name)) <= 0)
            panic("Fail to write ./msg");
        if (write(f, "\n=====\n", 7) != 7)
            panic("Fail to write ./msg");
        if (write(f, tmp->msg, sizeof(tmp->msg)) <= 0)
            panic("Fail to write ./msg");
        puts("[+] New Winner!");
        return 0;
    }
    return 1;
}
void score_report()
{
    if (won >= 12)
    {
        char buffer[0x400];
        puts("Wow, you're smart! I want to know more about you.");
        node *tmp = malloc(sizeof(node));

        puts("What is your name?");
        readn(buffer, sizeof(buffer) - 1);
        printf("Cool, %s! \nCan you share your strategy?\n", buffer); // Leak trash data on stack
        snprintf(tmp->name, sizeof(tmp->name), "%s", buffer);

        readn(buffer, sizeof(buffer) - 1);
        snprintf(tmp->msg, sizeof(tmp->msg), "%s", buffer);
        if (report(tmp))
        {
            puts("Although you are not the best one, but your strategy is amazing and we'll prepare a gift for you...");
            int f = open("./gift", 0);
            if (f < 0)
                panic("Fail to open gift");
            char buf[0x1000];
            int res = read(f, buf, 0x1000);
            close(f);
            if (res <= 0)
                panic("Fail to get the gift");
            res += snprintf(&buf[res], 0xfff - res, "%s", "\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
            res += snprintf(&buf[res], 0xfff - res, "%s", "\n===== CSAW'22 Blackjack ====");
            res += snprintf(&buf[res], 0xfff - res, "%s", "\n$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");
            res += snprintf(&buf[res], 0xfff - res, "%s", "\n♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠♠\n");
            res += snprintf(&buf[res], 0xfff - res, "%s", "\n============Name============\n");
            res += snprintf(&buf[res], 0xfff - res, "%s", tmp->name);
            res += snprintf(&buf[res], 0xfff - res, "%s", "\n==========Strategy==========\n");
            res += snprintf(&buf[res], 0xfff - res, "%s", tmp->msg);
            buf[res] = 0; // Vul
            puts(buf);
        }
        free(tmp);
    }
    else
        puts("The winner takes it all, the loser standing small ~");
}
void show_scoreboard()
{
    printf("The best score is %d\n\n", get_koh());
    int f = open("./msg", 0);
    if (f < 0)
        panic("Fail to open ./msg");
    char buf[0x200];
    memset(buf, 0, sizeof(buf));
    if (read(f, buf, 0x200) <= 0)
        panic("Fail to get info from ./msg");
    close(f);
    puts(buf);
}
int main(int argc, char **argv)
{
    init();
    puts("[Note] If you find something uncomfortable with others' messages, please contact us on discord");
    puts("[Note] We'll init koh/msg files every 300 mins, plz don't cheat(modify the files) to be the winner");
    puts("[Note] Don't share your solution in msg");
    puts("[Note] Leave some thing interesting on scoreboard but please make sure that your messages follow the rules on discord 'rule' page or we have to remove this interesting feature.");
    puts("[Note] Agree above rules to start? (Y/N)\n\n");
    char c = getchar();
    // getchar();

    srand((unsigned)time(NULL)); // Generates random seed for rand() function
    show_scoreboard();
    while (c == 'Y')
    {
        arena();
        score_report();
        puts("[*] Play again?(Y/N)");
        do
        {
            c = getchar();
            // getchar();
        } while (c != 'Y' && c != 'N');
    }
    return 0;
}
