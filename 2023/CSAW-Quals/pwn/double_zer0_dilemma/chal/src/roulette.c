#include <stdio.h>
#include <time.h>
#include <stdlib.h>

long bets[36];
char exit_msg[] = "Your total: $%0.2f. Come back again!\n";


int rng() {
    srand(time(NULL));
    return rand() % 37;
}

void play() {
    int index = 0;
    long amount = 0;
    puts("Enter the number (0-36) you think the roulette will land on: ");
    scanf("%d", &index);
    puts("Enter the amount you want to wager: ");
    scanf("%ld", &amount);
    bets[index] += amount;
    if (rng() == index) {
        bets[index] *= 36;
        puts("Congrats! You won.");
    } else {
        bets[index] /= 2;
        puts("Better luck next time! You lost.");
    }

}


int main() {
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);
    puts("This casino is very safe!");
    puts("You get to play twice, and we even let you keep half your money if you lose.");
    play();
    play();
    long double amount = 0;
    for (int i = 0; i < sizeof(bets); i++)
        amount += bets[i];
    printf(exit_msg, amount);
}