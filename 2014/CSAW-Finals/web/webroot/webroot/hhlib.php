<?php
	// All the goodies to actually do stuff that isn't AMF related.

  $db = new SQLite3('/var/www-sites/dev/my.db');


	function encryptHaiku($plaintext_poem) {

		$ecbKey = "#hax575!";
    $eh = mcrypt_module_open(MCRYPT_3DES, '', 'ecb', '');
    mcrypt_generic_init($eh, $ecbKey, '00000000');

    $encrypted_poem = mcrypt_generic($eh, $plaintext_poem);
    // bin2hex if necessary
		return $encrypted_poem;

	}

	function postHaiku($postme) {
		// some integration to twitter.

		include_once('../twit/tmhOAuth.php');
		$tmhOAuth = new tmhOAuth(array(
			'consumer_key' => 'xHbXKEAWirJSnfdTuBZ7SaNu4',
			'consumer_secret' => 'pHUFWWeuP3nYZiZkykvqqbXDIjbsTI0hO8RUwcLWxOgM7N2de6',
			'token' => '2891689520-9gHqz2bqjxxuWhCFlmvBCdyMTQV2g4uHhmGLkbT',
			'secret' => 'zHxld8ngNTkerbaPwRitwOP2qU2OGUexyHhLd9O5Aawq0',
		));

		$response = $tmhOAuth->request('POST', $tmhOAuth->url('1.1/statuses/update'), array(
			'status' => $postme
			#'status' => "~~Hello Dave.\n\tIs that you, Dave?~~\n~Is Dave there, please?\n\t-xx #4fvdsc23c"
		));

		if ($response == 200) {
			return "OK!";
		}
		else {
			return $tmhOAuth->response;
		}

	}

	function decryptHaiku($ciphertext_poem) {


		$ecbKey = "#hax575!";
    $eh = mcrypt_module_open(MCRYPT_3DES, '', 'ecb', '');
    mcrypt_generic_init($eh, $ecbKey, '00000000');

    $decrypted_poem = mdecrypt_generic($eh, $ciphertext_poem);

		return $decrypted_poem;
	}

	function amazingInputChecker($text_in) {
		$naughty_count = preg_match('/[^a-zA-Z0-9@\-\_]/', $text_in);

		if ($naughty_count == 0 && strlen($text_in) < 21 && strlen($text_in) != 0) {
			return $text_in;
		}
		else {
			if (strlen($text_in) > 20) {
				return "Error has occurred\nLength of your name is too long\nTry something shorter";
			}
			elseif (strlen($text_in) == 0) {
				return "Error has occurred\nI need to know your name, yo\nYou know what to do.";
			}
			else {
				return "Error has occurred\nHacker detector now on\nYour move, punk. Good luck.";
			}
		}
	}

?>
