<?php
$requeststring = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:xmethods-delayed-quotes">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:getCats soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
         <authtoken xsi:type="xsd:string">CSAWh8a02KwZFs</authtoken>
         <id xsi:type="xsd:string"></id>
         <adoptioncomment xsi:type="xsd:string"></adoptioncomment>
      </urn:getCats>
   </soapenv:Body>
</soapenv:Envelope>';


function getRequestSize($id, $comment){
	global $requeststring;
	
	$clientrequest = $requeststring . $id . $comment;
	$gzdata = gzencode($clientrequest, 1);
	return strlen($gzdata);
}
?>
<html>
<body>
<table width="400" border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr>
<form name="frmLogin" method="post" action="servicetest.php">
<td>
<table width="100%" border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF">
<tr>
<td colspan="3"><strong>Service Test - availablecats.php</strong></td>
</tr>
<tr>
<td width="75">Auth Token</td>
<td width="5">:</td>
<td width="320"><input name="Auth" type="text" id="Auth" value="XXXX" disabled></td>
</tr>
<tr>
<td width="75">ID</td>
<td width="5">:</td>
<td width="320"><input name="catid" type="text" id="catid" maxlength="4"></td>
</tr>
<tr>
<td width="75">Adoption Comment</td>
<td width="5">:</td>
<td width="320"><input name="comment" type="text" id="comment" maxlength="250"></td>
</tr>
<tr>
<td><input type="submit" name="Submit" value="Submit"></td>
<td><td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<?php

//check if postback
if($_SERVER['REQUEST_METHOD'] == 'POST'){
	
	//verify id is set on postback
	$flag = true;
	if(isset($_POST['catid'])){
		//verify id is between 0 and 9999
		if(!($_POST['catid'] > 0) || !($_POST['catid'] < 10000)){
			$flag = false;
		}
	}
	else{
		$flag = false;
	}
	
	//add some authenticity
	$seconds = rand(1, 3);
	sleep($seconds);
		
		
	echo '<table width="100%" border="0" cellpadding="3" cellspacing="1" bgcolor="#FFFFFF">' . "\r";
	//echo '<tr>' . "\r";
	//echo '<th>Response Time</th>' . "\r";
	//echo '<td>'. $seconds . '.' . rand(10,99) .' seconds</td>' . "\r";
	//echo '</tr>' . "\r";
	echo '<tr>' . "\r";
	echo '<th>Response Code</th>' . "\r";
	echo '<td>';
	if($flag){
		echo '200 Success';
	}
	else{
		echo '500 Failure';
	}
	echo '</td>' . "\r";
	echo '</tr>' . "\r";
	echo '<tr>' . "\r";
	echo '<th>Request Size</th>' . "\r";
	//request size
	echo '<td>';
	echo getRequestSize($_POST['catid'], $_POST['comment']);
	echo '</td>';
	echo '</tr>' . "\r";
	echo '</table>' . "\r";
}
?>
</td>
</tr>
</table>
</body>
</html>
