#include <stdio.h>
#include <string.h>

char flag[30] = {};
int index_flag = 0;

int xoring(int binary[]){
    int bin_1[4] = {};
    int bin_2[4] = {};
    
    for (int i = 0; i < 4; i++){
    	bin_1[i] = binary[i];
    	bin_2[i] = binary[i+4];
    }
    
    for (int i = 0; i < 4; i++) {
    	if (bin_1[i] == bin_2[i]) {
    		flag[index_flag] = '0';
    		index_flag++;
    	} else {
    		flag[index_flag] = '1';
    		index_flag++;
    	}
    }
    return 0;
}

void printbinchar(char character)
{
    int i;
    int bin;
    int binary[8] = {};
    char ch = character;
    
    for (i = 0; i < 8; i++) {
	bin = ((ch << i) & 0x80) ? 1 : 0;
	binary[i] = bin;
    }
    xoring(binary);
    
}

int main()
{
    const char Str[20] = "BgApYb7nCswD\0";
    int i;
    int length = strlen(Str);
  
    printf("That is incorrect :(");
    
    for (i = 0; i < length; ++i) {
    	if (i % 2 == 0 && i != 0) {
    		printbinchar(Str[i]);
    	}
    }
    
    return 0;
}
