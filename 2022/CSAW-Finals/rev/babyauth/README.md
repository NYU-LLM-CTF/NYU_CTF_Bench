# babyauth

## Description

This challenge requires you to exploit [CVE-2022-29824](https://packetstormsecurity.com/files/167345/libxml2-xmlBufAdd-Heap-Buffer-Overflow.html)
in libxml2, which is an integer overflow that results in a very large
heap-based overwrite. This will be triggered through libxml2's `xmllint` validator
binary, which I've repurposed slightly to ensure better reliable exploitation. See `libxml.patch`.

At the moment it's been kinda hard to groom the heap correctly with appropriate struct attributes 
to successfully perform something like unsafe linking, so I introduced a function pointer to `xmlBufNode`
to be overwritten (see `libxml.patch`) for the time being. If there is a much more complicated (and fun) heap exploitation primitive we can certainly change this up and remove some of the patches.

## Crash Repro / Exploit

This will segfault, or throw a `heap-buffer-overflow` ASAN report if instrumented:

```
$ ./validator --recover --huge --xpath "/test[string-length() < '4']" crash.xml
```
