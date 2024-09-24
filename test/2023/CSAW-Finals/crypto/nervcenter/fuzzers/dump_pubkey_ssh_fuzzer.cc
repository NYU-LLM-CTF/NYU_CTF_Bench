#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <fuzzer/FuzzedDataProvider.h>
#include <string>

// guard C headers
extern "C" {
#include "rsautil.h"
#include "nervcenter.h"
}

// char * dump_pubkey_ssh(int e, unsigned char *pubkey, unsigned int pubkey_len, char *comment);

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    FuzzedDataProvider fuzz_data_provider(data, size);
    FuzzedDataProvider *fuzz_data = &fuzz_data_provider;
    unsigned char pubkey[RSA_KEY_SIZE/8];
    fuzz_data->ConsumeData(pubkey, sizeof(pubkey));
    std::string comment = fuzz_data->ConsumeRemainingBytesAsString();
    char *result = dump_pubkey_ssh(RSA_EXPONENT, pubkey, sizeof(pubkey), (char *)comment.c_str());
    free(result);
    return 0;
}
