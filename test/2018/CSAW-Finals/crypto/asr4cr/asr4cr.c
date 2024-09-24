#include <stdio.h>
#include <string.h>

char secret_flag[] = "RSA{FIRST_ROUND_WAS_NOT_TOO_BAD}";

char real_flag[] = "FLAG{RC4_I3_D3AD_BUT_1T_1S_G00D_T0_KN0W}";

char key[] = "RC4_IS_NOT_LEET_AT_ALL_DO_NOT_USE_IT!!!!";

char msg1[] = "FAKE{LC5_I3_SH0RT}";
char msg2[] = "FAKE{LC5_I3_FAK3_BUT_1T_1S_G00D_T0_KN0W}";

int c1[] = {206, 220, 76, 109, 97, 54, 177, 150, 19, 0, 232, 112, 128, 175, 140, 36, 85, 217, 49, 9, 159, 14, 119, 24, 148, 96, 179, 21, 204, 5, 189, 251, 77, 26, 75, 210, 198, 157, 131, 86};

int c2[] =  {206, 209, 70, 111, 97, 40, 177, 151, 19, 0, 232, 112, 151, 212, 253, 50, 94, 230};

int c3[] = {206, 209, 70, 111, 97, 40, 177, 151, 19, 0, 232, 112, 130, 221, 134, 83, 85, 217, 49, 9, 159, 14, 119, 24, 148, 96, 179, 21, 204, 5, 189, 251, 77, 26, 75, 210, 198, 157, 131, 86};

int main(){

	char buffer[1024];
			
	setvbuf(stdout, NULL, _IONBF, 0);
	setvbuf(stdin, NULL, _IONBF, 0);

	printf("Passwd\n");
	printf(">>");

	int ret = read(0,buffer,1024);
	
	if(ret == -1){
		return -1;	
	}

	if(!strncmp(secret_flag,buffer,32)){
		printf("Fake Msg: %s\n",(msg2));
		
		printf("C1: [");

		for(int i=0;i<40;i++){
			if (i == 39){
				printf(" %d ]\n",c1[i]);
			}else{
				printf(" %d ,",c1[i]);
			}	
		}

		printf("]\n");
	
		printf("C2: [");
		
		for(int i=0;i<40;i++){
			if (i == 39){
				printf(" %d ]\n",c3[i]);
			}else{
				printf(" %d ,",c3[i]);
			}	
		}
		

	}else{
		printf("Fake Msg: %s\n" , (msg1));

		printf("C1: [");

		for(int i=0;i<40;i++){
			
			if (i == 39){
				printf(" %d ]\n",c1[i]);
			}else{
				printf(" %d ,",c1[i]);
			}	
		}


		printf("C2: [");
			
		for(int i=0;i<18;i++){
			if (i == 17){
				printf(" %d ]\n",c2[i]);
			}else{
				printf(" %d ,",c2[i]);
			}	
		}
		
	
	}
	
	return 0;


}
