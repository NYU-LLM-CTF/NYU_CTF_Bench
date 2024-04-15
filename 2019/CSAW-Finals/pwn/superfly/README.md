# Run Solver
 * LD_PRELOAD="./libjemalloc.so.2 ./libsuperfly.so" python < exploit.py 

# Requires
  * syscall-intercept (version doesn't matter)
  * 18.04.3 linker (ecedcc8d1cac4f344f2e2d0564ff67ab) (included)
  * libjemalloc (included version doesn't matter) (included)
  * python (version doesn't matter but exploit is written and tested for python2)

make sure libjemalloc and libsuperfly are loaded when binary is served

# Desc
```
Super Fly is an automatic Stand that imprisons its user, Toyohiro, inside it,
making it a nuisance. Its power of damage reflection means that it is powerful
and invulnerable, but anyone is free to exploit the tower when fighting inside
it.
```
