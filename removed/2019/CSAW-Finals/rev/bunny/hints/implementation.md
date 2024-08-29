Implement the following file main.cpp and run the following command to get the flag:

main.cpp:
```
#include <string>

void ENTER(std::string input);

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    std::string input(&data[0], &data[size]);
    ENTER(input);
    return 0;
}
```

```
sudo apt install clang
clang++ -fsanitize=fuzzer ~/ctf_files/bunny.cpp main.cpp -o bunny
./bunny
```
