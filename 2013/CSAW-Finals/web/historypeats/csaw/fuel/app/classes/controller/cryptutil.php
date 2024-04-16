<?php
ini_set('display_errors', 'On');
error_reporting(E_ALL | E_STRICT);


class Cryptutil {

    private $CIPHER = MCRYPT_RIJNDAEL_128;
    private $key =  '13somerandomkey2';
    private $MODE = MCRYPT_MODE_ECB;


    public function encrypt($data){
        $ciphertext = base64_encode(mcrypt_encrypt($this->CIPHER, $this->key, $data, $this->MODE));
        return $ciphertext;
    }

    public function decrypt($ciphertext){
        $ciphertext = base64_decode($ciphertext);
        $plaintext = mcrypt_decrypt($this->CIPHER, $this->key, $ciphertext, $this->MODE);
        return $plaintext;
    }

} 