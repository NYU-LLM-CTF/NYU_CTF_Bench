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

namespace Auth;

abstract class Auth_Login_Driver extends \Auth_Driver
{

	/**
	 * @var  Auth_Driver	default instance
	 */
	protected static $_instance = null;

	/**
	 * @var  Session_Cookie  session object for the remember-me feature
	 */
	protected static $remember_me = null;

	/**
	 * @var  array  contains references if multiple were loaded
	 */
	protected static $_instances = array();

	public static function forge(array $config = array())
	{
		// default driver id to driver name when not given
		! array_key_exists('id', $config) && $config['id'] = $config['driver'];

		$class = \Inflector::get_namespace($config['driver']).'Auth_Login_'.\Str::ucwords(\Inflector::denamespace($config['driver']));
		$driver = new $class($config);
		static::$_instances[$driver->get_id()] = $driver;
		is_null(static::$_instance) and static::$_instance = $driver;

		foreach ($driver->get_config('drivers', array()) as $type => $drivers)
		{
			foreach ($drivers as $d => $custom)
			{
				$custom = is_int($d)
					? array('driver' => $custom)
					: array_merge($custom, array('driver' => $d));
				$class = 'Auth_'.\Str::ucwords($type).'_Driver';
				$class::forge($custom);
			}
		}

		return $driver;
	}

	// ------------------------------------------------------------------------

	/**
	 * @var  array  config values
	 */
	protected $config = array();

	/**
	 * @var  object  PHPSecLib hash object
	 */
	private $hasher = null;

	/**
	 * Check for login
	 * (final method to (un)register verification, work is done by _check())
	 *
	 * @return  bool
	 */
	final public function check()
	{
		if ( ! $this->perform_check())
		{
			\Auth::_unregister_verified($this);
			return false;
		}

		\Auth::_register_verified($this);
		return true;
	}

	/**
	 * Return user info in an array, always includes email & screen_name
	 * Additional fields can be requested in the first param or set in config,
	 * all additional fields must have their own method "get_" + fieldname
	 *
	 * @param   array  additional fields
	 * @return  array
	 */
	final public function get_user_array(Array $additional_fields = array())
	{
		$user = array(
			'email'        => $this->get_email(),
			'screen_name'  => $this->get_screen_name(),
			'groups'       => $this->get_groups(),
		);

		$additional_fields = array_merge($this->config['additional_fields'], $additional_fields);
		foreach($additional_fields as $af)
		{
			// only works if it actually can be fetched through a get_ method
			if (is_callable(array($this, $method = 'get_'.$af)))
			{
				$user[$af] = $this->$method();
			}
		}
		return $user;
	}

	/**
	 * Verify Group membership
	 *
	 * @param   mixed   group identifier to check for membership
	 * @param   string  group driver id or null to check all
	 * @param   array   user identifier to check in form array(driver_id, user_id)
	 * @return  bool
	 */
	public function member($group, $driver = null, $user = null)
	{
		$user = $user ?: $this->get_user_id();

		if ($driver === null)
		{
			foreach (\Auth::group(true) as $g)
			{
				if ($g->member($group, $user))
				{
					return true;
				}
			}

			return false;
		}

		return \Auth::group($driver)->member($group, $user);
	}

	/**
	 * Verify Acl access
	 *
	 * @param   mixed   condition to validate
	 * @param   string  acl driver id or null to check all
	 * @param   array   user identifier to check in form array(driver_id, user_id)
	 * @return  bool
	 */
	public function has_access($condition, $driver = null, $entity = null)
	{
		$entity = $entity ?: $this->get_user_id();

		if ($driver === null)
		{
			foreach (\Auth::acl(true) as $acl)
			{
				if ($acl->has_access($condition, $entity))
				{
					return true;
				}
			}

			return false;
		}

		return \Auth::acl($driver)->has_access($condition, $entity);
	}

	/**
	 * Default password hash method
	 *
	 * @param   string
	 * @return  string
	 */
	public function hash_password($password)
	{
		return base64_encode($this->hasher()->pbkdf2($password, \Config::get('auth.salt'), \Config::get('auth.iterations', 10000), 32));
	}

	/**
	 * Returns the hash object and creates it if necessary
	 *
	 * @return  PHPSecLib\Crypt_Hash
	 */
	public function hasher()
	{
		is_null($this->hasher) and $this->hasher = new \PHPSecLib\Crypt_Hash();

		return $this->hasher;
	}

	/**
	 * Returns the list of defined groups
	 *
	 * @return  array
	 */
	public function groups($driver = null)
	{
		$result = array();

		if ($driver === null)
		{
			foreach (\Auth::group(true) as $group)
			{
				method_exists($group, 'groups') and $result = \Arr::merge($result, $group->groups());
			}
		}
		else
		{
			$result = \Auth::group($driver)->groups();
		}

		return $result;
	}

	/**
	 * Returns the list of defined roles
	 *
	 * @return  array
	 */
	public function roles($driver = null)
	{
		$result = array();

		if ($driver === null)
		{
			foreach (\Auth::acl(true) as $acl)
			{
				method_exists($acl, 'roles') and $result = \Arr::merge($result, $acl->roles());
			}
		}
		else
		{
			$result = \Auth::acl($driver)->roles();
		}

		return $result;
	}

	// ------------------------------------------------------------------------

	/**
	 * Set a remember-me cookie for the passed user id, or for the current
	 * logged-in user if no id was given
	 *
	 * @return  bool  wether or not the cookie was set
	 */
	public function remember_me($user_id = null)
	{
		// if no user-id is given, get the current user's id
		if ($user_id === null and isset($this->user['id']))
		{
			$user_id = $this->user['id'];
		}

		// if we have a session and an id, set it
		if (static::$remember_me and $user_id)
		{
			static::$remember_me->set('user_id', $user_id);
			return true;
		}

		// remember-me not enabled, or no user id available
		return false;
	}

	/**
	 * Remove any remember-me cookie stored
	 */
	public function dont_remember_me()
	{
		static::$remember_me and static::$remember_me->destroy();
	}

	// ------------------------------------------------------------------------

	/**
	 * Perform the actual login check
	 *
	 * @return  bool
	 */
	abstract protected function perform_check();

	/**
	 * Perform the actual login check
	 *
	 * @return  bool
	 */
	abstract public function validate_user();

	/**
	 * Login method
	 *
	 * @return  bool  whether login succeeded
	 */
	abstract public function login();

	/**
	 * Logout method
	 */
	abstract public function logout();

	/**
	 * Get User Identifier of the current logged in user
	 * in the form: array(driver_id, user_id)
	 *
	 * @return  array
	 */
	abstract public function get_user_id();

	/**
	 * Get User Groups of the current logged in user
	 * in the form: array(array(driver_id, group_id), array(driver_id, group_id), etc)
	 *
	 * @return  array
	 */
	abstract public function get_groups();

	/**
	 * Get emailaddress of the current logged in user
	 *
	 * @return  string
	 */
	abstract public function get_email();

	/**
	 * Get screen name of the current logged in user
	 *
	 * @return  string
	 */
	abstract public function get_screen_name();
}

/* end of file driver.php */
