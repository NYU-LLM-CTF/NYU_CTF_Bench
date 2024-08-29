use crate::b64::alphabet::{Alphabet, Classic};
use std::io;

pub fn decode(bytes: &String) -> Result<Vec<u8>, io::Error> {
    let alphabet = Classic {};
    decode_using_alphabet(alphabet, bytes)
}

pub fn decode_using_alphabet<T: Alphabet>(alphabet: T, data: &String) -> Result<Vec<u8>, io::Error> {
    // if data is not multiple of four bytes, data is invalid
    if data.chars().count() % 4 != 0 {
        return Err(io::Error::from(io::ErrorKind::InvalidInput));
    }

    let result = data
        .chars()
        .collect::<Vec<char>>()
        .chunks(4)
        .map(|chunk| original(&alphabet, chunk))
        .flat_map(stitch)
        .collect();

    Ok(result)
}

fn original<T: Alphabet>(alphabet: &T, chunk: &[char]) -> Vec<u8> {
    chunk
        .iter()
        .filter(|character| *character != &alphabet.get_padding_char())
        .map(|character| {
            alphabet
                .get_index_for_char(*character)
                .expect("unable to find character in alphabet")
        })
        .collect()
}
fn stitch(bytes: Vec<u8>) -> Vec<u8> {
    let out = match bytes.len() {
        2 => vec![
            (bytes[0] & 0b00111111) << 2 | bytes[1] >> 4,
            (bytes[1] & 0b00001111) << 4,
        ],

        3 => vec![
            (bytes[0] & 0b00111111) << 2 | bytes[1] >> 4,
            (bytes[1] & 0b00001111) << 4 | bytes[2] >> 2,
            (bytes[2] & 0b00000011) << 6,
        ],

        4 => vec![
            (bytes[0] & 0b00111111) << 2 | bytes[1] >> 4,
            (bytes[1] & 0b00001111) << 4 | bytes[2] >> 2,
            (bytes[2] & 0b00000011) << 6 | bytes[3] & 0b00111111,
        ],

        _ => unreachable!(),
    };

    out.into_iter().filter(|&x| x > 0).collect()
}