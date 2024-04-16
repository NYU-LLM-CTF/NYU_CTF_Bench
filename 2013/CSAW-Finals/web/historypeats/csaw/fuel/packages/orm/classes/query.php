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
 * ORM query object.
 */
class Query
{
	/**
	 * Create a new instance of the Query class.
	 *
	 * @param	string  $model      name of the model this instance has to operate on
	 * @param	mixed   $connection DB connection to use to run the query
	 * @param	array   $options    any options to pass on to the query
	 *
	 * @return	Query	newly created instance
	 */
	public static function forge($model, $connection = null, $options = array())
	{
		return new static($model, $connection, $options);
	}

	/**
	 * @var  string  classname of the model
	 */
	protected $model;

	/**
	 * @var  null|string  connection name to use
	 */
	protected $connection;

	/**
	 * @var  null|string  connection name to use for writes
	 */
	protected $write_connection;

	/**
	 * @var  array  database view to use with keys 'view' and 'columns'
	 */
	protected $view;

	/**
	 * @var  string  table alias
	 */
	protected $alias = 't0';

	/**
	 * @var  array  relations to join on
	 */
	protected $relations = array();

	/**
	 * @var  array  tables to join without returning any info
	 */
	protected $joins = array();

	/**
	 * @var  array  fields to select
	 */
	protected $select = array();

	/**
	 * @var  int  max number of returned base model instances
	 */
	protected $limit;

	/**
	 * @var  int  offset of base model table
	 */
	protected $offset;

	/**
	 * @var  int  max number of requested rows
	 */
	protected $rows_limit;

	/**
	 * @var  int  offset of requested rows
	 */
	protected $rows_offset;

	/**
	 * @var  array  where conditions
	 */
	protected $where = array();

	/**
	 * @var  array  order by clauses
	 */
	protected $order_by = array();

	/**
	 * @var  array  group by clauses
	 */
	protected $group_by = array();

	/**
	 * @var  array  values for insert or update
	 */
	protected $values = array();

	/**
	 * @var  array  select filters
	 */
	protected $select_filter = array();

	/**
	 * @var  bool  whether or not to retrieve a cached object
	 */
	protected $from_cache = true;

	/**
	 * Create a new instance of the Query class.
	 *
	 * @param	string  $model        Name of the model this instance has to operate on
	 * @param	mixed   $connection   DB connection to use to run the query
	 * @param	array   $options      Any options to pass on to the query
	 * @param	mixed   $table_alias  Optionally, the alias to use for the models table
	 */
	protected function __construct($model, $connection, $options, $table_alias = null)
	{
		$this->model = $model;

		if (is_array($connection))
		{
			list($this->connection, $this->write_connection) = $connection;
		}
		else
		{
			$this->connection = $connection;
			$this->write_connection = $connection;
		}

		foreach ($options as $opt => $val)
		{
			switch ($opt)
			{
				case 'select':
					$val = (array) $val;
					call_fuel_func_array(array($this, 'select'), $val);
					break;
				case 'related':
					$val = (array) $val;
					$this->related($val);
					break;
				case 'use_view':
					$this->use_view($val);
					break;
				case 'or_where':
					$this->and_where_open();
					foreach ($val as $where)
					{
						call_fuel_func_array(array($this, '_where'), array($where, 'or_where'));
					}
					$this->and_where_close();
					break;
				case 'where':
					$this->_parse_where_array($val);
					break;
				case 'order_by':
					$val = (array) $val;
					$this->order_by($val);
					break;
				case 'group_by':
					call_fuel_func_array(array($this, 'group_by'), $val);
					break;
				case 'limit':
					$this->limit($val);
					break;
				case 'offset':
					$this->offset($val);
					break;
				case 'rows_limit':
					$this->rows_limit($val);
					break;
				case 'rows_offset':
					$this->rows_offset($val);
					break;
				case 'from_cache':
					$this->from_cache($val);
					break;
			}
		}
	}

	/**
	 * Enables or disables the object cache for this query
	 *
	 * @param  bool  $cache    Whether or not to use the object cache on this query
	 *
	 * @return  Query
	 */
	public function from_cache($cache = true)
	{
		$this->from_cache = (bool) $cache;

		return $this;
	}

	/**
	 * Select which properties are included, each as its own param. Or don't give input to retrieve
	 * the current selection.
	 *
	 * @param bool          $add_pks    Whether or not to add the Primary Keys to the list of selected columns
	 * @param string|array  $fields     Optionally. Which field/fields must be retrieved
	 *
	 * @throws \FuelException No properties found in model
	 *
	 * @return  void|array
	 */
	public function select($add_pks = true)
	{
		$fields = func_get_args();

		if (empty($fields) or is_bool($add_pks))
		{
			if (empty($this->select))
			{
				$fields = array_keys(call_user_func($this->model.'::properties'));

				if (empty($fields))
				{
					throw new \FuelException('No properties found in model.');
				}
				foreach ($fields as $field)
				{
					in_array($field, $this->select_filter) or $this->select($field);
				}

				if ($this->view)
				{
					foreach ($this->view['columns'] as $field)
					{
						$this->select($field);
					}
				}
			}

			// backup select before adding PKs
			$select = $this->select;

			// ensure all PKs are being selected
			if ($add_pks)
			{
				$pks = call_user_func($this->model.'::primary_key');
				foreach($pks as $pk)
				{
					if ( ! in_array($this->alias.'.'.$pk, $this->select))
					{
						$this->select($pk);
					}
				}
			}

			// convert selection array for DB class
			$out = array();
			foreach($this->select as $k => $v)
			{
				$out[] = array($v, $k);
			}

			// set select back to before the PKs were added
			$this->select = $select;

			return $out;
		}

		$i = count($this->select);
		foreach ($fields as $val)
		{
			is_array($val) or $val = array($val => true);

			foreach ($val as $field => $include)
			{
				if ($include)
				{
					$this->select[$this->alias.'_c'.$i++] = (strpos($field, '.') === false ? $this->alias.'.' : '').$field;
				}
				else
				{
					$this->select_filter[] = $field;
				}
			}
		}

		return $this;
	}

	/**
	 * Set a view to use instead of the table
	 *
	 * @param  string   $view   Name of view which you want to use
	 *
	 * @throws \OutOfBoundsException Cannot use undefined database view, must be defined with Model
	 *
	 * @return  Query
	 */
	public function use_view($view)
	{
		$views = call_user_func(array($this->model, 'views'));
		if ( ! array_key_exists($view, $views))
		{
			throw new \OutOfBoundsException('Cannot use undefined database view, must be defined with Model.');
		}

		$this->view = $views[$view];
		$this->view['_name'] = $view;
		return $this;
	}

	/**
	 * Creates a "GROUP BY ..." filter.
	 *
	 * @param   mixed   $coulmns    Column name or array($column, $alias) or object
	 * @return  $this
	 */
	public function group_by()
	{
		$columns = func_get_args();

		$this->group_by = array_merge($this->group_by, $columns);

		return $this;
	}

	/**
	 * Set the limit
	 *
	 * @param   int $limit
	 *
	 * @return  $this
	 */
	public function limit($limit)
	{
		$this->limit = intval($limit);

		return $this;
	}

	/**
	 * Set the offset
	 *
	 * @param   int $offset
	 *
	 * @return  $this
	 */
	public function offset($offset)
	{
		$this->offset = intval($offset);

		return $this;
	}

	/**
	 * Set the limit of rows requested
	 *
	 * @param   int $limit
	 *
	 * @return  $this
	 */
	public function rows_limit($limit)
	{
		$this->rows_limit = intval($limit);

		return $this;
	}

	/**
	 * Set the offset of rows requested
	 *
	 * @param   int $offset
	 *
	 * @return  $this
	 */
	public function rows_offset($offset)
	{
		$this->rows_offset = intval($offset);

		return $this;
	}

	/**
	 * Set where condition
	 *
	 * @param   string  Property
	 * @param   string  Comparison type (can be omitted)
	 * @param   string  Comparison value
	 *
	 * @return  $this
	 */
	public function where()
	{
		$condition = func_get_args();
		is_array(reset($condition)) and $condition = reset($condition);

		return $this->_where($condition);
	}

	/**
	 * Set or_where condition
	 *
	 * @param   string  Property
	 * @param   string  Comparison type (can be omitted)
	 * @param   string  Comparison value
	 *
	 * @return  $this
	 */
	public function or_where()
	{
		$condition = func_get_args();
		is_array(reset($condition)) and $condition = reset($condition);

		return $this->_where($condition, 'or_where');
	}

	/**
	 * Does the work for where() and or_where()
	 *
	 * @param   array   $condition
	 * @param   string  $type
	 *
	 * @throws \FuelException
	 *
	 * @return  $this
	 */
	public function _where($condition, $type = 'and_where')
	{
		if (is_array(reset($condition)) or is_string(key($condition)))
		{
			foreach ($condition as $k_c => $v_c)
			{
				is_string($k_c) and $v_c = array($k_c, $v_c);
				$this->_where($v_c, $type);
			}
			return $this;
		}

		// prefix table alias when not yet prefixed and not a DB expression object
		if (strpos($condition[0], '.') === false and ! $condition[0] instanceof \Fuel\Core\Database_Expression)
		{
			$condition[0] = $this->alias.'.'.$condition[0];
		}

		if (count($condition) == 2)
		{
			$this->where[] = array($type, array($condition[0], '=', $condition[1]));
		}
		elseif (count($condition) == 3)
		{
			$this->where[] = array($type, $condition);
		}
		else
		{
			throw new \FuelException('Invalid param count for where condition.');
		}

		return $this;
	}

	/**
	 * Open a nested and_where condition
	 *
	 * @return  $this
	 */
	public function and_where_open()
	{
		$this->where[] = array('and_where_open', array());

		return $this;
	}

	/**
	 * Close a nested and_where condition
	 *
	 * @return  $this
	 */
	public function and_where_close()
	{
		$this->where[] = array('and_where_close', array());

		return $this;
	}

	/**
	 * Alias to and_where_open()
	 *
	 * @return  $this
	 */
	public function where_open()
	{
		$this->where[] = array('and_where_open', array());

		return $this;
	}

	/**
	 * Alias to and_where_close()
	 *
	 * @return  $this
	 */
	public function where_close()
	{
		$this->where[] = array('and_where_close', array());

		return $this;
	}

	/**
	 * Open a nested or_where condition
	 *
	 * @return  $this
	 */
	public function or_where_open()
	{
		$this->where[] = array('or_where_open', array());

		return $this;
	}

	/**
	 * Close a nested or_where condition
	 *
	 * @return  $this
	 */
	public function or_where_close()
	{
		$this->where[] = array('or_where_close', array());

		return $this;
	}

	/**
	 * Parses an array of where conditions into the query
	 *
	 * @param   array   $val
	 * @param   string  $base
	 * @param   bool    $or
	 */
	protected function _parse_where_array(array $val, $base = '', $or = false)
	{
		$or and $this->or_where_open();
		foreach ($val as $k_w => $v_w)
		{
			if (is_array($v_w) and ! empty($v_w[0]) and is_string($v_w[0]))
			{
				! $v_w[0] instanceof \Database_Expression and strpos($v_w[0], '.') === false and $v_w[0] = $base.$v_w[0];
				call_fuel_func_array(array($this, ($k_w === 'or' ? 'or_' : '').'where'), $v_w);
			}
			elseif (is_int($k_w) or $k_w == 'or')
			{
				$k_w === 'or' ? $this->or_where_open() : $this->where_open();
				$this->_parse_where_array($v_w, $base, $k_w === 'or');
				$k_w === 'or' ? $this->or_where_close() : $this->where_close();
			}
			else
			{
				! $k_w instanceof \Database_Expression and strpos($k_w, '.') === false and $k_w = $base.$k_w;
				$this->where($k_w, $v_w);
			}
		}
		$or and $this->or_where_close();
	}

	/**
	 * Set the order_by
	 *
	 * @param   string|array  $property
	 * @param   string        $direction
	 *
	 * @return  $this
	 */
	public function order_by($property, $direction = 'ASC')
	{
		if (is_array($property))
		{
			foreach ($property as $p => $d)
			{
				if (is_int($p))
				{
					is_array($d) ? $this->order_by($d[0], $d[1]) : $this->order_by($d, $direction);
				}
				else
				{
					$this->order_by($p, $d);
				}
			}
			return $this;
		}

		// prefix table alias when not yet prefixed and not a DB expression object
		if ( ! $property instanceof \Fuel\Core\Database_Expression and strpos($property, '.') === false)
		{
			$property = $this->alias.'.'.$property;
		}

		$this->order_by[] = array($property, $direction);

		return $this;
	}

	/**
	 * Set a relation to include
	 *
	 * @param   string  $relation
	 * @param   array   $conditions    Optionally
	 *
	 * @throws \UnexpectedValueException Relation was not found in the model
	 *
	 * @return  $this
	 */
	public function related($relation, $conditions = array())
	{
		if (is_array($relation))
		{
			foreach ($relation as $k_r => $v_r)
			{
				is_array($v_r) ? $this->related($k_r, $v_r) : $this->related($v_r);
			}
			return $this;
		}

		if (strpos($relation, '.'))
		{
			$rels = explode('.', $relation);
			$model = $this->model;
			foreach ($rels as $r)
			{
				$rel = call_user_func(array($model, 'relations'), $r);
				if (empty($rel))
				{
					throw new \UnexpectedValueException('Relation "'.$r.'" was not found in the model "'.$model.'".');
				}
				$model = $rel->model_to;
			}
		}
		else
		{
			$rel = call_user_func(array($this->model, 'relations'), $relation);
			if (empty($rel))
			{
				throw new \UnexpectedValueException('Relation "'.$relation.'" was not found in the model.');
			}
		}

		$this->relations[$relation] = array($rel, $conditions);

		if ( ! empty($conditions['related']))
		{
			$conditions['related'] = (array) $conditions['related'];
			foreach ($conditions['related'] as $k_r => $v_r)
			{
				is_array($v_r) ? $this->related($relation.'.'.$k_r, $v_r) : $this->related($relation.'.'.$v_r);
			}

			unset($conditions['related']);
		}

		return $this;
	}

	/**
	 * Add a table to join, consider this a protect method only for Orm package usage
	 *
	 * @param   array   $join
	 *
	 * @return  $this
	 */
	public function _join(array $join)
	{
		$this->joins[] = $join;

		return $this;
	}

	/**
	 * Set any properties for insert or update
	 *
	 * @param   string|array  $property
	 * @param   mixed         $value    Optionally
	 *
	 * @return  $this
	 */
	public function set($property, $value = null)
	{
		if (is_array($property))
		{
			foreach ($property as $p => $v)
			{
				$this->set($p, $v);
			}
			return $this;
		}

		$this->values[$property] = $value;

		return $this;
	}

	/**
	 * Build a select, delete or update query
	 *
	 * @param   \Fuel\Core\Database_Query_Builder_Where  DB where() query object
	 * @param   array $columns  Optionally
	 * @param   string $type    Type of query to build (select/update/delete/insert)
	 *
	 * @throws \FuelException            Models cannot be related between different database connections
	 * @throws \UnexpectedValueException Trying to get the relation of an unloaded relation
	 *
	 * @return  array          with keys query and relations
	 */
	public function build_query(\Fuel\Core\Database_Query_Builder_Where $query, $columns = array(), $type = 'select')
	{
		// Get the limit
		if ( ! is_null($this->limit))
		{
			$query->limit($this->limit);
		}

		// Get the offset
		if ( ! is_null($this->offset))
		{
			$query->offset($this->offset);
		}

		$where_conditions = call_user_func($this->model.'::condition', 'where');
		empty($where_conditions) or $this->where($where_conditions);

		$where_backup = $this->where;
		if ( ! empty($this->where))
		{
			$open_nests = 0;
			$where_nested = array();
			$include_nested = true;
			foreach ($this->where as $key => $w)
			{
				list($method, $conditional) = $w;

				if ($type == 'select' and (empty($conditional) or $open_nests > 0))
				{
					$include_nested and $where_nested[$key] = $w;
					if ( ! empty($conditional) and strpos($conditional[0], $this->alias.'.') !== 0)
					{
						$include_nested = false;
					}
					strpos($method, '_open') and $open_nests++;
					strpos($method, '_close') and $open_nests--;
					continue;
				}

				if (empty($conditional)
					or strpos($conditional[0], $this->alias.'.') === 0
					or ($type != 'select' and $conditional[0] instanceof \Fuel\Core\Database_Expression))
				{
					if ($type != 'select' and ! empty($conditional)
						and ! $conditional[0] instanceof \Fuel\Core\Database_Expression)
					{
						$conditional[0] = substr($conditional[0], strlen($this->alias.'.'));
					}
					call_fuel_func_array(array($query, $method), $conditional);
					unset($this->where[$key]);
				}
			}

			if ($include_nested and ! empty($where_nested))
			{
				foreach ($where_nested as $key => $w)
				{
					list($method, $conditional) = $w;

					if (empty($conditional)
						or strpos($conditional[0], $this->alias.'.') === 0
						or ($type != 'select' and $conditional[0] instanceof \Fuel\Core\Database_Expression))
					{
						if ($type != 'select' and ! empty($conditional)
							and ! $conditional[0] instanceof \Fuel\Core\Database_Expression)
						{
							$conditional[0] = substr($conditional[0], strlen($this->alias.'.'));
						}
						call_fuel_func_array(array($query, $method), $conditional);
						unset($this->where[$key]);
					}
				}
			}
		}

		// If it's not a select we're done
		if ($type != 'select')
		{
			return array('query' => $query, 'models' => array());
		}

		$i = 1;
		$models = array();
		foreach ($this->relations as $name => $rel)
		{
			// when there's a dot it must be a nested relation
			if ($pos = strrpos($name, '.'))
			{
				if (empty($models[substr($name, 0, $pos)]['table'][1]))
				{
					throw new \UnexpectedValueException('Trying to get the relation of an unloaded relation, make sure you load the parent relation before any of its children.');
				}

				$alias = $models[substr($name, 0, $pos)]['table'][1];
			}
			else
			{
				$alias = $this->alias;
			}

			$join = $rel[0]->join($alias, $name, $i++, $rel[1]);
			$models = array_merge($models, $this->modify_join_result($join, $name));
		}

		// if no order_by was given, see if a default was defined in the model
		empty($this->order_by) and $this->order_by(call_user_func($this->model.'::condition', 'order_by'));

		if ($this->use_subquery())
		{
			// Get the columns for final select
			foreach ($models as $m)
			{
				foreach ($m['columns'] as $c)
				{
					$columns[] = $c;
				}
			}

			// do we need to add order_by clauses on the subquery?
			foreach ($this->order_by as $idx => $ob)
			{
				if ( ! $ob[0] instanceof \Fuel\Core\Database_Expression)
				{
					if (strpos($ob[0], $this->alias.'.') === 0)
					{
						// order by on the current model
						$type == 'select' or $ob[0] = substr($ob[0], strlen($this->alias.'.'));
						$query->order_by($ob[0], $ob[1]);
					}
				}
			}

			// make current query subquery of ultimate query
			$new_query = call_fuel_func_array('DB::select', $columns);
			$query = $new_query->from(array($query, $this->alias));
		}
		else
		{
			// add additional selected columns
			foreach ($models as $m)
			{
				foreach ($m['columns'] as $c)
				{
					$query->select($c);
				}
			}
		}

		// join tables
		foreach ($this->joins as $j)
		{
			$join_query = $query->join($j['table'], $j['join_type']);
			foreach ($j['join_on'] as $on)
			{
				$join_query->on($on[0], $on[1], $on[2]);
			}
		}
		foreach ($models as $m)
		{
			if (($type == 'select' and $m['connection'] != $this->connection) or
				($type != 'select' and $m['connection'] != $this->write_connection))
			{
				throw new \FuelException('Models cannot be related between different database connections.');
			}

			$join_query = $query->join($m['table'], $m['join_type']);
			foreach ($m['join_on'] as $on)
			{
				$join_query->on($on[0], $on[1], $on[2]);
			}
		}

		// Get the order, if none set see if we have an order_by condition set
		$order_by = $order_by_backup = $this->order_by;

		// Add any additional order_by and where clauses from the relations
		foreach ($models as $m_name => $m)
		{
			if ( ! empty($m['order_by']))
			{
				foreach ((array) $m['order_by'] as $k_ob => $v_ob)
				{
					if (is_int($k_ob))
					{
						$v_dir = is_array($v_ob) ? $v_ob[1] : 'ASC';
						$v_ob = is_array($v_ob) ? $v_ob[0] : $v_ob;
						if ( ! $v_ob instanceof \Fuel\Core\Database_Expression and strpos($v_ob, '.') === false)
						{
							$v_ob = $m_name.'.'.$v_ob;
						}

						$order_by[] = array($v_ob, $v_dir);
					}
					else
					{
						strpos($k_ob, '.') === false and $k_ob = $m_name.'.'.$k_ob;
						$order_by[] = array($k_ob, $v_ob);
					}
				}
			}
			if ( ! empty($m['where']))
			{
				$this->_parse_where_array($m['where'], $m_name.'.');
			}
		}

		// Get the order
		if ( ! empty($order_by))
		{
			foreach ($order_by as $ob)
			{
				if ( ! $ob[0] instanceof \Fuel\Core\Database_Expression)
				{
					if (strpos($ob[0], $this->alias.'.') === 0)
					{
						// order by on the current model
						$type == 'select' or $ob[0] = substr($ob[0], strlen($this->alias.'.'));
					}
					else
					{
						// try to rewrite conditions on the relations to their table alias
						$dotpos = strrpos($ob[0], '.');
						$relation = substr($ob[0], 0, $dotpos);
						if ($dotpos > 0 and array_key_exists($relation, $models))
						{
							$ob[0] = $models[$relation]['table'][1].substr($ob[0], $dotpos);
						}
					}
				}
				$query->order_by($ob[0], $ob[1]);
			}
		}

		// Get the grouping
		if ( ! empty($this->group_by))
		{
			foreach ($this->group_by as $gb)
			{
				if ( ! $gb instanceof \Fuel\Core\Database_Expression)
				{
					if (strpos($gb, $this->alias.'.') === false)
					{
						// try to rewrite on the relations to their table alias
						$dotpos = strrpos($gb, '.');
						$relation = substr($gb, 0, $dotpos);
						if ($dotpos > 0)
						{
							if(array_key_exists($relation, $models))
							{
								$gb = $models[$relation]['table'][1].substr($gb, $dotpos);
							}
						}
						else
						{
							$gb = $this->alias.'.'.$gb;
						}
					}
				}
				$query->group_by($gb);
			}
		}

		// put omitted where conditions back
		if ( ! empty($this->where))
		{
			foreach ($this->where as $w)
			{
				list($method, $conditional) = $w;

				// try to rewrite conditions on the relations to their table alias
				if ( ! empty($conditional))
				{
					$dotpos = strrpos($conditional[0], '.');
					$relation = substr($conditional[0], 0, $dotpos);
					if ($dotpos > 0 and array_key_exists($relation, $models))
					{
						$conditional[0] = $models[$relation]['table'][1].substr($conditional[0], $dotpos);
					}
				}

				call_fuel_func_array(array($query, $method), $conditional);
			}
		}

		$this->where = $where_backup;
		$this->order_by = $order_by_backup;

		// Set the row limit and offset, these are applied to the outer query when a subquery
		// is used or overwrite limit/offset when it's a normal query
		! is_null($this->rows_limit) and $query->limit($this->rows_limit);
		! is_null($this->rows_offset) and $query->offset($this->rows_offset);

		return array('query' => $query, 'models' => $models);
	}

	/**
	 * Allows subclasses to make changes to the join information before it is used
	 */
	protected function modify_join_result($join_result, $name)
	{
		return $join_result;
	}

	/**
	 * Determines whether a subquery is needed, is the case if there was a limit/offset on a join
	 *
	 * @return  bool
	 */
	public function use_subquery()
	{
		return ( ! empty($this->relations) and ( ! empty($this->limit) or ! empty($this->offset)));
	}

	/**
	 * Hydrate model instances with retrieved data
	 *
	 * @param   array   &$row   Row from the database
	 * @param   array   $models Relations to be expected
	 * @param   array   $result Current result array (by reference)
	 * @param   string  $model  Optionally. Model classname to hydrate
	 * @param   array   $select Optionally. Columns to use
	 * @param   array   $primary_key    Optionally. Primary key(s) for this model
	 *
	 * @return  Model
	 */
	public function hydrate(&$row, $models, &$result, $model = null, $select = null, $primary_key = null)
	{
		// First check the PKs, if null it's an empty row
		$r1c1    = reset($select);
		$prefix  = substr($r1c1[0], 0, strpos($r1c1[0], '.') + 1);
		$obj     = array();
		foreach ($primary_key as $pk)
		{
			$pk_c = null;
			foreach ($select as $s)
			{
				$s[0] === $prefix.$pk and $pk_c = $s[1];
			}

			if (is_null($row[$pk_c]))
			{
				return false;
			}
			$obj[$pk] = $row[$pk_c];
		}

		// Check for cached object
		$pk  = count($primary_key) == 1 ? reset($obj) : '['.implode('][', $obj).']';
		$obj = $this->from_cache ? Model::cached_object($pk, $model) : false;

		// Create the object when it wasn't found
		if ( ! $obj)
		{
			// Retrieve the object array from the row
			$obj = array();
			foreach ($select as $s)
			{
				$f = substr($s[0], strpos($s[0], '.') + 1);
				$obj[$f] = $row[$s[1]];
				if (in_array($f, $primary_key))
				{
					$obj[$f] = \Orm\Observer_Typing::typecast($f, $obj[$f], call_user_func($model.'::property', $f));
				}
				unset($row[$s[1]]);
			}
			$obj = $model::forge($obj, false, $this->view ? $this->view['_name'] : null, $this->from_cache);
		}
		else
		{
			// add fields not present in the already cached version
			foreach ($select as $s)
			{
				$f = substr($s[0], strpos($s[0], '.') + 1);
				if ( ! isset($obj->{$f}))
				{
					$obj->{$f} = $row[$s[1]];
				}
			}
		}

		// if the result to be generated is an array and the current object is not yet in there
		if (is_array($result) and ! array_key_exists($pk, $result))
		{
			$result[$pk] = $obj;
		}
		// if the result to be generated is a single object and empty
		elseif ( ! is_array($result) and empty($result))
		{
			$result = $obj;
		}

		// start fetching relationships
		$rel_objs = $obj->_relate();
		foreach ($models as $m)
		{
			// when the expected model is empty, there's nothing to be done
			if (empty($m['model']))
			{
				continue;
			}

			// when not yet set, create the relation result var with null or array
			if ( ! array_key_exists($m['rel_name'], $rel_objs))
			{
				$rel_objs[$m['rel_name']] = $m['relation']->singular ? null : array();
			}

			// when result is array or singular empty, try to fetch the new relation from the row
			$this->hydrate(
				$row,
				! empty($m['models']) ? $m['models'] : array(),
				$rel_objs[$m['rel_name']],
				$m['model'],
				$m['columns'],
				$m['primary_key']
			);
		}

		// attach the retrieved relations to the object and update its original DB values
		$obj->_relate($rel_objs);
		$obj->_update_original_relations();

		return $obj;
	}

	/**
	 * Build the query and return hydrated results
	 *
	 * @return  array
	 */
	public function get()
	{
		// Get the columns
		$columns = $this->select();

		// Start building the query
		$select = $columns;
		if ($this->use_subquery())
		{
			$select = array();
			foreach ($columns as $c)
			{
				$select[] = $c[0];
			}
		}
		$query = call_fuel_func_array('DB::select', $select);

		// Set from view/table
		$query->from(array($this->_table(), $this->alias));

		// Build the query further
		$tmp     = $this->build_query($query, $columns);
		$query   = $tmp['query'];
		$models  = $tmp['models'];

		// Make models hierarchical
		foreach ($models as $name => $values)
		{
			if (strpos($name, '.'))
			{
				unset($models[$name]);
				$rels = explode('.', $name);
				$ref =& $models[array_shift($rels)];
				foreach ($rels as $rel)
				{
					empty($ref['models']) and $ref['models'] = array();
					empty($ref['models'][$rel]) and $ref['models'][$rel] = array();
					$ref =& $ref['models'][$rel];
				}
				$ref = $values;
			}
		}

		$rows = $query->execute($this->connection)->as_array();
		$result = array();
		$model = $this->model;
		$select = $this->select();
		$primary_key = $model::primary_key();
		foreach ($rows as $id => $row)
		{
			$this->hydrate($row, $models, $result, $model, $select, $primary_key);
			unset($rows[$id]);
		}

		// It's all built, now lets execute and start hydration
		return $result;
	}

	/**
	 * Get the Query as it's been build up to this point and return it as an object
	 *
	 * @return  Database_Query
	 */
	public function get_query()
	{
		// Get the columns
		$columns = $this->select(false);

		// Start building the query
		$select = $columns;
		if ($this->use_subquery())
		{
			$select = array();
			foreach ($columns as $c)
			{
				$select[] = $c[0];
			}
		}
		$query = call_fuel_func_array('DB::select', $select);

		// Set from table
		$query->from(array($this->_table(), $this->alias));

		// Build the query further
		$tmp     = $this->build_query($query, $columns);

		return $tmp['query'];
	}

	/**
	 * Build the query and return single object hydrated
	 *
	 * @return  Model
	 */
	public function get_one()
	{
		// save the current limits
		$limit = $this->limit;
		$rows_limit = $this->rows_limit;

		if ($this->rows_limit !== null)
		{
			$this->limit = null;
			$this->rows_limit = 1;
		}
		else
		{
			$this->limit = 1;
			$this->rows_limit = null;
		}

		// get the result using normal find
		$result = $this->get();

		// put back the old limits
		$this->limit = $limit;
		$this->rows_limit = $rows_limit;

		return $result ? reset($result) : null;
	}

	/**
	 * Count the result of a query
	 *
	 * @param   bool  $column   False for random selected column or specific column, only works for main model currently
	 * @param   bool  $distinct True if DISTINCT has to be aded to the query
	 *
	 * @return  mixed   number of rows OR false
	 */
	public function count($column = null, $distinct = true)
	{
		$select = $column ?: \Arr::get(call_user_func($this->model.'::primary_key'), 0);
		$select = (strpos($select, '.') === false ? $this->alias.'.'.$select : $select);

		// Get the columns
		$columns = \DB::expr('COUNT('.($distinct ? 'DISTINCT ' : '').
			\Database_Connection::instance($this->connection)->quote_identifier($select).
			') AS count_result');

		// Remove the current select and
		$query = \DB::select($columns);

		// Set from view or table
		$query->from(array($this->_table(), $this->alias));

		$tmp   = $this->build_query($query, $columns, 'select');
		$query = $tmp['query'];
		$count = $query->execute($this->connection)->get('count_result');

		// Database_Result::get('count_result') returns a string | null
		if ($count === null)
		{
			return false;
		}

		return (int) $count;
	}

	/**
	 * Get the maximum of a column for the current query
	 *
	 * @param   string      $column Column
	 * @return  bool|int    maximum value OR false
	 */
	public function max($column)
	{
		is_array($column) and $column = array_shift($column);

		// Get the columns
		$columns = \DB::expr('MAX('.
			\Database_Connection::instance($this->connection)->quote_identifier($this->alias.'.'.$column).
			') AS max_result');

		// Remove the current select and
		$query = \DB::select($columns);

		// Set from table
		$query->from(array($this->_table(), $this->alias));

		$tmp   = $this->build_query($query, $columns, 'max');
		$query = $tmp['query'];
		$max   = $query->execute($this->connection)->get('max_result');

		// Database_Result::get('max_result') returns a string | null
		if ($max === null)
		{
			return false;
		}

		return $max;
	}

	/**
	 * Get the minimum of a column for the current query
	 *
	 * @param   string      $column Column which min value you want to get
	 *
	 * @return  bool|int    minimum value OR false
	 */
	public function min($column)
	{
		is_array($column) and $column = array_shift($column);

		// Get the columns
		$columns = \DB::expr('MIN('.
			\Database_Connection::instance($this->connection)->quote_identifier($this->alias.'.'.$column).
			') AS min_result');

		// Remove the current select and
		$query = \DB::select($columns);

		// Set from table
		$query->from(array($this->_table(), $this->alias));

		$tmp   = $this->build_query($query, $columns, 'min');
		$query = $tmp['query'];
		$min   = $query->execute($this->connection)->get('min_result');

		// Database_Result::get('min_result') returns a string | null
		if ($min === null)
		{
			return false;
		}

		return $min;
	}

	/**
	 * Run INSERT with the current values
	 *
	 * @return  bool|int    Last inserted ID (if present) or false on failure
	 */
	public function insert()
	{
		$res = \DB::insert(call_user_func($this->model.'::table'), array_keys($this->values))
			->values(array_values($this->values))
			->execute($this->write_connection);

		// Failed to save the new record
		if ($res[1] === 0)
		{
			return false;
		}

		return $res[0];
	}

	/**
	 * Run UPDATE with the current values
	 *
	 * @return  bool  success of update operation
	 */
	public function update()
	{
		// temporary disable relations
		$tmp_relations   = $this->relations;
		$this->relations = array();

		// Build query and execute update
		$query = \DB::update(call_user_func($this->model.'::table'));
		$tmp   = $this->build_query($query, array(), 'update');
		$query = $tmp['query'];
		$res = $query->set($this->values)->execute($this->write_connection);

		// put back any relations settings
		$this->relations = $tmp_relations;

		// Update can affect 0 rows when input types are different but outcome stays the same
		return $res >= 0;
	}

	/**
	 * Run DELETE with the current values
	 *
	 * @return  bool  success of delete operation
	 */
	public function delete()
	{
		// temporary disable relations
		$tmp_relations   = $this->relations;
		$this->relations = array();

		// Build query and execute update
		$query = \DB::delete(call_user_func($this->model.'::table'));
		$tmp   = $this->build_query($query, array(), 'delete');
		$query = $tmp['query'];
		$res = $query->execute($this->write_connection);

		// put back any relations settings
		$this->relations = $tmp_relations;

		return $res > 0;
	}

	/**
	 * Returns target table (or view, if specified).
	 */
	protected function _table()
	{
		return $this->view ? $this->view['view'] : call_user_func($this->model.'::table');
	}
}
