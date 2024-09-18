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

int main(int argc, char **argv) {
    RSA *rsa_pub;
    RSA *rsa_priv;
    BIGNUM *n;
    BIGNUM *e;
    BIGNUM *d;

    if (argc != 5) {
        fprintf(stderr, "Usage: %s <pubkey_n> <pubkey_e> <privkey_d> <hex_message>\n", argv[0]);
        return 1;
    }
    char *pubkey_n = argv[1];
    char *pubkey_e = argv[2];
    char *privkey_d = argv[3];
    char *msg_hex = argv[4];
    int msg_hexlen = strlen(msg_hex);
    if (msg_hexlen % 2 != 0) {
        fprintf(stderr, "[-] Message must be hex-encoded\n");
        return 1;
    }

    // Convert the public key to a BIGNUM
    n = BN_new();
    BN_dec2bn(&n, pubkey_n);
    e = BN_new();
    BN_dec2bn(&e, pubkey_e);
    // Convert the private key to a BIGNUM
    d = BN_new();
    BN_dec2bn(&d, privkey_d);
    // Store the keys in the RSA struct
    rsa_pub = RSA_new();
    RSA_set0_key(rsa_pub, BN_dup(n), BN_dup(e), NULL);
    rsa_priv = RSA_new();
    RSA_set0_key(rsa_priv, BN_dup(n), BN_dup(e), BN_dup(d));

    // Disable blind signing
    RSA_blinding_off(rsa_pub);
    RSA_blinding_off(rsa_priv);

    // Read the hex-encoded message to sign
    unsigned char *msg = calloc(msg_hexlen/2, sizeof(unsigned char));
    int msg_len = 0;
    for (int i = 0; i < msg_hexlen; i += 2) {
        char byte[3] = {msg_hex[i], msg_hex[i+1], '\0'};
        msg[msg_len++] = strtol(byte, NULL, 16);
    }
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
    // Verify the signature
    res = RSA_verify(NID_sha256, msg, msg_len, sig, sig_len, rsa_pub);
    fprintf(stderr, "Verified = %d\n", res);
    if (res != 1) {
        fprintf(stderr, "[-] Signature verification failed\n");
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 1;
    }

    return 0;
}
