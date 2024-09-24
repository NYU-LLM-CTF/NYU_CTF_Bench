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

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    unsigned char challenge[32] = {0};
    session_t sess;
    FuzzedDataProvider fuzz_data_provider(data, size);
    FuzzedDataProvider *fuzz_data = &fuzz_data_provider;
    fuzz_data->ConsumeData(sess.pubkey, sizeof(sess.pubkey));
    fuzz_data->ConsumeData(challenge, 32);
    size_t rb = fuzz_data->remaining_bytes();
    unsigned char *response = (unsigned char *) malloc(rb);
    fuzz_data->ConsumeData(response, rb);
    rsa_error_t res = validate_challenge(&sess, challenge, 32, response, rb);
    free(response);
    assert (res != RERR_OK);
    (void)res;
    return 0;
}
