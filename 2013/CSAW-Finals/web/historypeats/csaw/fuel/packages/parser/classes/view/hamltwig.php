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

namespace Parser;

use Twig_Autoloader;
use Twig_Environment;
use Twig_Loader_Filesystem;
use Twig_Lexer;
use MtHaml;

class View_HamlTwig extends View_Twig {

	protected static $_environment;

	/**
	 * @access public
	 * @static
	 * @return void
	 */
	public static function _init()
	{
		// Include View_HamlTwig file(s) defined in config.
		$includes = \Config::get('parser.View_Twig.include');

		foreach ((array)$includes as $include)
		{
			require $include;
			static::$loaded_files[$include] = true;
		}

		parent::_init();

		MtHaml\Autoloader::register();

	}

	/**
	 * We Override the parser Loader here
	 *
	 * @access protected
	 * @static
	 */
	protected function process_file($file_override = false)
	{
		$file = $file_override ?: $this->file_name;

		$local_data  = $this->get_data('local');
		$global_data = $this->get_data('global');

		// Extract View name/extension (ex. "template.twig")
		$view_name = pathinfo($file, PATHINFO_BASENAME);

		// Twig Loader
		$views_paths = \Config::get('parser.View_Twig.views_paths', array(APPPATH . 'views'));
		array_unshift($views_paths, pathinfo($file, PATHINFO_DIRNAME));

		if ( ! empty($global_data))
		{
			foreach ($global_data as $key => $value)
			{
				static::parser()->addGlobal($key, $value);
			}
		}
		else
		{
			// Init the parser if you have no global data
			static::parser();
		}

		// Set the HtHaml Twig loader
		$filesyst = new Twig_Loader_Filesystem($views_paths);
		static::$_parser_loader = new MtHaml\Support\Twig\Loader(static::$_environment, $filesyst);

		$twig_lexer = new Twig_Lexer(static::$_parser, static::$_twig_lexer_conf);
		static::$_parser->setLexer($twig_lexer);
		//\Debug::dump(static::parser()); exit();
		try
		{
			return static::parser()->render($view_name, $local_data);
		}
		catch (\Exception $e)
		{
			// Delete the output buffer & re-throw the exception
			ob_end_clean();
			throw $e;
		}
	}

	/**
	 * @access public
	 * @static
	 * @return Twig_Environment
	 */
	public static function parser()
	{
		if (empty(static::$_parser))
		{
			parent::parser();

			// Register Haml twig supports
			static::$_parser->addExtension(new MtHaml\Support\Twig\Extension());
				// Store MtHaml environment
			static::$_environment	= new MtHaml\Environment('twig', \Config::get('parser.View_HamlTwig.environment'));

			return static::$_parser;
		}
		return parent::parser();
	}
}

// end of file hamltwig.php
