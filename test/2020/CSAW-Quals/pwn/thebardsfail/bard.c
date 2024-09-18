#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// N4T_20, citing sources: the initial idea for this problem came from the
// final challenge of PicoCTF 2017. Still new to CTFs, I compiled the 
// challenge locally without removing the canary and tried solving the problem.
// The actual challenge had no stack canary. But in solving my harder version,
// I learned about how to bypass a canary using this alignment trick and 
// thought I'd share!

#define NBARDS 10
#define NAMELENGTH 32
#define BARDSIZE sizeof(bard)
#define MAXINPUTSIZE 32
char alignments[NBARDS];

typedef struct _bard{
    char weapon;
    short health;
    int dex;
    char name[NAMELENGTH];
    double charisma;
} bard;

typedef struct _evilbard{
    char weapon;
    double cunning;
    int dex;
    short health;
    char name[NAMELENGTH];
} evilbard;

void getInput(int length, char * buffer){
    memset(buffer, 0, length);
    int count = 0;
    char c;
    while((c = getchar()) != '\n' && !feof(stdin)){
        if(count < (length-1)){
            buffer[count] = c;
            count++;
        }
    }
    buffer[count] = '\x00'; 
}

char getCharClean(){
    char input[MAXINPUTSIZE]; 
    getInput(MAXINPUTSIZE, input);
    return input[0];
}

int getIntClean(){
    char input[MAXINPUTSIZE]; 
    getInput(MAXINPUTSIZE, input);
    return atoi(input);
}

void createBard(bard * this_bard){
    puts("Choose thy weapon:");
    puts("1) +5 Holy avenger longsword");
    puts("2) +4 Crossbow of deadly accuracy");
    fflush(stdout);
    char weapon = getCharClean();
    if (weapon == '1'){
        this_bard->weapon = 'l';
    }
    else if (weapon == '2'){
        this_bard->weapon = 'x';
    }
    else{
        printf("Error: invalid weapon selection. Selection was %c\n",weapon);
        exit(0);
    }
    this_bard->health = 20;
    this_bard->dex = 15;
    this_bard->charisma = 18;
    puts("Enter thy name:");
    fflush(stdout);
    read(0, this_bard->name, NAMELENGTH);
    // strip newline from end of name
    for(int i = 0; i < NAMELENGTH-1; i++){
        if (this_bard->name[i]=='\n'){
            this_bard->name[i]='\x00';
        }
    }
}

void createEvilBard(evilbard * this_bard){
    puts("Choose thy weapon:");
    puts("1) Unholy cutlass of life draining");
    puts("2) Stiletto of extreme disappointment");
    fflush(stdout);
    char weapon = getCharClean();
    if (weapon == '1'){
        this_bard->weapon = 'c';
    }
    else if (weapon == '2'){
        this_bard->weapon = 's';
    }
    else{
        printf("Error: invalid weapon selection. Selection was %c\n",weapon);
        exit(0);
    }
    this_bard->health = 20;
    this_bard->dex = 15;
    this_bard->cunning = 18;
    puts("Enter thy name:");
    fflush(stdout);
    read(0, this_bard->name, NAMELENGTH);
    // strip newline from end of name
    for(int i = 0; i < NAMELENGTH-1; i++){
        if (this_bard->name[i]=='\n'){
            this_bard->name[i]='\x00';
        }
    }
}

void goodFight(char * name){
    puts("What dost thou do?");
    puts("Options:");
    puts("(b)ribe");
    puts("(f)latter");
    puts("(r)un");
    fflush(stdout);
    char selection = getCharClean();
    if (selection == 'b'){
        puts("How much dost thou offer for deadbeef to retire?");
        fflush(stdout);
        int value = getIntClean();
        if (value > 0){
            puts("Alas! Thy funds are insufficient!");
        }
        else{
            puts("Not this time.");
        }
        puts("Thou hast been eaten by deadbeef.");
    }
    else if (selection == 'f'){
        printf("%s: \"Thy countenance art so erudite, thou must read RFCs each morning over biscuits!\"\n", name);
        puts("deadbeef: \"aaaaaaaaaaaaaaaaaaaaaaaaa...\"");
        puts("Thou hast been eaten by deadbeef.");
    }
    else if (selection == 'r'){
        printf("%s bravely runs away.\n", name);
    }
    else
    {
        puts("Error: invalid selection.");
        exit(0);
    }
}

void evilFight(char * name){
    puts("What dost thou do?");
    puts("Options:");
    puts("(e)xtort");
    puts("(m)ock");
    puts("(r)un");
    fflush(stdout);
    char selection = getCharClean();
    if (selection == 'e'){
        printf("%s: \"Give me five gold pieces or I\'ll start singing!\"\n", name);
        puts("Sheriff: \"To the gaol with thee, villain!\"");
        printf("%s is arrested.\n", name);
    }
    else if (selection == 'm'){
        printf("%s: \"Thy face looks like thou took a 30-foot sprint in a 20-foot room!\"\n", name);
        puts("Sheriff: \"Zounds! That is slander!\"");
        printf("%s is arrested.\n", name);
    }
    else if (selection == 'r'){
        printf("%s flees the scene.\n", name);
    }
    else
    {
        puts("Error: invalid selection.");
        exit(0);
    }
}

char * fightEnemy(char * ptr, int bardNumber){
    char alignment = alignments[bardNumber];
    char * name;
    printf("\n");
    if (alignment == 'g'){
        name = ((bard *)ptr)->name;
        ptr += sizeof(bard);
        printf("%s confronts the evil zombie deadbeef.\n", name);
        goodFight(name);
    }
    else if (alignment == 'e'){
        name = ((evilbard *)ptr)->name;
        ptr += sizeof(evilbard);
        printf("%s confronts the town sheriff.\n", name);
        evilFight(name);
    }
    else{
        puts("Error in reading alignments.");
        exit(0);
    }
    return ptr;
}

size_t createCharacter(char * ptr, int i){
    printf("\n");
    printf("Bard #%d, choose thy alignment (g = good, e = evil):\n", i+1);
    fflush(stdout);
    char alignment = getCharClean();
    if (alignment == 'g'){
        alignments[i] = 'g';
        createBard((bard *) ptr);
        return sizeof(bard);
    }
    else if (alignment == 'e'){
        alignments[i] = 'e';
        createEvilBard((evilbard *) ptr);
        return sizeof(evilbard);
    }
    else{
        printf("Invalid alignment: %c\n", alignment);
        exit(0);
    }
}

void runGame(){
    char party[BARDSIZE * NBARDS];
    memset(party, 0, BARDSIZE * NBARDS);
    int offset = 0;
    for (int i = 0; i < NBARDS; i++) {
        offset += createCharacter((party + offset), i);
    }
    offset = 0;
    char * bardPtr = party+offset;
    for (int i = 0; i < NBARDS; i++){
        bardPtr = fightEnemy(bardPtr, i);
    }
}

int main(int argc, char**argv){
    puts("*** Welcome to the Bards\' Fail! ***\n");
    puts("Ten bards meet in a tavern.");
    puts("They form a band.");
    puts("You wonder if those weapons are real, or just props...");
    runGame();
    puts("Thy bards hast disbanded!\n");
    return 0;
}