#pragma once

#include "nervcenter.h"
#include <openssl/rsa.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    RERR_OK,
    RERR_LEADING_ZERO,
    RERR_EVEN_KEY,
    RERR_KEY_TOO_LARGE,
    RERR_KEY_TOO_SMALL,
    RERR_BADSIG,
    REER_BADENC,
} rsa_error_t;

int rsa_setup(session_t *thing);
char * dump_pubkey_ssh(int e, unsigned char *pubkey, unsigned int pubkey_len, char *comment);
void generate_challenge(unsigned char *challenge, size_t challenge_len);
rsa_error_t validate_challenge(session_t *sess,
    unsigned char *challenge, size_t challenge_len,
    unsigned char *response, size_t response_len
);
int encrypt_message(session_t *sess,
    unsigned char *message, size_t message_len,
    unsigned char **ciphertext, size_t *ciphertext_len);
int decrypt_message(RSA *rsa,
    unsigned char *ciphertext, size_t ciphertext_len,
    unsigned char **message, size_t *message_len);
rsa_error_t validate_key(unsigned char *pubkey, unsigned int pubkey_len);

#ifdef __cplusplus
}
#endif
