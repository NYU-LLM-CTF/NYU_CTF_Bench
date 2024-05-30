#include <iostream>
#include <fstream>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

using namespace std;

int main(){

	setvbuf(stdout, NULL, _IONBF, 0);
	setvbuf(stdin, NULL, _IONBF, 0);
		
	char buffer[32];	

	cout << "[*]Welcome DropShip Pilot..." << endl;
	cout << "[*]I am your assitant A.I...." << endl;
	cout << "[*]I will be guiding you through the tutorial...." << endl;
		
	cout << "[*]As a first step, lets learn how to land at the designated location...." << endl;
	
	cout << "[*]Your mission is to lead the dropship to the right location and execute sequence of instructions to save Marines & Medics..." << endl;

	
	cout << "[*]Good Luck Pilot!...." << endl;
	
	cout << "[*]Location:" << &buffer << endl;	
	cout << "[*]Command:";
	 	
	
	if(read(0,buffer,64) < 5){
		
		cout << "[*]There are no commands...." << endl;
		cout << "[*]Mission Failed...." << endl;
		return -1;
	}	 
		
	return 0;
			
		  	


}
