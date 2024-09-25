#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#define EVIDENCE_SIZE 1024
#define ANSWER_SIZE 1024
#define INVENTORY_SIZE 2048 
#define DOCUMENT_SIZE 2048


typedef struct People{

	char name[100];
	char phone_number[100];
	int age;
	int flag;

	struct People * fd;
	struct People * bk;

} Suspect; 

enum report_state { HOLDING, PROCESSING, VERIFYING,EXECUTING };

typedef struct Report{
	
	enum report_state state;
	struct Relativity* context;
	struct People* suspeople;
	int number_of_crimes; 
	int ban_list; 
		

} Document;

typedef struct Relativity{

	int authcode;
	
	struct relativity*fd;
	struct relativity*bk;


} Context;


struct{ 

	struct Report crtable[DOCUMENT_SIZE];

} rrecord;


void scenario(){
	
	char format[] = "\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x2d\x0a";
		
	char suspect[] = "\x7c\x53\x55\x53\x50\x45\x43\x54\x7c\xa\x53\x4d\x49\x54\x48\x3a\x20\x4d\x45\x53\x53\x45\x44\x20\x55\x50\x20\x4d\x59\x20\x53\x54\x41\x43\x4b\xa\x59\x41\x4e\x59\x3a\x20\x4d\x45\x53\x53\x45\x44\x20\x55\x50\x20\x4d\x59\x20\x48\x45\x41\x50\xa\x44\x4f\x52\x59\x3a\x20\x4d\x45\x53\x53\x45\x44\x20\x55\x50\x20\x4d\x59\x20\x50\x52\x4f\x47\x52\x41\x4d\x53\xa\x4a\x45\x4e\x4e\x59\x3a\x20\x4d\x45\x53\x53\x45\x44\x20\x55\x50\x20\x4d\x59\x20\x43\x4f\x4d\x50\x55\x54\x45\x52\xa\x46\x4f\x52\x59\x3a\x20\x3f\x3f\xa\x52\x4f\x59\x3a\x20\x4d\x45\x53\x53\x45\x44\x20\x55\x50\x20\x4d\x59\x20\x41\x50\x50\xa";
	
	write(1,format,sizeof(format));
	write(1,suspect,sizeof(suspect));	
	write(1,format,sizeof(format));

}

void congratulation(){
		
		char convertable[100];	
		char changeable[100];

		char shellcode[] = "\xeb\x12\x31\xc9\x5e\x56\x5f\xb1\x15\x8a\x06\xfe\xc8\x88\x06\x46\xe2\xf7\xff\xe7\xe8\xe9\xff\xff\xff\x32\xc1\x32\xca\x52\x69\x30\x74\x69\x01\x69\x30\x63\x6a\x6f\x8a\xe4\xb1\x0c\xce\x81";
		
		printf("REWARD:0x%1x\n",&shellcode);
		fflush(stdout);

			
		write(1,"YOUR SIGN NUMBER:\n",18);	
		write(1,"$",1);
		read(0,changeable,sizeof(changeable));

		unsigned int sign_number = (unsigned int)strtoul(changeable,NULL,16);


		write(1,"PLACE FOR YOUR SIGN\n",20);	
		write(1,"$",1);
		
		read(0,convertable,sizeof(convertable));

		unsigned int *sign_place = (unsigned int *)strtoul(convertable,NULL,16);
	
		*sign_place = sign_number;

		exit(0);		
}


void suspect_list(struct People*suspect){

	Suspect * p = suspect;	
		
	write(1,"Suspect\n",10);
	write(1,"----------------------------\n",30);
	int i = 0;	
	for(; i < 10; i++,p++){
		printf("| %s | %d | %s | %p | %p |\n",p->name,p->age,p->phone_number,p->fd,p->bk);
	}
	fflush(stdout);
	write(1,"-----------------------------\n",30);

}


void add_suspect(struct People*suspect){
	
	Suspect *p = suspect;
	char temp_age[7];	

	while(p != NULL){
		if(!(p->flag)){
			write(1,"ADDING SUSPECT\n",15);		
			write(1,"Name?:",6);
			read(0,p->name,6);
			p->name[strlen(p->name)-1] = '\0';
			write(1,"Age?:",6);
			read(0,temp_age,4);
			p->age = atoi(temp_age);
			write(1,"Phone Number?:",14);
			read(0,p->phone_number,14);
			p->phone_number[strlen(p->phone_number)-1] = '\0';
			p->flag=1;
			break;
		
		}
		p++;
	}

}


void remove_suspect(struct People*suspect){

	Suspect * p = suspect;
	char name[100];

	write(1,"DELETE WRONG ITEMS\n",19);		
	write(1,"Name to Remove?:",16);
	read(0,name,sizeof(name));

	while(p != NULL){
		if(p->flag){
		       if(!strncmp(p->name,name,5)){

				p->name[0] = '\0';
				p->age = 0;
				p->phone_number[0] ='\0';
				p->flag = 0;	
				break;

		       }
		}	
		p++;	
	}

}


void swap_suspect(struct People*suspect){

	Suspect * p =suspect;

	char name[100];
	char age[6];

	write(1,"SWAP SUSPECT\n",13);	
	write(1,"Name?:",6);
	read(0,name,sizeof(name));
	
	while(p != NULL){
		if(p->flag){

			if(!strncmp(p->name,name,5)){

				write(1,"New Name?:",10);
				read(0,p->name,6);
				p->name[strlen(p->name)-1] = '\0';
				write(1,"New Age?:",9);
				read(0,age,4);
				p->age = atoi(age);
				write(1,"Phone Number?:",14);
				read(0,p->phone_number,14);
				p->phone_number[strlen(p->phone_number)-1] = '\0';
				break;

			}
		}

		p++;
	
	}	
		
}

void shift_left(int math[5][5]){
	int i;
	int j;
	
	for(i = 0;i < 5;i++){
	     for(j = 0;j < 5;j++){
			math[i][j] = math[i][j] << 2;
		}

	}

}

void shift_right(int math[5][5]){
	
	int i;
	int j;
	
	for(i = 0;i < 5;i++){
	     for(j = 0;j < 5;j++){

			math[i][j] = math[i][j] >>  2;
		}

	}

}

void print_signature(int math[5][5]){
	
	int i;
	int j;

	write(1,"-------------------------\n",27);
		for(i = 0;i < 5;i++){
		     for(j = 0;j < 5;j++){

			     printf("| %d |",math[i][j]);
			     fflush(stdout);
		      
		}

	     write(1,"\n",1);
	}

	write(1,"-------------------------\n",27);

}

void update_signature_queue(int math[5][5],int solution[5][5],int final[5][5]){
	
	int i;
	int j;

	char quenum[10];

	while(1){	

		write(1,"UPDATE THE SIGNATURE QUEUE\n",27);
		write(1,"$",1);
		read(0,quenum,sizeof(quenum));

		switch(quenum[0]){
	
			case '1':
				write(1,"Updating first queue....\n",25);

				for(i = 0; i < 5;i++){
						solution[0][i] = math[0][i];												
					}

				break;
			case '2':
				write(1,"Updating second queue....\n",26);

				for(i = 0; i < 5;i++){
						solution[1][i] = math[1][i];												
				}

				break;
			case '3':
				write(1,"Updating third queue....\n",25);

				for(i = 0; i < 5;i++){
						solution[2][i] = math[2][i];												
				}

				break;
			case '4':
				write(1,"Updating fourth queue....\n",26);

				for(i = 0; i < 5;i++){
						solution[3][i] = math[3][i];												
				}

				break;
			case '5':

				write(1,"Updating fifth queue....\n",25);

				for(i = 0; i < 5;i++){
						solution[4][i] = math[4][i];												
				}
				break;

			case 'Q':
				return; 
				break;

			case 'S':
				
				write(1,"************ ***********\n",25);
				write(1,"*****||***** *****||****\n",25);	
				write(1,"*****||***** *****||****\n",25);				
				write(1,"************ ***********\n",25);
				write(1,"Signing the report....\n",23);

				
				for(i = 0;i < 5;i++){
		     			for(j = 0;j < 5;j++){
						if(solution[i][j] != final[i][j]){
							write(1,"USE OF FAKE SIGN IS AGAINST THE LAW!\n",37);
							return;
						}		
			     		}	
				}

				congratulation();
				break;

			case 'V':
				write(1,"-------------------------\n",27);
				for(i = 0;i < 5;i++){
		     			for(j = 0;j < 5;j++){
			     			printf("| %d |",solution[i][j]);
						fflush(stdout);	
					}
					write(1,"\n",1);
				}
				write(1,"-------------------------\n",27);
				break;
			default:
				write(1,"Don't understand your input!\n",30);
				break;
		}
	}

}

void reset_signature(int math[5][5],int temp [5][5]){

	int i;
	int j;

	for(i = 0;i < 5;i++){
		     for(j = 0;j < 5;j++){
			     math[i][j] = temp[i][j];
		      
		}
	}

}

void verify_signature(struct People*suspect,int final_answer[5][5]){
	
	Suspect * ptr = suspect;
		
	int i;
	int j;

	int final_solution[5][5] = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}};
	int math[5][5] = { {1,2,3,4,5},{4,5,6,7,8},{5,6,7,8,9},{6,7,8,9,1},{7,8,9,2,3} };

	int reset[5][5];

	char answer[6];
	char signature[3];	
	

	int fd = open("criminal.txt",O_RDONLY);

	if (fd <= 0){
		write(1,"Can't Open the file!\n",21);
		return;	
	
	}

	
	read(fd,answer,4);
	close(fd);

	write(1,"\n",1);

	if(!strncmp(ptr->name,answer,4)){

		write(1,"YOU HAVE FOUND THE CRIMINAL!\n",29);

	}else{

		write(1,"SORRY, THIS PERSON IS INNOCENT!\n",33);
		return;	
		
	}
	

	write(1,"\n",1);
	
	write(1,"PLEASE SIGN THE REPORT WITH VALID SIGNATURE!\n",46);

	write(1,"-------------------------\n",27);

	for(i = 0;i < 5;i++){
	     for(j = 0;j < 5;j++){
		     reset[i][j] = math[i][j];
		}

	}


	while(1){
		
		write(1,"EQUATION FOR VALID SIGNATURE\n",29);
		write(1,"-------------------------\n",27);
		write(1,"| v | w | x | y | z |\n",22);
		write(1,"-------------------------\n",27);
		write(1,"1.((v-w)+(x % y)) % z = 128\n",29);
		write(1,"2.FOUR OF A KIND AND SUM IS 384\n",32);
		write(1,"3.y^2 = (x^3/z)+3w+1692047\n",27);
		write(1,"4.PALINDROME\n",13);
		write(1,"5.((v | w) + (x^y)) & z = 524288\n",33);
		write(1,"-------------------------\n",27);
		write(1,"$",1);

		read(0,signature,2);

		switch(signature[0]){

			case '1':
				shift_left(math);			
				break;
			case '2':
				shift_right(math);			
				break;
			case '3':
				print_signature(math);
				break;
			case '4':
				update_signature_queue(math,final_solution,final_answer);
				break;
			case 'R':
				reset_signature(math,reset);
				break;
			default:
				break;
	
		}

	}	



}

void report_suspect(struct People*suspect,int final_answer[5][5]){
	
	
	int i = 0;
	char answer[3];	
	
	struct Report* p = rrecord.crtable;
	Suspect *temp = suspect;	
	p->suspeople = suspect;

	write(1,"SUBMIT REPORT\n",14);

	for(;p< &rrecord.crtable[DOCUMENT_SIZE];p++){
		for(; i < 10;i++){
			if (p->state == HOLDING && temp != NULL){
				p->context->authcode = i; 	
				p->state = PROCESSING;
				temp++;
			}
		}
		break;	
	}

	write(1,"Is this the final list?\n",24);
	suspect_list(suspect);
	write(1,"$",1);
	
	fgets(answer,sizeof(answer),stdin);
	
	switch(answer[0]){
		case 'y':
			verify_signature(p->suspeople,final_answer);	
			break;
		case 'n':
			write(1,"Returning....\n",15);
			break;
		default:
			break;

	}	
		
}	
					

int main(int argc,char*argv[]){

	char answer[ANSWER_SIZE];
	Suspect people[INVENTORY_SIZE];
	Document document[DOCUMENT_SIZE];
	struct Report * p;

	FILE* fd;

 	fd = fopen("answer.txt","r");

	int k;


	int final[5][5] = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}};

	while(feof(fd) == 0){
		
		fscanf(fd, "%d %d %d %d %d",&final[k][0],&final[k][1],&final[k][2],&final[k][3],&final[k][4]);	
		k++;	
	}
		
	fclose(fd);

	for(p = rrecord.crtable; p < &rrecord.crtable[DOCUMENT_SIZE];p++){

		p->state = PROCESSING;	
	
	}

	while (1){

		write(1,"EVIDENCE DIRECTORY\n",19);
		write(1,"$",1);
		fgets(answer,sizeof(answer),stdin);
			
		switch(answer[0]){

			case '1':
				suspect_list(people);
				break;

			case '2':
				add_suspect(people);
				break;

			case '3':
				remove_suspect(people);
				break;

			case '4':
				swap_suspect(people);
				break;
			case '5':
				report_suspect(people,final);	
				break;	
			case '#':
				scenario();
				break;


		}
			
	}
	return 0;
}
