#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>

//custom
#include "starcraft.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <arpa/inet.h>	


using namespace std;

void parser(){
	
	Starcraft starcraft; 
	
	FILE*f;	
	FILE*fd;	

	char tmp[100] = "/tmp/";

	char name[201];
	char key[300];

	unsigned char data[300];
 
	cout << "----------------------------------------------" << endl;	
	cout << "|PROPHECY PROPHECY PROPHECY PROPHECY PROPHECY| " << endl;
	cout << "----------------------------------------------" << endl;
	
	cout << "[*]Give me the secret name" << endl;
	cout << ">>";

	if(read(0,name,200) > 0){
		name[strlen(name)-1] = '\0';
	}

	cout << "[*]Give me the key to unlock the prophecy" << endl;
	cout << ">>";

	if(read(0,key,300) > 0){
		key[strlen(key)-1] = '\0';
	}

	//Check for .starcraft	
	if(strstr(name,".starcraft") != NULL){
		cout << "[*]Interpreting the secret...." << endl;	
	}else{
		exit(-1);
	}
	
	//Dump the file content
	char*dump = strncat(tmp,name,strlen(name));
	
	f = fopen(strtok(dump,"\n"),"wb");
	fwrite(key,1,sizeof(key),f);
	fclose(f);	

	//parsing locally
	fd = fopen(dump,"rb");

	if(fd == NULL){
		cout << "[*]Failed to reveal the prophecy...." << endl;
		exit(-1);
	}
	
	fread(data,1,4,fd);
	
	int magic_byte = *((int *)data); 
		
	
	if(magic_byte == 387982600){
	
		char filename[8];
		unsigned char information[1];
		unsigned char info; 
			
		cout << "[*]Waiting...." << endl;
	
		//filename	
		fread(filename,1,8,fd);
		
		starcraft.filename = filename;
		
		//info	
		fread(information,1,1,fd);
		
		info = information[0];
		
		switch(info){

			case 'Z':
				cout << "[*]With the Khala fallen to corruption, the memories of our ancestors are lost to us...." << endl;
				break;	
			case 'K':
				cout << "[*]I do not join. I lead!" << endl;
				break;
			case 'J':
				cout << "[*]I never look for trouble but it always seems to find me. Usually at a bar." << endl; 
				break;
			case 'O':
				cout << "[*]On a distant, shadowed world, the protoss will make their final stand." << endl;	
				break;
			default:
				exit(-1);
				break;

		}	
		
		starcraft.info = info;
		
		//flag	
		fread(information,1,1,fd);	

		long long prophecy1 = (long long )information[0];
		
		starcraft.flag = information[0];
			

		switch(prophecy1){

			case 1:
				cout << "[*]In the fullness of time the cycle shall draw to its end." << endl;
				break;	
			case 2:
				cout << "[*]Every living thing in the universe will bow before the Queen of Blades, or else they will die. Obedience or oblivion. That is why we fight." << endl;
				break;
			case 3:
				cout << "[*]You'll see that better future Matt. But it 'aint for the likes of us." << endl;
				break;
			default:
				exit(-1);	
				break;
		

		}
			
		//date	
		long long date[4];
		
		fread(date,1,4,fd);
		
		long long prophecy2 = *(long long *)date;

		if(prophecy2 == 15002259){
			
			cout << "[*]The xel'naga, who forged the stars,Will transcend their creation...." << endl;

		}else{

			exit(-1);
		}
		
		starcraft.date = prophecy2;
		
		//hero	
		long long hero[7];
	
		fread(hero,1,7,fd);
		
		long long prophecy3 = *(long long *)hero;
		
		if(prophecy3 == 0x4c55544152455a){
			
			cout << "[*]Yet, the Fallen One shall remain,Destined to cover the Void in shadow..." << endl;
			
			cout <<"[*]Before the stars wake from their Celestial courses," << endl;			


		}else{
			exit(-1);
		}
		
		//secret
		long long secret[6];
		
		fread(secret,1,6,fd);

		long long prophecy4 = *(long long *)secret;
		

		if(prophecy4 == 0x444556415300){
		
			cout << "[*]He shall break the cycle of the gods,Devouring all light and hope." << endl;	
					
		}else{
			exit(-1);
		}
	
		//value
		long long value[4];
		
		fread(value,1,4,fd);

		long long prophecy5 = *(long long *)value;			
		if(prophecy5 ==  0x4c4c4100){
			cout << "[*]It begins with the Great Hungerer. It ends in utter darkness." << endl;
		}
		
		//close
		fclose(fd);
		cout << "==========================================================================================================" << endl;
		cout <<"[*]ZERATUL:";	
		//Clean Up janky...really...
		system("cat flag");
		cout << "==========================================================================================================" << endl;
		
		if(!remove(tmp)){
			cout << "[*]Prophecy has disappered into the Void...." << endl;
		}
			
	}	

	
}



int main(int argc , char *argv[]){
	

	setvbuf(stdout, NULL, _IONBF, 0);	
	setvbuf(stdin, NULL, _IONBF, 0);

	parser();		
 
}
