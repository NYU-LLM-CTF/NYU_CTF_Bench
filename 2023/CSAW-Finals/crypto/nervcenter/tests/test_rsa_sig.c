#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <fcntl.h>
#include <unistd.h>

// Silence deprecation warnings since we want to use the RSA primitives
#define OPENSSL_SUPPRESS_DEPRECATED 1
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/rand.h>

#include "rsautil.h"

int main(int argc, char **argv) {
    RSA *rsa_pub;
    RSA *rsa_priv;
    const BIGNUM *n;
    session_t sess;

    // Initialize the session with a random key
    BIGNUM *e = BN_new();
    BN_set_word(e, RSA_EXPONENT);

    // Generate a RSA_KEY_SIZE bit key with e = RSA_EXPONENT
    rsa_priv = RSA_new();
    RSA_generate_key_ex(rsa_priv, RSA_KEY_SIZE, e, NULL);

    // Public key for verification
    n = RSA_get0_n(rsa_priv);
    rsa_pub = RSA_new();
    RSA_set0_key(rsa_pub, BN_dup(n), BN_dup(e), NULL);

    // Put the key into the session
    BN_bn2bin(n, sess.pubkey);

    // Disable blind signing
    RSA_blinding_off(rsa_pub);
    RSA_blinding_off(rsa_priv);

    // Message to sign
    unsigned char msg[32] = {
        0x79, 0x3a, 0xb9, 0xa6, 0x92, 0x34, 0x9a, 0xe5, 0x20, 0x76, 0x7e, 0xa2,
        0xdd, 0x34, 0x92, 0x99, 0xb1, 0x47, 0x4f, 0x4e, 0x09, 0x55, 0xb9, 0x3e,
        0xe7, 0xe1, 0xdb, 0xea, 0x6b, 0xb7, 0x22, 0x42
    };
    int msg_len = sizeof(msg);

    // Sign the message
    int res;
    unsigned char *sig = calloc(RSA_size(rsa_priv), sizeof(unsigned char));
    unsigned int sig_len = 0;
    res = RSA_sign(NID_sha256, msg, msg_len, sig, &sig_len, rsa_priv);
    if (res != 1) {
        fprintf(stderr, "[-] Signing failed\n");
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 1;
    }
    // Dump the signature
    for (int i = 0; i < sig_len; i++) {
        printf("%02x", sig[i]);
    }
    printf("\n");

    rsa_error_t validate_res = validate_challenge(&sess, msg, msg_len, sig, sig_len);
    if (validate_res != RERR_OK) {
        fprintf(stderr, "[-] Validation failed: %d\n", validate_res);
        return 1;
    }

    // Free memory
    RSA_free(rsa_pub);
    RSA_free(rsa_priv);
    BN_free(e);
    free(sig);

    return 0;
}
