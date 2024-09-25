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

namespace Oil;

/**
 * Oil\Package Class
 *
 * @package		Fuel
 * @subpackage	Oil
 * @category	Core
 * @author		Phil Sturgeon
 */
class Cell
{
	protected static $_protected = array('auth', 'email', 'oil', 'orm', 'parser');
	protected static $_api_url = 'http://cells.fuelphp.com/api/';

	protected static $_git_binary = 'git';
	protected static $_hg_binary = 'hg';

	public static function install($package = null)
	{
		// Make sure something is set
		if ($package === null)
		{
			static::help();
			return;
		}

		$version = \Cli::option('version', 'master');

		// Check to see if this package is already installed
		if (is_dir(PKGPATH . $package))
		{
			throw new \FuelException('Package "' . $package . '" is already installed.');
			return;
		}

		$request_url = static::$_api_url.'cells/show.json?name='.urlencode($package);
		$response = json_decode(@file_get_contents($request_url), true);

		if ( ! $response)
		{
			throw new \FuelException('No response from the API. Perhaps check your internet connection?');
		}

		if (empty($response['cell']))
		{
			throw new \FuelException('Could not find the cell "' . $package . '".');
		}

		$cell = $response['cell'];

		// Now, lets get this package

		// If it is git and (they have git installed (TODO) and they havent asked for a zip)
		if ($cell['repository_type'] == 'git' and ! \Cli::option('via-zip'))
		{
			\Cli::write('Downloading package: ' . $package);
			static::_clone_package_repo($cell['repository_url'], $package, $version);
		}

		// Fallback to shoving a ZIP file in place
		else
		{
			\Cli::write('Downloading package: ' . $package);
			static::_download_package_zip($zip_url, $package, $version);
		}
	}

	public static function all()
	{
		$request_url = static::$_api_url.'cells/list.json';
		$response = json_decode(@file_get_contents($request_url), true);

		if (empty($response['cells']))
		{
			throw new \FuelException('No cells were found with this name.');
		}

		foreach ($response['cells'] as $cell)
		{
			\Cli::write(\Cli::color($cell['name'], 'yellow').' '.\Cli::color($cell['current_version'], 'white').' - '.$cell['summary']);
		}
	}

	public static function search($name)
	{
		$request_url = static::$_api_url.'cells/search.json?name='.urlencode($name);
		$response = json_decode(file_get_contents($request_url), true);

		if (empty($response['cells']))
		{
			throw new \FuelException('No cells were found with this name.');
		}

		foreach ($response['cells'] as $cell)
		{
			\Cli::write(\Cli::color($cell['name'], 'yellow').' '.\Cli::color($cell['current_version'], 'white').' - '.$cell['summary']);
		}
	}


	public static function uninstall($package)
	{
		// Check to see if this package is already installed
		if ( ! $package_folder = \Package::exists($package))
		{
			throw new \FuelException('Package "' . $package . '" is not installed.');
			return false;
		}

		// Check to see if this package is already installed
		if (in_array($package, static::$_protected))
		{
			throw new \FuelException('Package "' . $package . '" cannot be uninstalled.');
			return false;
		}

		\Cli::write('Package "' . $package . '" was uninstalled.', 'yellow');

		\File::delete_dir($package_folder);
	}

	public static function info($cell = null)
	{
		// Make sure something is set
		if ($cell === null)
		{
			static::help();
			return;
		}

		$request_url = static::$_api_url.'cells/show.json?name='.urlencode($cell);
		$response = json_decode(@file_get_contents($request_url), true);

		if ( ! $response)
		{
			throw new \FuelException('No response from the API. Perhaps check your internet connection?');
		}

		else if (empty($response['cell']))
		{
			throw new \FuelException('Could not find the cell "' . $cell . '".');
		}

		var_dump($response);
	}

	public static function help()
	{
		$output = <<<HELP

Usage:
  oil cell <sub-command> <cell-name>

Description:
  Packages containing extra functionality can be downloaded (or git cloned) simply with
  the following commands.

Runtime options:
  --via-zip       # Download a ZIP file instead of using Git or Hg.

Examples:
  oil cell list
  oil cell search <keyword>
  oil cell show <cell-name>
  oil cell install <cell-name>
  oil cell uninstall <cell-name>

Documentation:
  http://docs.fuelphp.com/packages/oil/cell.html
HELP;
		\Cli::write($output);

	}


	protected static function _use_git()
	{
		exec('which git', $output);

		// If this is a valid path to git, use it instead of just "git"
		if (file_exists($line = trim(current($output))))
		{
			static::$git = $line;
		}

		unset($output);

		// Double check git is installed (windows will fail step 1)
		exec(static::$git . ' --version', $output);

		preg_match('#^(git version)#', current($output), $matches);

		// If we have a match, use Git!
		return ! empty($matches[0]);
	}

	protected static function _download_package_zip($zip_url, $package, $version)
	{
		// get the list of configured package paths
		$paths = \Config::get('package_paths', array(PKGPATH));

		// and make sure we have at least one
		if (empty($paths))
		{
			throw new \FuelException('There are no package paths defined in your configuration file. Don\'t know where to install the package.');
		}

		// we'll install in the first path defined
		$package_folder = reset($paths);

		// Make the folder so we can extract the ZIP to it
		mkdir($tmp_folder = APPPATH . 'tmp' . DS . $package . '-' . time());

		$zip_file = $tmp_folder . '.zip';
		@copy($zip_url, $zip_file);

		$unzip = new \Unzip;
		$files = $unzip->extract($zip_file, $tmp_folder);

		// Grab the first folder out of it (we dont know what it's called)
		foreach($pkgfolders = new \GlobIterator($tmp_folder.DS.'*') as $pkgfolder)
		{
			if ($pkgfolder->isDir())
			{
				$tmp_package_folder = $tmp_folder.DS.$pkgfolder->getFilename();
				break;
			}
		}

		if (empty($tmp_package_folder))
		{
			throw new \FuelException('The package zip file doesn\'t contain any install directory.');
		}

		// Move that folder into the packages folder
		rename($tmp_package_folder, $package_folder);

		unlink($zip_file);
		rmdir($tmp_folder);

		foreach ($files as $file)
		{
			$path = str_replace($tmp_package_folder, $package_folder, $file);
			chmod($path, octdec(755));
			\Cli::write("\t" . $path);
		}
	}

	public static function _clone_package_repo($repo_url, $package, $version)
	{
		// get the list of configured package paths
		$paths = \Config::get('package_paths', array(PKGPATH));

		// and make sure we have at least one
		if (empty($paths))
		{
			throw new \FuelException('There are no package paths defined in your configuration file. Don\'t know where to install the package.');
		}

		// we'll install in the first path defined
		$package_folder = reset($paths);

		// Clone to the package path
		passthru(static::$_git_binary.' submodule add '.$repo_url.' '.$package_folder);
		passthru(static::$_git_binary.' submodule update');

		\Cli::write('');
	}
}
