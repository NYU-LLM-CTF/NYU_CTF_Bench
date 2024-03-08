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
#include <openssl/aes.h>

#include "rsautil.h"
#include "base64.h"

int rsa_setup(session_t *s) {
    int failed = 0;
    RSA *rsa;
    BIGNUM *e = BN_new();
    BN_set_word(e, RSA_EXPONENT);

    // Generate a RSA_KEY_SIZE bit key with e = RSA_EXPONENT
    rsa = RSA_new();
    RSA_generate_key_ex(rsa, RSA_KEY_SIZE, e, NULL);

    // Get the public key modulus
    const BIGNUM *n = RSA_get0_n(rsa);
    int pubkey_len = BN_num_bytes(n);
    unsigned char *pubkey = calloc(pubkey_len, sizeof(unsigned char));
    BN_bn2bin(n, pubkey);
    // Decimal version for printing
    char * n_dec = BN_bn2dec(n);
    printf("[+] Public key modulus\n");
    printf("N = %s\n", n_dec);
    OPENSSL_free(n_dec);

    // Print the private exponent d
    const BIGNUM *d = RSA_get0_d(rsa);
    // Decimal version for printing
    char * d_dec = BN_bn2dec(d);
    printf("[+] Private exponent:\n");
    printf("D = %s\n", d_dec);
    OPENSSL_free(d_dec);

    // Print p and q
    const BIGNUM *p = RSA_get0_p(rsa);
    const BIGNUM *q = RSA_get0_q(rsa);
    // Decimal version for printing
    char * p_dec = BN_bn2dec(p);
    char * q_dec = BN_bn2dec(q);
    printf("[+] p and q:\n");
    printf("p = %s\n", p_dec);
    printf("q = %s\n", q_dec);
    OPENSSL_free(p_dec);
    OPENSSL_free(q_dec);

    // Set up the session
    if (pubkey_len > sizeof(s->pubkey)) {
        printf("[-] Public key is too large\n");
        failed = 1;
    }
    else {
        printf("[+] Setting up session, pubkey_len = %d\n", pubkey_len);
        memcpy(s->pubkey, pubkey, pubkey_len);
    }

#if 0
    // Test encrypt/decrypt
    unsigned char *ciphertext;
    size_t ciphertext_len;
    const char *plaintext = "Hello, world!";
    size_t plen = strlen(plaintext);
    if (encrypt_message(s, (unsigned char *)plaintext, plen, &ciphertext, &ciphertext_len)) {
        printf("Encrypted message:\n");
        for (int i = 0; i < ciphertext_len; i++) {
            printf("%02x", ciphertext[i]);
        }
        printf("\n");
    } else {
        printf("Encryption failed\n");
    }
    unsigned char *plaintext2;
    size_t plaintext2_len;
    if (decrypt_message(rsa, ciphertext, ciphertext_len, &plaintext2, &plaintext2_len)) {
        printf("Decrypted message: %s\n", plaintext2);
    } else {
        printf("Decryption failed\n");
    }
#endif
    // Clean up
    free(pubkey);
    RSA_free(rsa);
    BN_free(e);
    return !failed;
}

rsa_error_t validate_key(unsigned char *pubkey, unsigned int pubkey_len) {
    // MSB must not be zero
    if (pubkey[0] == 0) {
        return RERR_LEADING_ZERO;
    }
    // Key must be odd
    if (!(pubkey[pubkey_len-1] & 0x01)) {
        return RERR_EVEN_KEY;
    }
    // Key must be at least 1024 bits
    if (pubkey_len < 128) {
        return RERR_KEY_TOO_SMALL;
    }
    // Key must be at most 2048 bits
    if (pubkey_len > 256) {
        return RERR_KEY_TOO_LARGE;
    }
    return RERR_OK;
}

char * dump_pubkey_ssh(int e, unsigned char *pubkey, unsigned int pubkey_len, char *comment) {
    unsigned char keybuf[1024] = {};
    int keybuf_len = 0;
    // key type
    memcpy(keybuf, "\x00\x00\x00\x07ssh-rsa", 11);
    keybuf_len += 11;
    // exponent size, big endian
    keybuf[keybuf_len++] = 0;
    keybuf[keybuf_len++] = 0;
    keybuf[keybuf_len++] = 0;
    keybuf[keybuf_len++] = 3;
    // exponent
    unsigned char exponent[3];
    exponent[0] = (e >> 16) & 0xFF;
    exponent[1] = (e >> 8) & 0xFF;
    exponent[2] = e & 0xFF;
    memcpy(&keybuf[keybuf_len], exponent, 3);
    keybuf_len += 3;
    // modulus size, big endian
    // Note: from RFC 4251:
    //    mpint
    //   Represents multiple precision integers in two's complement format,
    //   stored as a string, 8 bits per byte, MSB first.  Negative numbers
    //   have the value 1 as the most significant bit of the first byte of
    //   the data partition.  If the most significant bit would be set for
    //   a positive number, the number MUST be preceded by a zero byte.
    //   Unnecessary leading bytes with the value 0 or 255 MUST NOT be
    //   included.  The value zero MUST be stored as a string with zero
    //   bytes of data.
    // So we need to check if the MSB is set and add a leading zero if so
    int real_size = pubkey_len;
    if (pubkey[0] & 0x80) {
        real_size++;
    }
    keybuf[keybuf_len++] = (real_size >> 24) & 0xFF;
    keybuf[keybuf_len++] = (real_size >> 16) & 0xFF;
    keybuf[keybuf_len++] = (real_size >> 8) & 0xFF;
    keybuf[keybuf_len++] = real_size & 0xFF;
    // modulus
    if (pubkey[0] & 0x80) {
        keybuf[keybuf_len++] = 0;
    }
    memcpy(&keybuf[keybuf_len], pubkey, pubkey_len);
    keybuf_len += pubkey_len;

    // Base64 encode the key
    size_t b64_len = 0;
    char *b64 = base64_encode(keybuf, keybuf_len, &b64_len);

    // Dump the public key in SSH format
    int size = snprintf(NULL, 0, "ssh-rsa %s %s", b64, comment);
    char *ssh = calloc(size+1, sizeof(char));
    snprintf(ssh, size+1, "ssh-rsa %s %s", b64, comment);
    free(b64);
    return ssh;
}

// Generate a challenge string
void generate_challenge(unsigned char *challenge, size_t challenge_len) {
    // Generate a random challenge
    RAND_bytes(challenge, challenge_len);
}

// Validate challenge response
rsa_error_t validate_challenge(session_t *sess,
    unsigned char *challenge, size_t challenge_len,
    unsigned char *response, size_t response_len) {

    rsa_error_t result = validate_key(sess->pubkey, sizeof(sess->pubkey));
    if (result != RERR_OK) {
        return result;
    }

    // Create an RSA key from the public key in the session
    RSA *rsa = RSA_new();
    BIGNUM *n = BN_new();
    BN_bin2bn(sess->pubkey, sizeof(sess->pubkey), n);
    BIGNUM *e = BN_new();
    BN_set_word(e, RSA_EXPONENT);
    RSA_set0_key(rsa, n, e, NULL);

    printf("[+] Public key modulus for validation:\n");
    char * n_hex = BN_bn2hex(n);
    printf("N = %s\n", n_hex);
    OPENSSL_free(n_hex);

    // Verify the signature
    int res = RSA_verify(NID_sha256, challenge, challenge_len, response, response_len, rsa);
    rsa_error_t ret;
    printf("Verified = %d\n", res);
    if (res != 1) {
        printf("[-] Signature verification failed\n");
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = RERR_BADSIG;
    }
    else {
        printf("[+] Signature verified\n");
        ret = RERR_OK;
    }
    // Clean up
    RSA_free(rsa);
    // rsa takes ownership of e and n so don't free them
    return ret;
}

int gcm_encrypt(unsigned char *plaintext, int plaintext_len,
                unsigned char *aad, int aad_len,
                unsigned char *key,
                unsigned char *iv, int iv_len,
                unsigned char *ciphertext,
                unsigned char *tag)
{
    EVP_CIPHER_CTX *ctx;
    int len;
    int ciphertext_len;
    int ret = 0;

    /* Create and initialise the context */
    if(!(ctx = EVP_CIPHER_CTX_new())) {
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        goto gcm_encrypt_cleanup;
    }

    /* Initialise the encryption operation. */
    if(1 != EVP_EncryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL)) {
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        goto gcm_encrypt_cleanup;
    }

    /*
     * Set IV length if default 12 bytes (96 bits) is not appropriate
     */
    if(1 != EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, iv_len, NULL)) {
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        goto gcm_encrypt_cleanup;
    }

    /* Initialise key and IV */
    if(1 != EVP_EncryptInit_ex(ctx, NULL, NULL, key, iv)) {
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        goto gcm_encrypt_cleanup;
    }

    /*
     * Provide any AAD data. This can be called zero or more times as
     * required
     */
    if(1 != EVP_EncryptUpdate(ctx, NULL, &len, aad, aad_len)) {
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        goto gcm_encrypt_cleanup;
    }

    /*
     * Provide the message to be encrypted, and obtain the encrypted output.
     * EVP_EncryptUpdate can be called multiple times if necessary
     */
    if(1 != EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len)) {
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        goto gcm_encrypt_cleanup;
    }
    ciphertext_len = len;

    /*
     * Finalise the encryption. Normally ciphertext bytes may be written at
     * this stage, but this does not occur in GCM mode
     */
    if(1 != EVP_EncryptFinal_ex(ctx, ciphertext + len, &len)) {
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        goto gcm_encrypt_cleanup;
    }
    ciphertext_len += len;

    /* Get the tag */
    if(1 != EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, 16, tag)) {
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        return 0;
    }
    ret = ciphertext_len;

gcm_encrypt_cleanup:
    /* Clean up */
    EVP_CIPHER_CTX_free(ctx);
    return ret;
}

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
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = -1;
        goto gcm_decrypt_cleanup;
    }

    /* Initialise the decryption operation. */
    if(!EVP_DecryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL)){
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = -1;
        goto gcm_decrypt_cleanup;
    }

    /* Set IV length. Not necessary if this is 12 bytes (96 bits) */
    if(!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, iv_len, NULL)){
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = -1;
        goto gcm_decrypt_cleanup;
    }

    /* Initialise key and IV */
    if(!EVP_DecryptInit_ex(ctx, NULL, NULL, key, iv)){
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = -1;
        goto gcm_decrypt_cleanup;
    }

    /*
     * Provide any AAD data. This can be called zero or more times as
     * required
     */
    if(!EVP_DecryptUpdate(ctx, NULL, &len, aad, aad_len)){
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = -1;
        goto gcm_decrypt_cleanup;
    }

    /*
     * Provide the message to be decrypted, and obtain the plaintext output.
     * EVP_DecryptUpdate can be called multiple times if necessary
     */
    if(!EVP_DecryptUpdate(ctx, plaintext, &len, ciphertext, ciphertext_len)){
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = -1;
        goto gcm_decrypt_cleanup;
    }
    plaintext_len = len;

    /* Set expected tag value. Works in OpenSSL 1.0.1d and later */
    if(!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, 16, tag)){
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = -1;
        goto gcm_decrypt_cleanup;
    }

    /*
     * Finalise the decryption. A positive return value indicates success,
     * anything else is a failure - the plaintext is not trustworthy.
     */
    ret = EVP_DecryptFinal_ex(ctx, plaintext + len, &len);

gcm_decrypt_cleanup:
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

// Encrypt a message with the public key. This first generates a random
// 256-bit AES key, encrypts the message with AES, then encrypts the AES key with
// the public key. The ciphertext is returned in ciphertext and the length in
// ciphertext_len.
int encrypt_message(session_t *sess,
    unsigned char *message, size_t message_len,
    unsigned char **ciphertext, size_t *ciphertext_len) {
    // Create an RSA key from the public key in the session
    RSA *rsa = RSA_new();
    BIGNUM *n = BN_new();
    BN_bin2bn(sess->pubkey, sizeof(sess->pubkey), n);
    BIGNUM *e = BN_new();
    BN_set_word(e, RSA_EXPONENT);
    RSA_set0_key(rsa, n, e, NULL);
    printf("[+] Public key modulus for encryption:\n");
    char * n_hex = BN_bn2hex(n);
    printf("N = %s\n", n_hex);
    OPENSSL_free(n_hex);

    // Allocate space for the ciphertext
    // The ciphertext consists of:
    // 8 bytes for the message length
    // message_len bytes for the message
    // 12 bytes for the AES-GCM IV
    // 16 bytes for the AES-GCM tag
    // RSA_size(rsa) bytes for the encrypted AES key
    #define GCM_TAG_LEN 16
    #define GCM_IV_LEN 12
    *ciphertext_len = sizeof(size_t) + message_len + GCM_IV_LEN + GCM_TAG_LEN + RSA_size(rsa);
    *ciphertext = calloc(*ciphertext_len, sizeof(unsigned char));

    // Encrypt the message with AES-GCM
    memcpy(*ciphertext, &message_len, sizeof(size_t));
    unsigned char *ciphertext_aes = *ciphertext + sizeof(size_t);
    unsigned char *tag = ciphertext_aes + message_len;
    unsigned char *iv = tag + GCM_TAG_LEN;
    unsigned char *ciphertext_rsa = iv + GCM_IV_LEN;
    // Generate a random AES key and IV
    unsigned char aes_key[32];
    RAND_bytes(aes_key, sizeof(aes_key));
    RAND_bytes(iv, GCM_IV_LEN);
    int ciphertext_aes_len = gcm_encrypt(message, message_len, NULL, 0, aes_key, iv, GCM_IV_LEN, ciphertext_aes, tag);
    int ret = 0;
    if (ciphertext_aes_len <= 0) {
        printf("[-] AES-GCM encryption failed\n");
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = 0;
        goto rsa_enc_cleanup;
    }

    // Encrypt the message
    int res = RSA_public_encrypt(sizeof(aes_key), aes_key, ciphertext_rsa, rsa, RSA_PKCS1_OAEP_PADDING);
    if (res == -1) {
        printf("[-] Encryption failed\n");
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        ret = 0;
    }
    else {
        printf("[+] Encryption successful\n");
        ret = 1;
    }
rsa_enc_cleanup:
    // Clean up
    RSA_free(rsa);
    return ret;
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
        printf("[-] RSA decryption failed\n");
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        return 0;
    }
    else {
        printf("[+] Decryption successful\n");
    }

    // Decrypt the message
    int plaintext_len = gcm_decrypt(
        ciphertext_aes, *message_len,
        NULL, 0, tag, aes_key, iv, GCM_IV_LEN, *message);
    if (plaintext_len == -1) {
        printf("[-] AES-GCM decryption failed\n");
        printf("[-] Error: ");
        ERR_print_errors_fp(stdout);
        return 0;
    }
    else {
        printf("[+] Decryption successful\n");
        *message_len = plaintext_len;
        return 1;
    }
}
