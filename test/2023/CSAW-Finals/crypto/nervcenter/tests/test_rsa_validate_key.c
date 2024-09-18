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
    rsa_error_t rt = validate_key(s.pubkey, sizeof(s.pubkey));
    if (rt != RERR_OK) {
        printf("validate_key failed, value = %d\n", rt);
        return 1;
    }

    // Make a key w/ leading zero
    unsigned char old_val = s.pubkey[0];
    s.pubkey[0] = 0;
    rt = validate_key(s.pubkey, sizeof(s.pubkey));
    if (rt != RERR_LEADING_ZERO) {
        printf("validate_key RERR_LEADING_ZERO failed, value = %d\n", rt);
        return 1;
    }
    s.pubkey[0] = old_val;

    // Make an even key
    s.pubkey[sizeof(s.pubkey)-1] &= 0xfe;
    rt = validate_key(s.pubkey, sizeof(s.pubkey));
    if (rt != RERR_EVEN_KEY) {
        printf("validate_key RERR_EVEN_KEY failed, value = %d\n", rt);
        return 1;
    }
    s.pubkey[sizeof(s.pubkey)-1] |= 0x01;

    // Make a key that's too large
    unsigned char bigkey[512] = {0};
    bigkey[0] = 1;
    bigkey[511] = 1;
    rt = validate_key(bigkey, 512);
    if (rt != RERR_KEY_TOO_LARGE) {
        printf("validate_key RERR_KEY_TOO_LARGE failed, value = %d\n", rt);
        return 1;
    }

    // Make a key that's too small
    unsigned char smallkey[64] = {0};
    smallkey[0] = 1;
    smallkey[63] = 1;
    rt = validate_key(smallkey, 64);
    if (rt != RERR_KEY_TOO_SMALL) {
        printf("validate_key RERR_KEY_TOO_SMALL failed, value = %d\n", rt);
        return 1;
    }

    return 0;
}
