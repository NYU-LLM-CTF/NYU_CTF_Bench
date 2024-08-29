//pseudo-code for debugging, there may be lots of differences to the released csaw_game
#include<stdio.h>
#include<string.h>
#include <stdlib.h>

void *ptr=0;
unsigned int readint()
{
 char buf[0x10]={0};
 unsigned t=0;
 while(t<0x10-1)
 {
 	unsigned int res = read(0,&buf[t],1);
 	if(res!=1)
 		break;
 	if(buf[t]=='\n')
 	{
 		buf[t]=0;
 		break;
 	}
 	 t++;
 }
 return strtol(buf,0,10);
}
void add()
{
	puts("LengthOfMessage:");
	unsigned int size = readint();
	if(size<0x888)
	{	ptr=malloc(size);
		puts("Content:");
		read(0,ptr,size);
		free(ptr);
		ptr=0;
	}
}
int check()
{
	char buf[0x30];
	read(0,buf,0x48);
	return strcpy(buf,"94d6b039a32bb818fadbd91790592569");
}
void vul()
{
	
	while(1){
	add();
	puts("Escape from the CSAW-box?");	
	if(!check()){
			puts("Out there, you don’t stand a chance. I believe you will be back soon!");
			break;}
	}
}
void logo()
{
	puts("  ______    ______    ______   __       __  __   ______     __   ");
	puts(" /      \\  /      \\  /      \\ /  |  _  /  |/  | /      \\  _/  |  ");
	puts("/$$$$$$  |/$$$$$$  |/$$$$$$  |$$ | / \\ $$ |$$/ /$$$$$$  |/ $$ |  ");
	puts("$$ |  $$/ $$ \\__$$/ $$ |__$$ |$$ |/$  \\$$ |$/  $$____$$ |$$$$ |  ");
	puts("$$ |      $$      \\ $$    $$ |$$ /$$$  $$ |     /    $$/   $$ |  ");
	puts("$$ |   __  $$$$$$  |$$$$$$$$ |$$ $$/$$ $$ |    /$$$$$$/    $$ |  ");
	puts("$$ \\__/  |/  \\__$$ |$$ |  $$ |$$$$/  $$$$ |    $$ |_____  _$$ |_ ");
	puts("$$    $$/ $$    $$/ $$ |  $$ |$$$/    $$$ |    $$       |/ $$   |");
	puts(" $$$$$$/   $$$$$$/  $$/   $$/ $$/      $$/     $$$$$$$$/ $$$$$$/ ");
	puts("                                                                 ");
	puts("                                                                 ");
	puts("");
}
void CSAW()
{
	puts("Back to Win");
	free(((unsigned long long)malloc(0)>>12<<12)+0x10);
}
void init()
{
    setvbuf(stdin,0,2,0);
    setvbuf(stdout,0,2,0);
    setvbuf(stderr,0,2,0);
}
int main()
{
	init();
	logo();
	vul();
}

