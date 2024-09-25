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

namespace Orm;

/**
 * Allows revisions of database entries to be kept when updates are made.
 *
 * @package Orm
 * @author  Fuel Development Team
 */
class Model_Temporal extends Model
{

	/**
	 * Compound primary key that includes the start and end times is required
	 */
	protected static $_primary_key = array('id', 'temporal_start', 'temporal_end');

	/**
	 * Override to change default temporal paramaters
	 */
	protected static $_temporal = array();

	/**
	 * Contains cached temporal properties.
	 */
	protected static $_temporal_cached = array();

	/**
	 * Contains the status of the primary key disable flag for temporal models
	 */
	protected static $_pk_check_disabled = array();

	/**
	 * Contains the status for classes that defines if primaryKey() should return
	 * just the ID.
	 */
	protected static $_pk_id_only = array();

	/**
	 * If the model has been loaded through find_revision then this will be set
	 * to the timestamp used to find the revision.
	 */
	protected $_lazy_timestamp = null;

	/**
	 * Contains the filtering status for temporal queries
	 */
	protected static $_lazy_filtered_classes = array();

	public static function _init()
	{
		\Config::load('orm', true);
	}

	/**
	 * Gets the temporal properties.
	 * Mostly stolen from the parent class properties() function
	 *
	 * @return array
	 */
	public static function temporal_properties()
	{
		$class = get_called_class();

		// If already determined
		if (array_key_exists($class, static::$_temporal_cached))
		{
			return static::$_temporal_cached[$class];
		}

		$properties = array();

		// Try to grab the properties from the class...
		if (property_exists($class, '_temporal'))
		{
			//Load up the info
			$properties['start_column'] =
				\Arr::get(static::$_temporal, 'start_column', 'temporal_start');
			$properties['end_column'] =
				\Arr::get(static::$_temporal, 'end_column', 'temporal_end');
			$properties['mysql_timestamp'] =
				\Arr::get(static::$_temporal, 'mysql_timestamp', false);

			$properties['max_timestamp'] = ($properties['mysql_timestamp']) ?
				\Config::get('orm.sql_max_timestamp_mysql') :
				\Config::get('orm.sql_max_timestamp_unix');
		}

		// cache the properties for next usage
		static::$_temporal_cached[$class] = $properties;

		return static::$_temporal_cached[$class];
	}

	/**
	 * Fetches temporal property description array, or specific data from
	 * it.
	 * Stolen from parent class.
	 *
	 * @param   string  property or property.key
	 * @param   mixed   return value when key not present
	 * @return  mixed
	 */
	public static function temporal_property($key, $default = null)
	{
		$class = get_called_class();

		// If already determined
		if (!array_key_exists($class, static::$_temporal_cached))
		{
			static::temporal_properties();
		}

		return \Arr::get(static::$_temporal_cached[$class], $key, $default);
	}

	/**
	 * Finds a specific revision for the given ID. If a timestamp is specified
	 * the revision returned will reflect the entity's state at that given time.
	 * This will also load relations when requested.
	 *
	 * @param type $id
	 * @param int $timestamp Null to get the latest revision (Same as find($id))
	 * @param array $relations Names of the relations to load.
	 * @return Subclass of Orm\Model_Temporal
	 */
	public static function find_revision($id, $timestamp = null, $relations = array())
	{
		if ($timestamp == null)
		{
			return parent::find($id);
		}

		$timestamp_start_name = static::temporal_property('start_column');
		$timestamp_end_name = static::temporal_property('end_column');

		// Select the next latest revision after the requested one then use that
		// to get the revision before.
		self::disable_primary_key_check();

		$query = static::query()
			->where('id', $id)
			->where($timestamp_start_name, '<=', $timestamp)
			->where($timestamp_end_name, '>', $timestamp);
		self::enable_primary_key_check();

		//Make sure the temporal stuff is activated
		$query->set_temporal_properties($timestamp, $timestamp_end_name, $timestamp_start_name);

		foreach ($relations as $relation)
		{
			$query->related($relation);
		}

		$query_result = $query->get_one();
		$query_result->set_lazy_timestamp($timestamp);
		return $query_result;
	}

	private function set_lazy_timestamp($timestamp)
	{
		$this->_lazy_timestamp = $timestamp;
	}

	/**
	 * Overrides Model::get() to allow lazy loaded relations to be filtered
	 * temporaly.
	 *
	 * @param string $property
	 * @return mixed
	 */
	public function & get($property, array $conditions = array())
	{
		// if a timestamp is set and that we have a temporal relation
		$rel = static::relations($property);
		if ($rel && is_subclass_of($rel->model_to, 'Orm\Model_Temporal'))
		{
			// find a specific revision or the newest if lazy timestamp is null
			$lazy_timestamp = $this->_lazy_timestamp ?: static::temporal_property('max_timestamp') - 1;
			//add the filtering and continue with the parent's behavour
			$class_name = $rel->model_to;

			$class_name::make_query_temporal($lazy_timestamp);
			$result =& parent::get($property, $conditions);
			$class_name::make_query_temporal(null);

			return $result;
		}

		return parent::get($property, $conditions);
	}

	/**
	 * When a timestamp is set any query objects produced by this temporal model
	 * will behave the same as find_revision()
	 *
	 * @param array $timestamp
	 */
	private static function make_query_temporal($timestamp)
	{
		$class = get_called_class();
		static::$_lazy_filtered_classes[$class] = $timestamp;
	}

	/**
	 * Overrides Model::query to provide a Temporal_Query
	 *
	 * @param array $options
	 * @return Query_Temporal
	 */
	public static function query($options = array())
	{
		$timestamp_start_name = static::temporal_property('start_column');
		$timestamp_end_name = static::temporal_property('end_column');
		$max_timestamp = static::temporal_property('max_timestamp');

		$query = Query_Temporal::forge(get_called_class(), static::connection(), $options)
			->set_temporal_properties($max_timestamp, $timestamp_end_name, $timestamp_start_name);

		//Check if we need to add filtering
		$class = get_called_class();
		$timestamp = \Arr::get(static::$_lazy_filtered_classes, $class, null);

		if(! is_null($timestamp) )
		{
			$query->where($timestamp_start_name, '<=', $timestamp)
				->where($timestamp_end_name, '>', $timestamp);
		}

		return $query;
	}

	/**
	 * Returns a list of revisions between the given times with the most recent
	 * first. This does not load relations.
	 *
	 * @param int|string $id
	 * @param timestamp $earliestTime
	 * @param timestamp $latestTime
	 */
	public static function find_revisions_between($id, $earliestTime = null, $latestTime = null)
	{
		$timestamp_start_name = static::temporal_property('start_column');
		$max_timestamp = static::temporal_property('max_timestamp');

		if ($earliestTime == null)
		{
			$earliestTime = 0;
		}

		if($latestTime == null)
		{
			$latestTime = $max_timestamp;
		}

		static::disable_primary_key_check();
		//Select all revisions within the given range.
		$query = static::query()
			->where('id', $id)
			->where($timestamp_start_name, '>=', $earliestTime)
			->where($timestamp_start_name, '<=', $latestTime);
		static::enable_primary_key_check();

		$revisions = $query->get();
		return $revisions;
	}

	/**
	 * Overrides the default find method to allow the latest revision to be found
	 * by default.
	 *
	 * If any new options to find are added the switch statement will have to be
	 * updated too.
	 *
	 * @param type $id
	 * @param array $options
	 * @return type
	 */
	public static function find($id = null, array $options = array())
	{
		$timestamp_end_name = static::temporal_property('end_column');
		$max_timestamp = static::temporal_property('max_timestamp');

		switch ($id)
		{
			case 'all':
			case 'first':
			case 'last':
				break;
			default:
				$id = (array) $id;
				$count = 0;
				foreach(static::getNonTimestampPks() as $key)
				{
					$options['where'][] = array($key, $id[$count]);

					$count++;
				}
				break;
		}

		$options['where'][] = array($timestamp_end_name, $max_timestamp);

		static::enable_id_only_primary_key();
		$result = parent::find($id, $options);
		static::disable_id_only_primary_key();

		return $result;
	}

	/**
	 * Returns an array of the primary keys that are not related to temporal
	 * timestamp information.
	 */
	public static function getNonTimestampPks()
	{
		$timestamp_start_name = static::temporal_property('start_column');
		$timestamp_end_name = static::temporal_property('end_column');

		$pks = array();
		foreach(parent::primary_key() as $key)
		{
			if ($key != $timestamp_start_name && $key != $timestamp_end_name)
			{
				$pks[] = $key;
			}
		}

		return $pks;
	}

	/**
	 * Overrides the save method to allow temporal models to be
	 * @param boolean $cascade
	 * @param boolean $use_transaction
	 * @param boolean $skip_temporal Skips temporal filtering on initial inserts. Should not be used!
	 * @return boolean
	 */
	public function save($cascade = null, $use_transaction = false)
	{
		// Load temporal properties.
		$timestamp_start_name = static::temporal_property('start_column');
		$timestamp_end_name = static::temporal_property('end_column');
		$mysql_timestamp = static::temporal_property('mysql_timestamp');

		$max_timestamp = static::temporal_property('max_timestamp');
		$current_timestamp = $mysql_timestamp ?
			\Date::forge()->format('mysql') :
			\Date::forge()->get_timestamp();

		// If this is new then just call the parent and let everything happen as normal
		if ($this->is_new())
		{
			static::disable_primary_key_check();
			$this->{$timestamp_start_name} = $current_timestamp;
			$this->{$timestamp_end_name} = $max_timestamp;
			static::enable_primary_key_check();

			// Make sure save will populate the PK
			static::enable_id_only_primary_key();
			$result = parent::save($cascade, $use_transaction);
			static::disable_id_only_primary_key();

			return $result;
		}
		// If this is an update then set a new PK, save and then insert a new row
		else
		{
			$diff = $this->get_diff();

			if (count($diff[0]) > 0)
			{
				// Take a copy of this model
				$revision = clone $this;

				// Give that new model an end time of the current time after resetting back to the old data
				$revision->set($this->_original);

				self::disable_primary_key_check();
				$revision->{$timestamp_end_name} = $current_timestamp;
				self::enable_primary_key_check();

				// Make sure relations stay the same
				$revision->_original_relations = $this->_data_relations;

				// save that, now we have our archive
				self::enable_id_only_primary_key();
				$revision_result = $revision->overwrite(false, $use_transaction);
				self::disable_id_only_primary_key();

				if ( ! $revision_result)
				{
					// If the revision did not save then stop the process so the user can do something.
					return false;
				}

				// Now that the old data is saved update the current object so its end timestamp is now
				self::disable_primary_key_check();
				$this->{$timestamp_start_name} = $current_timestamp;
				self::enable_primary_key_check();

				$result = parent::save($cascade, $use_transaction);

				return $result;
			}
			else
			{
				// If nothing has changed call parent::save() to insure relations are saved too
				return parent::save($cascade, $use_transaction);
			}
		}
	}

	/**
	 * ALlows an entry to be updated without having to insert a new row.
	 * This will not record any changed data as a new revision.
	 *
	 * Takes the same options as Model::save()
	 */
	public function overwrite($cascade = null, $use_transaction = false)
	{
		return parent::save($cascade, $use_transaction);
	}

	/**
	 * Restores the entity to this state.
	 *
	 * @return boolean
	 */
	public function restore()
	{
		$timestamp_end_name = static::temporal_property('end_column');
		$max_timestamp = static::temporal_property('max_timestamp');

		// check to see if there is a currently active row, if so then don't
		// restore anything.
		$activeRow = static::find('first', array(
				'where' => array(
					array('id', $this->id),
					array($timestamp_end_name, $max_timestamp),
				),
			));

		if(is_null($activeRow))
		{
			// No active row was found so we are ok to go and restore the this
			// revision
			$timestamp_start_name = static::temporal_property('start_column');
			$mysql_timestamp = static::temporal_property('mysql_timestamp');

			$max_timestamp = static::temporal_property('max_timestamp');
			$current_timestamp = $mysql_timestamp ?
				\Date::forge()->format('mysql') :
				\Date::forge()->get_timestamp();

			// Make sure this is saved as a new entry
			$this->_is_new = true;

			// Update timestamps
			static::disable_primary_key_check();
			$this->{$timestamp_start_name} = $current_timestamp;
			$this->{$timestamp_end_name} = $max_timestamp;

			// Save
			$result = parent::save();
			static::enable_primary_key_check();

			return $result;
		}

		return false;
	}

	/**
	 * Deletes all revisions of this entity permantly.
	 */
	public function purge()
	{
		// Get a clean query object so there's no temporal filtering
		$query = parent::query();
		// Then select and delete
		return $query->where('id', $this->id)
			->delete();
	}

	/**
	 * Overrides update to remove PK checking when performing an update.
	 */
	public function update()
	{
		static::disable_primary_key_check();
		$result = parent::update();
		static::enable_primary_key_check();

		return $result;
	}

	/**
	 * Allows correct PKs to be added when performing updates
	 *
	 * @param Query $query
	 */
	protected function add_primary_keys_to_where($query)
	{
		$timestamp_start_name = static::temporal_property('start_column');
		$timestamp_end_name = static::temporal_property('end_column');

		$primary_key = array(
			'id',
			$timestamp_start_name,
			$timestamp_end_name,
		);

		foreach ($primary_key as $pk)
		{
			$query->where($pk, '=', $this->_original[$pk]);
		}
	}

	/**
	 * Overrides the parent primary_key method to allow primaray key enforcement
	 * to be turned off when updating a temporal model.
	 */
	public static function primary_key()
	{
		$id_only = static::get_primary_key_id_only_status();
		$pk_status = static::get_primary_key_status();

		if ($id_only)
		{
			return static::getNonTimestampPks();
		}

		if ($pk_status && ! $id_only)
		{
			return static::$_primary_key;
		}

		return array();
	}

	public function delete($cascade = null, $use_transaction = false)
	{
		// If we are using a transcation then make sure it's started
		if ($use_transaction)
		{
			$db = \Database_Connection::instance(static::connection(true));
			$db->start_transaction();
		}

		// Call the observers
		$this->observe('before_delete');

		// Load temporal properties.
		$timestamp_end_name = static::temporal_property('end_column');
		$mysql_timestamp = static::temporal_property('mysql_timestamp');

		// Generate the correct timestamp and save it
		$current_timestamp = $mysql_timestamp ?
			\Date::forge()->format('mysql') :
			\Date::forge()->get_timestamp();

		static::disable_primary_key_check();
		$this->{$timestamp_end_name} = $current_timestamp;
		static::enable_primary_key_check();

		// Loop through all relations and delete if we are cascading.
		$this->freeze();
		foreach ($this->relations() as $rel_name => $rel)
		{
			// get the cascade delete status
			$relCascade = is_null($cascade) ? $rel->cascade_delete : (bool) $cascade;

			if ($relCascade)
			{
				if(get_class($rel) != 'Orm\ManyMany')
				{
					// Loop through and call delete on all the models
					foreach($rel->get($this) as $model)
					{
						$model->delete($cascade);
					}
				}
			}
		}
		$this->unfreeze();

		parent::save();

		$this->observe('after_delete');

		// Make sure the transaction is committed if needed
		$use_transaction and $db->commit_transaction();

		return $this;
	}

	/**
	 * Disables PK checking
	 */
	private static function disable_primary_key_check()
	{
		$class = get_called_class();
		self::$_pk_check_disabled[$class] = false;
	}

	/**
	 * Enables PK checking
	 */
	private static function enable_primary_key_check()
	{
		$class = get_called_class();
		self::$_pk_check_disabled[$class] = true;
	}

	/**
	 * Returns true if the PK checking should be performed. Defaults to true
	 */
	private static function get_primary_key_status()
	{
		$class = get_called_class();
		return \Arr::get(self::$_pk_check_disabled, $class, true);
	}

	/**
	 * Returns true if the PK should only contain the ID. Defaults to false
	 */
	private static function get_primary_key_id_only_status()
	{
		$class = get_called_class();
		return \Arr::get(self::$_pk_id_only, $class, false);
	}

	/**
	 * Makes all PKs returned
	 */
	private static function disable_id_only_primary_key()
	{
		$class = get_called_class();
		self::$_pk_id_only[$class] = false;
	}

	/**
	 * Makes only id returned as PK
	 */
	private static function enable_id_only_primary_key()
	{
		$class = get_called_class();
		self::$_pk_id_only[$class] = true;
	}

}
