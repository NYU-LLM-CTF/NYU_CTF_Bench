#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <fuzzer/FuzzedDataProvider.h>

// guard C headers
extern "C" {
#include "../rsautil.h"
#include "../nervcenter.h"
}

// int decrypt_message(RSA *rsa,
//     unsigned char *ciphertext, size_t ciphertext_len,
//     unsigned char **message, size_t *message_len);

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    RSA *rsa = RSA_new();
    FuzzedDataProvider fuzz_data_provider(data, size);
    FuzzedDataProvider *fuzz_data = &fuzz_data_provider;
    unsigned char pubkey[RSA_KEY_SIZE/8];
    fuzz_data->ConsumeData(pubkey, sizeof(pubkey));
    BIGNUM *e = BN_new();
    BIGNUM *n = BN_new();
    BN_set_word(e, RSA_EXPONENT);
    BN_bin2bn(pubkey, sizeof(pubkey), n);
    RSA_set0_key(rsa, n, e, NULL);
    int rb = fuzz_data->remaining_bytes();
    unsigned char *ciphertext = (unsigned char *) malloc(rb);
    fuzz_data->ConsumeData(ciphertext, rb);
    unsigned char *message;
    size_t message_len;
    int res = decrypt_message(rsa, ciphertext, rb, &message, &message_len);
    free(message);
    free(ciphertext);
    RSA_free(rsa);
    // Should never succeed.
    assert (res == 0);
    return 0;
}
