<?php
	require 'common.php';
	
	// TODO: Allow users to update zipcode
	
	if ($req_method == "GET") {
		// Get weather
		// TODO: Actually get the current conditions
		
		echo jsonp($_GET['callback'], array("location"	=> "Canada",
		                      				"summary"	=> "friggin cold"));
	} else {
		http_response_code(405);
	}
?>