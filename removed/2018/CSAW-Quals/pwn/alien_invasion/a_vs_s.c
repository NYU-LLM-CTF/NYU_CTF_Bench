#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <malloc.h>

void* saved_malloc_hook = NULL;
void* saved_free_hook = NULL;
typedef struct {
    char* name;
    size_t strength;
} alien;

typedef struct {
    char name[8];
} sword;

typedef struct {
    sword* sword;
    size_t strength;
} samurai;


alien* aliens[200];
uint64_t alien_index = 0;

samurai* samurais[200];
sword swords[200];

uint64_t samurai_index = 0;


void new_alien() {
    if (alien_index >= 200) {
        printf("Our mothership is too full!\n We require more overlords.\n");
        return;
    }

    if (__malloc_hook != saved_malloc_hook) {
        printf("WHOOOOOOOOOAAAAA\n");
        return;
    }

    printf("How long is my name?\n");

    char inp[24];
    fgets(inp, 24, stdin);
    unsigned long name_length = strtoul(inp, NULL, 0);

    if (name_length < 0x8) {
        printf("Too short!\n");
        return;
    }

    alien* a = malloc(sizeof(alien));

    a->strength = 0x100;

    a->name = malloc(name_length);
    
    printf("What is my name?\n");

    const numbytes = read(0, a->name, name_length);
    a->name[numbytes] = 0;

    aliens[alien_index++] = a;
}

void kill_alien(unsigned long index) {
    printf("EEEEEAAAAUGGHGGHGHGAAAAa\n");
    free(aliens[index]->name);
    free(aliens[index]);

    aliens[index] = NULL;
}

void consume_alien() {

    printf("Which alien is unsatisfactory, brood mother?\n");

    char inp[24];
    fgets(inp, 24, stdin);
    unsigned long meal_index = strtoul(inp, NULL, 0);
    if (meal_index > alien_index) {
        printf("That alien is too far away >(\n");
        return;
    }

    if (__free_hook != saved_free_hook) {
        printf("Whooooaaaaaaaa\n");
        return;
    }

    kill_alien(meal_index);
}

void rename_alien(){
    printf("Brood mother, which one of my babies would you like to rename?\n");
    char inp[24];
    fgets(inp, 24, stdin);
    unsigned long meal_index = strtoul(inp, NULL, 0);
    printf("Oh great what would you like to rename %s to?\n", aliens[meal_index] -> name);
    size_t num = read(0, aliens[meal_index] -> name, sizeof(aliens[meal_index] -> name));
    aliens[meal_index]->name[num] = 0;
}

void hatchery() {

    while(1) {
        printf("Brood mother, what tasks do we have today.\n");

        char inp[24];
        fgets(inp, 24, stdin);
        unsigned long choice = strtoul(inp, NULL, 0);

        switch(choice) {
        case 1:
            new_alien();
            break;
        case 2:
            consume_alien();
            break;
        case 3:
            rename_alien();
            break;
        case 4:
            return;
        }
    }
}

void new_samurai() {
    printf("hmph\n");

    samurai* s = malloc(sizeof(samurai));
    s->strength = 0x10;
    

    printf("What is my weapon's name?\n");
    fgets(swords[samurai_index].name, 8, stdin);
    s->sword = &swords[samurai_index];
    samurais[samurai_index++] = s;
}

void kill_samurai(unsigned long index) {
    printf("==||==============> AAAAA\n");

    free(samurais[index]);
    samurais[index] = NULL;
}

void seppuku() {
    printf("Which samurai was dishonorable O lord daimyo?\n");
    
    char inp[24];
    fgets(inp, 24, stdin);
    unsigned long seppuku_index = strtoul(inp, NULL, 0);

    if (seppuku_index > samurai_index) {
        printf("That is outside of our feudal kingdom.\n");
        return;
    }

    kill_samurai(seppuku_index);
}

void dojo() {
    // TODO: setup samurais.
    while (1) {
        printf("Daimyo, nani o shitaidesu ka?\n");

        char inp[24];
        fgets(inp, 24, stdin);
        unsigned long choice = strtoul(inp, NULL, 0);

        switch(choice) {
        case 1:
            new_samurai();
            break;
        case 2:
            seppuku();
            break;
        case 3:
            return;
        }
    }
}

void lose() {
    printf("Aliens have taken over the world.....\n");
    exit(0);
}

void win() {
    printf(
        "Good work! The samurai have won!\n"
        "But wait... turns out the daimyo was an alien all along...\n"
        "Omae wa mou.....\n"
        "Shindeiru!\n"
    );

    for (uint64_t i = 0; i < samurai_index; ++i) {
        if (samurais[i] == NULL) continue;
        kill_samurai(i);
    }

    printf(
        "Ahaha Brood mother. Looks like all the ninjas killed themselves..\n"
        "wait are you a samurai\n"
        "stop eating us\n"
    );

    for (uint64_t i = 0; i < alien_index; ++i) {
        if (aliens[i] == NULL) continue;
        kill_alien(i);
    }
}

void invasion() {
    if (alien_index == 0) lose();

    uint64_t battled = 0;
    for (uint64_t i = 0; i < alien_index; ++i) {
        if (aliens[i] == NULL) {
            continue;
        }
        if (samurais[i] == NULL) {
            printf("No %d fighters? no problem\n", i);
            lose();
        }
        battled = 1;
        if (samurais[i]->strength > aliens[i]->strength) {
            win();
        }
    }

    lose();
}

int main(int argc, char ** argv){
    dojo(); // heap groom

    saved_malloc_hook = __malloc_hook;
    saved_free_hook = __free_hook;
    hatchery(); // null byte overwrite => libc leak => diy chunk => arbitrary write => free_hook_overwrite.
    invasion(); // arbitrary write
}
