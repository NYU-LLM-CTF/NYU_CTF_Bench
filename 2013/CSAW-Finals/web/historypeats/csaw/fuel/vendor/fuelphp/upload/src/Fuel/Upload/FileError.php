<?php
/**
 * @package    Fuel\Upload
 * @version    2.0
 * @author     Fuel Development Team
 * @license    MIT License
 * @copyright  2010 - 2013 Fuel Development Team
 * @link       http://fuelphp.com
 */

namespace Fuel\Upload;

/**
 * FileError is a container for file upload errors
 */
class FileError
{
	/**
	 * @var  array  Default error messages
	 */
	protected $messages = array(
		0 => 'The file uploaded with success',
		1 => 'The uploaded file exceeds the upload_max_filesize directive in php.ini',
		2 => 'The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form',
		3 => 'The uploaded file was only partially uploaded',
		4 => 'No file was uploaded',
		6 => 'Configured temporary upload folder is missing',
		7 => 'Failed to write uploaded file to disk',
		8 => 'Upload blocked by an installed PHP extension',
		101 => 'The uploaded file exceeds the defined maximum size',
		102 => 'Upload of files with this extension is not allowed',
		103 => 'Upload of files with this extension is not allowed',
		104 => 'Upload of files of this file type is not allowed',
		105 => 'Upload of files of this file type is not allowed',
		106 => 'Upload of files of this mime type is not allowed',
		107 => 'Upload of files of this mime type is not allowed',
		108 => 'The uploaded file name exceeds the defined maximum length',
		109 => 'Unable to move the uploaded file to it\'s final destination',
		110 => 'A file with the name of the uploaded file already exists',
		111 => 'Unable to create the file\'s destination directory',
		112 => 'Unable to upload the file to the destination using FTP',
	);

	/**
	 * @var  int  Current error number
	 */
	protected $error = 0;

	/**
	 * @var  string  Current error message
	 */
	protected $message = '';

	/**
	 * Constructor
	 *
	 * @param  int          $error  Number of the error message
	 * @param callable|null $langCallback
	 *
	 * @return FileError
	 */
	public function __construct($error, $langCallback = null)
	{
		$this->error = $error;

		if (is_callable($langCallback))
		{
			$this->message = call_user_func($langCallback, $error);
		}

		if (empty($this->message))
		{
			$this->message = isset($this->messages[$error]) ? $this->messages[$error] : 'Unknown error message number: '.$error;
		}
	}

	/**
	 * Return the error code
	 *
	 * @return  int  The error code set
	 */
	public function getError()
	{
		return $this->error;
	}

	/**
	 * Return the error message
	 *
	 * @return  string  The error message set
	 */
	public function getMessage()
	{
		return $this->message;
	}

	/**
	 * __toString magic method, will output the stored error message
	 *
	 * @return string
	 */
	public function __toString()
	{
		return $this->getMessage();
	}
}
