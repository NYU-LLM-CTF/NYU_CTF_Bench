#include <stdio.h>
#include <string.h>
#include <openssl/evp.h>

#define DIGEST_LENGTH 16

int main()
{
    char Str[1000];
    int i;
  
    printf("Enter the String: ");
    scanf("%s", Str);
  
    for (i = 0; Str[i] != '\0'; ++i);
  
    if (i == 12) {
    	printf("that's correct!\n");
    	unsigned char bytes[DIGEST_LENGTH];

    	EVP_MD_CTX* context = EVP_MD_CTX_new();
    	EVP_DigestInit_ex(context, EVP_md5(), NULL);
    	EVP_DigestUpdate(context, "12", 2);
    	unsigned int digestLength = DIGEST_LENGTH;
    	EVP_DigestFinal_ex(context, bytes, &digestLength);
    	EVP_MD_CTX_free(context);

    	char digest[DIGEST_LENGTH * 2 + 1];
    	for (int i = 0; i < DIGEST_LENGTH; i++) {
        	sprintf(&digest[i * 2], "%02x", bytes[i]);
    	}
    	
    	printf("csawctf{%s}\n", digest);
    } else {
    	printf("that isn't correct, im sorry!");
    }

    return 0;
}
