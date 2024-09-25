<?php

class HaikuService {

	public function createHaiku() {

		// onClick loads this.
		include_once('../hhlib.php');	
		include_once('../poemshiz.php');	

		$chosen_formula = $formulas[rand(0,sizeof($formulas)-1)];

		$formula_lines = [];
		$formula_lines = split('/', $chosen_formula);

		$final_poem = '~';

		foreach ($formula_lines as $line) {
			$line_parts = [];
			$line_parts = split('-', $line);
			
			$poem_line = '';
			foreach ($line_parts as $part) {
				switch($part) {
					case '1j':
						$poem_line .= $adjectives['1'][rand(0,sizeof($adjectives['1'])-1)] . ' ';
						break;
					case '2j':
						$poem_line .= $adjectives['2'][rand(0,sizeof($adjectives['2'])-1)] . ' ';
						break;
					case '3j':
						$poem_line .= $adjectives['3'][rand(0,sizeof($adjectives['3'])-1)] . ' ';
						break;
					case '1n':
						$poem_line .= $nouns['1'][rand(0,sizeof($nouns['1'])-1)] . ' ';
						break;
					case '2n':
						$poem_line .= $nouns['2'][rand(0,sizeof($nouns['2'])-1)] . ' ';
						break;
					case '3n':
						$poem_line .= $nouns['3'][rand(0,sizeof($nouns['3'])-1)] . ' ';
						break;
					case '1v':
						$poem_line .= $verbs['1'][rand(0,sizeof($verbs['1'])-1)] . ' ';
						break;
					case '2v':
						$poem_line .= $verbs['2'][rand(0,sizeof($verbs['2'])-1)] . ' ';
						break;
					case '3v':
						$poem_line .= $verbs['3'][rand(0,sizeof($verbs['3'])-1)] . ' ';
						break;
					case '2a':
						$poem_line .= $adverbs['2'][rand(0,sizeof($adverbs['2'])-1)] . ' ';
						break;
					case '3a':
						$poem_line .= $adverbs['3'][rand(0,sizeof($adverbs['3'])-1)] . ' ';
						break;
					case 'a':
						$poem_line .= 'a ';
						break;
					case 'is':
						$poem_line .= 'is ';
						break;
					} //switch
				} //linepart

				// capitalize first letter
				$poem_line = ucfirst($poem_line);

				// axe the trailing space
				$poem_line = trim($poem_line);

				// add a newline
				$final_poem .= $poem_line . "\n";

			}	//line						

		// encrypts
		$encrypted_haiku = encryptHaiku($final_poem);

		return bin2hex($encrypted_haiku);

	}

	public function saveHaiku($timestamp, $name, $encblob) {

		include_once('../hhlib.php');	
		// decrypt the blob
		// first, hex2bin
		try {
			$unhexed_blob = pack("H*" , $encblob);
		}
		catch (Exception $eeee) {
			throw new Exception("Winter is coming\nThat which goes in, must come out\nSupplied blob was bad", 122);
		}
		$poem = trim(decryptHaiku($unhexed_blob));	


		$checked_name = amazingInputChecker($name);
		if (preg_match('/^Error has occurred/', $checked_name)) {
			// raise an error somehow
			throw new Exception($checked_name, 123);
		} 
		else {
			// saves to table using exec()
			try {
				$db->exec('INSERT INTO haikus (name, timestamp, poem) VALUES (\'' . $checked_name . '\', \'' . $timestamp . '\', \'' . $poem . '\')');
				`touch /tmp/ok`;
				$rez = $db->query("SELECT poem FROM haikus WHERE timestamp = '" . $timestamp . "' LIMIT 1");
		#		while ($row = $rez->fetchArray()) {
		#			$poem = $row['poem'];
		#		}
			}
			catch(Exception $ee) {
				throw new Exception("Database error\nOh God what have you done now\nLets try this again\n", 166);
			}
			#postHaiku($poem . '-' . $name . "#hackerhaikus #csawctf");
			try {
				$res = postHaiku($poem . "\n-" . $name . " #hackerhaikus");
				return "success!";
			}
			catch(Exception $eee) {
				throw new Exception("Could not post haiku\nThe Lords of Twitter say no\nWinter is coming", 125);
			}	
		}
	}
}

?>
