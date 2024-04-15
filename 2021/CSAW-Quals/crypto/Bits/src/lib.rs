#[macro_use]
extern crate lazy_static;

use std::collections::HashMap;
use std::sync::Mutex;
use rug::{Integer,Complete,ops::Pow};

pub static FLAG: &[u8;49] = b"flag{https://www.youtube.com/watch?v=uhTCeZasCmc}";

static P0: i64 = 785685301;
static P1: i64 = 633462701;
static GP: i64 = 2;
static Q0: i64 = 794309437;
static Q1: i64 = 942797321;
static GQ: i64 = 2;

lazy_static!(
    static ref PPOW: Integer = Integer::from(P0).pow(16u32);
    static ref QPOW: Integer = Integer::from(Q0).pow(16u32);
    static ref P: Integer = 2 * (&*PPOW * Integer::from(P1)) + 1;
    static ref Q: Integer = 2 * (&*QPOW * Integer::from(Q1)) + 1;
    pub static ref N: Integer = Integer::from(&*P * &*Q);
    pub static ref ORDER: Integer = Integer::from(&*P - 1).lcm(&Integer::from(&*Q - 1));
    pub static ref G: Integer = crt(&Integer::from(GP), &Integer::from(GQ), &*P, &*Q).unwrap();
);

fn crt(a: &Integer, b: &Integer, m1: &Integer, m2: &Integer) -> Option<Integer> {
    let common = Integer::from(m1.gcd_ref(m2));
    let m = Integer::from(m1.lcm_ref(m2));
    if b < a {
        crt(b, a, m2, m1)
    } else if Integer::from(b - a) % &common != 0 {
        None
    } else {
        let q = Integer::from(b - a) / &common;
        Some((a + q * m1 * Integer::from(m1/&common).invert(&Integer::from(m2/&common)).ok()?) % m)
    }
}

type BSKey = (Integer, Integer);
type BSVal = HashMap<Integer, Integer>;
type BSCache = HashMap<BSKey, BSVal>;
lazy_static!(
    static ref BS_CACHE: Mutex<BSCache> = Mutex::<BSCache>::new(BSCache::new());
);
pub fn baby_step(p: Integer, ell: Integer, gamma: Integer) {
    let key = (p.clone(), ell.clone());
    if !BS_CACHE.lock().unwrap().contains_key(&key) {
        let s: Integer = ell.sqrt() + 1;
        let mut bs = BSVal::with_capacity(s.to_usize_wrapping());
        let mut g = Integer::from(1);
        let mut m = Integer::from(0);
        while m <= s {
            bs.insert(g.clone(), m.clone());
            g = g * &gamma;
            g = g % &p;
            m += 1;
        }
        BS_CACHE.lock().unwrap().insert(key, bs);
    }
}

pub fn giant_step(p: &Integer, ell: &Integer, g: &Integer, h: &Integer) -> Option<Integer> {
    let s = Integer::from(ell.sqrt_ref()) + 1;
    let step = g.clone().pow_mod(&s, p).unwrap().invert(p).unwrap();
    let mut m = 0;
    let mut hh = h.clone();
    let bs = &BS_CACHE.lock().unwrap()[&(p.clone(), ell.clone())];

    while m <= s {
        if bs.contains_key(&hh) {
            return Some((bs[&hh].clone() + m*s) % ell);
        }
        hh = hh * &step;
        hh = hh % p;
        m += 1;
    }

    None
}


fn f(tup : (Integer, Integer, Integer), g : &Integer, target : &Integer, p : &Integer, ell : &Integer) -> (Integer, Integer, Integer) {
    let (x, a, b) = tup;
    match Integer::from(&x % 3).to_i64().unwrap() {
        0 => {
            ((&x * &x).complete() % p, (2 * a) % ell, (2 * b) % ell)
        },
        1 => {
            ((target * x) % p, a, (b + 1))
        },
        2 => {
            ((g * x) % p, (a + 1), b)
        },
        _ => {unreachable!();}
    }
}

pub fn rho(p : &Integer, ell : &Integer, g : &Integer, target : &Integer) -> Integer {
    if g == target { return Integer::from(1); }
    let mut a = (Integer::from(1), Integer::from(0), Integer::from(0));
    let mut b = (Integer::from(1), Integer::from(0), Integer::from(0));
    loop {
        a = f(a, g, target, p, ell);
        b = f(b, g, target, p, ell);
        b = f(b, g, target, p, ell);
        if a.0 == b.0 {
            break;
        }
    }
    ((a.1 - b.1) * (b.2 - a.2).invert(ell).unwrap() % ell + ell) % ell
}

fn dlog_prime_power(target: &Integer, p: &Integer, pi: &Integer, ei: u32) -> Option<Integer> {
    let ni = Integer::from(pi).pow(ei);
    let inject = Integer::from(p - 1)/&ni;
    let gi = Integer::from(&*G).pow_mod(&inject, p).unwrap();
    let hi = Integer::from(target).pow_mod(&inject, p).unwrap();

    let mut xi = Integer::from(0);
    let mut hk_exp = Integer::from(p - 1)/pi;
    let gamma = Integer::from(&gi).pow_mod(&hk_exp, p).unwrap();

    baby_step(p.clone(), pi.clone(), gamma.clone());

    for k in 0..ei {
        let gk = Integer::from(&gi).pow_mod(&xi, p).unwrap().invert(p).unwrap();
        let hk = Integer::from(&gk * &hi).pow_mod(&hk_exp, p).unwrap();
        let dk = giant_step(p, pi, &gamma, &hk)?;
        // assert_eq!(dk, rho(p, pi, &gamma, &hk));
        xi += &dk * Integer::from(pi).pow(k);
        if k != ei - 1 { hk_exp = hk_exp / pi; }
    }

    Some(xi)
}

pub fn dlog(target: Integer) -> Option<Integer> {
    let modp = crt(
        &crt(
            &dlog_prime_power(&target, &*P, &Integer::from(2), 1)?,
            &dlog_prime_power(&target, &*P, &Integer::from(P0), 16)?,
            &Integer::from(2),
            &*PPOW
        )?,
        &dlog_prime_power(&target, &*P, &Integer::from(P1), 1)?,
        &Integer::from(2 * &*PPOW),
        &Integer::from(P1)
    )?;
    let modq = crt(
        &crt(
            &dlog_prime_power(&target, &*Q, &Integer::from(2), 1)?,
            &dlog_prime_power(&target, &*Q, &Integer::from(Q0), 16)?,
            &Integer::from(2),
            &*QPOW
        )?,
        &dlog_prime_power(&target, &*Q, &Integer::from(Q1), 1)?,
        &Integer::from(2 * &*QPOW),
        &Integer::from(Q1)
    )?;
    Some(crt(&modp, &modq, &(&*P - Integer::from(1)), &(&*Q - Integer::from(1)))?)
}
