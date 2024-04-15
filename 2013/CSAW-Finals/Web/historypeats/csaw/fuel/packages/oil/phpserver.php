<?php
/**
 * Fuel
 *
 * Fuel is a fast, lightweight, community driven PHP5 framework.
 *
 * @package    Fuel
 * @version    1.7
 * @author     Fuel Development Team
 * @license    MIT License
 * @copyright  2010 - 2013 Fuel Development Team
 * @link       http://fuelphp.com
 */

// determine the file we're loading, we need to strip the query string for that
if (isset($_SERVER['SCRIPT_NAME']))
{
	$file = $_SERVER['DOCUMENT_ROOT'].$_SERVER['SCRIPT_NAME'];
}
else
{
	$file = $_SERVER['DOCUMENT_ROOT'].$_SERVER['REQUEST_URI'];
	if (($pos = strpos($file, '?')) !== false)
	{
		$file = substr($file, 0, $pos);
	}
}

if (file_exists($file))
{
	// bypass existing file processing
	return false;
}
else
{
	// route requests though the normal path
	include($_SERVER['DOCUMENT_ROOT'].'/index.php');
}

