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


#include <pythread.h>


#define BN_num_bytes(a) ((BN_num_bits(a)+7)/8)

int bn_num_bytes(BIGNUM * a){
    return BN_num_bytes(a);
}

int bn_is_odd(BIGNUM * a){
    return BN_is_odd(a);
}

size_t hmac_ctx_size(void){
    return sizeof(HMAC_CTX);
}


extern void ERR_load_crypto_strings(void);
extern void OPENSSL_config(void*);
extern void ERR_free_strings(void);

void init_ciphers(void){

    /* Load the human readable error strings for libcrypto */
    ERR_load_crypto_strings();

    /* Load all digest and cipher algorithms */
    OpenSSL_add_all_algorithms();

    /* Load config file, and other important initialisation */
    OPENSSL_config(NULL);

}

void cleanup_ciphers(void){

    /* Removes all digests and ciphers */
    EVP_cleanup();

    /* if you omit the next, a small leak may be left when you make use of the BIO (low level API) for e.g. base64 transformations */
    CRYPTO_cleanup_all_ex_data();

    /* Remove error strings */
    ERR_free_strings();

}

/* This code is derived from the locking code found in the Python _ssl module's
   locking callback for OpenSSL.

   Copyright 2001-2016 Python Software Foundation; All Rights Reserved.

   Adapted from: cryptography/master/src/_cffi_src/openssl/callbacks.py
*/

static unsigned int _ssl_locks_count = 0;
static PyThread_type_lock *_ssl_locks = NULL;

static void _ssl_thread_locking_function(int mode, int n, const char *file,
                                         int line) {
    /* this function is needed to perform locking on shared data
       structures. (Note that OpenSSL uses a number of global data
       structures that will be implicitly shared whenever multiple
       threads use OpenSSL.) Multi-threaded applications will
       crash at random if it is not set.

       locking_function() must be able to handle up to
       CRYPTO_num_locks() different mutex locks. It sets the n-th
       lock if mode & CRYPTO_LOCK, and releases it otherwise.

       file and line are the file number of the function setting the
       lock. They can be useful for debugging.
    */

    if ((_ssl_locks == NULL) ||
        (n < 0) || ((unsigned)n >= _ssl_locks_count)) {
        return;
    }

    if (mode & CRYPTO_LOCK) {
        PyThread_acquire_lock(_ssl_locks[n], 1);
    } else {
        PyThread_release_lock(_ssl_locks[n]);
    }
}

int setup_ssl_threads(void) {
    unsigned int i;

    if (_ssl_locks == NULL) {
        _ssl_locks_count = CRYPTO_num_locks();
        _ssl_locks = PyMem_New(PyThread_type_lock, _ssl_locks_count);
        if (_ssl_locks == NULL) {
            PyErr_NoMemory();
            return 0;
        }
        memset(_ssl_locks, 0, sizeof(PyThread_type_lock) * _ssl_locks_count);
        for (i = 0;  i < _ssl_locks_count;  i++) {
            _ssl_locks[i] = PyThread_allocate_lock();
            if (_ssl_locks[i] == NULL) {
                unsigned int j;
                for (j = 0;  j < i;  j++) {
                    PyThread_free_lock(_ssl_locks[j]);
                }
                PyMem_Free(_ssl_locks);
                return 0;
            }
        }
        CRYPTO_set_locking_callback(_ssl_thread_locking_function);
    }
    return 1;
}
