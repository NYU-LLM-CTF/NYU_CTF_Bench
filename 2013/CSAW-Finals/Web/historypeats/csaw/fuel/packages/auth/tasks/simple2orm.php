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

namespace Fuel\Tasks;

/**
 * Converts a SimpleAuth ruleset to an OrmAuth one
 */
class Simple2orm
{
	/*
	 * @var  array  collected data during validation
	 */
	protected static $data = array();

	/**
	 * Show help.
	 *
	 * Usage (from command line):
	 *
	 * php oil refine simple2orm
	 */
	public static function run()
	{
		// fetch the commandline options
		$run_migration = \Cli::option('migrate', \Cli::option('m', false));
		$run_validation = $run_migration ? true : \Cli::option('validate', \Cli::option('v', false));

		// if no run options are present, show the help
		if ( ! $run_migration and ! $run_validation )
		{
			return static::help();
		}

		// step 1: run validation
		$validated = true;
		if ($run_validation)
		{
			$validated = static::run_validation();
		}

		// step 2: run migration
		if ($run_migration)
		{
			if ($validated)
			{
				$migrated = static::run_migration();
				if ($migrated)
				{
					\Cli::write('Migration succesfully finished', 'light_green');
				}
				else
				{
					\Cli::write("\n".'Migration failed. Skipping the remainder of the migration. Please correct the errors and run again.', 'light_red');
				}
			}
			else
			{
				\Cli::write("\n".'Validation failed. Skipping the actual migration. Please correct the errors.', 'light_red');
			}
		}
	}

	/**
	 * Show help.
	 *
	 * Usage (from command line):
	 *
	 * php oil refine simple2orm:help
	 */
	public static function help()
	{
		$output = <<<HELP

Description:
  The task converts an existing SimpleAuth setup to OrmAuth, migrating
  all configured users, groups, roles and rights.

  Before using this task, make sure your auth configuration is set to use
  the Ormauth driver, you have an ormauth configuration file, and you have
  run all auth migrations.

Runtime options:
  -v, [--validate]    # Validate the current installation, do not migrate
  -m, [--migrate]     # Run the migration

Commands:
  php oil refine simple2orm
  php oil refine simple2orm:help
  php oil refine simple2orm --validate
  php oil refine simple2orm

HELP;
		\Cli::write($output);
	}

	/**
	 * Run the environment validation
	 */
	protected static function run_validation()
	{
		// storage for collected errors
		$errors = array();

		// validate the auth configuration file
		if ( ! is_file($file = APPPATH.'config'.DS.'auth.php'))
		{
			$errors[] = \Fuel::clean_path($file).' does not exist.';
		}
		else
		{
			\Config::load('auth', true);
			if ( ! $driver = \Config::get('auth.driver', false))
			{
				$errors[] = \Fuel::clean_path($file).' does not define an auth driver.';
			}
			elseif ($driver != 'Ormauth')
			{
				$errors[] = \Fuel::clean_path($file).' is not configured to use the Ormauth driver.';
			}
		}

		// validate the simpleauth configuration file
		if ( ! is_file($file = APPPATH.'config'.DS.'simpleauth.php'))
		{
			$errors[] = \Fuel::clean_path($file).' does not exist.';
		}
		else
		{
			\Config::load('simpleauth', true);
			if ( ! $table = \Config::get('simpleauth.table_name', false))
			{
				$errors[] = \Fuel::clean_path($file).' does not define a user table.';
			}
			elseif ( ! \DBUtil::table_exists($table))
			{
				$errors[] = \Fuel::clean_path($file).' defines a table that does not exist.';
			}
			else
			{
				// store the table name for future use
				static::$data['simpleauth_table'] = $table;
			}
		}

		// validate the ormauth configuration file
		if ( ! is_file($file = APPPATH.'config'.DS.'ormauth.php'))
		{
			$errors[] = \Fuel::clean_path($file).' does not exist.';
		}
		else
		{
			$config = \Config::load('ormauth', true);
			if ( ! $table = \Config::get('ormauth.table_name', false))
			{
				$errors[] = \Fuel::clean_path($file).' does not define a user table.';
			}
			elseif ( ! \DBUtil::table_exists($table))
			{
				$errors[] = \Fuel::clean_path($file).' defines a table that does not exist.';
			}
			else
			{
				// store the table name for future use
				static::$data['ormauth_table'] = $table;
			}

			if ( ! $cache_prefix = \Config::get('ormauth.cache_prefix', false) or empty($cache_prefix))
			{
				$errors[] = \Fuel::clean_path($file).' does not define a cache_prefix.';
			}
			else
			{
				// store the cache prefix for future use
				static::$data['cache_prefix'] = $cache_prefix;
			}
		}

		// check if all migrations have run, and the migration system is consistent
		$migrations = \Config::load('migrations', true);
		if ( ! isset($migrations['version']['package']['auth'][6]))
		{
			$errors[] = 'Auth database migrations haven\'t run (succesfully).';
		}
		else
		{
			$result = \DB::select('*')->from($migrations['table'])->where('type', '=', 'package')->where('name', '=', 'auth')->execute();
			if (count($result) < 7)
			{
				$errors[] = 'Auth database migrations haven\'t run (succesfully).';
				$errors[] = 'There is a discrepancy between your migration configuration file and the migration table.';
			}
		}

		// check the fields of the users table
		$usertable = array(
			'id' => array('type' => 'int', 'constraint' => 11, 'auto_increment' => true),
			'username' => array('type' => 'varchar', 'constraint' => 50, 'after' => 'id'),
			'password' => array('type' => 'varchar', 'constraint' => 255, 'after' => 'username'),
			'group_id' => array('type' => 'int', 'constraint' => 11, 'default' => 1, 'after' => 'password'),
			'email' => array('type' => 'varchar', 'constraint' => 255, 'after' => 'group_id'),
			'last_login' => array('type' => 'varchar', 'constraint' => 25, 'after' => 'email'),
			'previous_login' => array('type' => 'varchar', 'constraint' => 25, 'default' => 0, 'after' => 'last_login'),
			'login_hash' => array('type' => 'varchar', 'constraint' => 255, 'after' => 'previous_login'),
			'user_id' => array('type' => 'int', 'constraint' => 11, 'default' => 0, 'after' => 'login_hash'),
			'created_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0, 'after' => 'user_id'),
			'updated_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0, 'after' => 'created_at'),
			);

		foreach ($usertable as $field => $value)
		{
			if (\DBUtil::field_exists(static::$data['ormauth_table'], $field))
			{
				unset($usertable[$field]);
			}
		}
		if ( ! empty($usertable))
		{
			$errors[] = 'User table "'.static::$data['ormauth_table'].'" is missing the field(s): '.implode(', ', array_keys($usertable));
		}

		// process the results of the validation
		if ($errors)
		{
			// display all errors
			\Cli::write('You environment did not validate:', 'light_red');

			foreach ($errors as $error)
			{
				\Cli::write('* '.$error);
			}

			return false;
		}

		// inform the user we're good to go
		\Cli::write('Environment validated', 'light_green');
		return true;
	}

	/**
	 * Run the actual migration
	 */
	protected static function run_migration()
	{
		// make sure we've got a usertable we can work with
		static::usertable();

		// get the simpleauth config
		\Config::load('simpleauth', true);
		$simpleauth = \Config::get('simpleauth', array());

		// process the defined roles
		foreach (\Config::get('simpleauth.roles', array()) as $role => $config)
		{
			// skip all non-standard roles
			if ($role == '#' or ! is_array($config))
			{
				continue;
			}

			// do we already have this role?
			$result = \DB::select('id')->from(static::$data['ormauth_table'].'_roles')->where('name', '=', $role)->execute();
			if (count($result))
			{
				$role_id = $result[0]['id'];
			}

			// no, add it
			else
			{
				\Cli::write('- creating role: '.$role, 'light_green');
				list($role_id, $rows_affected) = \DB::insert(static::$data['ormauth_table'].'_roles')->set(array('name' => $role))->execute();
			}

			// fetch the role as an ORM object, and assign the defined permissions to it
			$role = \Model\Auth_Role::find($role_id);
			if ($role)
			{
				foreach ($config as $area => $permissions)
				{
					foreach ($permissions as $permission)
					{
						$perm = \Model\Auth_Permission::query()->where('area', '=', $area)->where('permission', '=', $permission)->get_one();
						if ( ! $perm)
						{
							\Cli::write('- creating permission: '.$area.'.'.$permission, 'light_green');
							$perm = \Model\Auth_Permission::forge(array('area' => $area, 'permission' => $permission, 'description' => $area.'.'.$permission, 'actions' => serialize(array())));
						}
						$role->permissions[] = $perm;
					}
				}

				// update the role and save the permissions
				$role->save();
			}
		}

		// process the defined groups
		foreach (\Config::get('simpleauth.groups', array()) as $group => $config)
		{
			// ignore invalid entries
			if ( ! isset($config['name']) or ! isset($config['roles']))
			{
				continue;
			}

			// do we already have this group?
			$result = \DB::select('id')->from(static::$data['ormauth_table'].'_groups')->where('name', '=', $config['name'])->execute();
			if (count($result))
			{
				$group_id = $result[0]['id'];
			}

			// no, add it
			else
			{
				\Cli::write('- creating group: '.$config['name'], 'light_green');
				list($group_id, $rows_affected) = \DB::insert(static::$data['ormauth_table'].'_groups')->set(array('name' => $config['name']))->execute();
			}

			// update the user group entries
			\DB::update(static::$data['ormauth_table'])->set(array('group_id' => $group_id))->where('group_id', '=', $group)->execute();

			// fetch the group as an ORM object, and assign the defined roles to it
			$group = \Model\Auth_Group::find($group_id);

			if ($group)
			{
				foreach ($config['roles'] as $role)
				{
					$role = \Model\Auth_Role::query()->where('name', '=', $role)->get_one();
					if ( ! $role)
					{
						$role = \Model\Auth_Role::forge(array('name' => $role));
						\Cli::write('- creating role: '.$role, 'light_green');
					}
					$group->roles[] = $role;
				}

				// update the group and save the roles
				$group->save();
			}
		}

		return true;
	}


	/*
	 * Deal with potential changes in users table layout between simpleauth and ormauth
	 */
	protected static function usertable()
	{
		if ( ! \DBUtil::table_exists(static::$data['ormauth_table']))
		{
			if ( ! \DBUtil::table_exists(static::$data['simpleauth_table']))
			{
				// table users
				\DBUtil::create_table(static::$data['ormauth_table'], array(
					'id' => array('type' => 'int', 'constraint' => 11, 'auto_increment' => true),
					'username' => array('type' => 'varchar', 'constraint' => 50),
					'password' => array('type' => 'varchar', 'constraint' => 255),
					'group_id' => array('type' => 'int', 'constraint' => 11, 'default' => 1),
					'email' => array('type' => 'varchar', 'constraint' => 255),
					'last_login' => array('type' => 'varchar', 'constraint' => 25),
					'previous_login' => array('type' => 'varchar', 'constraint' => 25, 'default' => 0),
					'login_hash' => array('type' => 'varchar', 'constraint' => 255),
					'user_id' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
					'created_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
					'updated_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
				), array('id'));

				// add a unique index on username and email
				\DBUtil::create_index(static::$data['ormauth_table'], array('username', 'email'), 'username', 'UNIQUE');
			}
			else
			{
				\DBUtil::rename_table(static::$data['simpleauth_table'], static::$data['ormauth_table']);
			}
		}

		// run a check on required fields, and deal with missing ones. we might be migrating from simpleauth
		if (\DBUtil::field_exists(static::$data['ormauth_table'], 'group'))
		{
			\DBUtil::modify_fields(static::$data['ormauth_table'], array(
				'group' => array('name' => 'group_id', 'type' => 'int', 'constraint' => 11),
			));
		}
		if ( ! \DBUtil::field_exists(static::$data['ormauth_table'], 'group_id'))
		{
			\DBUtil::add_fields(static::$data['ormauth_table'], array(
				'group_id' => array('type' => 'int', 'constraint' => 11, 'default' => 1, 'after' => 'password'),
			));
		}
		if ( ! \DBUtil::field_exists(static::$data['ormauth_table'], 'previous_login'))
		{
			\DBUtil::add_fields(static::$data['ormauth_table'], array(
				'previous_login' => array('type' => 'varchar', 'constraint' => 25, 'default' => 0, 'after' => 'last_login'),
			));
		}
		if ( ! \DBUtil::field_exists(static::$data['ormauth_table'], 'user_id'))
		{
			\DBUtil::add_fields(static::$data['ormauth_table'], array(
				'user_id' => array('type' => 'int', 'constraint' => 11, 'default' => 0, 'after' => 'login_hash'),
			));
		}
		if (\DBUtil::field_exists(static::$data['ormauth_table'], 'created'))
		{
			\DBUtil::modify_fields(static::$data['ormauth_table'], array(
				'created' => array('name' => 'created_at', 'type' => 'int', 'constraint' => 11),
			));
		}
		if ( ! \DBUtil::field_exists(static::$data['ormauth_table'], 'created_at'))
		{
			\DBUtil::add_fields(static::$data['ormauth_table'], array(
				'created_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0, 'after' => 'user_id'),
			));
		}
		if (\DBUtil::field_exists(static::$data['ormauth_table'], 'updated'))
		{
			\DBUtil::modify_fields(static::$data['ormauth_table'], array(
				'updated' => array('name' => 'updated_at', 'type' => 'int', 'constraint' => 11),
			));
		}
		if ( ! \DBUtil::field_exists(static::$data['ormauth_table'], 'updated_at'))
		{
			\DBUtil::add_fields(static::$data['ormauth_table'], array(
				'updated_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0, 'after' => 'created_at'),
			));
		}
	}
}
