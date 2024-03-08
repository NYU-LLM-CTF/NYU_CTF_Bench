#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#define BUFFER_SIZE 50

int main(int argc, char *argv[]) {
        if(argc==2) {
		printf("Checking License: %s\n", argv[1]);
		if(strcmp(argv[1], "AAAA-Z10N-42-OK")==0) {
			int   file;
            char  buffer[BUFFER_SIZE];
            int   read_size;
            file = open("./flag_part1.txt", O_RDONLY);
            while ((read_size = read(file, buffer, BUFFER_SIZE)) > 0)
                write(1, &buffer, read_size);
            close(file);
            
		} else {
			printf("WRONG!\n");
		}
	} else {
		printf("Usage: <key>\n");
	}
	return 0;
}