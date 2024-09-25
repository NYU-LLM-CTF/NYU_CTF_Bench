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
 * Upload is a container for unified access to uploaded files
 */
class Upload implements \ArrayAccess, \Iterator, \Countable
{
	/**
	 * @var  array  Container for uploaded file objects
	 */
	protected $container = array();

	/**
	 * @var  int  index pointer for Iterator
	 */
	protected $index = 0;

	/**
	 * @var  array  Default configuration values
	 */
	protected $defaults = array(
		// global settings
		'auto_process'    => false,
		'langCallback'    => null,
		'moveCallback'    => null,
		// validation settings
		'max_size'        => 0,
		'max_length'      => 0,
		'ext_whitelist'   => array(),
		'ext_blacklist'   => array(),
		'type_whitelist'  => array(),
		'type_blacklist'  => array(),
		'mime_whitelist'  => array(),
		'mime_blacklist'  => array(),
		// file settings
		'prefix'          => '',
		'suffix'          => '',
		'extension'       => '',
		'randomize'       => false,
		'normalize'       => false,
		'normalize_separator' => '_',
		'change_case'     => false,
		// save-to-disk settings
		'path'            => '',
		'create_path'     => true,
		'path_chmod'      => 0777,
		'file_chmod'      => 0666,
		'auto_rename'     => true,
		'new_name'        => false,
		'overwrite'       => false,
	);

	/**
	 * @var  array  Container for callbacks
	 */
	protected $callbacks = array(
		'before_validation' => array(),
		'after_validation' => array(),
		'before_save' => array(),
		'after_save' => array(),
	);

	/**
	 * Constructor
	 *
	 * @param  array|null  $config  Optional array of configuration items
	 *
	 * @throws NoFilesException No uploaded files were found (did specify "enctype"?)
	 */
	public function __construct(array $config = null)
	{
		// override defaults if needed
		if (is_array($config))
		{
			foreach ($config as $key => $value)
			{
				array_key_exists($key, $this->defaults) and $this->defaults[$key] = $value;
			}
		}

		// we can't do anything without any files uploaded
		if (empty($_FILES))
		{
			throw new NoFilesException('No uploaded files were found. Did you specify "enctype" in your &lt;form&gt; tag?');
		}

		// if auto-process was active, run validation on all file objects
		if ($this->defaults['auto_process'])
		{
			// process all data in the $_FILES array
			$this->processFiles();

			// and validate it
			$this->validate();
		}
	}

	/**
	 * Run save on all loaded file objects
	 *
	 * @param  int|string|array  $selection  Optional array index, element name or array with filter values
	 *
	 * @return void
	 */
	public function save($selection = null)
	{
		// prepare the selection
		if (func_num_args())
		{
			if (is_array($selection))
			{
				$filter = array();

				foreach ($this->container as $file)
				{
					$match = true;
					foreach($selection as $item => $value)
					{
						if ($value != $file->{$item})
						{
							$match = false;
							break;
						}
					}

					$match and $filter[] = $file;
				}

				$selection = $filter;
			}
			else
			{
				$selection =  array($this[$selection]);
			}
		}
		else
		{
			$selection = $this->container;
		}

		// loop through all selected files
		foreach ($selection as $file)
		{
			$file->save();
		}
	}

	/**
	 * Run validation on all selected file objects
	 *
	 * @param  int|string|array  $selection  Optional array index, element name or array with filter values
	 *
	 * @return void
	 */
	public function validate($selection = null)
	{
		// prepare the selection
		if (func_num_args())
		{
			if (is_array($selection))
			{
				$filter = array();

				foreach ($this->container as $file)
				{
					$match = true;
					foreach($selection as $item => $value)
					{
						if ($value != $file->{$item})
						{
							$match = false;
							break;
						}
					}

					$match and $filter[] = $file;
				}

				$selection = $filter;
			}
			else
			{
				$selection =  array($this[$selection]);
			}
		}
		else
		{
			$selection = $this->container;
		}

		// loop through all selected files
		foreach ($selection as $file)
		{
			$file->validate();
		}
	}

	/**
	 * Return a consolidated status of all uploaded files
	 *
	 * @return bool
	 */
	public function isValid()
	{
		// loop through all files
		foreach ($this->container as $file)
		{
			// return false at the first non-valid file
			if ( ! $file->isValid())
			{
				return false;
			}
		}

		// only return true if there are uploaded files, and they are all valid
		return empty($this->container) ? false : true;
	}

	/**
	 * Return the list of uploaded files
	 *
	 * @param  int|string  $index  Optional array index or element name
	 *
	 * @return File[]
	 */
	public function getAllFiles($index = null)
	{
		// return the selection
		$selection = (func_num_args() and ! is_null($index)) ? $this[$index] : $this->container;

		// make sure selection is an array
		is_array($selection) or $selection = array($selection);

		return $selection;
	}

	/**
	 * Return the list of uploaded files that valid
	 *
	 * @param  int|string  $index  Optional array index or element name
	 *
	 * @return File[]
	 */
	public function getValidFiles($index = null)
	{
		// prepare the selection
		if (is_numeric($index))
		{
			$selection = $this->container;
		}
		else
		{
			$selection = (func_num_args() and ! is_null($index)) ? $this[$index] : $this->container;
		}

		// make sure selection is an array
		is_array($selection) or $selection = array($selection);

		// storage for the results
		$results = array();

		// loop through all files
		foreach ($selection as $file)
		{
			// store only files that are valid
			$file->isValid() and $results[] = $file;
		}

		// return the results
		if (is_numeric($index))
		{
			// a specific valid file was requested
			return isset($results[$index]) ? array($results[$index]) : array();
		}
		else
		{
			return $results;
		}
	}

	/**
	 * Return the list of uploaded files that invalid
	 *
	 * @param  int|string  $index  Optional array index or element name
	 *
	 * @return File[]
	 */
	public function getInvalidFiles($index = null)
	{
		// prepare the selection
		if (is_numeric($index))
		{
			$selection = $this->container;
		}
		else
		{
			$selection = (func_num_args() and ! is_null($index)) ? $this[$index] : $this->container;
		}

		// make sure selection is an array
		is_array($selection) or $selection = array($selection);

		// storage for the results
		$results = array();

		// loop through all files
		foreach ($selection as $file)
		{
			// store only files that are invalid
			$file->isValid() or $results[] = $file;
		}

		// return the results
		if (is_numeric($index))
		{
			// a specific valid file was requested
			return isset($results[$index]) ? array($results[$index]) : array();
		}
		else
		{
			return $results;
		}
	}

	/**
	 * Registers a Callback for a given event
	 *
	 * @param  string  $event  The type of the event
	 * @param  mixed   $callback  Any valid callback, must accept a File object
	 *
	 * @throws \InvalidArgumentException Not valid event or not callable second parameter
	 * @return  void
	 */
	public function register($event, $callback)
	{
		// check if this is a valid event type
		if ( ! isset($this->callbacks[$event]))
		{
			throw new \InvalidArgumentException($event.' is not a valid event');
		}

		// check if the callback is acually callable
		if ( ! is_callable($callback))
		{
			throw new \InvalidArgumentException('Callback passed is not callable');
		}

		// store it
		$this->callbacks[$event][] = $callback;
	}

	/**
	 * Set the configuration for this file
	 *
	 * @param  string|array  $item  name of the configuration item to set, or an array of configuration items
	 * @param  mixed  $value  if $name is an item name, this holds the configuration values for that item
	 *
	 * @return  void
	 */
	public function setConfig($item, $value = null)
	{
		// unify the parameters
		is_array($item) or $item = array($item => $value);

		// update the configuration
		foreach ($item as $name => $value)
		{
			// is this a valid config item? then update the defaults
			array_key_exists($name, $this->defaults) and $this->defaults[$name] = $value;
		}

		// and push it to all file objects in the containers
		foreach ($this->container as $file)
		{
			$file->setConfig($item);
		}
	}

	/**
	 * Process the data in the $_FILES array, unify it, and create File objects for them
	 *
	 * @param  mixed  $selection  Array of fieldnames to process, or null for all uploaded files
	 *
	 * @return void
	 */
	public function processFiles(array $selection = null)
	{
		// normalize the multidimensional fields in the $_FILES array
		foreach($_FILES as $name => $file)
		{
			// was it defined as an array?
			if (is_array($file['name']))
			{
				$data = $this->unifyFile($name, $file);

				foreach ($data as $entry)
				{
					if ($selection === null or in_array($entry['element'], $selection))
					{
						$this->addFile($entry);
					}
				}
    		}
			else
			{
				// normal form element, just create a File object for this uploaded file
				if ($selection === null or in_array($name, $selection))
				{
					$this->addFile(array_merge(array('element' => $name, 'filename' => null), $file));
				}
			}
		}
	}

	/**
	 * Convert the silly different $_FILE structures to a flattened array
	 *
	 * @param  string  $name  key name of the file
	 * @param  array   $file  $_FILE array structure
	 *
	 * @return  array  unified array file uploaded files
	 */
	protected function unifyFile($name, $file)
	{
		// storage for results
		$data = array();

		// loop over the file array
		foreach ($file['name'] as $key => $value)
		{
			// we're not an the end of the element name nesting yet
			if (is_array($value))
			{
				// recurse with the array data we have at this point
				$data = array_merge(
					$data,
					$this->unifyFile($name.'.'.$key,
						array(
							'filename' => null,
							'name'     => $file['name'][$key],
							'type'     => $file['type'][$key],
							'tmp_name' => $file['tmp_name'][$key],
							'error'    => $file['error'][$key],
							'size'     => $file['size'][$key],
						)
					)
				);
			}
			else
			{
				$data[] = array(
					'filename' => null,
					'element'  => $name.'.'.$key,
					'name'     => $file['name'][$key],
					'type'     => $file['type'][$key],
					'tmp_name' => $file['tmp_name'][$key],
					'error'    => $file['error'][$key],
					'size'     => $file['size'][$key],
				);
			}
		}

		return $data;
	}

	/**
	 * Add a new uploaded file structure to the container
	 *
	 * @param  array  $entry  uploaded file structure
	 */
	protected function addFile(array $entry)
	{
		// add the new file object to the container
		$this->container[] = new File($entry, $this->callbacks);

		// and load it with a default config
		end($this->container)->setConfig($this->defaults);
	}

	//------------------------------------------------------------------------------------------------------------------

	/**
	 * Countable methods
	 */
	public function count()
	{
		return count($this->container);
	}

	/**
	 * ArrayAccess methods
	 */
	public function offsetExists($offset)
	{
		return isset($this->container[$offset]);
	}

	public function offsetGet($offset)
	{
		// if the requested key is alphanumeric, do a search on element name
		if (is_string($offset))
		{
			// if it's in form notation, convert it to dot notation
			$offset = str_replace(array('][', '[', ']'), array('.', '.', ''), $offset);

			// see if we can find this element or elements
			$found = array();
			foreach($this->container as $key => $file)
			{
				if (strpos($file->element, $offset) === 0)
				{
					$found[] = $this->container[$key];
				}
			}

			if ( ! empty($found))
			{
				return $found;
			}
		}

		// else check on numeric offset
		elseif (isset($this->container[$offset]))
		{
			return $this->container[$offset];
		}

		// not found
		return null;
	}

	public function offsetSet($offset, $value)
	{
		throw new \OutOfBoundsException('An Upload Files instance is read-only, its contents can not be altered');
	}

	public function offsetUnset($offset)
	{
		throw new \OutOfBoundsException('An Upload Files instance is read-only, its contents can not be altered');
	}

	/**
	 * Iterator methods
	 */
	public function rewind()
	{
		$this->index = 0;
	}

	public function current()
	{
		return $this->container[$this->index];
	}

	public function key()
	{
		return $this->index;
	}

	public function next()
	{
		++$this->index;
	}

	public function valid()
	{
		return isset($this->container[$this->index]);
	}
}
