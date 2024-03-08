#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OPENSSL_SUPPRESS_DEPRECATED
#include <openssl/evp.h>
#include <openssl/rsa.h>
#include <openssl/err.h>

#define GCM_TAG_LEN 16
#define GCM_IV_LEN 12

int gcm_decrypt(unsigned char *ciphertext, int ciphertext_len,
                unsigned char *aad, int aad_len,
                unsigned char *tag,
                unsigned char *key,
                unsigned char *iv, int iv_len,
                unsigned char *plaintext)
{
    EVP_CIPHER_CTX *ctx;
    int len;
    int plaintext_len;
    int ret;

    /* Create and initialise the context */
    if(!(ctx = EVP_CIPHER_CTX_new())){
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 0;
    }

    /* Initialise the decryption operation. */
    if(!EVP_DecryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL)){
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 0;
    }

    /* Set IV length. Not necessary if this is 12 bytes (96 bits) */
    if(!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, iv_len, NULL)){
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 0;
    }

    /* Initialise key and IV */
    if(!EVP_DecryptInit_ex(ctx, NULL, NULL, key, iv)){
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 0;
    }

    /*
     * Provide any AAD data. This can be called zero or more times as
     * required
     */
    if(!EVP_DecryptUpdate(ctx, NULL, &len, aad, aad_len)){
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 0;
    }

    /*
     * Provide the message to be decrypted, and obtain the plaintext output.
     * EVP_DecryptUpdate can be called multiple times if necessary
     */
    if(!EVP_DecryptUpdate(ctx, plaintext, &len, ciphertext, ciphertext_len)){
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 0;
    }
    plaintext_len = len;

    /* Set expected tag value. Works in OpenSSL 1.0.1d and later */
    if(!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, 16, tag)){
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 0;
    }

    /*
     * Finalise the decryption. A positive return value indicates success,
     * anything else is a failure - the plaintext is not trustworthy.
     */
    ret = EVP_DecryptFinal_ex(ctx, plaintext + len, &len);

    /* Clean up */
    EVP_CIPHER_CTX_free(ctx);

    if(ret > 0) {
        /* Success */
        plaintext_len += len;
        return plaintext_len;
    } else {
        /* Verify failed */
        return -1;
    }
}

// Decrypt a message with the private key. This first decrypts the AES key with
// the private key, then decrypts the message with AES. The plaintext is
// returned in plaintext and the length in plaintext_len.
int decrypt_message(RSA *rsa,
    unsigned char *ciphertext, size_t ciphertext_len,
    unsigned char **message, size_t *message_len) {
    // Allocate space for the plaintext
    memcpy(message_len, ciphertext, sizeof(size_t));
    *message = calloc(*message_len, sizeof(unsigned char));
    unsigned char *ciphertext_aes = ciphertext + sizeof(size_t);
    unsigned char *tag = ciphertext_aes + *message_len;
    unsigned char *iv = tag + GCM_TAG_LEN;
    unsigned char *ciphertext_rsa = iv + GCM_IV_LEN;

    // Decrypt the AES key
    unsigned char aes_key[32];
    int res = RSA_private_decrypt(RSA_size(rsa), ciphertext_rsa, aes_key, rsa, RSA_PKCS1_OAEP_PADDING);
    if (res == -1) {
        fprintf(stderr, "[-] RSA decryption failed\n");
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 0;
    }
    else {
        fprintf(stderr, "[+] Decryption successful\n");
    }

    // Decrypt the message
    int plaintext_len = gcm_decrypt(
        ciphertext_aes, *message_len,
        NULL, 0, tag, aes_key, iv, GCM_IV_LEN, *message);
    if (plaintext_len == -1) {
        fprintf(stderr, "[-] AES-GCM decryption failed\n");
        fprintf(stderr, "[-] Error: ");
        ERR_print_errors_fp(stderr);
        return 0;
    }
    else {
        fprintf(stderr, "[+] Decryption successful\n");
        *message_len = plaintext_len;
        return 1;
    }
}

int main(int argc, char **argv) {
    if (argc != 5) {
        fprintf(stderr, "Usage: %s <n> <e> <privkey_d> <hex_message>\n", argv[0]);
        return 1;
    }
    char *pubkey_n = argv[1];
    char *pubkey_e = argv[2];
    char *privkey_d = argv[3];
    char *ctxt_hex = argv[4];
    int ctxt_hexlen = strlen(ctxt_hex);
    if (ctxt_hexlen % 2 != 0) {
        fprintf(stderr, "[-] Message must be hex-encoded\n");
        return 1;
    }
    unsigned char *ciphertext = calloc(ctxt_hexlen/2, sizeof(char));
    size_t ciphertext_len = 0;
    for (int i = 0; i < ctxt_hexlen; i += 2) {
        char byte[3] = {ctxt_hex[i], ctxt_hex[i+1], '\0'};
        ciphertext[ciphertext_len++] = strtol(byte, NULL, 16);
    }

    RSA *rsa_priv;
    BIGNUM *n;
    BIGNUM *e;
    BIGNUM *d;

    // Convert the public key to a BIGNUM
    n = BN_new();
    BN_dec2bn(&n, pubkey_n);
    e = BN_new();
    BN_dec2bn(&e, pubkey_e);
    // Convert the private key to a BIGNUM
    d = BN_new();
    BN_dec2bn(&d, privkey_d);
    // Create the RSA struct
    rsa_priv = RSA_new();
    RSA_set0_key(rsa_priv, BN_dup(n), BN_dup(e), BN_dup(d));
    unsigned char *plain;
    size_t plain_len;
    int res = decrypt_message(rsa_priv, ciphertext, ciphertext_len, &plain, &plain_len);
    if (res == 0) {
        fprintf(stderr, "[-] Decryption failed\n");
        return 1;
    }

    fwrite(plain, plain_len, 1, stdout);
    return 0;
}
