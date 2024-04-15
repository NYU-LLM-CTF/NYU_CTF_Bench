#include <openssl/err.h>
#include <openssl/bn.h>
#include <openssl/ec.h>
#include <openssl/evp.h>
#include <openssl/hmac.h>
#include <openssl/ecdsa.h>

#include <openssl/ssl.h>
#include <openssl/x509.h>
#include <openssl/x509_vfy.h>
#include <openssl/crypto.h>
#include <openssl/conf.h>
#include <openssl/opensslv.h>


#include <pythread.h>


#define BN_num_bytes(a) ((BN_num_bits(a)+7)/8)

int bn_num_bytes(BIGNUM * a){
    return BN_num_bytes(a);
}

int bn_is_odd(BIGNUM * a){
    return BN_is_odd(a);
}

void init_ciphers(void){
    OPENSSL_config(NULL);
}

void cleanup_ciphers(void){

    /* Removes all digests and ciphers */
    EVP_cleanup();

    /* if you omit the next, a small leak may be left when you make use of the BIO (low level API) for e.g. base64 transformations */
    CRYPTO_cleanup_all_ex_data();

    /* Remove error strings */
}

/* This line is borrowed from pyca/cryptography.
   
   https://github.com/pyca/cryptography/commit/bc1667791eedfe9d77d56dd9014e26481f571ff5
*/
int (*setup_ssl_threads)(void) = NULL;

/* Version of ECDSA_SIG_set0 that does not take ownership
 * of passed variables r and s. */
int ECDSA_SIG_set0_petlib(ECDSA_SIG *sig, BIGNUM *r, BIGNUM *s) {
    BIGNUM *rnew = BN_new();
    BIGNUM *snew = BN_new();

    BN_copy(rnew, r);
    BN_copy(snew, s);

    return ECDSA_SIG_set0(sig, rnew, snew);
    // NOTE: new values rnew, snew not freed because signature
    // takes ownership.
}
