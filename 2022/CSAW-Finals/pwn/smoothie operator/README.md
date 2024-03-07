# smoothie_operator<<

## Hashes and versions

```
smoothie_operator : 79ee63a203b20124e5d7cf8cafd525a6
libc-2.31.so : 5898fac5d2680d0d8fefdadd632b7188
OS : Ubuntu 20.04
```

## Description

This challenge incorporates an OOB heap write to corrupt heap metadata, specifically to retrieve a UAF by clobbering the `std::shared_ptr` struct and its associated metadata. Further details on the challenge are below, including an overview of relevant C++ structs and how they appear in memory

## Vulnerabilities

This program has a single key vulnerability (and another omission, which is a mistake) that can yield RCE. The vulnerability is incorrect array (or vector) indexing in the `Monster` (or `Pastry`) `edit_params` function:

```cpp
void Monster::edit_params() {
    long long n;

    n = 0;
    for (; n < ARRSIZE; n++) 
        std::cout << n + 1 << ". " << FLAVORS[n] << std::endl;

    printf("Choose an flavor to edit: ");
    std::cin >> n;
    if (n < 0) goto fail;
    else {
        // vuln here - logic sequence error
        // entering index 0 allows an OOB write at quantities[0xff]
        n--;
        long long s = ARRSIZE;
        if (n < s) {
            std::cout << "Enter a new quantity: ";
            std::cin >> quantities[(uint8_t)n];
            return;
        }
        else { goto fail; }
    }
    
    fail:
        std::cout << "[ ERROR ] : invalid flavor index\n";
        return;
}
```

As shown above, inputting an index of 0 passes both size checks, because they are done separately while separated by a logical operation (`n--`). Therefore, we can override index `quantities[0xff]`, which is OOB on the heap.

## Exploit

### `shared_ptr`s 

Shared pointers create new heap objects when initialized through `make_shared<T>`. These allocations can be thought of as a wrapper around `T`, whether that be a primitive data type or a `Class`. The allocation takes the following form in memory 

```
0x0 - 0x8 bytes: shared_ptr vtable
0x8 - 0xc bytes: shared reference count 
0xc - 0x10 bytes: weak reference count
```

So long as a `shared_ptr` or object containining one holds a referenced to the wrapped data, the shared counter is greater than 0. Every time a `shared_ptr` falls out of scope, C++ checks to see if the reference count hit 0. If it did, it frees not only the shared pointer, but `T` type inside it (if applicable). 

### `std::string`s

`std::string s = new std::string(input)` creates a new allocation on the heap which varies in size depending on the input. Any input less than 0x10 bytes receives a 0x30 allocation (0x20 for data, 0x8 for metadata, 0x8 for padding) in the following layout 

``` 
| -- 1 -- | -- 2 -- | -- 3 -- | -- 4 -- | -- 5 -- | -- 6 -- | -- 7 -- | -- 8 -- | 
|           ptr to string data          |                  size                 |
|           data ....                                                           |
``` 

This implies that the ptr in the first quadword points to the address 0x10 bytes below it, and the data immediately follows the `ptr, size` preamble. 

This layout deviates when the allocation size exceeds 0xf bytes:

```
| -- 1 -- | -- 2 -- | -- 3 -- | -- 4 -- | -- 5 -- | -- 6 -- | -- 7 -- | -- 8 -- | 
|           ptr to string data          |                  size                 |
|           size                        |                  blank                |

...
| -- 1 -- | -- 2 -- | -- 3 -- | -- 4 -- | -- 5 -- | -- 6 -- | -- 7 -- | -- 8 -- | 
|           data...                                                             |
|                                                                               |
...

```

In this case, the data resides in a different allocation, sized to fit. So, strings smaller than 0x10 bytes fit within the `std::string` class body, and any larger string requires an additional allocation, maintained by the pointer in the class body. This difference is important for heap grooming. 

### Using the OOB

We can use this 4byte OOB to clobber the shared pointer reference count, setting it to 0. Then, the next time we use the `shared_ptr`, it will fall out of scope and trigger cleanup. This can lead to a UAF, so long as we maintain access to the `shared_ptr` from an encompassing data structure (in this case, the `OrderList`). Cleanup includes freeing any standard, heap-allocated data structures in the object automatically - so clobbering a `shared_ptr<Pastry>` frees `std::vector<uint32_t> quantities`. However, we still have access to editing that data structure from the `OrderList` via the `Pastry::edit_params` function. 

Once we have the UAF, we need to juggle it between fastbins (or tcache, if you're daring) and unsorted bins to leak a heap and glibc address, respectively, using heap feng shui. After that, it's a matter of aligning the UAF with a same-size data structure that extends our capabilities. Overlapping with `std::string` is perfect, because it occupies the same size (0x30 bytes, incl. metadata) on the heap as the freed `quantities` vector (which has a default allocation of 0x30 thanks to `std::vector::reserve`). This is also an easily allocation to make using the `Complaint` struct, which is a simple `std::string` with variable size.  Once overlapping, overwriting the first two quantities in the UAF clobber the pointer to the string data. Setting this to `__free_hook`'s address and then editing the complaint to `&system` now diverts execution flow to `system(ptr)` for every call to `free(ptr)`. 

The last step is placing something meaningful to free on the heap so that `free(ptr)` calls `system(ptr)` without a crash. Using the above information on `std::string`, allocating any data larger than 0x10 bytes results in two allocations: one for the control block and one for the data. In this situation, the data chunk is literally a pointer to the char* returned by `std:string::c_str()`. Therefore, allocating `"/" * 0x30 + "bin/sh"` is perfect, because it is freed first when the `std::string` is `delete`d. Allocating and freeing this string using a complaint fulfills the needs, resulting in a remote shell.