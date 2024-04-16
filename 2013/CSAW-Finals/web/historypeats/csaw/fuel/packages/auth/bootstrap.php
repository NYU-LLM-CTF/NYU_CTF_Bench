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


Autoloader::add_core_namespace('Auth');

Autoloader::add_classes(array(
	'Auth\\Auth'                         => __DIR__.'/classes/auth.php',
	'Auth\\AuthException'                => __DIR__.'/classes/auth.php',

	'Auth\\Auth_Driver'                  => __DIR__.'/classes/auth/driver.php',

	'Auth\\Auth_Opauth'                  => __DIR__.'/classes/auth/opauth.php',

	'Auth\\Auth_Acl_Driver'              => __DIR__.'/classes/auth/acl/driver.php',
	'Auth\\Auth_Acl_Simpleacl'           => __DIR__.'/classes/auth/acl/simpleacl.php',
	'Auth\\Auth_Acl_Ormacl'              => __DIR__.'/classes/auth/acl/ormacl.php',

	'Auth\\Auth_Group_Driver'            => __DIR__.'/classes/auth/group/driver.php',
	'Auth\\Auth_Group_Simplegroup'       => __DIR__.'/classes/auth/group/simplegroup.php',
	'Auth\\Auth_Group_Ormgroup'          => __DIR__.'/classes/auth/group/ormgroup.php',

	'Auth\\Auth_Login_Driver'            => __DIR__.'/classes/auth/login/driver.php',
	'Auth\\Auth_Login_Simpleauth'        => __DIR__.'/classes/auth/login/simpleauth.php',
	'Auth\\Auth_Login_Ormauth'           => __DIR__.'/classes/auth/login/ormauth.php',

	'Auth\\SimpleUserUpdateException'    => __DIR__.'/classes/auth/exceptions.php',
	'Auth\\SimpleUserWrongPassword'      => __DIR__.'/classes/auth/exceptions.php',
	'Auth\\OpauthException'              => __DIR__.'/classes/auth/exceptions.php',

	'Auth\\Model\\Auth_User'             => __DIR__.'/classes/model/auth/user.php',
	'Auth\\Model\\Auth_Userpermission'   => __DIR__.'/classes/model/auth/userpermission.php',
	'Auth\\Model\\Auth_Metadata'         => __DIR__.'/classes/model/auth/metadata.php',
	'Auth\\Model\\Auth_Group'            => __DIR__.'/classes/model/auth/group.php',
	'Auth\\Model\\Auth_Grouppermission'  => __DIR__.'/classes/model/auth/grouppermission.php',
	'Auth\\Model\\Auth_Role'             => __DIR__.'/classes/model/auth/role.php',
	'Auth\\Model\\Auth_Rolepermission'   => __DIR__.'/classes/model/auth/rolepermission.php',
	'Auth\\Model\\Auth_Permission'       => __DIR__.'/classes/model/auth/permission.php',
));
