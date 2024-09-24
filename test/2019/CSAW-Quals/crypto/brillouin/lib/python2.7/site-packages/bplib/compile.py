#!/usr/bin/env python

import os
import platform
import cffi

try:
    print("OpenSSL Path: %s" % os.environ["OPENSSL_DIR"])
    openssl_dir = os.environ["OPENSSL_DIR"]
except:
    if (platform.system() == "Darwin"
        and os.path.isdir('/usr/local/opt/openssl/include')):
        openssl_dir = '/usr/local/opt/openssl/include'
    else:
        print("Using default openssl location. Set OPENSSL_DIR env variable to change it.")
        openssl_dir = '../openssl'


# Determine the include and src directory
from os.path import join
csrc = "include" # abspath(join(dirname(__file__),"../src"))

## Asume we are running on a posix system
# LINUX: libraries=["crypto"], extra_compile_args=['-Wno-deprecated-declarations']
link_args = []
libraries=["crypto"]
extra_compile_args=['-Wno-deprecated-declarations']
include_dirs=[csrc, openssl_dir]
library_dirs=[]

cfiles = [r"bp_fp12.c",  r"bp_fp6.c", r"bp_g2.c", 
          r"bp_group.c",  r"bp_map.c", r"bp_fp2.c",   
          r"bp_g1.c", r"bp_g2_mult.c", r"bp_gt.c"]
print("Path: %s" % csrc)
csources = list(map(lambda x: r"bplib/src/"+x,cfiles))

from petlib.compile import _FFI as petlib_ffibuilder
ffibuilder = cffi.FFI()
ffibuilder.include(petlib_ffibuilder)

ffibuilder.set_source("bplib._bplib","""
#include <openssl/crypto.h>
#include <openssl/err.h>
#include <openssl/bn.h>
#include <openssl/ec.h>
#include <openssl/evp.h>
#include <openssl/hmac.h>
#include <openssl/ecdsa.h>

#include <openssl/ossl_typ.h>

#include <bp.h>

    """, libraries=libraries, 
    extra_compile_args=extra_compile_args, 
    include_dirs=include_dirs,
    library_dirs=library_dirs, 
    extra_link_args=link_args,
    sources=csources)


ffibuilder.cdef("""

// BP Functions
typedef ... BP_GROUP;
typedef ... G1_ELEM;
typedef ... G2_ELEM;
typedef ... GT_ELEM;

#define NID_fp254bnb 1

BP_GROUP *BP_GROUP_new(void);
BP_GROUP *BP_GROUP_new_by_curve_name(int nid);
void BP_GROUP_clear_free(BP_GROUP *group);
BP_GROUP *BP_GROUP_dup(const BP_GROUP *a);
const EC_GROUP *BP_GROUP_get_group_G1(BP_GROUP *group);

int BP_GROUP_get_order(const BP_GROUP *group, BIGNUM *order, BN_CTX *ctx);
int BP_GROUP_get_generator_G1(const BP_GROUP *group, G1_ELEM *g);
int BP_GROUP_precompute_mult_G1(BP_GROUP *group, BN_CTX *ctx);
int BP_GROUP_get_generator_G2(const BP_GROUP *group, G2_ELEM *g);
int BP_GROUP_precompute_mult_G2(BP_GROUP *group, BN_CTX *ctx);
int BP_GROUP_get_curve(const BP_GROUP *group, BIGNUM *p, BIGNUM *a,
                       BIGNUM *b, BN_CTX *ctx);
G1_ELEM *G1_ELEM_new(const BP_GROUP *group);
void G1_ELEM_free(G1_ELEM *point);
void G1_ELEM_clear_free(G1_ELEM *point);
int G1_ELEM_copy(G1_ELEM *dst, const G1_ELEM *src);
G1_ELEM *G1_ELEM_dup(const G1_ELEM *src, const BP_GROUP *group);
int G1_ELEM_set_to_infinity(const BP_GROUP *group, G1_ELEM *point);
int G1_ELEM_set_Jprojective_coordinates(const BP_GROUP *group,
                                        G1_ELEM *point, const BIGNUM *x,
                                        const BIGNUM *y,
                                        const BIGNUM *z, BN_CTX *ctx);
int G1_ELEM_get_Jprojective_coordinates(const BP_GROUP *group,
                                        const G1_ELEM *point, BIGNUM *x,
                                        BIGNUM *y, BIGNUM *z,
                                        BN_CTX *ctx);
int G1_ELEM_set_affine_coordinates(const BP_GROUP *group, G1_ELEM *point,
                                   const BIGNUM *x, const BIGNUM *y,
                                   BN_CTX *ctx);
int G1_ELEM_get_affine_coordinates(const BP_GROUP *group,
                                   const G1_ELEM *point, BIGNUM *x,
                                   BIGNUM *y, BN_CTX *ctx);
int G1_ELEM_set_compressed_coordinates(const BP_GROUP *group,
                                       G1_ELEM *point, const BIGNUM *x,
                                       int y_bit, BN_CTX *ctx);
size_t G1_ELEM_point2oct(const BP_GROUP *group, const G1_ELEM *point,
                         point_conversion_form_t form, unsigned char *buf,
                         size_t len, BN_CTX *ctx);
int G1_ELEM_oct2point(const BP_GROUP *group, const G1_ELEM *point,
                      const unsigned char *buf, size_t len, BN_CTX *ctx);
/********************************************************************/
/*              Functions for arithmetic in group G1                */
/********************************************************************/
int G1_ELEM_add(const BP_GROUP *group, G1_ELEM *r, const G1_ELEM *a,
                const G1_ELEM *b, BN_CTX *ctx);
int G1_ELEM_dbl(const BP_GROUP *group, G1_ELEM *r, const G1_ELEM *a,
                BN_CTX *ctx);
int G1_ELEM_invert(const BP_GROUP *group, G1_ELEM *a, BN_CTX *ctx);
int G1_ELEM_is_at_infinity(const BP_GROUP *group, const G1_ELEM *point);
int G1_ELEM_is_on_curve(const BP_GROUP *group, const G1_ELEM *point,
                        BN_CTX *ctx);
int G1_ELEM_cmp(const BP_GROUP *group, const G1_ELEM *point,
                const G1_ELEM *b, BN_CTX *ctx);
int G1_ELEM_make_affine(const BP_GROUP *group, G1_ELEM *point, BN_CTX *ctx);
int G1_ELEMs_make_affine(const BP_GROUP *group, size_t num,
                         G1_ELEM *points[], BN_CTX *ctx);
int G1_ELEM_mul(const BP_GROUP *group, G1_ELEM *r, const BIGNUM *g_scalar,
                const G1_ELEM *point, const BIGNUM *p_scalar,
                BN_CTX *ctx);
int G1_ELEMs_mul(const BP_GROUP *group, G1_ELEM *r, const BIGNUM *scalar,
                 size_t num, const G1_ELEM *points[],
                 const BIGNUM *scalars[], BN_CTX *ctx);
/********************************************************************/
/*              Functions for managing G2 elements                  */
/********************************************************************/
G2_ELEM *G2_ELEM_new(const BP_GROUP *group);
void G2_ELEM_free(G2_ELEM *point);
void G2_ELEM_clear_free(G2_ELEM *point);
int G2_ELEM_copy(G2_ELEM *dst, const G2_ELEM *src);
G2_ELEM *G2_ELEM_dup(const G2_ELEM *src, const BP_GROUP *group);
/********************************************************************/
/*              Functions for arithmetic in group G2                */
/********************************************************************/
int G2_ELEM_set_to_infinity(const BP_GROUP *group, G2_ELEM *point);
int G2_ELEM_set_Jprojective_coordinates(const BP_GROUP *group,
                                        G2_ELEM *point, const BIGNUM *x[2],
                                        const BIGNUM *y[2],
                                        const BIGNUM *z[2], BN_CTX *ctx);
int G2_ELEM_get_Jprojective_coordinates(const BP_GROUP *group,
                                        const G2_ELEM *point, BIGNUM *x[2],
                                        BIGNUM *y[2], BIGNUM *z[2],
                                        BN_CTX *ctx);
int G2_ELEM_set_affine_coordinates(const BP_GROUP *group, G2_ELEM *point,
                                   const BIGNUM *x[2], const BIGNUM *y[2],
                                   BN_CTX *ctx);
int G2_ELEM_get_affine_coordinates(const BP_GROUP *group,
                                   const G2_ELEM *point, BIGNUM *x[2], BIGNUM *y[2],
                                   BN_CTX *ctx);
size_t G2_ELEM_point2oct(const BP_GROUP *group, const G2_ELEM *point,
                         point_conversion_form_t form, unsigned char *buf,
                         size_t len, BN_CTX *ctx);
int G2_ELEM_oct2point(const BP_GROUP *group, G2_ELEM *point,
                      const unsigned char *buf, size_t len, BN_CTX *ctx);
/********************************************************************/
/*              Functions for arithmetic in group G2                */
/********************************************************************/
int G2_ELEM_add(const BP_GROUP *group, G2_ELEM *r, const G2_ELEM *a,
                const G2_ELEM *b, BN_CTX *ctx);
int G2_ELEM_dbl(const BP_GROUP *group, G2_ELEM *r, const G2_ELEM *a,
                BN_CTX *ctx);
int G2_ELEM_invert(const BP_GROUP *group, G2_ELEM *point, BN_CTX *ctx);
int G2_ELEM_is_at_infinity(const BP_GROUP *group, const G2_ELEM *point);
int G2_ELEM_is_on_curve(const BP_GROUP *group, const G2_ELEM *point,
                        BN_CTX *ctx);
int G2_ELEM_cmp(const BP_GROUP *group, const G2_ELEM *point,
                const G2_ELEM *b, BN_CTX *ctx);
int G2_ELEM_make_affine(const BP_GROUP *group, G2_ELEM *point, BN_CTX *ctx);
int G2_ELEMs_make_affine(const BP_GROUP *group, size_t num,
                         G2_ELEM *points[], BN_CTX *ctx);
int G2_ELEM_mul(const BP_GROUP *group, G2_ELEM *r, const BIGNUM *g_scalar,
                const G2_ELEM *point, const BIGNUM *p_scalar,
                BN_CTX *ctx);
int G2_ELEMs_mul(const BP_GROUP *group, G2_ELEM *r, const BIGNUM *scalar,
                 size_t num, const G2_ELEM *points[],
                 const BIGNUM *scalars[], BN_CTX *ctx);
/********************************************************************/
/*              Functions for managing GT elements                  */
/********************************************************************/
GT_ELEM *GT_ELEM_new(const BP_GROUP *group);
void GT_ELEM_free(GT_ELEM *elem);
void GT_clear_free(GT_ELEM *a);
int GT_ELEM_copy(GT_ELEM *dst, const GT_ELEM *src);
GT_ELEM *GT_ELEM_dup(const GT_ELEM *src, const BP_GROUP *group);
int GT_ELEM_zero(GT_ELEM *a);
int GT_ELEM_is_zero(GT_ELEM *a);
int GT_ELEM_set_to_unity(const BP_GROUP *group, GT_ELEM *a);
int GT_ELEM_is_unity(const BP_GROUP *group, const GT_ELEM *a);
size_t GT_ELEM_elem2oct(const BP_GROUP *group, const GT_ELEM *a,
                         unsigned char *buf, size_t len, BN_CTX *ctx);
int GT_ELEM_oct2elem(const BP_GROUP *group, GT_ELEM *a,
                      const unsigned char *buf, size_t len, BN_CTX *ctx);
int GT_ELEM_add(const BP_GROUP *group, GT_ELEM *r, const GT_ELEM *a,
                const GT_ELEM *b, BN_CTX *ctx);
int GT_ELEM_sub(const BP_GROUP *group, GT_ELEM *r, const GT_ELEM *a,
                const GT_ELEM *b, BN_CTX *ctx);
int GT_ELEM_sqr(const BP_GROUP *group, GT_ELEM *r, const GT_ELEM *a,
                BN_CTX *ctx);
int GT_ELEM_mul(const BP_GROUP *group, GT_ELEM *r, GT_ELEM *a, GT_ELEM *b, BN_CTX *ctx);
int GT_ELEM_inv(const BP_GROUP *group, GT_ELEM *r, GT_ELEM *a, BN_CTX *ctx);
int GT_ELEM_cmp(const GT_ELEM *a, const GT_ELEM *b);
int GT_ELEM_exp(const BP_GROUP *group, GT_ELEM *r, const GT_ELEM *a, const BIGNUM *b,
                BN_CTX *ctx);
int GT_ELEM_pairing(const BP_GROUP *group, GT_ELEM *r, const G1_ELEM *p,
                    const G2_ELEM *q, BN_CTX *ctx);
int GT_ELEMs_pairing(const BP_GROUP *group, GT_ELEM *r, size_t num,
                     const G1_ELEM *p[], const G2_ELEM *q[], BN_CTX *ctx);


""")

if __name__ == "__main__":
    print("Compiling bp ...")
    ffibuilder.compile(verbose=True)
