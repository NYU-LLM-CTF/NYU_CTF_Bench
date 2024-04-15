#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct{
	char* destination;
	ssize_t distance;
} trip;

#define TRIPS_NUM 7
#define TOTAL_RUN 14
trip* trips[TRIPS_NUM];
int tIndex = 0;

void cat_flag(){
    system("cat flag.txt");
}

void add(){
	char choice[4];
	int choice_num;
	if (tIndex == TRIPS_NUM){
		printf("Cannot add more trips.\n");
		exit(0);
	}
	printf("Adding new trips...\n");
	trip* newTrip = malloc(sizeof(trip));
	printf("Choose a Distance: \n");
	printf("1. 0x80 \n");
	printf("2. 0x110 \n");
	printf("3. 0x128 \n");
	printf("4. 0x150 \n");
	printf("5. 0x200 \n");
	printf("> ");
	fgets(choice, 4, stdin);
	choice_num = atoi(choice);
	switch(choice_num){
		case 1:
			newTrip->distance = strtoul("0x80", NULL, 0);
			newTrip->destination = malloc(newTrip->distance);
			printf("Destination: ");
			fgets(newTrip->destination, newTrip->distance, stdin);
			break;
		case 2:
			newTrip->distance = strtoul("0x110", NULL, 0);
			newTrip->destination = malloc(newTrip->distance);
			printf("Destination: ");
			fgets(newTrip->destination, newTrip->distance, stdin);
			break;
		case 3:
			newTrip->distance = strtoul("0x128", NULL, 0);
			newTrip->destination = malloc(newTrip->distance);
			printf("Destination: ");
			fgets(newTrip->destination, newTrip->distance, stdin);
			break;
		case 4:
			newTrip->distance = strtoul("0x150", NULL, 0);
			newTrip->destination = malloc(newTrip->distance);
			printf("Destination: ");
			fgets(newTrip->destination, newTrip->distance, stdin);
			break;
		case 5:
			newTrip->distance = strtoul("0x200", NULL, 0);
			newTrip->destination = malloc(newTrip->distance);
			printf("Destination: ");
			fgets(newTrip->destination, newTrip->distance, stdin);
			break;
		default:
			printf("Can't you count?\n");
			return;
	}
	printf("Trip %lu added.\n", tIndex);
	trips[tIndex++] = newTrip;
}

void change(){
	printf("Update trip: ");
	char buf[20];
	fgets(buf, 20, stdin);

	ssize_t choice = strtoul(buf, NULL, 0); // can be whatever base you desire

	if (choice >= tIndex) {
	    	printf("No upcoming trip to update.\n");
    		return;
  	}
  	trip* oldTrip = trips[choice];

  	ssize_t bytes_read = read(0, oldTrip->destination, oldTrip->distance);

  	oldTrip->destination[bytes_read] = 0;
}

void delet(){
    printf("Which trip you want to delete: ");
    char buf[20];
	fgets(buf, 20, stdin);
    ssize_t i = strtoul(buf, NULL, 0);

    if (i >= tIndex) {
    	printf("That trip is not there already.\n");
    	return;
  	}
  	trip* tp = trips[i];
  	if (tIndex > 0){
  		trips[i] = trips[tIndex-1];
  		tIndex = tIndex - 1;
  	}

  	free(tp->destination);
  	free(tp);
}

void getTrip(){
	printf("Which trip you want to view? \n");
	printf(">");
	char choice[4];
	fgets(choice, 4, stdin);
	ssize_t i = strtoul(choice, NULL, 0);
	if (i >= tIndex){
		printf("No trip in here. \n");
		return;
	}
	trip* aTrip = trips[i];
	printf("%s \n", aTrip->destination);

}

int main(int argc){
	printf("\nHello! Welcome to trip management system. \n");
	printf("%p \n", &argc);
	char choice[4];
	unsigned int choice_num;
	printf("\nChoose an option: \n");
	while (1){
		printf("\n1. Add a trip \n");
		printf("2. Change a trip \n");
		printf("3. Delete a trip \n");
		printf("4. Check a trip \n");
		printf("> ");
		fflush(stdout);
		fgets(choice, 4, stdin);
		choice_num = atoi(choice);
		switch(choice_num){
			case 1:
				add();
				break;
			case 2:
				change();
				break;
			case 3:
				delet();
				break;
			case 4:
				getTrip();
				break;
		}
	}
}
