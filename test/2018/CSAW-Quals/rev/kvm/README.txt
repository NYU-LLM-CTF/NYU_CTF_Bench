KVM chal

Author: Toshi
Points: 500
Give competitors `kvm/challenge`

Building:

1. `make -C chal`     (generates guest.img)
2. Run binja script on guest.img to make a better obfuscated one
   and to generate guest-tbl.c
3. `make -C chal tbl` (generates guest-tbl.o)
4. `make -C kvm`
