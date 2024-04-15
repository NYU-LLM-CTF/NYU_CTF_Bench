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

class Auth_Opauth
{
	/**
	 * @var  string  name of the providers table
	 */
	protected static $provider_table = null;

	/**
	 * Class initialisation
	 */
	public static function _init()
	{
		// just checkin', do we have Opauth installed?
		if ( ! class_exists('Opauth'))
		{
			throw new \OpauthException('Opauth composer package not installed. Add "opauth/opauth" to composer.json and run a composer update.');
		}

		// load the auth and opauth config
		\Config::load('auth', true);
		\Config::load('opauth', true);

		// determine the auth driver we're going to use
		$drivers = \Config::get('auth.driver', array());
		is_array($drivers) or $drivers = array($drivers);

		if (in_array('Simpleauth', $drivers))
		{
			// get the tablename
			\Config::load('simpleauth', true);
			static::$provider_table = \Config::get('simpleauth.table_name', 'users').'_providers';
		}

		elseif (in_array('Ormauth', $drivers))
		{
			// get the tablename
			\Config::load('ormauth', true);
			static::$provider_table = \Config::get('ormauth.table_name', 'users').'_providers';
		}
	}

	/**
	 * Create an OpAuth instance
	 *
	 * @param  array any call-time configuration to be used
	 * @param  bool  whether or not Opauth should run automatically
	 */
	public static function forge($config = array(), $autorun = true)
	{
		// deal with passing only the autorun value
		if (func_num_args() == 1 and is_bool($config))
		{
			$autorun = $config;
			$config = array();
		}

		// merge the default config with the runtime config
		$config = \Arr::merge(\Config::get('opauth'), $config);

		// define the transport system we use
		$config['callback_transport'] = 'get';

		// make sure we have a remotes table
		if ( ! isset($config['table']) and ($config['table'] = static::$provider_table) === null)
		{
			throw new \OpauthException('No providers table configured. At the moment, only SimpleAuth and OrmAuth can be auto-detected.');
		}

		// and a security salt
		if (empty($config['security_salt']))
		{
			throw new \OpauthException('There is no "security_salt" defined in the opauth.php configuration file.');
		}

		// set some defaults, just in case
		isset($config['security_iteration']) or $config['security_iteration'] = 300;
		isset($config['security_timeout']) or $config['security_timeout'] = '2 minutes';

		if (empty($config['path']))
		{
			$parsed_url = parse_url(\Uri::base().\Request::main()->uri->get());
			$path = explode('/', trim($parsed_url['path'], '/'));

			// construct the path if needed
//			$path = \Request::main()->uri->get_segments();
			$params = count(\Request::active()->route->method_params);

			while ($params-- > 0)
			{
				array_pop($path);
			}
			$config['path'] = '/'.(implode('/', $path)).'/';
		}

		// and construct the callback URL if needed
		if (empty($config['callback_url']))
		{
			// pop the method name from the path
			$path = explode('/', trim($config['path'], '/'));
			array_pop($path);

			// and add 'callback' as the controller callback action
			$config['callback_url'] = '/'.implode('/', $path).'/callback/';
		}

		// determine the name of the provider we want to call
		if ( ! $autorun)
		{
			// we're processing a callback
			$config['provider'] = 'Callback';
		}
		else
		{
			if (empty($config['provider']))
			{
				$parsed_url = parse_url(\Uri::base().\Request::main()->uri->get());
				$provider = explode('/', substr($parsed_url['path'], strlen($config['path'])));
				$config['provider'] = ucfirst($provider[0]);
			}

			// check if we have a strategy defined for this provider
			$strategies = \Config::get('opauth.Strategy', array());
			if ( ! array_key_exists(strtolower($config['provider']), array_change_key_case($strategies)))
			{
				throw new \OpauthException('Opauth strategy "'.$config['provider'].'" is not supported');
			}
		}

		// return the created Auth_Opauth object
		return new static($config, $autorun);
	}

	// -------------------------------------------------------------------------

	/**
	 * Opauth configuration
	 */
	protected $config = array();

	/**
	 * Opauth instance
	 */
	protected $opauth = null;

	/**
	 * Opauth response
	 */
	protected $response = array();

	/**
	 * Construct the Auth_Opauth object
	 */
	public function __construct(Array $config, $autorun = true)
	{
		// store the config
		$this->config = $config;

		// construct the Opauth object
		$this->opauth = new \Opauth($config, $autorun);
	}

	/**
	 * New Opauth login. If we know this user, we can perform a login, if
	 * not, we need to register the user first
	 */
	public function login_or_register()
	{
		// process the callback data
		$this->callback();

		// if there is no UID we don't know who this is
		if ($this->get('auth.uid', null) === null)
		{
			throw new \OpauthException('No uid in response from the provider, so we have no idea who you are.');
		}

		// we have a UID and logged in? Just attach this authentication to a user
		if (\Auth::check())
		{
			list(, $user_id) = \Auth::instance()->get_user_id();

			$result = \DB::select(\DB::expr('COUNT(*) as count'))->from($this->config['table'])->where('parent_id', '=', $user_id)->execute();
			$num_linked = ($result and $result = $result->current()) ? $result['count'] : 0;

			// allowed multiple providers, or not authed yet?
			if ($num_linked === 0 or \Config::get('opauth.link_multiple_providers') === true)
			{
				// attach this account to the logged in user
				$this->link_provider(array(
					'parent_id'		=> $user_id,
					'provider' 		=> $this->get('auth.provider'),
					'uid' 			=> $this->get('auth.uid'),
					'access_token' 	=> $this->get('auth.credentials.token', null),
					'secret' 		=> $this->get('auth.credentials.secret', null),
					'expires' 		=> $this->get('auth.credentials.expires', null),
					'refresh_token' => $this->get('auth.credentials.refresh_token', null),
					'created_at' 	=> time(),
				));

				// attachment went ok so we'll redirect
				return 'linked';
			}

			else
			{
				$result = \DB::select()->from($this->config['table'])->where('parent_id', '=', $user_id)->limit(1)->as_object()->execute();
				$auth = $result ? $result->current() : null;
				throw new \OpauthException(sprintf('This user is already linked to "%s" and can\'t be linked to another provider.', $auth->provider));
			}
		}

		// the user exists, so send him on his merry way as a user
		elseif ($authentication = \DB::select()->from($this->config['table'])->where('uid', '=', $this->get('auth.uid'))->where('provider', '=', $this->get('auth.provider'))->as_object()->execute() and $authentication->count())
		{
			// force a login with this username
			$authentication = $authentication->current();
			if (\Auth::instance()->force_login((int) $authentication->parent_id))
			{
			    // credentials ok, go right in
			    return 'logged_in';
			}

			throw new \OpauthException('This user could not be logged in.');
		}

		// not an existing user of any type, so we need to create a user somehow
		else
		{
			// generate a dummy password if we don't have one, and want auto registration for this user
			if ($this->config['auto_registration'])
			{
				$this->get('auth.info.password') or $this->response['auth']['info']['password'] = \Str::random('sha1');
			}

			// did the provider return enough information to log the user in?
			if ($this->get('auth.info.nickname') and $this->get('auth.info.email') and $this->get('auth.info.password'))
			{
				// make a user with what we have
				$user_id = $this->create_user($this->response['auth']['info']);

				// attach this authentication to the new user
				$insert_id = $this->link_provider(array(
					'parent_id'		=> $user_id,
					'provider' 		=> $this->get('auth.provider'),
					'uid' 			=> $this->get('auth.uid'),
					'access_token' 	=> $this->get('auth.credentials.token', null),
					'secret' 		=> $this->get('auth.credentials.secret', null),
					'expires' 		=> $this->get('auth.credentials.expires', null),
					'refresh_token' => $this->get('auth.credentials.refresh_token', null),
					'created_at' 	=> time(),
				));

				// force a login with this users id
				if ($insert_id and \Auth::instance()->force_login((int) $user_id))
				{
				    // credentials ok, go right in
				    return 'registered';
				}

				throw new \OpauthException('We tried automatically creating a user but that just really did not work. Not sure why...');
			}

			// they aren't a user and cant be automatically registerd, so redirect to registration page
			else
			{
				\Session::set('auth-strategy', array(
					'user' => $this->get('auth.info'),
					'authentication' => array(
						'provider' 		=> $this->get('auth.provider'),
						'uid' 			=> $this->get('auth.uid'),
						'access_token' 	=> $this->get('auth.credentials.token', null),
						'secret' 		=> $this->get('auth.credentials.secret', null),
						'expires' 		=> $this->get('auth.credentials.expires', null),
						'refresh_token' => $this->get('auth.credentials.refresh_token', null),
					),
				));

				return 'register';
			}
		}
	}

	/**
	 * create a remote entry for this login
	 */
	public function link_provider(array $data)
	{
		// do some validation
		if ( ! is_numeric($data['expires']))
		{
			if ($date = \DateTime::createFromFormat(\DateTime::ISO8601, $data['expires']))
			{
				$data['expires'] = $date->getTimestamp();
			}
			elseif ($date = \DateTime::createFromFormat('Y-m-d H:i:s', $data['expires']))
			{
				$data['expires'] = $date->getTimestamp();
			}
			else
			{
				$data['expires'] = time();
			}
		}

		// get rid of old registrations to prevent duplicates
		\DB::delete($this->config['table'])->where('uid', '=', $data['uid'])->where('provider', '=', $data['provider'])->execute();

		// insert the new provider UID
		list($insert_id, $rows_affected) = \DB::insert($this->config['table'])->set($data)->execute();
		return $rows_affected ? $insert_id : false;
	}

	/**
	 * Get a response value
	 */
	public function get($key, $default = null)
	{
		return is_array($this->response) ? \Arr::get($this->response, $key, $default) : $default;
	}

	/**
	 * fetch the callback response
	 */
	protected function callback()
	{
		// fetch the response and decode it
		$this->response = \Input::get('opauth', false) and $this->response = unserialize(base64_decode($this->response));

		// did we receive a response at all?
		if ( ! $this->response)
		{
			throw new \OpauthException('no valid response received in the callback');
		}

		// did we receive one, but was it an error
		if (array_key_exists('error', $this->response))
		{
			throw new \OpauthException('Authentication error: the callback returned an error auth response');
		}

		// validate the response
		if ($this->get('auth') === null or $this->get('timestamp') === null or
			$this->get('signature') === null or $this->get('auth.provider') === null or $this->get('auth.uid') === null)
		{
			throw new \OpauthException('Invalid auth response: Missing key auth response components');
		}
		elseif ( ! $this->opauth->validate(sha1(print_r($this->get('auth'), true)), $this->get('timestamp'), $this->get('signature'), $reason))
		{
			throw new \OpauthException('Invalid auth response: '.$reason);
		}
	}

	/**
	 * use Auth to create a new user, in case we've received enough information to do so
	 *
	 * @param  array  array with the raw Opauth response user fields
	 *
	 * @return  mixed  id of the user record created, or false if the create failed
	 */
	protected function create_user(array $user)
	{
		$user_id = \Auth::create_user(

			// username
			isset($user['nickname']) ? $user['nickname'] : null,

			// password (random string will do if none provided)
			isset($user['password']) ? $user['password'] : \Str::random(),

			// email address
			isset($user['email']) ? $user['email'] : null,

			// which group are they in?
			\Config::get('opauth.default_group', -1),

			// extra information
			array(

				// got their name? full name? or first and last to make up a full name?
				'fullname' => isset($user['name']) ? $user['name'] : (
					isset($user['full_name']) ? $user['full_name'] : (
						isset($user['first_name'], $user['last_name']) ? $user['first_name'].' '.$user['last_name'] : null
					)
				),
			)
		);

		return $user_id ?: false;
	}

}
