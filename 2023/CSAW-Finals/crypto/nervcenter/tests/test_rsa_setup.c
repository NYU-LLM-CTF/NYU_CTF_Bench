// Silence deprecation warnings since we want to use the RSA primitives
#define OPENSSL_SUPPRESS_DEPRECATED 1
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/rand.h>

#include "rsautil.h"
#include "nervcenter.h"

int main(void) {
    session_t s;
    int r = 0;
    r = rsa_setup(&s);
    if (r != 1) {
        printf("rsa_setup failed\n");
        return 1;
    }
    // dump the public ssh key
    char *sshkey = dump_pubkey_ssh(RSA_EXPONENT, s.pubkey, sizeof(s.pubkey), "nerv");
    if (sshkey == NULL) {
        printf("dump_pubkey_ssh failed\n");
        return 1;
    }
    printf("%s\n", sshkey);
    free(sshkey);

    // Test MSB special case
    s.pubkey[0] ^= 0x80;
    sshkey = dump_pubkey_ssh(RSA_EXPONENT, s.pubkey, sizeof(s.pubkey), "nerv");
    if (sshkey == NULL) {
        printf("dump_pubkey_ssh failed\n");
        return 1;
    }
    printf("%s\n", sshkey);
    free(sshkey);

    return 0;
}
