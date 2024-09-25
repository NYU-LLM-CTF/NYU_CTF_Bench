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

namespace Auth\Model;

class Auth_User extends \Orm\Model
{
	/**
	 * @var  string  connection to use
	 */
	protected static $_connection = null;

	/**
	 * @var  string  table name to overwrite assumption
	 */
	protected static $_table_name;

	/**
	 * @var array	model properties
	 */
	protected static $_properties = array(
		'id',
		'username'        => array(
			'label'		  => 'auth_model_user.name',
			'default' 	  => 0,
			'null'		  => false,
			'validation'  => array('required', 'max_length' => array(255))
		),
		'email'           => array(
			'label'		  => 'auth_model_user.email',
			'default' 	  => 0,
			'null'		  => false,
			'validation'  => array('required', 'valid_email')
		),
		'group_id'        => array(
			'label'		  => 'auth_model_user.group_id',
			'default' 	  => 0,
			'null'		  => false,
			'form'  	  => array('type' => 'select'),
			'validation'  => array('required', 'is_numeric')
		),
		'password'        => array(
			'label'		  => 'auth_model_user.password',
			'default' 	  => 0,
			'null'		  => false,
			'form'  	  => array('type' => 'password'),
			'validation'  => array('min_length' => array(8), 'match_field' => array('confirm'))
		),
		'last_login'	  => array(
			'form'  	  => array('type' => false),
		),
		'previous_login'  => array(
			'form'  	  => array('type' => false),
		),
		'login_hash'	  => array(
			'form'  	  => array('type' => false),
		),
		'user_id'         => array(
			'default' 	  => 0,
			'null'		  => false,
			'form'  	  => array('type' => false),
		),
		'created_at'      => array(
			'default' 	  => 0,
			'null'		  => false,
			'form'  	  => array('type' => false),
		),
		'updated_at'      => array(
			'default' 	  => 0,
			'null'		  => false,
			'form'  	  => array('type' => false),
		),
	);

	/**
	 * @var array	defined observers
	 */
	protected static $_observers = array(
		'Orm\\Observer_CreatedAt' => array(
			'events' => array('before_insert'),
			'property' => 'created_at',
			'mysql_timestamp' => false
		),
		'Orm\\Observer_UpdatedAt' => array(
			'events' => array('before_update'),
			'property' => 'updated_at',
			'mysql_timestamp' => false
		),
		'Orm\\Observer_Typing' => array(
			'events' => array('after_load', 'before_save', 'after_save')
		),
		'Orm\\Observer_Self' => array(
			'events' => array('before_insert', 'before_update'),
			'property' => 'user_id'
		),
	);

    // EAV container for user metadata
    protected static $_eav = array(
        'metadata' => array(
            'attribute' => 'key',
            'value' => 'value',
        ),
    );

	/**
	 * @var array	belongs_to relationships
	 */
	protected static $_belongs_to = array(
		'group' => array(
			'model_to' => 'Model\\Auth_Group',
			'key_from' => 'group_id',
			'key_to'   => 'id',
			'cascade_delete' => false,
		),
	);

	/**
	 * @var array	has_many relationships
	 */
	protected static $_has_many = array(
		'metadata' => array(
			'model_to' => 'Model\\Auth_Metadata',
			'key_from' => 'id',
			'key_to'   => 'parent_id',
			'cascade_delete' => true,
		),
		'userpermission' => array(
			'model_to' => 'Model\\Auth_Userpermission',
			'key_from' => 'id',
			'key_to'   => 'user_id',
			'cascade_delete' => false,
		),
	);

	/**
	 * @var array	many_many relationships
	 */
	protected static $_many_many = array(
		'roles' => array(
			'key_from' => 'id',
			'model_to' => 'Model\\Auth_Role',
			'key_to' => 'id',
			'table_through' => null,
			'key_through_from' => 'user_id',
			'key_through_to' => 'role_id',
		),
		'permissions' => array(
			'key_from' => 'id',
			'model_to' => 'Model\\Auth_Permission',
			'key_to' => 'id',
			'table_through' => null,
			'key_through_from' => 'user_id',
			'key_through_to' => 'perms_id',
		),
	);

	/**
	 * init the class
	 */
   	public static function _init()
	{
		// auth config
		\Config::load('ormauth', true);

		// set the connection this model should use
		static::$_connection = \Config::get('ormauth.db_connection');

		// set the models table name
		static::$_table_name = \Config::get('ormauth.table_name', 'users');

		// set the relations through table names
		static::$_many_many['roles']['table_through'] = \Config::get('ormauth.table_name', 'users').'_user_roles';
		static::$_many_many['permissions']['table_through'] = \Config::get('ormauth.table_name', 'users').'_user_permissions';

		// model language file
		\Lang::load('auth_model_user', true);
	}

	/**
	 * before_insert observer event method
	 */
	public function _event_before_insert()
	{
		// assign the user id that lasted updated this record
		$this->user_id = ($this->user_id = \Auth::get_user_id()) ? $this->user_id[1] : 0;
	}

	/**
	 * before_update observer event method
	 */
	public function _event_before_update()
	{
		$this->_event_before_insert();
	}
}
