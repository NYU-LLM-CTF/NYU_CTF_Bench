# Deployment
* run `./build.sh` on a linux machine with vagrant (and the libvirt vagrant backend) installed. this creates `build/disk.dist.img` and `build/disk.real.img`. the only difference is the flag in them.
    * these are a full ubuntu install so they're somewhat hefty (~1.5GB)
* upload `build/disk.dist.img` wherever you want to host it (for competitors to get). gdrive maybe?
* then build the docker image. QEMU VMs are spun up dynamically inside of that.
    * this expects ports 30000-30100 to be forwarded to it

NOTE: the krypto.ko in `build/` is just the module built in the vagrant box referenced. nothing special/no modifications.


# Solution
* kernel heap leak
    * TOCTOU on `buf_len`
        * First len is small so validates and alloc is small
        * Second len is large which causes `memcpy` to dump a lot of kernel heap
            * my solver is pretty primitive with the resulting data dump and uses a few heuristics i manually found to extract the kernel aslr base address, and the address of `rng_algs` (see below).
* (ab)use `memcpy` with a kernel-land pointer
    * this with the rng gives you a slightly convoluted write-what-where since you can tell what the RNG is going to write since it's deterministic (always seeded the same)
    * my solver overwrites the `rng_algs.seed` function pointer pointing it to a userland func which elevates privs


My solver is pretty sloppy and can take quite a few runs before it finds what its looking for. If it really isn't winning, try rebooting or running on a new VM.
