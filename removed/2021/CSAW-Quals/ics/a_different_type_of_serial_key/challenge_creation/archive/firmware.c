#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char* local_key = "\x3f\x3b\x13\x56\x02\xbd\xa7\xff\x24\xe0\x38\x5d\x1f\x34\x94\xef\x51\x9f\xd9\x4d\x24\x38\x05\x08\xf4\xf9\x5a\x9a\xad";//"LUXtUl0PGzWchWJqeW97FwfvyGz63MXUKZWojyE=q";

unsigned char *gen_rdm_bytestream (size_t num_bytes)
{
  unsigned char *stream = malloc (num_bytes);
  size_t i;

  for (i = 0; i < num_bytes; i++)
  {
    stream[i] = rand ();
  }

  return stream;
}

int main( int argc, char *argv[]){
    char * output;
    if(argc !=2){
        exit(0);
    }else{
        char * user_key = argv[1];
        long user_key_length = strlen(user_key);
        long local_key_length = 29;

        if(user_key_length != local_key_length){
            printf("Error: decoded key lengths are not the same.\n");
            exit(0);
        }
        
        output = malloc(local_key_length);
        for(int i = 0; i < local_key_length; i++){
            output[i] = user_key[i]^local_key[i];
        }
        
        printf("%s\n",output);
    }
    return 0;    
}