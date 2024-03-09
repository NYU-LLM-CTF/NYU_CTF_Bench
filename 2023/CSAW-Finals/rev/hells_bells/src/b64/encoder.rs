use crate::b64::alphabet::{Alphabet, Classic};
use std::iter::FromIterator;

pub fn encode(data: &[u8]) -> String {
    let classic_alphabet = &Classic {};
    encode_using_alphabet(classic_alphabet, data)
}

pub fn encode_using_alphabet<T: Alphabet>(alphabet: &T, data: &[u8]) -> String {
    let encoded = data
        .chunks(3)
        .map(split)
        .flat_map(|chunk| encode_chunk(alphabet, chunk));

    String::from_iter(encoded)
}

fn split(chunk: &[u8]) -> Vec<u8> {
    match chunk.len() {
        1 => vec![&chunk[0] >> 2, (&chunk[0] & 0b00000011) << 4],

        2 => vec![
            &chunk[0] >> 2,
            (&chunk[0] & 0b00000011) << 4 | &chunk[1] >> 4,
            (&chunk[1] & 0b00001111) << 2,
        ],

        3 => vec![
            &chunk[0] >> 2,
            (&chunk[0] & 0b00000011) << 4 | &chunk[1] >> 4,
            (&chunk[1] & 0b00001111) << 2 | &chunk[2] >> 6,
            &chunk[2] & 0b00111111,
        ],

        _ => unreachable!(),
    }
}

fn encode_chunk<T: Alphabet>(alphabet: &T, chunk: Vec<u8>) -> Vec<char> {
    let mut out = vec![alphabet.get_padding_char(); 4];

    for i in 0..chunk.len() {
        if let Some(chr) = alphabet.get_char_for_index(chunk[i]) {
            out[i] = chr;
        }
    }

    out
}