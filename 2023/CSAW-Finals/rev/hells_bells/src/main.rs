use std::io::{stdout, Write};
use std::error::Error;
use std::{mem, process, ptr};
use std::io;
use std::convert::TryInto;
use std::env;
use crypto::rc4::Rc4;
use crypto::symmetriccipher::SynchronousStreamCipher;
use webbrowser;
use std::iter::repeat;
use std::str;
use crypto::digest::Digest;
use crypto::md5::Md5;
use windows::Win32::System::Memory::{MEM_COMMIT, MEM_RESERVE, PAGE_EXECUTE_READWRITE, VirtualAlloc};
use crate::injection::inject_and_migrate;
use std::time::{Duration, Instant, SystemTime};
use once_cell::sync::Lazy;

// Import project modules.
mod util;
mod injection;
mod b64 {
    pub mod decoder;
    pub mod alphabet;
    pub mod encoder;
}
mod stage;

// Define shellcode data. These CANNOT be stored in .text as the need to be modified during decoding / decryption.
const SHELLCODE_BYTES: &[u8] = include_bytes!("shellcodes/initial-shellcode/sc.dat");
const SHELLCODE_LENGTH: usize = SHELLCODE_BYTES.len();
const SHELLCODE2_BYTES: &[u8] = include_bytes!("shellcodes/injected-shellcode/sc.dat");
const SHELLCODE2_LENGTH: usize = SHELLCODE2_BYTES.len();
#[no_mangle]
static mut SHELLCODE: [u8; SHELLCODE_LENGTH] = *include_bytes!("shellcodes/initial-shellcode/sc.dat");
#[no_mangle]
static mut SHELLCODE2: [u8; SHELLCODE2_LENGTH] = *include_bytes!("shellcodes/injected-shellcode/sc.dat");

// Allocate space for the 'Oracle' struct used by both shellcodes.
// Why do we want to define it in .bss? Well, it needs to be modified by both shellcodes, so they
// both need to know the exact location to point to in order to access the memory location.
// But, can we be more reliable than that and store a pointer.
static mut ORACLE: [u8; 5000] = [0; 5000];

// Here we have pointers to the memory sections that will be used by the shellcodes.
#[no_mangle]
#[link_section = ".text"]
static ORACLE_POINTER: &[u8; 5000] = unsafe { &ORACLE };
#[no_mangle]
#[link_section = ".text"]
static READ_INPUT: extern "C" fn() -> String = read_input_c;

// More global variables.
#[link_section = ".text"]
const URL_BYTES: &[u8] = include_bytes!("encrypted_url.dat");
const ARG_HASH: [i32; 16] = [0x8d, 0x08, 0x9a, 0xd1, 0xf8, 0xca, 0x1b, 0x85, 0x65, 0x6f, 0x14, 0xd1, 0x31, 0x45, 0xdb, 0xeb];
static EPOCH: Lazy<(Instant, SystemTime)> = Lazy::new(|| (Instant::now(), SystemTime::now()));

const ENTRY_MESSAGE: &str = "

                  &@@               ,@@,                                                   .@@/
               .@@@@@@@,          @@@@@@@%                       @@@@@@@@@@@@@@(         %@@@@@@@.
             %@@@@@@@@@@@@     ,@@@@@@@@@@@@,                 /@@@@@@@@@@@@@@@@@@@.   .@@@@@@@@@@@@*
          .@@@@@@@&&@@@@@@@@,@@@@@@@@/@@@@@@@@#             @@@@@@@@**,***,#@@@@@@@@&@@@@@@@*@@@@@@@@@
        @@@@@@@@,    ,@@@@@@@@@@@@#     @@@@@@@@@. @@@@@@@@@@@@@@(            @@@@@@@@@@@&     %@@@@@@@@,
      @@@@@@@&          &@@@@@@@          /@@@@@@@@@@@@@@@@@@@@@&      .        %@@@@@@,         .@@@@@@@@&
      @@@@@,    #@        &@@@     %@        @@@@@@@@@@      @@@@@     .@@,      (@@@     /@        @@@@@@@@(
      @@@@@     #@@@(     &@@@     %@@@*  .@@@@@@@@@@%      @@@@@@     .@@@@     (@@@     /@@@#  .@@@@@@@@*.
      @@@@@     #@@@@     &@@@     %@@@@@@@@@@@@@@@@%      @@@@@@@     .@@@@     (@@@     /@@@@@@@@@@@@#,
      @@@@@     #@@@@     &@@@     %@@@@@@@@@@@@@@@(      @@@@@@@@     .@@@@     (@@@     /@@@@@@@@@@*.
      @@@@@               &@@@     %@@@@@@@@@@@@@@,          *@@@@     .@@@@     (@@@     /@@@@@@@@@/
      @@@@@               &@@@     %@@@@@@@@@@@@@,          @@@@@@     .@@@@     (@@@     /@@@@@@@@@@@@
      @@@@@               &@@@     %@@@@@@@@@@@@@@@@@     @@@@@@@@     .@@@@     (@@@     /@@@@@%@@@@@@@@(
     &@@@@@     #@@@@     &@@@     %@@*    .@@@@@@@@.   @@@@@@@@@@     .@@@@     (@@@     /@@(     @@@@@@@@@.
  ,@@@@@@@#     .@@@(     ,@@@,            ,@@@@@@@(  #@@@@@@@@@@@     .@.       (@@@/             @@@@@@@@/.
  /@@@@@@#        @*       .@@@@@        &@@@@@@@@& ,@@@@@@@@@@@               #@@@@@@@@        %@@@@@@@#,
    .@@@@@@@   #@@@@@@   %@@@@@@@@@,  .@@@@@@@@@@@ @@@@@@#*(@@@@@@(          @@@@@@@@@@@@@(   @@@@@@@@*.
       (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(,@@@@@@@@(,     .@@@@@@@@@@@@@@@@@@@@#, ,@@@@@@@@@@@@@#,
         ,@@@@@@@@#*@@@@@@@@(,  .%@@@@@@@&*   &@@@@/,           (@@@@@@@@@@@@@@@*.     .#@@@@@@@@*.
            (@@@/.   .&@@@*.       ,@@@(,     ,&/.                .,,,,,,,,,,,,           .@@@#,
              .


        In the depths of this cryptic challenge, the haunting chimes of Hells Bells beckon you.
        As you embark on this journey, you will be immersed in a world of musical enigma and
        hidden secrets.

        Your mission is clear: reverse the song's essence and decipher its knell.
        It won't be easy, but your determination and wit will be your greatest allies.
        Prepare to dive into the poetic fire of Hells Bells and prove your mettle as a master of
        reverse engineering.

        May your code-breaking skills be sharp, and may the riddles of Hells Bells reveal their secrets to
        you. Best of luck, and may the challenge begin!

";

const FIRST_MESSAGE: &str = "Enter a key";

fn read_input(n: usize) -> Vec<io::Result<String>> {
    // Read n lines from the console.
    let mut inputs = vec![];
    let mut i = 0;
    loop {
        if i == n { break; }
        i += 1;
        print!("> ");
        let _ = io::stdout().flush();
        inputs.push(io::stdin().lines().take(1).nth(0).unwrap());
    }
    // Anti-debugging, checks if the program has been running more than 20 seconds.
    let (epoch, sys) = *EPOCH;
    let now = Instant::now().duration_since(epoch).as_secs();
    if now > 90 || sys.elapsed().expect("").as_secs() > 90 { loop {} }
    return inputs;
}

#[no_mangle]
pub extern "C" fn read_input_c<'a>() -> String {
    // Read n lines from the console.
    // This is used in the first shellcode for the final challenge when getting flag decryption key.
    print!("> ");
    let _ = io::stdout().flush();
    let mut lines = io::stdin().lines().take(1);
    let line = lines.nth(0).unwrap().unwrap();
    // Anti-debugging, checks if the program has been running more than 20 seconds.
    let (epoch, sys) = *EPOCH;
    let now = Instant::now().duration_since(epoch).as_secs();
    if now > 90 || sys.elapsed().expect("").as_secs() > 90 { loop {} }
    return line;
}

fn hash(s: String) -> Vec<u8> {
    // Run MD5 hashing on a string
    let mut sum: u32 = 0;
    s.as_bytes().iter().for_each(|&b| (sum += b as u32));
    let mut output: Vec<u8> = repeat(0).take(16).collect();
    let mut md5 = Md5::new();
    md5.input(s.as_bytes());
    md5.result(&mut *output);
    return output;
}

fn do_process_injection() {
    // Grab the second parameter which should be the PPID
    let mut param = env::args().nth(2);
    if param.is_some() {
        let param_n = param.clone();
        if param_n.is_some() {
            let param_s = param.clone().unwrap();
            let num: i32 = param_s.parse().unwrap();
            // Decode the second shellcode.
            unsafe { SHELLCODE2 = SHELLCODE2.map(|x| x ^ 0x25)};
            // Inject
            unsafe { inject_and_migrate(&SHELLCODE2, num as u32) }
        }
    }
}

fn do_crazy_stuff_with_arg(param: String) {
    // If the argument is SelfDebugging (md5 hash matches) then it will open the following link:
    // https://www.youtube.com/watch?v=etAIpkdhU9Q
    // After decrypting the link using the argument.
    let mut hash_r = hash(param.clone());
    let mut i = 0;
    while i < 16 {
        if hash_r[i] != ARG_HASH[i] as u8 { return; }
        i += 1;
    }
    // Decrypt the link.
    let mut output: Vec<u8> = repeat(0).take(URL_BYTES.len()).collect();
    let mut rc4 = Rc4::new(param.as_bytes());
    rc4.process(URL_BYTES, &mut output);
    let s = match str::from_utf8(&*output) {
        Ok(v) => v,
        Err(e) => panic!("Invalid UTF-8 sequence: {}", e),
    };
    // Open a web browser with the link.
    if webbrowser::open(s).is_ok() {
        // Inject the second shellcode
        do_process_injection();
        process::exit(0x0);
    }
}

unsafe fn run_sc_decryption(key: Vec<u8>) -> *mut u8 {
    // Decrypt the shellcode
    let mut rc4 = Rc4::new(&*key);
    let alloc = VirtualAlloc(None, SHELLCODE.len(), (MEM_RESERVE | MEM_COMMIT), PAGE_EXECUTE_READWRITE) as *mut u8;
    rc4.process(SHELLCODE.as_ref(), &mut SHELLCODE);
    alloc.copy_from(SHELLCODE.as_ptr() as *mut u8, SHELLCODE.len());
    return alloc;
}

fn check_args() {
    let mut param = env::args().nth(1);
    if param.is_some() {
        let param_n = param.clone();
        if param_n.is_some() {
            let param_s = param.clone().unwrap();
            do_crazy_stuff_with_arg(param_s);
        }
    } else {
        print!("{}", ENTRY_MESSAGE);
        let _ = io::stdout().flush();
        // Read two lines from console
        let res = read_input(2);
        // Get the key from the first line
        let k = res.iter().nth(0).clone().unwrap().as_ref().expect("Raise your hand if you like reversing rust! *crickets*");
        // Base64 decode the key
        let out = b64::decoder::decode(k).unwrap();
        // Check if key is legit
        let is_match = stage::check_key(out.clone());
        if !is_match { return; }
        unsafe {
            // Decrypt shellcode
            let sc_loc = run_sc_decryption(out.clone());
            // Modify shellcode at offset 0x443 which is the key used when doing
            // ROTR-32 encrypting while walking the PEB.
            // Requires a solver script such as the one in solver/rotr32_solver.cpp
            let new_p = sc_loc.offset(0x443);
            let char = u8::try_from(res.iter().nth(1).unwrap().as_ref().unwrap().chars().nth(0).unwrap()).unwrap();
            new_p.replace(char);
            // Call the shellcode (see shellcodes/initial-shellcode/*)
            let exec_shellcode: extern "C" fn() -> ! = mem::transmute(sc_loc as *const _ as *const ());
            exec_shellcode();
        }
    }
}

fn now() {
    // Needed for initialization?
    let (epoch, sys) = *EPOCH;
    let _ = sys.elapsed().expect("Initializing system time for anti-debugging.").as_secs();
    let _ = Instant::now().duration_since(epoch);
}

fn main() {
    // Initialize timestamps for anti-debug
    now();
    // Enter main program
    check_args();
}