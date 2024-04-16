<?php
/**
 * @package    Fuel\Upload
 * @version    2.0
 * @author     Fuel Development Team
 * @license    MIT License
 * @copyright  2010 - 2013 Fuel Development Team
 * @link       http://fuelphp.com
 */

namespace Fuel\Upload\Providers;

use Fuel\Upload\Upload;

use Fuel\Dependency\ServiceProvider;

/**
 * FuelPHP ServiceProvider class for this package
 *
 * @package  Fuel\Upload
 *
 * @since  1.0.0
 */
class FuelServiceProvider extends ServiceProvider
{
	/**
	 * @var  array  list of service names provided by this provider
	 */
	public $provides = array('upload');

	/**
	 * Service provider definitions
	 */
	public function provide()
	{
		// \Fuel\Upload\Upload
		$this->register('upload', function ($dic, Array $config = null)
		{
			return $dic->resolve('Fuel\Upload\Upload', array($config));
		});

	}
}
