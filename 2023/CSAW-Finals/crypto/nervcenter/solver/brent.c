#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>
#include <sys/random.h>

void gcd(mpz_t result, mpz_t a, mpz_t b) {
    mpz_gcd(result, a, b);
}

void brent(mpz_t result, mpz_t N) {
    if (mpz_even_p(N)) {
        mpz_set_ui(result, 2);
        return;
    }

    mpz_t y, c, m, g, r, q, x, ys, temp;
    mpz_inits(y, c, m, g, r, q, x, ys, temp, NULL);

    gmp_randstate_t state;
    gmp_randinit_mt(state);

    // Seed using getrandom
    unsigned long seed;
    getrandom(&seed, sizeof(seed), 0);
    gmp_randseed_ui(state, seed);

    mpz_urandomm(y, state, N);
    mpz_urandomm(c, state, N);
    mpz_urandomm(m, state, N);

    mpz_set_ui(g, 1);
    mpz_set_ui(r, 1);
    mpz_set_ui(q, 1);

    while (mpz_cmp_ui(g, 1) == 0) {
        mpz_set(x, y);

        for (unsigned long i = 0; i < mpz_get_ui(r); i++) {
            mpz_mul(y, y, y);
            mpz_add(y, y, c);
            mpz_mod(y, y, N);
        }

        unsigned long k = 0;
        while (k < mpz_get_ui(r) && mpz_cmp_ui(g, 1) == 0) {
            mpz_set(ys, y);

            unsigned long range = (mpz_cmp_ui(m, mpz_get_ui(r) - k) < 0) ? mpz_get_ui(m) : mpz_get_ui(r) - k;
            for (unsigned long i = 0; i < range; i++) {
                mpz_mul(y, y, y);
                mpz_add(y, y, c);
                mpz_mod(y, y, N);

                mpz_sub(temp, x, y);
                mpz_abs(temp, temp);
                mpz_mul(q, q, temp);
                mpz_mod(q, q, N);
            }

            gcd(g, q, N);
            k += mpz_get_ui(m);
        }
        mpz_mul_ui(r, r, 2);
    }

    if (mpz_cmp(g, N) == 0) {
        do {
            mpz_mul(ys, ys, ys);
            mpz_add(ys, ys, c);
            mpz_mod(ys, ys, N);

            mpz_sub(temp, x, ys);
            mpz_abs(temp, temp);
            gcd(g, temp, N);
        } while (mpz_cmp_ui(g, 1) <= 0);
    }

    mpz_set(result, g);

    mpz_clears(y, c, m, g, r, q, x, ys, temp, NULL);
    gmp_randclear(state);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <number to factor>\n", argv[0]);
        return 1;
    }

    mpz_t N, factor;
    mpz_init_set_str(N, argv[1], 10);
    mpz_init(factor);

    brent(factor, N);

    gmp_printf("%Zd\n", factor);

    mpz_clear(N);
    mpz_clear(factor);

    return 0;
}