<?php
	if (isset($_GET['template'])) {
		@readfile("template/" . $_GET['template']);
	} else {
		echo "Must specify template file";
	}
?>