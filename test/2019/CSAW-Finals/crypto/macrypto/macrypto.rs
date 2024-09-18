extern crate hex;
extern crate rand;

use rand::random as r;
use std::io::{self, Result as R};
use std::fs::read_to_string as rts;

type T = u8;

const L: usize        = 256;
const E: &'static str = "whoops didnt work :(";
const F: &'static str = "flag.txt";

macro_rules! a { ($x:expr, $y:expr) => ($x.wrapping_add($y)) }
macro_rules! f { ($f:expr) => (rts($f)); }
macro_rules! s { ($x:expr, $y:expr) => { $x ^= $y; $y ^= $x; $x ^= $y; }}
macro_rules! u { ($u:expr) => ($u as usize); }

macro_rules! i {
    () => {{
        let mut r = String::new();
        io::stdin().read_line(&mut r).expect(E);
        r
    }};
}

macro_rules! k {
    ($p:expr) => {{
        let mut a = [0u8; L];
        for (i, e) in a.iter_mut().enumerate() { *e = i as u8; }
        let mut j: u8 = 0;
        for i in 0..L {
            j = a!(a!(j, a[i]), $p[i % $p.len()]);
            s!(a[i], a[u!(j)]);
        }
        a.to_vec()
    }};
}


fn main() -> R<()> {
    let f = f!(F)?;
    let r: Vec<T> = (0..L).map(|_| { r::<T>() }).collect();
    let mut a = k!(r);
    let (mut i, mut j): (T, T) = (0, 0);
    loop {
        let n = i!();
        let m = [n.as_bytes(), f.as_bytes()].concat();
        let mut c = vec![];
        for b in m.iter() {
            let mut k: T = 0;
            i = a!(i, 1); j = a!(j, a[u!(i)]);
            s!(a[u!(i)], a[u!(j)]);
            k = a!(a[u!(i)], a[u!(j)]);
            c.push(b ^ a[u!(k)]);
        }
        println!("{}", hex::encode(c));
    }
}
