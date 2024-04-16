<?php
$auth = "CSAWh8a02KwZFs";
$cats = array(
  1 => array("id"=>1, "Name"=>"Grumpy Cat", "Available"=>"Now", "Description"=>"Your day was not possibly worse than mine."),
  2 => array("id"=>2, "Name"=>"Keyboard Cat", "Available"=>"Now", "Description"=>"Entertaining since 1984"),
  3 => array("id"=>3, "Name"=>"Computer Cat", "Available"=>"Now", "Description"=>"Just keeping up on the memes."),
  4 => array("id"=>4, "Name"=>"Bodybuilder Cat", "Available"=>"Now", "Description"=>"Just one more rep"),
  5 => array("id"=>5, "Name"=>"Hoodie Cat", "Available"=>"Now", "Description"=>"He didn't do it"),
  6 => array("id"=>6, "Name"=>"Hacker Cat", "Available"=>"Now", "Description"=>"All your Internetz belong to Uz"),
  7 => array("id"=>7, "Name"=>"CSAW Cat", "Available"=>"Coming Soon", "Description"=>"key{LolCatzRuleTheInternetz}"),
);  

function getCats($authtoken, $id, $adoptioncomment) {
	global $cats;
	global $auth;
	
	if(!(strcmp($authtoken, $auth) == 0)){
		return array("id"=>"-1", "Name"=>"Authentication Error", "Available"=>"NULL", "Description"=>"NULL");
	}
	
	if($id >= 0 && $id <= 7){
		return $cats[$id];
	}
	//return $quotes[$symbol];
	return array("id"=>"-1", "Name"=>"Error Cat Not Found", "Available"=>"NULL", "Description"=>"NULL");
}

ini_set("soap.wsdl_cache_enabled", "0"); // disabling WSDL cache

$server = new SoapServer("AvailableCats.wsdl");

$server->addFunction("getCats");

$server->handle();

?>