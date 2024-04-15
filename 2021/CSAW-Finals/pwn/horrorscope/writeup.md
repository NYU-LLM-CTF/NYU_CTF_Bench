## horrorscope

### Overview
This is a heap pwn challenge to teach about new glibc 2.34 mitigations. Version 2.34 is not shipped natively with Ubuntu or Debian latest at this point in time. Therefore, challengers must install the shared library and linker using []().  Furthermore, the user must patch any binary compiled on a machine that does not run glibc 2.34 natively to use the appropriate linker. This is possible using a utility like `patchelf`.  

### 2.34 Mitigations
glibc 2.34 imposes new heap allocation security mitigations in the form of "safe-linking". Additional reading on safe-linking are listed here: [House of Rust](https://c4ebt.github.io/2021/01/22/House-of-Rust.html), [Checkpoint](https://research.checkpoint.com/2020/safe-linking-eliminating-a-20-year-old-malloc-exploit-primitive/), [House of Io](https://awaraucom.wordpress.com/2020/07/19/house-of-io-remastered/).  Furthermore, glibc maintainers removed `__malloc_hook` and `__free_hook` functionality from their respective functions. This is a huge impact for us heap pwners, as those functions were key components to execution flow hijacking. 

### Vulnerability Overview 
This binary contains two intentional vulnerabilities which, when used in combination, can bypass security mitigations to gain arbitrary read privileges on the target filesystem. 
* The unlink function (`delete_cookie()`) which serves to unlink a fortune cookie fortune when the array is filled contains incorrect logic. The unlinked index is incorrectly incremented after it is freed but before the links are updated. The result is a dangling pointer to the freed index and a corrupted linked list prior to the unlinked index.  Note that indices after (greater than) the freed index are not corrupted.  
* * There is an additional vulnerability in this logic: when the challenger frees the last index, the index is freed and no logic is updated. This means there is no update to the global counter variable which tracks the number of allocated indices, so no new objects are permitted.  Furthermore, the final index does not corrupt the link check logic, so it can be freed multiple times without consequence

```c
// update linked lists
free(c[index++].next);
for (; index < globals.curr_cookie_index; index++) {
if (index != 0) {
    c[index].prev = c[index].next;
    c[index].next->next = (unsigned int *)&c[index - 1];
}
if (index != MAX_COOKIES - 1) {
    c[index].next = c[index + 1].next;
}
else {
    c[index].prev = 0;
    c[index].next = 0;
    globals.curr_cookie_index--;
}
}
```

* The second, more minor, vulnerability is an incorrectly implemented `read()` call in the `ask_8ball()` function. The function does null terminate the chunk, but does not terminate immediately after the input. This is not immediately noticeable when dealing with a fresh heap, since null bytes on the heap will terminate the string automatically. However, it does allow memory leaks by reading past the end of user input.

```c
printf(" Ask a question to the magic 8 ball\n > ");
read(0, question + 17, 0x70 - 17);
question[0x6f] = '\0';
```

### Exploit Walkthrough
#### Leak a Heap Address
Leaking a heap address with the first vulnerability is simple. We can create a UAF by completely filling the fortune cookie array and then choosing an index to delete. It is useful to delete an early (low) index so that we can use the same vulnerability later in the exploit. By reading this index after freed, we leak the address in the first quadword.  If the chunk is in either tcache or fastbins, then this will be a pointer to the `next` chunk.  However, this chunk is not as we would expect from a pre-2.32 glibc, instead the pointer is "protected" with safe-linking. If we are clever and leak the memory address when it is the first index in either tcache or fastbins, then we can simply shift the value left by 12 bits (3 nibbles) to get the address of the heap start (assuming the chunk is not `>0xfff` bytes after the start of the heap).  We now have a fingerprinted the heap start in memory

#### Leak a .data Address
A tempting next option would be to leak a glibc address by using a UAF to leak a `main_arena` address. This would be a very useful path forward in most challenges. However, as previously mentioned, glibc 2.34 removed `__malloc_hook` and `__free_hook` from allocation and deallocation calls. Therefore, our old friends for hijacking `rip` are no longer available.  FSOP is a logic next step, though this challenge presents a unique opportunity to leak the flag without touching glibc at all.  Instead, we will focus on the `globals` struct in the data section. A clever contestant will notice that when the ` ` value is maximized it has a value of `0x21`, which looks like a valid chunk size. Since the binary offers two allocation size options, 0x80 and 0x20, this looks promising.

```c 
struct {
  char* sign;
  long curr_cookie_index; // max 0x21 when array is full
  char* oracle_file;
  long oracle_file_lines;
  char* cookie_file;
  long cookie_file_lines;
  long num_8ball_fortunes;
  unsigned long* lucky_number;
  char* name;
} globals = {0, 0, "oracle.txt\0", 11, "cookies.txt\0", 52, 0, 0};
```

Leaking a data address relies on both vulnerabilities.  The key is to allocate the previously created UAF chunk within a Magic 8 Ball fortune.  If we ask a question right up to the final quadword, we can print the question and response to leak the previously linked data address from the (admittedly weird) doubly-linked list. Note that vulnerability two does not replace the line feed (`\n`) character from the input, so we will overwrite the least significant byte in the .data address. That is not a problem, since we are more concerned with fingerprinting where the .data segment starts.  We can calculate the address of the `globals` structure in memory. 

#### Flipping the UAF
There are two requirements for the `globals` overwrite strategy: first, we need a corruptible 0x20 chunk so we can overwrite it's next pointer. Second, it is best if this chunk resides in fastbins so we do not need to forge a doubly-linked list to pass the `p->fw->bk == p` check when allocating from tcache. The problem is our current UAF is in the 0x80 bin, not the 0x20 bin.  Therefore, we must set up a UAF and push it into the unsorted bin, but make sure that it is not sorted into the 0x80 (or larger) smallbin.  This can be accomplished with some clever heap feng shui and is best accomplished using a UAF on the last index (we will see why in a minute).  Freeing the UAF so it is in fastbins and calling the `focus()` function pushes the UAF into unsorted bins as desired.  Since a 0x20 allocation is smaller than the 0x80 smallbin, any `calloc()` call (since `calloc()` bypasses tcache) pulls from unsorted bins if no fastbins or smallbins of matching size are available. 

Once the UAF is allocated in 0x20, we can free it using the UAF again. This is why using the last index is useful, since it can be freed multiple times.  This puts a 0x20 chunk onto fastbins while we still hold a dangling pointer through the `globals.sign` variable.  Changing our sign to the `globals` address will corrupt the fastbins linked list so that we can obtain an arbitrary pointer. However, we need to pay attention to the safe-linking mitigation which calls `reveal()` on the fastbins `fw` pointer to unmask the obfuscated pointer.  If we legitimately mask the `globals` address using safe-linking masking then this will pass the `reveal()` check.  Allocating two consecutive 0x20 chunks (using `store_lucky_num()` and `get_lucky_num()`) will return the `globals` address.  If we override 0x10 bytes after the chunk start then we can corrupt `char* oracle_file` and `long oracle_file_lines`.  Pointing this to `flag.txt` and `0x1` forces the next call to `oracle()` to read from `flag.txt` instead of `oracle.txt`.  This will dump the flag: `The oracle says: flag{S4f3-l1nk1nG_Do35n7_pr073c7_ur_GL0B4L5}`
