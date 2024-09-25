<?php

namespace Fuel\Migrations;

class Auth_Create_Usertables
{

	function up()
	{
		// get the driver used
		\Config::load('auth', true);

		$drivers = \Config::get('auth.driver', array());
		is_array($drivers) or $drivers = array($drivers);

		if (in_array('Simpleauth', $drivers))
		{
			// get the tablename
			\Config::load('simpleauth', true);
			$table = \Config::get('simpleauth.table_name', 'users');

			// only do this if it doesn't exist yet
			if ( ! \DBUtil::table_exists($table))
			{
				// table users
				\DBUtil::create_table($table, array(
					'id' => array('type' => 'int', 'constraint' => 11, 'auto_increment' => true),
					'username' => array('type' => 'varchar', 'constraint' => 50),
					'password' => array('type' => 'varchar', 'constraint' => 255),
					'group' => array('type' => 'int', 'constraint' => 11, 'default' => 1),
					'email' => array('type' => 'varchar', 'constraint' => 255),
					'last_login' => array('type' => 'varchar', 'constraint' => 25),
					'login_hash' => array('type' => 'varchar', 'constraint' => 255),
					'profile_fields' => array('type' => 'text'),
					'created_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
					'updated_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
				), array('id'));

				// add a unique index on username and email
				\DBUtil::create_index($table, array('username', 'email'), 'username', 'UNIQUE');
			}
		}

		elseif (in_array('Ormauth', $drivers))
		{
			// get the tablename
			\Config::load('ormauth', true);
			$table = \Config::get('ormauth.table_name', 'users');

			if ( ! \DBUtil::table_exists($table))
			{
				// get the simpleauth tablename, maybe that exists
				\Config::load('simpleauth', true);
				$simpletable = \Config::get('simpleauth.table_name', 'users');

				if ( ! \DBUtil::table_exists($simpletable))
				{
					// table users
					\DBUtil::create_table($table, array(
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
					\DBUtil::create_index($table, array('username', 'email'), 'username', 'UNIQUE');
				}
				else
				{
					\DBUtil::rename_table($simpletable, $table);
				}
			}

			// run a check on required fields, and deal with missing ones. we might be migrating from simpleauth
			if (\DBUtil::field_exists($table, 'group'))
			{
				\DBUtil::modify_fields($table, array(
					'group' => array('name' => 'group_id', 'type' => 'int', 'constraint' => 11),
				));
			}
			if ( ! \DBUtil::field_exists($table, 'group_id'))
			{
				\DBUtil::add_fields($table, array(
					'group_id' => array('type' => 'int', 'constraint' => 11, 'default' => 1, 'after' => 'password'),
				));
			}
			if ( ! \DBUtil::field_exists($table, 'previous_login'))
			{
				\DBUtil::add_fields($table, array(
					'previous_login' => array('type' => 'varchar', 'constraint' => 25, 'default' => 0, 'after' => 'last_login'),
				));
			}
			if ( ! \DBUtil::field_exists($table, 'user_id'))
			{
				\DBUtil::add_fields($table, array(
					'user_id' => array('type' => 'int', 'constraint' => 11, 'default' => 0, 'after' => 'login_hash'),
				));
			}
			if (\DBUtil::field_exists($table, 'created'))
			{
				\DBUtil::modify_fields($table, array(
					'created' => array('name' => 'created_at', 'type' => 'int', 'constraint' => 11),
				));
			}
			if ( ! \DBUtil::field_exists($table, 'created_at'))
			{
				\DBUtil::add_fields($table, array(
					'created_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0, 'after' => 'user_id'),
				));
			}
			if (\DBUtil::field_exists($table, 'updated'))
			{
				\DBUtil::modify_fields($table, array(
					'updated' => array('name' => 'updated_at', 'type' => 'int', 'constraint' => 11),
				));
			}
			if ( ! \DBUtil::field_exists($table, 'updated_at'))
			{
				\DBUtil::add_fields($table, array(
					'updated_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0, 'after' => 'created_at'),
				));
			}

			// table users_meta
			\DBUtil::create_table($table.'_metadata', array(
				'id' => array('type' => 'int', 'constraint' => 11, 'auto_increment' => true),
				'parent_id' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
				'key' => array('type' => 'varchar', 'constraint' => 20),
				'value' => array('type' => 'varchar', 'constraint' => 100),
				'user_id' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
				'created_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
				'updated_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
			), array('id'));

			// convert profile fields to metadata, and drop the column
			if (\DBUtil::field_exists($table, 'profile_fields'))
			{
				$result = \DB::select('id', 'profile_fields')->from($table)->execute();
				foreach ($result as $row)
				{
					$profile_fields = empty($row['profile_fields']) ? array() : unserialize($row['profile_fields']);
					foreach ($profile_fields as $field => $value)
					{
						if ( ! is_numeric($field))
						{
							\DB::insert($table.'_metadata')->set(
								array(
									'parent_id' => $row['id'],
									'key' => $field,
									'value' => $value,
								)
							)->execute();
						}
					}
				}
				\DBUtil::drop_fields($table, array(
					'profile_fields',
				));
			}

			// table users_user_role
			\DBUtil::create_table($table.'_user_roles', array(
				'user_id' => array('type' => 'int', 'constraint' => 11),
				'role_id' => array('type' => 'int', 'constraint' => 11),
			), array('user_id', 'role_id'));

			// table users_user_perms
			\DBUtil::create_table($table.'_user_permissions', array(
				'user_id' => array('type' => 'int', 'constraint' => 11),
				'perms_id' => array('type' => 'int', 'constraint' => 11),
			), array('user_id', 'perms_id'));
		}
	}

	function down()
	{
		// get the driver used
		\Config::load('auth', true);

		$drivers = \Config::get('auth.driver', array());
		is_array($drivers) or $drivers = array($drivers);

		if (in_array('Simpleauth', $drivers))
		{
			// get the tablename
			\Config::load('simpleauth', true);
			$table = \Config::get('simpleauth.table_name', 'users');

			// drop the admin_users table
			\DBUtil::drop_table($table);
		}

		elseif (in_array('Ormauth', $drivers))
		{
			// get the tablename
			\Config::load('ormauth', true);
			$table = \Config::get('ormauth.table_name', 'users');

			// drop the admin_users table
			\DBUtil::drop_table($table);

			// drop the admin_users_meta table
			\DBUtil::drop_table($table.'_metadata');

			// drop the admin_users_user_role table
			\DBUtil::drop_table($table.'_user_roles');

			// drop the admin_users_user_perms table
			\DBUtil::drop_table($table.'_user_permissions');
		}
	}
}
