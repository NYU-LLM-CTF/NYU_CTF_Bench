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

const char *msg = "Hello, world!";

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

    // Encrypt the message
    unsigned char *ciphertext;
    size_t ciphertext_len;
    int res = encrypt_message(&sess, (unsigned char *)msg, strlen(msg), &ciphertext, &ciphertext_len);
    if (res == 0) {
        fprintf(stderr, "[-] Encryption failed\n");
        return 1;
    }

    // Decrypt the message
    unsigned char *plaintext;
    size_t plaintext_len;
    res = decrypt_message(rsa_priv, ciphertext, ciphertext_len, &plaintext, &plaintext_len);
    if (res == 0) {
        fprintf(stderr, "[-] Decryption failed\n");
        return 1;
    }

    // Check that the decrypted message matches the original
    if (memcmp(plaintext, msg, plaintext_len) != 0) {
        fprintf(stderr, "[-] Decrypted message does not match original\n");
        return 1;
    }

    // Free memory
    RSA_free(rsa_pub);
    RSA_free(rsa_priv);
    BN_free(e);
    free(ciphertext);
    free(plaintext);

    return 0;
}
