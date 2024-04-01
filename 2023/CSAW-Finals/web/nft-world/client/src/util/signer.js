import { getInt32Bytes } from "./bitmath";

export function signData(data) {
    let result = data 
    const CryptoJS = require("crypto-js");
    const passPhrase = localStorage.getItem("creationTime");
    const salt = CryptoJS.lib.WordArray.create([0])
    const pbkdf2 = CryptoJS.algo.PBKDF2.create({
        keySize: 8, 
        iterations: 100,
        hasher: CryptoJS.algo.SHA256,
    })
    const key = pbkdf2.compute(passPhrase, salt)
    const iv = CryptoJS.lib.WordArray.create([0,0,0,0])
    const encrypted = CryptoJS.AES.encrypt(result, key, {
        iv: iv,
        mode: CryptoJS.mode.CFB,
        padding: CryptoJS.pad.Pkcs7,
    })
    const hash = CryptoJS.MD5(encrypted.ciphertext)
    for( let i = 0; i < hash.words.length; i ++ ) {
        let word = getInt32Bytes(hash.words[i])
        for ( let j = 0 ; j < word.length; j++ ) {
            result += String.fromCharCode(word[j])
        }
    }
    return result
}