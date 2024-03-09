// Could be useful? :)
// unsafe {
//     asm!(
//         "mov {tmp}, {x}",
//         "shl {tmp}, 1",
//         "shl {x}, 2",
//         "add {x}, {tmp}",
//         x = inout(reg) x,
//         tmp = out(reg) _,
//     ).unwrap();
// }

use crate::b64;

pub fn build_decryption_key(s: String) -> Vec<u8> {
    let res = b64::decoder::decode(&s).expect("TODO: panic message");
    return res;
}

// Check if encoded value is "@nd_I_think_T0_mys3lf_WHat_a_wonderful_w0rld"
// The trick is that the decoding functionality is kind of broken... see b64/decoder.rs
// The idea is that the reverser needs to patch the binary in order to go to next section successfully.
// The reverser *can* decrypt the shellcode by knowing the key, but the shellcode depends on being executed
// within the binary itself as certain things it looks for are built at runtime which eliminates
// running the shellcode through a stub.

fn key_check_sub() -> [i32; 30] {
    return [0x58,0x31,0x74,0x5e,0x46,0x6e,0x75,0x5e,0x6c,0x32,0x5e,0x73,0x30,0x6f,0x66,0x30,0x6f,0x66,0x5e,0x49,0x32,0x6d,0x6d,0x72,0x5e,0x63,0x64,0x4d,0x6d,0x34]
}
pub fn check_key(key: Vec<u8>) -> bool {
    let tmp = key_check_sub();
    // let s = "Y0u_Got_m3_r1ng1ng_H3lls_beLl5".as_bytes();
    let mut i = tmp.len() - 1;
    while i >= 0 {
        if key[i] != (tmp[i] ^ 0x1) as u8 {
            return false;
        }
        if i == 0 {
            return true;
        }
        i -= 1;
    }
    return true;
}