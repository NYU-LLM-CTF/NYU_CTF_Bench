<?php

namespace Fuel\Migrations;

class Auth_Create_Oauth2tables
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
			$basetable = \Config::get('simpleauth.table_name', 'users');
		}

		elseif (in_array('Ormauth', $drivers))
		{
			// get the tablename
			\Config::load('ormauth', true);
			$basetable = \Config::get('ormauth.table_name', 'users');
		}

		else
		{
			$basetable = 'users';
		}

		\DBUtil::create_table($basetable.'_clients', array(
			'id' => array('type' => 'int', 'constraint' => 11, 'auto_increment' => true),
			'name' => array('type' => 'varchar', 'constraint' => 32, 'default' => ''),
			'client_id' => array('type' => 'varchar', 'constraint' => 32, 'default' => ''),
			'client_secret' => array('type' => 'varchar', 'constraint' => 32, 'default' => ''),
			'redirect_uri' => array('type' => 'varchar', 'constraint' => 255, 'default' => ''),
			'auto_approve' => array( 'type' => 'tinyint', 'constraint' => 1, 'default' => 0),
			'autonomous' => array( 'type' => 'tinyint', 'constraint' => 1, 'default' => 0),
			'status' => array( 'type' => 'enum', 'constraint' => '"development","pending","approved","rejected"', 'default' => 'development'),
			'suspended' => array( 'type' => 'tinyint', 'constraint' => 1, 'default' => 0),
			'notes' => array('type' => 'tinytext'),
		), array('id'));
		\DBUtil::create_index($basetable.'_clients', 'client_id', 'client_id', 'UNIQUE');

		\DBUtil::create_table($basetable.'_sessions',
			array(
				'id' => array('type' => 'int', 'constraint' => 11, 'auto_increment' => true),
				'client_id' => array('type' => 'varchar', 'constraint' => 32, 'default' => ''),
				'redirect_uri' => array('type' => 'varchar', 'constraint' => 255, 'default' => ''),
				'type_id' => array('type' => 'varchar', 'constraint' => 64),
				'type' => array( 'type' => 'enum', 'constraint' => '"user","auto"', 'default' => 'user'),
				'code' => array('type' => 'text'),
				'access_token' => array('type' => 'varchar', 'constraint' => 50, 'default' => ''),
				'stage' => array( 'type' => 'enum', 'constraint' => '"request","granted"', 'default' => 'request'),
				'first_requested' => array( 'type' => 'int', 'constraint' => 11),
				'last_updated' => array( 'type' => 'int', 'constraint' => 11),
				'limited_access' => array( 'type' => 'tinyint', 'constraint' => 1, 'default' => 0),
			),
			array('id'),
			true,
			false,
			null,
			array(
				array(
					'constraint' => 'oauth_sessions_ibfk_1',
					'key' => 'client_id',
					'reference' => array(
						'table' => $basetable.'_clients',
						'column' => 'client_id',
					),
					'on_delete' => 'CASCADE',
				),
			)
		);

		\DBUtil::create_table($basetable.'_scopes', array(
			'id' => array('type' => 'int', 'constraint' => 11, 'auto_increment' => true),
			'scope' => array('type' => 'varchar', 'constraint' => 64, 'default' => ''),
			'name' => array('type' => 'varchar', 'constraint' => 64, 'default' => ''),
			'description' => array('type' => 'varchar', 'constraint' => 255, 'default' => ''),
		), array('id'));
		\DBUtil::create_index($basetable.'_scopes', 'scope', 'scope', 'UNIQUE');

		\DBUtil::create_table($basetable.'_sessionscopes',
			array(
				'id' => array('type' => 'int', 'constraint' => 11, 'auto_increment' => true),
				'session_id' => array('type' => 'int', 'constraint' => 11),
				'access_token' => array('type' => 'varchar', 'constraint' => 50, 'default' => ''),
				'scope' => array('type' => 'varchar', 'constraint' => 64, 'default' => ''),
			),
			array('id'),
			true,
			false,
			null,
			array(
				array(
					'constraint' => 'oauth_sessionscopes_ibfk_1',
					'key' => 'scope',
					'reference' => array(
						'table' => $basetable.'_scopes',
						'column' => 'scope',
					),
				),
				array(
					'constraint' => 'oauth_sessionscopes_ibfk_2',
					'key' => 'session_id',
					'reference' => array(
						'table' => $basetable.'_sessions',
						'column' => 'id',
					),
					'on_delete' => 'CASCADE',
				),
			)
		);
		\DBUtil::create_index($basetable.'_sessionscopes', 'session_id', 'session_id');
		\DBUtil::create_index($basetable.'_sessionscopes', 'access_token', 'access_token');
		\DBUtil::create_index($basetable.'_sessionscopes', 'scope', 'scope');
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
			$basetable = \Config::get('simpleauth.table_name', 'users');
		}

		elseif (in_array('Ormauth', $drivers))
		{
			// get the tablename
			\Config::load('ormauth', true);
			$basetable = \Config::get('ormauth.table_name', 'users');
		}

		else
		{
			$basetable = 'users';
		}

		\DBUtil::drop_table($basetable.'_sessionscopes');
		\DBUtil::drop_table($basetable.'_sessions');
		\DBUtil::drop_table($basetable.'_scopes');
		\DBUtil::drop_table($basetable.'_clients');
	}
}
