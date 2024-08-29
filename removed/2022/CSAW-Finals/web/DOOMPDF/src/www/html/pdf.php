<?php 

    require('func.php');
	use Dompdf\Dompdf;
	use Dompdf\Options;

	include_once __DIR__ . '/../config/bootstrap.php';

    $filename = "export.pdf";

    $options = new Options();
    // disable remote urls
    $options->setIsRemoteEnabled(false);

    $dompdf = new Dompdf($options);   

    $title = $_GET['title'];

	$html = "<!DOCTYPE html>
	<html>
	<head>
	<style>
	body {
	    display: block;
	    text-align: center;
	}
	</style>
	</head>
	<body>";

	$html .= "<h1>My TODO List</h1>";

	$html .= "<p>".urldecode($_GET['title'])."</p>"; 

	$html .= "</body>";
	$html .= "</html>";

    $dompdf->loadHtml($html);
    $dompdf->setPaper('A5', 'portrait');

    // print warnings
    global $_dompdf_show_warnings;
    $_dompdf_show_warnings = true;

    // render the HTML as PDF
    $dompdf->render();

    // output the generated PDF to browser
    $dompdf->stream($filename, array('Attachment' => 0));

?>
