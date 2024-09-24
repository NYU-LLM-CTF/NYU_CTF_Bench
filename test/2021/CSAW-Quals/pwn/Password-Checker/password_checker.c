#include <stdio.h> 
#include <stdlib.h>
#include <string.h>

#define INPUTBUF 48

void backdoor() {
	system("/bin/sh");
}

void init() {
	setvbuf(stdout, NULL, _IONBF, 0);
}

void password_checker() {
	int result;
	char input[INPUTBUF];
	char password[INPUTBUF];
	printf("Enter the password to get in: \n>");
	gets(input);
	strcpy(password, "password");
	result = strcmp(input, password);
	if(result == 0) {
		printf("You got in!!!!");
	}
	else {
		printf("This is not the password");
	}
}

int main() {
	init();
	password_checker();
	return 0;
}
