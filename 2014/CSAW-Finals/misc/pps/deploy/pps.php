#!/usr/bin/env php
<?php
chdir(realpath(dirname(__FILE__)));
set_time_limit(180);
ob_implicit_flush();
$stdin = fopen('php://stdin', 'r');
$punsource = "./puns";
$puns = file($punsource,FILE_IGNORE_NEW_LINES);

echo "Welcome to the PhPS: Phun Pun Service

	Yes, this is a horrible php script as xinetd. I mean, if people can write
	python and c and all sorts of other languages for their l33t socket services,
	why can't php be used? It seems like a perfectly fine choice. Anyway, to run
	this yourself, just save the file somewhere and launch it via xinetd.

	The real point though is that now you can play with some phun puns! I hope you
	enjoy. Also, I'm not saying there are hints in some of the puns, but I'm also
	not saying there /aren't/.
";


while(true)
{
	echo "
	MENU
	----
	1) Request a random pun
	2) List all puns
	3) Add a pun
	4) Use remote pun file
	5) Change pun file (admin password required)
	6) Reload puns from pun file
	7) Print the flag
	0) Quit

	Choice: ";

	fscanf(STDIN, "%d\n", $number) || $number=99; // reads number from STDIN
	echo "\n";
	switch($number) {
	case 8:
		echo "Ahh, clever. You found the hidden choice. Or you typoed. Just remember, every
			time you typo, the errorists win.

			Having sufffered through that, here's something that might help:\n";
		system("ls -l");
		break;
	case 1:
		$key=array_rand($puns);
		echo str_repeat("-",80)."\n";
		echo "Pun #".$key.": ".$puns[$key]."\n";
		echo str_repeat("-",80)."\n";
		break;
	case 2:
		echo str_repeat("-",80)."\n";
		foreach ($puns as $key => $pun)
		{
			echo "Pun #".$key.": ".$pun."\n";
		}
		echo str_repeat("-",80)."\n";
		break;
	case 3:
		echo "Enter a pun: ";
		$puns[] = trim(fgets($stdin));
		break;
	case 4:
		echo "Enter a pun URL: ";
		$url = str_replace(["file","flag"],"",trim(fgets($stdin)),$count);
		if ($count > 0)
		{
			echo "I'll have to file this warning as a flag on the play. 10 yards, repeat 4th down.\n";
			break;
		}
		$fp = @fopen($url,"r");
		if ($fp)
		{
			$puns = explode("\n",fread($fp, 32768));
		} else
		{
			echo "fopen failed. Must be closed or something.\n";
		}
		break;
	case 5:
		echo "Please enter the admin password: ";
		//temporarily disabled
		$password=preg_replace("/[1-9]/","",trim(fgets($stdin)));
		if ($password != "180019117")
		{
			echo "You may not pass (word).\n";
			continue;
		}
		echo "Please enter the new file name: ";
		$punsource=preg_replace("/[^a-zA-Z]/","",trim(fgets($stdin)));
	case 6:
		echo "Reloading ".$punsource.".\n";
		$puns = file($punsource,FILE_IGNORE_NEW_LINES);
		break;
	case 7:
		echo "the flag\n\n";
		break;
	case 0:
		echo "\nGoodbye.\n\n";
		break 2;
	default:
		echo "That is an invalid selection.\n\n";
		break;
	}

}
?>
