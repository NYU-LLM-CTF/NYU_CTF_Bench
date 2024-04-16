<?php
/**
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

/**
 * OrmAuth ORM driven group driver
 *
 * @package     Fuel
 * @subpackage  Auth
 */
class Auth_Group_Ormgroup extends \Auth_Group_Driver
{
	/*
	 * @var  array  list of valid groups
	 */
	protected static $_valid_groups = array();

	/*
	 * class init
	 */
	public static function _init()
	{
		// get the list of valid groups
		try
		{
			static::$_valid_groups = \Cache::get(\Config::get('ormauth.cache_prefix', 'auth').'.groups');
		}
		catch (\CacheNotFoundException $e)
		{
			static::$_valid_groups = \Model\Auth_Group::find('all');
			\Cache::set(\Config::get('ormauth.cache_prefix', 'auth').'.groups', static::$_valid_groups);
		}
	}

	/*
	 * additional drivers to load
	 */
	protected $config = array(
		'drivers' => array('acl' => array('Ormacl'))
	);

	/*
	 * Return the list of defined groups
	 */
	public function groups()
	{
		return static::$_valid_groups;
	}

	/*
	 * check for group membership
	 */
	public function member($group, $user = null)
	{
		// if no user is given
		if ($user === null)
		{
			// get the groups of the logged-in user
			$groups = \Auth::instance()->get_groups();
		}
		else
		{
			// get the groups if the given user instance
			$groups = \Auth::instance($user[0])->get_groups();
		}

		// if no group info could be retrieved, the user can't be a member
		if ( ! $groups)
		{
			return false;
		}

		// if it's a group id, find the corresponding object
		if (is_numeric($group) and isset(static::$_valid_groups[$group]))
		{
			$group = static::$_valid_groups[$group];
		}

		// return the result
		return in_array(array($this->id, $group), $groups);
	}

	/*
	 * get the name of a specific group, or of the users default group
	 */
	public function get_name($group = null)
	{
		// if no group is given
		if ($group === null)
		{
			// try get the the group assigned to the logged-in user
			if ( ! $login = \Auth::instance() or ! is_array($groups = $login->get_groups()))
			{
				return false;
			}
			$group = isset($groups[0][1]) ? $groups[0][1] : null;
		}

		// if it's a group id, find the corresponding object
		elseif (is_numeric($group) and isset(static::$_valid_groups[$group]))
		{
			$group = static::$_valid_groups[$group];
		}

		// if the group was found, return the name
		if ($group instanceOf Model\Auth_Group)
		{
			return $group->name;
		}
		else
		{
			// no group found, so no name either
			return null;
		}
	}

	/*
	 * get the roles assigned to a group, or to the users default group
	 */
	public function get_roles($group = null)
	{
		// When group is empty, attempt to get groups from a current login
		if ($group === null)
		{
			if ($login = \Auth::instance()
				and is_array($groups = $login->get_groups())
				and isset($groups[0][1]))
			{
				$group = $groups[0][1];
			}
		}

		// if it's a group id, find the corresponding object
		elseif (is_numeric($group) and isset(static::$_valid_groups[$group]))
		{
			$group = static::$_valid_groups[$group];
		}

		// if the group was found, return the roles
		if ($group instanceOf Model\Auth_Group)
		{
			return $group->roles;
		}
		else
		{
			// no group found, so no roles either
			return array();
		}
	}
}
