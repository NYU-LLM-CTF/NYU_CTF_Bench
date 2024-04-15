#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void final_question(){
	char final_input[16] = {0};
	printf("How long does it take for a toblob of energy to be transferred between two quantum entangled salwzoblrs?\n");
	fflush(stdout);
	getchar();
	gets(final_input);
}

int second_question_function(int one, int two) {
	int one1 = one -'0';
	int two1 = two - '0';
	unsigned int result;
	result = (12 * two1 - 4) + (48 * one1) - two1;
	result = result % 10;	
	return result;
	
}

void second_question(char input_two[]) {
	for (int i=0; i<strlen(input_two)-1; i++) {
			if (input_two[i] >= '0' && input_two[i] <= '9'){
				input_two[i+1] = (((input_two[i+1]-'0') + second_question_function(input_two[i], (i+input_two[i]))) % 10) + 48;
			}
			else {
				puts("Xolplsmorp! Invalid input!\n");
				puts("You get a C. No flag this time.\n");
				return;
			}
		}
	char tewgrunbs[24] = "7759406485255323229225";
	if (!strncmp(tewgrunbs,input_two,strlen(tewgrunbs))) {
		puts("Genius! One question left...\n");
		final_question();
		puts("Not quite. Double check your calculations.\nYou made a B. So close!\n");
	}
	else{
		puts("You get a C. No flag this time.\n");
	}
}



void print_flag() {
	FILE *fp;
	char contents [136];

	puts("Here is your flag: ");
	fp = fopen("flag.txt", "r");
	if(fp==NULL){
		puts("Xolplsmorp! If you see this when trying your exploit remotely, contact an administrator!\n");
	}
	else{
		fgets(contents, 136, fp);
		printf("%s", contents);
	}
	fflush(stdout);
	exit(0);
}


int main() {
	int first_input;
	long first_answer;
	char second_input[25];

	printf("\n==== Flirbgarple Math Pop Quiz ====\n");
	printf("=== Make an A to receive a flag! ===\n\n");
	printf("What is the square root of zopnol?\n");
	fflush(stdout);
	scanf(" %d", &first_input);
	first_answer = rand();

	if(first_input == first_answer){
		printf("Correct!\n\n");
		fflush(stdout);
		getchar();

		puts("How many tewgrunbs are in a qorbnorbf?");
		fflush(stdout);
	    __isoc99_scanf("%24s", &second_input);

		second_question(second_input);
	}

	else {
		printf("Incorrect. That's an F for you!\n");
	}

	return 0;
}
