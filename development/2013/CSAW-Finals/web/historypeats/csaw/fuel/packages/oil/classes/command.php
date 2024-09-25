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
 * Oil\Cli Class
 *
 * @package		Fuel
 * @subpackage	Oil
 * @category	Core
 */
class Command
{
	public static function init($args)
	{
		\Config::load('oil', true);

		// Remove flag options from the main argument list
		$args = self::_clear_args($args);

		try
		{
			if ( ! isset($args[1]))
			{
				if (\Cli::option('v', \Cli::option('version')))
				{
					\Cli::write('Fuel: '.\Fuel::VERSION.' running in "'.\Fuel::$env.'" mode');
					return;
				}

				static::help();
				return;
			}

			switch ($args[1])
			{
				case 'g':
				case 'generate':

					$action = isset($args[2]) ? $args[2]: 'help';

					$subfolder = 'orm';
					if (is_int(strpos($action, '/')))
					{
						list($action, $subfolder)=explode('/', $action);
					}

					switch ($action)
					{
						case 'config':
						case 'controller':
						case 'model':
						case 'migration':
						case 'task':
						case 'package':
							call_user_func('Oil\Generate::'.$action, array_slice($args, 3));
						break;

						case 'views':
							call_user_func('Oil\Generate::views', array_slice($args, 3), $subfolder);
						break;

						case 'admin':
							call_user_func('Oil\Generate_Admin::forge', array_slice($args, 3), $subfolder);
						break;

						case 'scaffold':
							call_user_func('Oil\Generate_Scaffold::forge', array_slice($args, 3), $subfolder);
						break;

						default:
							Generate::help();
					}

				break;

				case 'c':
				case 'console':

					if (isset($args[2]) and $args[2] == 'help')
					{
						Console::help();
					}
					else
					{
						new Console;
					}

				break;

				case 'p':
				case 'package':

					$action = isset($args[2]) ? $args[2]: 'help';

					switch ($action)
					{
						case 'install':
						case 'uninstall':
							call_fuel_func_array('Oil\Package::'.$action, array_slice($args, 3));
						break;

						default:
							Package::help();
					}

				break;

				case 'r':
				case 'refine':

					$task = isset($args[2]) ? $args[2] : null;
					call_user_func('Oil\Refine::run', $task, array_slice($args, 3));

				break;

				case 'cell':
				case 'cells':

					$action = isset($args[2]) ? $args[2]: 'help';

					switch ($action)
					{
						case 'list':
							call_user_func('Oil\Cell::all');
						break;

						case 'search':
						case 'install':
						case 'upgrade':
						case 'uninstall':
							call_fuel_func_array('Oil\Cell::'.$action, array_slice($args, 3));
						break;

						case 'info':
						case 'details':
							call_fuel_func_array('Oil\Cell::info', array_slice($args, 3));
						break;

						default:
							Cell::help();
					}

				break;

				case 't':
				case 'test':

					if (isset($args[2]) and $args[2] == 'help')
					{
		$output = <<<HELP

Usage:
  php oil [t|test]

Runtime options:
  --file=<file>              # Run a test on a specific file only.
  --group=<group>            # Only runs tests from the specified group(s).
  --exclude-group=<group>    # Exclude tests from the specified group(s).
  --coverage-clover=<file>   # Generate code coverage report in Clover XML format.
  --coverage-html=<dir>      # Generate code coverage report in HTML format.
  --coverage-php=<file>      # Serialize PHP_CodeCoverage object to file.
  --coverage-text=<file>     # Generate code coverage report in text format.
  --log-junit=<file>         # Generate report of test execution in JUnit XML format to file.

Description:
  Run phpunit on all or a subset of tests defined for the current application.

Examples:
  php oil test

Documentation:
  http://fuelphp.com/docs/packages/oil/test.html
HELP;
		\Cli::write($output);
					}
					else
					{
						$phpunit_command = \Config::get('oil.phpunit.binary_path', 'phpunit');

						// Check if we might be using the phar library
						$is_phar = false;
						foreach(explode(':', getenv('PATH')) as $path)
						{
							if (is_file($path.DS.$phpunit_command))
							{
								$handle = fopen($path.DS.$phpunit_command, 'r');
								$is_phar = fread($handle, 18) == '#!/usr/bin/env php';
								fclose($handle);
								if ($is_phar)
								{
									break;
								}
							}
						}

						// Suppressing this because if the file does not exist... well thats a bad thing and we can't really check
						// I know that supressing errors is bad, but if you're going to complain: shut up. - Phil
						$phpunit_autoload_path = \Config::get('oil.phpunit.autoload_path', 'PHPUnit/Autoload.php' );
						@include_once($phpunit_autoload_path);

						// Attempt to load PHUnit.  If it fails, we are done.
						if ( ! $is_phar and ! class_exists('PHPUnit_Framework_TestCase'))
						{
							throw new Exception('PHPUnit does not appear to be installed.'.PHP_EOL.PHP_EOL."\tPlease visit http://phpunit.de and install.");
						}

						// Check for a custom phpunit config, but default to the one from core
						if (is_file(APPPATH.'phpunit.xml'))
						{
							$phpunit_config = APPPATH.'phpunit.xml';
						}
						else
						{
							$phpunit_config = COREPATH.'phpunit.xml';
						}

						// CD to the root of Fuel and call up phpunit with the path to our config
						$command = 'cd '.DOCROOT.'; '.$phpunit_command.' -c "'.$phpunit_config.'"';

						// Respect the group options
						\Cli::option('group') and $command .= ' --group '.\Cli::option('group');
						\Cli::option('exclude-group') and $command .= ' --exclude-group '.\Cli::option('exclude-group');

						// Respect the coverage-html option
						\Cli::option('coverage-html') and $command .= ' --coverage-html '.\Cli::option('coverage-html');
						\Cli::option('coverage-clover') and $command .= ' --coverage-clover '.\Cli::option('coverage-clover');
						\Cli::option('coverage-text') and $command .= ' --coverage-text='.\Cli::option('coverage-text');
						\Cli::option('coverage-php') and $command .= ' --coverage-php '.\Cli::option('coverage-php');
						\Cli::option('log-junit') and $command .= ' --log-junit '.\Cli::option('log-junit');
						\Cli::option('file') and $command .= ' '.\Cli::option('file');

						\Cli::write('Tests Running...This may take a few moments.', 'green');

						$return_code = 0;
						foreach(explode(';', $command) as $c)
						{
							passthru($c, $return_code_task);
							// Return failure if any subtask fails
							$return_code |= $return_code_task;
						}
						exit($return_code);
					}

				break;

				case 's':
				case 'server':

					if (version_compare(PHP_VERSION, '5.4.0') < 0)
					{
						\Cli::write('The PHP built-in webserver is only available on PHP 5.4+', 'red');
						break;
					}

					$php = \Cli::option('php', 'php');
					$port = \Cli::option('p', \Cli::option('port', '8000'));
					$host = \Cli::option('h', \Cli::option('host', 'localhost'));
					$docroot = \Cli::option('d', \Cli::option('docroot', 'public/'));
					$router = \Cli::option('r', \Cli::option('router', __DIR__.DS.'..'.DS.'phpserver.php'));

					\Cli::write("Listening on http://$host:$port");
					\Cli::write("Document root is $docroot");
					\Cli::write("Press Ctrl-C to quit.");
					passthru("$php -S $host:$port -t $docroot $router");
				break;

				case 'create':
					\Cli::write('You can not use "oil create", a valid FuelPHP installation already exists in this directory', 'red');
					break;

				default:

					static::help();
			}
		}

		catch (\Exception $e)
		{
			static::print_exception($e);
			exit(1);
		}
	}

	private static function print_exception(\Exception $ex)
	{
		\Cli::error('Uncaught exception '.get_class($ex).': '.$ex->getMessage());
		\Cli::error('Callstack: ');
		\Cli::error($ex->getTraceAsString());
		\Cli::beep();

		\Cli::option('speak') and `say --voice="Trinoids" "{$ex->getMessage()}"`;

		if (($previous = $ex->getPrevious()) != null)
		{
			\Cli::error('');
			\Cli::error('Previous exception: ');
			static::print_exception($previous);
		}
	}

	public static function help()
	{
		echo <<<HELP

Usage:
  php oil [cell|console|generate|package|refine|help|server|test]

Runtime options:
  -f, [--force]    # Overwrite files that already exist
  -s, [--skip]     # Skip files that already exist
  -q, [--quiet]    # Supress status output
  -t, [--speak]    # Speak errors in a robot voice

Description:
  The 'oil' command can be used in several ways to facilitate quick development, help with
  testing your application and for running Tasks.

Environment:
  If you want to specify a specific environment oil has to run in, overload the environment
  variable on the commandline: FUEL_ENV=staging php oil <commands>

More information:
  You can pass the parameter "help" to each of the defined command to get information
  about that specific command: php oil package help

Documentation:
  http://docs.fuelphp.com/packages/oil/intro.html

HELP;

	}

	private static function _clear_args($actions = array())
	{
		foreach ($actions as $key => $action)
		{
			if (substr($action, 0, 1) === '-')
			{
				unset($actions[$key]);
			}

			// get rid of any junk added by Powershell on Windows...
			isset($actions[$key]) and $actions[$key] = trim($actions[$key]);
		}

		return $actions;
	}
}

/* End of file oil/classes/command.php */
