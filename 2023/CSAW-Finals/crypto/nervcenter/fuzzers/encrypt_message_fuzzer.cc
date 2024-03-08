#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <fuzzer/FuzzedDataProvider.h>

// guard C headers
extern "C" {
#include "rsautil.h"
#include "nervcenter.h"
}

// int encrypt_message(session_t *sess,
    // unsigned char *message, size_t message_len,
    // unsigned char **ciphertext, size_t *ciphertext_len);

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    session_t sess;
    FuzzedDataProvider fuzz_data_provider(data, size);
    FuzzedDataProvider *fuzz_data = &fuzz_data_provider;
    fuzz_data->ConsumeData(sess.pubkey, sizeof(sess.pubkey));
    size_t rb = fuzz_data->remaining_bytes();
    unsigned char *message = (unsigned char *) malloc(rb+1);
    fuzz_data->ConsumeData(message, rb);
    message[rb] = '\0';
    unsigned char *ciphertext;
    size_t ciphertext_len;
    int res = encrypt_message(&sess, message, rb, &ciphertext, &ciphertext_len);
    // Could succeed or fail, but should not crash.
    free(message);
    free(ciphertext);
    assert (res == 0 || res == 1);
    (void)res;
    return 0;
}
