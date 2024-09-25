<?php

namespace Fuel\Migrations;

class Auth_Add_Permissionsfilter
{

	function up()
	{
		// get the driver used
		\Config::load('auth', true);

		$drivers = \Config::get('auth.driver', array());
		is_array($drivers) or $drivers = array($drivers);

		if (in_array('Ormauth', $drivers))
		{
			// get the tablename
			\Config::load('ormauth', true);
			$table = \Config::get('ormauth.table_name', 'users');

			// modify the filter field to add the 'remove' filter
			\DBUtil::modify_fields($table.'_roles', array(
				'filter' => array('type' => 'enum', 'constraint' => "'', 'A', 'D', 'R'", 'default' => ''),
			));
		}
	}

	function down()
	{
		// get the driver used
		\Config::load('auth', true);

		$drivers = \Config::get('auth.driver', array());
		is_array($drivers) or $drivers = array($drivers);

		if (in_array('Ormauth', $drivers))
		{
			// get the tablename
			\Config::load('ormauth', true);
			$table = \Config::get('ormauth.table_name', 'users');

			// modify the filter field to add the 'remove' filter
			\DB::update($table.'_roles')->set(array('filter' => 'D'))->where('filter', '=', 'R')->execute();

			\DBUtil::modify_fields($table.'_roles', array(
				'filter' => array('type' => 'enum', 'constraint' => "'', 'A', 'D'", 'default' => ''),
			));
		}
	}
}
