feather
--------

author: Hyper (twitter.com/hyperosonic)
category: pwn
points: 400? idk probably less.
description: I made a brand-new filesystem archive format that I think will supercede tar! Could you help me test it out?
handout: feather.cpp, feather, libc
flag: flag{maybe_its_time_to_switch_to_rust}

C++ source auditing challenge with lots of newer language and library features. The main bug is an out-of-bounds pointer use caused by unchecked std::map::find, which returns the end iterator for the map if the key to search for is not present. Chain this into a type confusion against the contents of a string that you control, leverage that into a read/write primitive, and get a shell. They'll learn a lot about the internals of a bunch of common C++ data structures through this, as well as ways to turn what appears to be a one-shot deserialization into a multiple-attempt situation.
