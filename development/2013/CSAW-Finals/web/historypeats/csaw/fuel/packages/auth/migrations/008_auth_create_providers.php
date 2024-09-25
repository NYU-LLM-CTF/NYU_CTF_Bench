<?php

namespace Fuel\Migrations;

class Auth_Create_Providers
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
			$table = \Config::get('simpleauth.table_name', 'users').'_providers';
		}

		elseif (in_array('Ormauth', $drivers))
		{
			// get the tablename
			\Config::load('ormauth', true);
			$table = \Config::get('ormauth.table_name', 'users').'_providers';
		}

		if (isset($table))
		{
			\DBUtil::create_table($table, array(
				'id' => array('type' => 'int', 'constraint' => 11, 'auto_increment' => true),
				'parent_id' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
				'provider' => array('type' => 'varchar', 'constraint' => 50),
				'uid' => array('type' => 'varchar', 'constraint' => 255),
				'secret' => array('type' => 'varchar', 'constraint' => 255, 'null' => true),
				'access_token' => array('type' => 'varchar', 'constraint' => 255, 'null' => true),
				'expires' => array( 'type' => 'int', 'constraint' => 12, 'default' => 0, 'null' => true),
				'refresh_token' => array('type' => 'varchar', 'constraint' => 255, 'null' => true),
				'user_id' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
				'created_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
				'updated_at' => array('type' => 'int', 'constraint' => 11, 'default' => 0),
			), array('id'));

			\DBUtil::create_index($table, 'parent_id', 'parent_id');
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
			$table = \Config::get('simpleauth.table_name', 'users').'_providers';
		}

		elseif (in_array('Ormauth', $drivers))
		{
			// get the tablename
			\Config::load('ormauth', true);
			$table = \Config::get('ormauth.table_name', 'users').'_providers';
		}

		if (isset($table))
		{
			// drop the users remote table
			\DBUtil::drop_table($table);
		}
	}
}
