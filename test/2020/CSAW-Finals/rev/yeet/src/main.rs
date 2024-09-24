use obfstr::obfstr;

fn main() {
    println!("Writing challenges are wayy too hard for me :(");
    println!("Here's the flag, just don't tell anyone ;)\n\n");
    assert_eq!(obfstr!("flag{1ts_ok_t0_b3_rusty_4t_RE}"), obfstr!("flag{1ts_ok_t0_b3_rusty_4t_RE}"));
    //println!("{}", flag);
    println!("Sike!");
}
