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
 * Implements NestedSets (http://en.wikipedia.org/wiki/Nested_set_model)
 *
 * Some design ideas borrowed from https://github.com/hubspace/fuel-nestedset
 * (see http://fuelphp.com/forums/discussion/12206/fuel-nested-sets)
 */
class Model_Nestedset extends Model
{
	/*
	 * @var  array  tree configuration for this model
	 */
	// protected static $_tree = array();

	/**
	 * @var  array  cached tree configurations
	 */
	protected static $_tree_cached = array();

	/*
	 * @var  array  nestedset tree configuration defaults
	 */
	protected static $_defaults = array(
		'left_field'     => 'left_id',		// name of the tree node left index field
		'right_field'    => 'right_id',		// name of the tree node right index field
		'tree_field'     => null,			// name of the tree node tree index field
		'title_field'    => null,			// value of the tree node title field
		'read-only'      => array(),		// list of properties to protect against direct updates
	);

	// -------------------------------------------------------------------------
	// tree configuration
	// -------------------------------------------------------------------------

	/**
	 * Get a tree configuration parameter
	 *
	 * @param  string  name of the parameter to get
	 * @return  mixed  parameter value, or null if the parameter does not exist
	 */
	public static function tree_config($name = null)
	{
		$class = get_called_class();

		// configuration not loaded yet
		if ( ! array_key_exists($class, static::$_tree_cached))
		{
			// do we have a custom config for this model?
			if (property_exists($class, '_tree'))
			{
				static::$_tree_cached[$class] = array_merge(static::$_defaults, static::$_tree);
			}
			else
			{
				static::$_tree_cached[$class] = static::$_defaults;
			}

			// array of read-only column names, the can not be set manually
			foreach(array('left_field','right_field','tree_field') as $field)
			{
				$column = static::tree_config($field) and static::$_tree_cached[$class]['read-only'][] = $column;
			}
		}

		if (func_num_args() == 0)
		{
			return static::$_tree_cached[$class];
		}
		else
		{
			return array_key_exists($name, static::$_tree_cached[$class]) ? static::$_tree_cached[$class][$name] :  null;
		}
	}

	// -------------------------------------------------------------------------
	// updated constructor, capture un-supported compound PK's
	// -------------------------------------------------------------------------

	/**
	 * @var  array  store the node operation we need to execute on save() or get()
	 */
	protected $_node_operation = array();

	/**
	 * @var  mixed  id value of the current tree in multi-tree models
	 */
	protected $_current_tree_id = null;

	/*
	 * Initialize the nestedset model instance
	 *
	 * @param  array    any data passed to this model
	 * @param  bool     whether or not this is a new model instance
	 * @param  string   name of a database view to use instead of a table
	 * @param  bool     whether or not to cache this object
	 *
	 * @throws  OutOfBoundsException  if the model has a compound primary key defined
	 */
	public function __construct(array $data = array(), $new = true, $view = null, $cache = true)
	{
		// check for a compound key, we don't do that (yet)
		if (count(static::$_primary_key) > 1)
		{
			throw new \OutOfBoundsException('The Nestedset ORM model doesn\'t support compound primary keys.');
		}

		// call the ORM base model constructor
		parent::__construct($data, $new, $view, $cache);
	}

	// -------------------------------------------------------------------------
	// multi-tree select
	// -------------------------------------------------------------------------

	/**
	 * Select a specific tree if the table contains multiple trees
	 *
	 * @param  mixed  type depends on the field type of the tree_field
	 * @return  Model_Nestedset  this object, for chaining
	 *
	 * @throws  BadMethodCallException  if the model is not multi-tree
	 */
	public function set_tree_id($tree = null)
	{
		// is this a multi-tree model?
		if (static::tree_config('tree_field') === null)
		{
			throw new \BadMethodCallException('This is not a multi-tree model, set_tree_id() can not be used.');
		}

		// set the tree filter value to select a specific tree
		$this->_current_tree_id = $tree;

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Select a specific tree if the table contains multiple trees
	 *
	 * @return  mixed  current tree id value
	 *
	 * @throws  OutOfRangeException  if no tree id has been set
	 */
	public function get_tree_id()
	{
		// check if the current object is part of a tree
		if (($value = $this->{static::tree_config('tree_field')}) !== null)
		{
			return $value;
		}

		// check if there is a default tree id value set
		if ($this->_current_tree_id !== null)
		{
			return $this->_current_tree_id;
		}

		// we needed a tree id, but there isn't one defined
		throw new \OutOfRangeException('tree id required, but none is defined.');
	}

	// -------------------------------------------------------------------------
	// tree queries
	// -------------------------------------------------------------------------

	/**
	 * Returns a query object on the selected tree
	 *
	 * @return  Query  the constructed query object
	 */
	public function build_query()
	{
		// create a new query object
		$query = $this->query();

		// get params to avoid excessive method calls
		$tree_field = static::tree_config('tree_field');

		// add the tree id if needed
		if ( ! is_null($tree_field))
		{
			$query->where($tree_field, $this->get_tree_id());
		}

		// return the query object
		return $query;
	}

	// -------------------------------------------------------------------------

	/**
	 * Returns the root of the tree the current node belongs to
	 *
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function root()
	{
		$this->_node_operation = array(
			'single' => true,
			'action' => 'root',
			'to' => null,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Returns the roots of all trees
	 *
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function roots()
	{
		$this->_node_operation = array(
			'single' => false,
			'action' => 'roots',
			'to' => null,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Returns the parent of the current node
	 *
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function parent()
	{
		$this->_node_operation = array(
			'single' => true,
			'action' => 'parent',
			'to' => null,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Returns the children of the current node
	 *
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function children()
	{
		$this->_node_operation = array(
			'single' => false,
			'action' => 'children',
			'to' => null,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Returns all ancestors of the current node
	 *
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function ancestors()
	{
		$this->_node_operation = array(
			'single' => false,
			'action' => 'ancestors',
			'to' => null,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Returns all descendants of the current node
	 *
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function descendants()
	{
		$this->_node_operation = array(
			'single' => false,
			'action' => 'descendants',
			'to' => null,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Returns all leafs of the current node
	 *
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function leaf_descendants()
	{
		$this->_node_operation = array(
			'single' => false,
			'action' => 'leaf_descendants',
			'to' => null,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Returns the siblings of the current node (includes the node itself!)
	 *
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function siblings()
	{
		$this->_node_operation = array(
			'single' => false,
			'action' => 'siblings',
			'to' => null,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Returns the path to the current node
	 *
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function path($addroot = true)
	{
		$this->_node_operation = array(
			'single' => false,
			'action' => 'path',
			'to' => null,
			'addroot' => $addroot,
		);

		// return the object for chaining
		return $this;
	}


	// -------------------------------------------------------------------------
	// node manipulation methods
	// -------------------------------------------------------------------------

	/**
	 * Alias for last_child()
	 *
	 * @param   Model_Nestedset, or PK of the parent object, or null
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function child($to = null)
	{
		return $this->last_child($to);
	}

	// -------------------------------------------------------------------------

	/**
	 * Gets or sets the first child of a node
	 *
	 * @param   Model_Nestedset, or PK of the parent object, or null
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function first_child($to = null)
	{
		$this->_node_operation = array(
			'single' => true,
			'action' => 'first_child',
			'to' => $to,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Gets or sets the last child of a node
	 *
	 * @param   Model_Nestedset, or PK of the parent object, or null
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function last_child($to = null)
	{
		$this->_node_operation = array(
			'single' => true,
			'action' => 'last_child',
			'to' => $to,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Alias for next_sibling()
	 *
	 * @param   Model_Nestedset, or PK of the parent object, or null
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function sibling($to = null)
	{
		return $this->next_sibling($to);
	}

	// -------------------------------------------------------------------------

	/**
	 * Gets or sets the previous sibling of a node
	 *
	 * @param   Model_Nestedset, or PK of the parent object, or null
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function previous_sibling($to = null)
	{
		$this->_node_operation = array(
			'single' => true,
			'action' => 'previous_sibling',
			'to' => $to,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------

	/**
	 * Gets or sets the next sibling of a node
	 *
	 * @param   Model_Nestedset, or PK of the parent object, or null
	 * @return  Model_Nestedset  this object, for chaining
	 */
	public function next_sibling($to = null)
	{
		$this->_node_operation = array(
			'single' => true,
			'action' => 'next_sibling',
			'to' => $to,
		);

		// return the object for chaining
		return $this;
	}

	// -------------------------------------------------------------------------
	// boolean tree functions
	// -------------------------------------------------------------------------

	/**
	 * Check if the object is a tree root
	 *
	 * @return  bool
	 */
	public function is_root()
	{
		return $this->{static::tree_config('left_field')} == 1;
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object is a tree leaf (node with no children)
	 *
	 * @return  bool
	 */
	public function is_leaf()
	{
		return $this->{static::tree_config('right_field')} - $this->{static::tree_config('left_field')} == 1;
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object is a child node (not a root node)
	 *
	 * @return  bool
	 */
	public function is_child()
	{
		return ! $this->is_root($this);
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object is a child of node
	 *
	 * @param   Model_Nestedset of the parent to check
	 * @return  bool
	 */
	public function is_child_of(Model_Nestedset $parent)
	{
		// get our parent
		$our_parent = $this->parent()->get_one();

		// and check if the parents match
		return $parent == $our_parent;
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object is a direct descendant of node
	 *
	 * @param   Model_Nestedset of the parent to check
	 * @return  bool
	 */
	public function is_descendant_of(Model_Nestedset $parent)
	{
		// get params to avoid excessive method calls
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');

		return $this->{$left_field} > $parent->{$left_field} and
			$this->{$right_field} < $parent->{$right_field};
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object is the parent of node
	 *
	 * @param   Model_Nestedset of the child to check
	 * @return  bool
	 */
	public function is_parent_of(Model_Nestedset $child)
	{
		return $this == $child->parent()->get_one();
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object is the ancestor of node
	 *
	 * @param   Model_Nestedset of the child to check
	 * @return  bool
	 */
	public function is_ancestor_of(Model_Nestedset $child)
	{
		// get params to avoid excessive method calls
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');

		return $child->{$left_field} > $this->{$left_field} and
			$child->{$right_field} < $this->{$right_field};
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object is the same model
	 *
	 * @param   Model_Nestedset object to verify against
	 * @return  bool
	 */
	public function is_same_model_as(Model_Nestedset $object)
	{
		return (get_class($object) == get_class($this));
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object is the same model and the same tree
	 *
	 * @param   Model_Nestedset object to verify against
	 * @return  bool
	 */
	public function is_same_tree_as(Model_Nestedset $object)
	{
		// make sure they're the same model
		if ($this->is_same_model_as($object))
		{
			// get params to avoid excessive method calls
			$tree_field = static::tree_config('tree_field');

			if (empty($this->{$tree_field}) or $this->{$tree_field} === $object->{$tree_field})
			{
				// same tree, or not a multi-tree model
				return true;
			}
		}

		// not the same tree
		return false;
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object has a parent
	 *
	 * Note: this is an alias for is_child()
	 *
	 * @return  bool
	 */
	public function has_parent()
	{
		return $this->is_child($this);
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object has children
	 *
	 * @return  bool
	 */
	public function has_children()
	{
		return $this->is_leaf($this) ? false : true;
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object has a previous sibling
	 *
	 * @return  bool
	 */
	public function has_previous_sibling()
	{
		return ! is_null($this->previous_sibling()->get_one());
	}

	// -------------------------------------------------------------------------

	/**
	 * Check if the object has a next sibling
	 *
	 * @return  bool
	 */
	public function has_next_sibling()
	{
		return ! is_null($this->next_sibling()->get_one());
	}

	// -------------------------------------------------------------------------
	// integer tree methods
	// -------------------------------------------------------------------------

	/**
	 * Return the count of the objects children
	 *
	 * @return  mixed  integer, or false in case no valid object was passed
	 */
	public function count_children()
	{
		$result = $this->children()->get();
		return $result ? count($result) : 0;
	}

	// -------------------------------------------------------------------------

	/**
	 * Return the count of the objects descendants
	 *
	 * @return  mixed  integer, or false in case no valid object was passed
	 */
	public function count_descendants()
	{
		return ($this->{static::tree_config('right_field')} - $this->{static::tree_config('left_field')} - 1) / 2;
	}

	// -------------------------------------------------------------------------

	/**
	 * Return the depth of the object in the tree, where the root = 0
	 *
	 * @return	mixed	integer, of false in case no valid object was found
	 */
	public function depth()
	{
		// get params to avoid excessive method calls
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');

		// we need a valid object for this to work
		if ($this->is_new())
		{
			return false;
		}
		else
		{
			// if we have a valid object, run the query to calculate the depth
			$query = $this->build_query()
				->where($left_field, '<', $this->{$left_field})
				->where($right_field, '>', $this->{$right_field});

			// return the result count
			return $query->count();
		}
	}

	// -------------------------------------------------------------------------

	/**
	 * Return the tree, with the current node as root, as a nested array structure
	 *
	 * @param   bool    whether or not to return an array of objects
	 * @param   string  property name to store the node's children
	 * @return	array
	 */
	public function dump_tree($as_object = false, $children = 'children', $path = 'path')
	{
		// get the PK
		$pk = reset(static::$_primary_key);

		// and the tree pointers
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');
		$title_field = static::tree_config('title_field');

		// storage for the result, start with the current node
		if ($as_object)
		{
			$this->_custom_data[$children] = array();
			$tree = array($this->{$pk} => $this);
		}
		else
		{
			$this[$children] = array();
			$tree = array($this->{$pk} => $this->to_array(true));
		}

		if ( ! empty($title_field) and isset($this->{$title_field}))
		{
			if ($as_object)
			{
				$this->_custom_data[$path] = '/';
			}
			else
			{
				$this[$path] = '/';
			}
		}

		// parent tracker
		$tracker = array();
		$index = 0;
		$tracker[$index] =& $tree[$this->{$pk}];

		// loop over the descendants
		foreach ($this->descendants()->get() as $treenode)
		{
			// get the data for this node and make sure we have a place to store child information
			if ($as_object)
			{
				$node = $treenode;
				$node->_custom_data[$children] = array();
			}
			else
			{
				$node = $treenode->to_array(true);
				$node[$children] = array();
			}

			// is this node a child of the current parent?
			while ($treenode->{$left_field} > $tracker[$index][$right_field])
			{
				// no, so pop the last parent and move a level back up
				$index--;
			}

			// add the path to this node
			if ( ! empty($title_field) and isset($treenode->{$title_field}))
			{
				if ($as_object)
				{
					$node->_custom_data[$path] = rtrim($tracker[$index][$path],'/').'/'.$node->{$title_field};
				}
				else
				{
					$node[$path] = rtrim($tracker[$index][$path],'/').'/'.$node[$title_field];
				}
			}

			// add it as a child to the current parent
			if ($as_object)
			{
				$tracker[$index]->_custom_data[$children][$treenode->{$pk}] = $node;
			}
			else
			{
				$tracker[$index][$children][$treenode->{$pk}] = $node;
			}

			// does this node have children?
			if ($treenode->{$right_field} - $treenode->{$left_field} > 1)
			{
				// create a new parent level
				if ($as_object)
				{
					$tracker[$index+1] =& $tracker[$index]->_custom_data[$children][$treenode->{$pk}];
				}
				else
				{
					$tracker[$index+1] =& $tracker[$index][$children][$treenode->{$pk}];
				}
				$index++;
			}
		}

		return $as_object ? $this : $tree;
	}

	// -------------------------------------------------------------------------

	/**
	 * Capture __unset() to make sure no read-only properties are erased
	 *
	 * @param   string  $property
	 */
	public function __unset($property)
	{
		// make sure we're not unsetting a read-only value
		if (in_array($property, static::tree_config('read-only')))
		{
			throw new \InvalidArgumentException('Property "'.$property.'" is read-only and can not be changed');
		}

		parent::__unset($property);
	}

	// -------------------------------------------------------------------------

	/**
	 * Capture set() to make sure no read-only properties are overwritten
	 *
	 * @param   string|array  $property
	 * @param   string  $value in case $property is a string
	 * @return  Model
	 */
	public function set($property, $value = null)
	{
		// check if we're in a frozen state
		if ($this->_frozen)
		{
			throw new FrozenObject('No changes allowed.');
		}

		// make sure we're not setting a read-only value
		if (in_array($property, static::tree_config('read-only')) and $this->{$property} !== $value)
		{
			throw new \InvalidArgumentException('Property "'.$property.'" is read-only and can not be changed');
		}

		return parent::set($property, $value);
	}


	// -------------------------------------------------------------------------

	/**
	 * Capture calls to save(), to make sure no new record is inserted
	 * directly which would seriously break the tree...
	 */
	public function save($cascade = null, $use_transaction = false)
	{
		// get params to avoid excessive method calls
		$tree_field = static::tree_config('tree_field');
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');

		// deal with new objects
		if ($this->_is_new)
		{
			// was a relocation of this node asked?
			if ( ! empty($this->_node_operation))
			{
				if ($this->_node_operation['to'])
				{
					// do we have a model? if not, try to autoload it
					if ( ! $this->_node_operation['to'] instanceOf Model_Nestedset)
					{
						$this->_node_operation['to'] = static::find($this->_node_operation['to']);
					}

					// verify that both objects are from the same model
					$this->_same_model_as($this->_node_operation['to'], __METHOD__);

					// set the tree id if needed
					if ( ! is_null($tree_field))
					{
						$this->_data[$tree_field] = $this->_node_operation['to']->get_tree_id();
					}
				}

				// add the left- and right pointers to the current object, and make room for it
				if ($use_transaction)
				{
					$db = \Database_Connection::instance(static::connection(true));
					$db->start_transaction();
				}
				try
				{
					switch ($this->_node_operation['action'])
					{
						case 'next_sibling':
							// set the left- and right pointers for the new node
							$this->_data[$left_field] = $this->_node_operation['to']->{$right_field} + 1;
							$this->_data[$right_field] = $this->_node_operation['to']->{$right_field} + 2;

							// create room for this new node
							$this->_shift_rl_values($this->{$left_field}, 2);
						break;

						case 'previous_sibling':
							// set the left- and right pointers for the new node
							$this->_data[$left_field] = $this->_node_operation['to']->{$left_field};
							$this->_data[$right_field] = $this->_node_operation['to']->{$left_field} + 1;

							// create room for this new node
							$this->_shift_rl_values($this->{$left_field}, 2);
						break;

						case 'first_child':
							// set the left- and right pointers for the new node
							$this->_data[$left_field] = $this->_node_operation['to']->{$left_field} + 1;
							$this->_data[$right_field] = $this->_node_operation['to']->{$left_field} + 2;

							// create room for this new node
							$this->_shift_rl_values($this->{$left_field}, 2);
						break;

						case 'last_child':
							// set the left- and right pointers for the new node
							$this->_data[$left_field] = $this->_node_operation['to']->{$right_field};
							$this->_data[$right_field] = $this->_node_operation['to']->{$right_field} + 1;

							// create room for this new node
							$this->_shift_rl_values($this->{$left_field}, 2);
						break;

						default:
							throw new \OutOfBoundsException('You can not define a '.$this->_node_operation['action'].'() action before a save().');
						break;
					}
				}
				catch (\Exception $e)
				{
					$use_transaction and $db->rollback_transaction();
					throw $e;
				}
			}

			// assume we want a new root node
			else
			{
				// set the left- and right pointers for the new root
				$this->_data[$left_field] = 1;
				$this->_data[$right_field] = 2;
				$pk = reset(static::$_primary_key);

				// we need to check if we don't already have this root
				$query = \DB::select($pk)
					->from(static::table())
					->where($left_field, '=', 1);

				// multi-root tree? And no new tree id defined?
				if ( ! is_null($tree_field) and empty($this->{$tree_field}))
				{
					// get the next free tree id, and hope it's numeric...
					$this->_data[$tree_field] = $this->max($tree_field) + 1;

					// and set it as the default tree id for this node
					$this->set_tree_id($this->_data[$tree_field]);
				}

				// add the tree_id to the query if present
				if ( ! empty($this->{$tree_field}))
				{
					$query->where($tree_field, '=', $this->_data[$tree_field]);
				}

				// run the check
				$result = $query->execute(static::connection());

				// any hits?
				if (count($result))
				{
					throw new \OutOfBoundsException('You can not add this new tree root, it already exists.');
				}
			}
		}

		// and with existing objects
		else
		{
			// get the classname of this model
			$class = get_called_class();

			// readonly fields may not be changed
			foreach (static::$_tree_cached[$class]['read-only'] as $column)
			{
				// so reset them if they were changed
				$this->_data[$column] = $this->_original[$column];
			}

			// was a relocation of this node asked
			if ( ! empty($this->_node_operation))
			{
				if ($this->_node_operation['to'])
				{
					// do we have a model? if not, try to autoload it
					if ( ! $this->_node_operation['to'] instanceOf Model_Nestedset)
					{
						$this->_node_operation['to'] = static::find($this->_node_operation['to']);
					}

					// verify that both objects are from the same model
					$this->_same_model_as($this->_node_operation['to'], __METHOD__);

					// and from the same tree (if we have multi-tree support for this object)
					if ( ! is_null($tree_field))
					{
						if ($this->{$tree_field} !== $this->_node_operation['to']->{$tree_field})
						{
							throw new \OutOfBoundsException('When moving nodes, nodes must be part of the same tree.');
						}
					}
				}

				// move the node
				if ($use_transaction)
				{
					$db = \Database_Connection::instance(static::connection(true));
					$db->start_transaction();
				}
				try
				{
					switch ($this->_node_operation['action'])
					{
						case 'next_sibling':
							$this->_move_subtree($this->_node_operation['to']->{static::tree_config('right_field')} + 1);
						break;

						case 'previous_sibling':
							$this->_move_subtree($this->_node_operation['to']->{static::tree_config('left_field')});
						break;

						case 'first_child':
							$this->_move_subtree($this->_node_operation['to']->{static::tree_config('left_field')} + 1);
						break;

						case 'last_child':
							$this->_move_subtree($this->_node_operation['to']->{static::tree_config('right_field')});
						break;

						default:
							throw new \OutOfBoundsException('You can not define a '.$this->_node_operation['action'].'() action before a save().');
						break;
					}
				}
				catch (\Exception $e)
				{
					$use_transaction and $db->rollback_transaction();
					throw $e;
				}
			}
		}

		// reset the node operation store to make sure nothings pending...
		$this->_node_operation = array();

		// save the current node and return the result
		return parent::save($cascade, $use_transaction);
	}

	// -------------------------------------------------------------------------

	/**
	 * Capture calls to delete(), to make sure no delete happens without reindexing
	 *
	 * @param   mixed  $cascade
	 *     null = use default config,
	 *     bool = force/prevent cascade,
	 *     array cascades only the relations that are in the array
	 * @return  Model  this instance as a new object without primary key(s)
	 *
	 * @throws DomainException if you try to delete a root node with multiple children
	 */
	public function delete($cascade = null, $use_transaction = false)
	{
		if ($use_transaction)
		{
			$db = \Database_Connection::instance(static::connection(true));
			$db->start_transaction();
		}

		// get params to avoid excessive method calls
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');

		// if this is a root node with multiple children, bail out
		if ($this->is_root() and $this->count_children() > 1)
		{
			throw new \DomainException('You can not delete a tree root with multiple children.');
		}

		// put the entire operation in a try/catch, so we can rollback if needed
		try
		{
			// delete the node itself
			$result = parent::delete($cascade);

			// check if the delete was succesful
			if ($result !== false)
			{
				// re-index the tree
				$this->_shift_rl_range($this->{$left_field} + 1, $this->{$right_field} - 1, -1);
				$this->_shift_rl_values($this->{$right_field} + 1, -2);
			}
		}
		catch (\Exception $e)
		{
			$use_transaction and $db->rollback_transaction();
			throw $e;
		}

		// reset the node operation store to make sure nothings pending...
		$this->_node_operation = array();

		// and return the result
		return $result;
	}

	// -------------------------------------------------------------------------
	// tree destructors
	// -------------------------------------------------------------------------

	/**
	 * Deletes the entire tree structure using the current node as starting point
	 *
	 * @param   mixed  $cascade
	 *     null = use default config,
	 *     bool = force/prevent cascade,
	 *     array cascades only the relations that are in the array
	 * @return  Model  this instance as a new object without primary key(s)
	 */
	public function delete_tree($cascade = null, $use_transaction = false)
	{
		if ($use_transaction)
		{
			$db = \Database_Connection::instance(static::connection(true));
			$db->start_transaction();
		}

		// get params to avoid excessive method calls
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');
		$pk = reset(static::$_primary_key);

		// put the entire operation in a try/catch, so we can rollback if needed
		try
		{
			// check if the node has children
			if ($this->has_children())
			{
				// get them
				$children = $this->children()->get();

				// and delete them to
				foreach ($children as $child)
				{
					if ($child->delete_tree($cascade) === false)
					{
						throw new \UnexpectedValueException('delete of child node with PK "'.$child->{$pk}.'" failed.');
					}
				}
			}

			// delete the node itself
			$result = parent::delete($cascade);

			// check if the delete was succesful
			if ($result !== false)
			{
				// re-index the tree
				$this->_shift_rl_values($this->{$right_field} + 1, $this->{$left_field} - $this->{$right_field} - 1);
			}
		}
		catch (\Exception $e)
		{
			$use_transaction and $db->rollback_transaction();
			throw $e;
		}

		// reset the node operation store to make sure nothings pending...
		$this->_node_operation = array();

		// and return the result
		return $result;
	}

	// -------------------------------------------------------------------------
	// get methods
	// -------------------------------------------------------------------------

	/**
	 * Creates a new query with optional settings up front, or return a pre-build
	 * query to further chain upon
	 *
	 * @param   array
	 * @return  Query
	 */
	public function get_query()
	{
		// make sure there's a node operation defined
		if (empty($this->_node_operation))
		{
			// assume a get-all operation
			$this->_node_operation = array(
				'single' => false,
				'action' => 'all',
				'to' => null,
			);
		}

		return $this->_fetch_nodes('query');
	}

	// -------------------------------------------------------------------------

	/**
	 * Get one or more tree nodes, and provide fallback for
	 * the original model getter
	 *
	 * @param  mixed
	 *
	 * @returns  mixed
	 * @throws  BadMethodCallException if called without a parameter and without a node to fetch
	 */
	public function & get($query = null, array $conditions = array())
	{
		// do we have any parameters passed?
		if (func_num_args())
		{
			// capture normal getter calls
			if ($query instanceOf Query)
			{
				// run a get() on the query
				return $query->get();
			}
			else
			{
				// assume it's a model getter call
				return parent::get($query, $conditions);
			}
		}

		// make sure there's a node operation defined
		if (empty($this->_node_operation))
		{
			// assume a get-all operation
			$this->_node_operation = array(
				'single' => false,
				'action' => 'all',
				'to' => null,
			);
		}

		// no parameters, so we need to fetch something
		$result = $this->_fetch_nodes('multiple');
		return $result;
	}

	// -------------------------------------------------------------------------

	/*
	 * Get a single tree node
	 *
	 * @param  Query
	 *
	 * @returns  mixed
	 * @throws  BadMethodCallException if called without a parameter and without a node to fetch
	 */
	public function get_one(Query $query = null)
	{
		// do we have a query object passed?
		if (func_num_args())
		{
			// return the query result
			return $query->get_one();
		}

		// make sure there's a node operation defined
		if (empty($this->_node_operation))
		{
			// assume a get-all operation
			$this->_node_operation = array(
				'single' => true,
				'action' => 'all',
				'to' => null,
			);
		}

		// so we need to fetch something
		return $this->_fetch_nodes('single');
	}

	// -------------------------------------------------------------------------
	// protected class functions
	// -------------------------------------------------------------------------

	/**
	 * Check if the object passed is an instance of the current model
	 *
	 * @param   Model_Nestedset
	 * @param  string  optional method name to display in the exception message
	 * @return  bool
	 *
	 * @throws  OutOfBoundsException  in case the two objects are not part of the same model
	 */
	protected function _same_model_as($object, $method = 'unknown')
	{
		if ( ! $this->is_same_model_as($object))
		{
			throw new \OutOfBoundsException('Model object passed to '.$method.'() is not an instance of '.get_class($this).'.');
		}
	}

	// -------------------------------------------------------------------------

	/*
	 * Fetch a node or nodes, and return the result
	 *
	 * @param  string  action, either 'single' or 'multiple'
	 * @return  mixed  Model_Nestedset or an array of Model_Nestedset, or null if none found
	 */
	protected function _fetch_nodes($action)
	{
		// get params to avoid excessive method calls
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');
		$tree_field = static::tree_config('tree_field');

		// construct the query
		switch ($this->_node_operation['action'])
		{
			case 'all':
				$query = $this->build_query();
			break;

			case 'root':
				$query = $this->build_query()
					->where($left_field, '=', 1);
			break;

			case 'roots':
				$query = $this->query()
					->where($left_field, '=', 1);
			break;

			case 'parent':
				$query = $this->build_query()
					->where($left_field, '<', $this->{$left_field})
					->where($right_field, '>', $this->{$right_field})
					->order_by($right_field, 'ASC');
			break;

			case 'first_child':
				$query = $this->build_query()
					->where($left_field, $this->{$left_field} + 1);
			break;

			case 'last_child':
				$query = $this->build_query()
					->where($right_field, $this->{$right_field} - 1);
			break;

			case 'children':
				// get the PK's of all child objects
				$pk = reset(static::$_primary_key);
				$left = $this->{$left_field};
				$right = $this->{$right_field};

				// if we're multitree, add the tree filter to the query
				if (is_null($tree_field))
				{
					$query = \DB::select('child.'.$pk)
						->from(array(static::table(), 'child'))
						->join(array(static::table(), 'ancestor'), 'left')
						->on(\DB::identifier('ancestor.' . $left_field), 'BETWEEN', \DB::expr(($left + 1) . ' AND ' . ($right - 1)))
						->on(\DB::identifier('child.' . $left_field), 'BETWEEN', \DB::expr(\DB::identifier('ancestor.'.$left_field).' + 1 AND '.\DB::identifier('ancestor.'.$right_field).' - 1'))
						->where(\DB::identifier('child.' . $left_field), 'BETWEEN', \DB::expr(($left + 1) . ' AND ' . ($right - 1)))
						->and_where('ancestor.'.$pk, null);
				}
				else
				{
					$query = \DB::select('child.'.$pk)
						->from(array(static::table(), 'child'))
						->join(array(static::table(), 'ancestor'), 'left')
						->on(\DB::identifier('ancestor.' . $left_field), 'BETWEEN', \DB::expr(($left + 1) . ' AND ' . ($right - 1) . ' AND '.\DB::identifier('ancestor.'.$tree_field).' = '.$this->get_tree_id()))
						->on(\DB::identifier('child.' . $left_field), 'BETWEEN', \DB::expr(\DB::identifier('ancestor.'.$left_field).' + 1 AND '.\DB::identifier('ancestor.'.$right_field).' - 1'))
						->where(\DB::identifier('child.' . $left_field), 'BETWEEN', \DB::expr(($left + 1) . ' AND ' . ($right - 1)))
						->and_where('ancestor.'.$pk, null)
						->and_where('child.'.$tree_field, '=', $this->get_tree_id());

				}

				// extract the PK's, and bail out if no children found
				if ( ! $pks = $query->execute(static::connection())->as_array())
				{
					return null;
				}

				// construct the query to find all child objects
				$query = $this->build_query()
					->where($pk, 'IN', $pks)
					->order_by($left_field, 'ASC');
			break;

			case 'ancestors':
				// storage for the result
				$result = array();

				// new objects don't have a parent
				if ( ! $this->is_new())
				{
					$parent = $this;
					$pk = reset(static::$_primary_key);

					while (($parent = $parent->parent()->get_one()) !== null)
					{
						$result[$parent->{$pk}] = $parent;
					}
				}

				// reverse the result
				$result = array_reverse($result, true);

				// return the result
				return $result;
			break;

			case 'descendants':
				$query = $this->build_query()
					->where($left_field, '>', $this->{$left_field})
					->where($right_field, '<', $this->{$right_field})
					->order_by($left_field, 'ASC');
			break;

			case 'leaf_descendants':
				$query = $this->build_query()
					->where($left_field, '>', $this->{$left_field})
					->where($right_field, '<', $this->{$right_field})
					->where(\DB::expr(\DB::quote_identifier($right_field) . ' - ' . \DB::quote_identifier($left_field)), '=', 1)
					->order_by($left_field, 'ASC');
			break;

			case 'previous_sibling':
				$query = $this->build_query()
					->where(static::tree_config('right_field'), $this->{static::tree_config('left_field')} - 1);
			break;

			case 'next_sibling':
				$query = $this->build_query()
					->where(static::tree_config('left_field'), $this->{static::tree_config('right_field')} + 1);
			break;

			case 'siblings':
				// if we have a parent object
				if ($parent = $this->parent()->get_one())
				{
					// get the children of that parent
					return $parent->children()->get();
				}
				else
				{
					// no siblings
					return null;
				}
			break;

			case 'path':
				// do we have a title field defined?
				if ($title_field = static::tree_config('title_field'))
				{
					// storage for the path
					$path = '';

					// do we need to add the root?
					$addroot = $this->_node_operation['addroot'];

					// get all parents
					$result = $this->ancestors()->get();

					// construct the path
					foreach($result as $object)
					{
						if ($addroot or $object->{$left_field} > 1)
						{
							$path .= $object->{$title_field}.'/';
						}
					}
					$path .= $this->{$title_field};

					// and return it
					return $path;
				}
				else
				{
					throw new \OutOfBoundsException('You can call path(), the "'.get_class($this).'" model does not define a title field.');
				}
			break;

			default:
				throw new \OutOfBoundsException('You can not set a '.$this->_node_operation['action'].'() operation on a get() or get_one().');
			break;
		}

		// reset the node operation store to make sure nothings pending...
		$this->_node_operation = array();

		if ($action == 'query')
		{
			// return the query object for further chaining
			return $query;
		}
		else
		{
			// return the query result based on the action type
			return $action == 'single' ? $query->get_one() : $query->get();
		}
	}

	// -------------------------------------------------------------------------

	/**
	 * Interal tree operation. Shift left-right pointers to make room for
	 * one or mode nodes, or to re-order the pointers after a delete
	 * operation.
	 *
	 * @param  integer  left pointer of the first node to shift
	 * @param  integer  number of positions to shift (if negative the shift will be to the left)
	 */
	protected function _shift_rl_values($first, $delta)
	{
		// get params to avoid excessive method calls
		$tree_field = static::tree_config('tree_field');
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');

		$query = \DB::update(static::table());

		// if we have multiple roots
		if ( ! is_null($tree_field))
		{
			$query->where($tree_field, $this->get_tree_id());
		}

		$query->where($left_field, '>=', $first);

		// correct the delta
		$sqldelta = ($delta < 0) ? (' - '.abs($delta)) : (' + '.$delta);

		// set clause
		$query->set(array(
			$left_field => \DB::expr(\DB::quote_identifier($left_field).$sqldelta),
		));

		// update in the correct order to avoid constraint conflicts
		$query->order_by($left_field, ($delta < 0 ? 'ASC' : 'DESC'));

		// execute it
		$query->execute(static::connection(true));

		$query = \DB::update(static::table());

		// if we have multiple roots
		if ( ! is_null($tree_field))
		{
			$query->where($tree_field, $this->get_tree_id());
		}

		$query->where($right_field, '>=', $first);

		// set clause
		$query->set(array(
			$right_field => \DB::expr(\DB::quote_identifier($right_field).$sqldelta),
		));

		// update in the correct order to avoid constraint conflicts
		$query->order_by($right_field, ($delta < 0 ? 'ASC' : 'DESC'));

		// execute it
		$query->execute(static::connection(true));

		// update cached objects, we've modified pointers
		$class = get_called_class();
		if (array_key_exists($class, static::$_cached_objects))
		{
			foreach (static::$_cached_objects[$class] as $object)
			{
				if (is_null($tree_field) or $object->{$tree_field} == $this->{$tree_field})
				{
					if ($object->{$left_field} >= $first)
					{
						if ($delta < 0)
						{
							$object->_data[$left_field] -= abs($delta);
							$object->_original[$left_field] -= abs($delta);
						}
						else
						{
							$object->_data[$left_field] += $delta;
							$object->_original[$left_field] += $delta;
						}
					}
					if ($object->{$right_field} >= $first)
					{
						if ($delta < 0)
						{
							$object->_data[$right_field] -= abs($delta);
							$object->_original[$right_field] -= abs($delta);
						}
						else
						{
							$object->_data[$right_field] += $delta;
							$object->_original[$right_field] += $delta;
						}
					}
				}
			}
		}
	}

	// -------------------------------------------------------------------------

	/**
	 * Interal tree operation. Shift left-right pointers to make room for
	 * one or mode nodes, or to re-order the pointers after a delete
	 * operation, in the given range
	 *
	 * @param  integer  left pointer of the first node to shift
	 * @param  integer  right pointer of the last node to shift
	 * @param  integer  number of positions to shift (if negative the shift will be to the left)
	 */
	protected function _shift_rl_range($first, $last, $delta)
	{
		// get params to avoid excessive method calls
		$tree_field = static::tree_config('tree_field');
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');

		$query = \DB::update(static::table());

		// if we have multiple roots
		if ( ! is_null($tree_field))
		{
			$query->where($tree_field, $this->get_tree_id());
		}

		// select the range
		$query->where($left_field, '>=', $first);
		$query->where($right_field, '<=', $last);

		// correct the delta
		$sqldelta = ($delta < 0) ? (' - '.abs($delta)) : (' + '.$delta);

		// set clause
		$query->set(array(
			$left_field => \DB::expr(\DB::quote_identifier($left_field).$sqldelta),
			$right_field => \DB::expr(\DB::quote_identifier($right_field).$sqldelta),
		));

		// update in the correct order to avoid constraint conflicts
		$query->order_by($right_field, ($delta < 0 ? 'ASC' : 'DESC'));

		// execute it
		$query->execute(static::connection(true));

		// update cached objects, we've modified pointers
		$class = get_called_class();
		if (array_key_exists($class, static::$_cached_objects))
		{
			foreach (static::$_cached_objects[$class] as $object)
			{
				if (is_null($tree_field) or $object->{$tree_field} == $this->{$tree_field})
				{
					if ($object->{$left_field} >= $first and $object->{$right_field} <= $last)
					{
						if ($delta < 0)
						{
							$object->_data[$left_field] -= abs($delta);
							$object->_data[$right_field] -= abs($delta);
							$object->_original[$left_field] -= abs($delta);
							$object->_original[$right_field] -= abs($delta);
						}
						else
						{
							$object->_data[$left_field] += $delta;
							$object->_data[$right_field] += $delta;
							$object->_original[$left_field] += $delta;
							$object->_original[$right_field] += $delta;
						}
					}
				}
			}
		}
	}

	// -------------------------------------------------------------------------

	/**
	 * Interal tree operation. Move the current node and all children
	 * to a new position in the tree
	 *
	 * @param  integer  new left pointer location to move to
	 */
	protected function _move_subtree($destination_id)
	{
		// get params to avoid excessive method calls
		$tree_field = static::tree_config('tree_field');
		$left_field = static::tree_config('left_field');
		$right_field = static::tree_config('right_field');

		// catch a move into the subtree
		if ( $destination_id >= $this->{$left_field} and $destination_id <= $this->{$right_field} )
		{
			// it would make no change to the tree
			return $this;
		}

		// determine the size of the tree to move
		$treesize = $this->{$right_field} - $this->{$left_field} + 1;

		// get the objects left- and right pointers
		$left_id = $this->{$left_field};
		$right_id = $this->{$right_field};

		// shift to make some space
		$this->_shift_rl_values($destination_id, $treesize);

		// correct pointers if there were shifted to
		if ($this->{$left_field} >= $destination_id)
		{
			$left_id += $treesize;
			$right_id += $treesize;
		}

		// enough room now, start the move
		$this->_shift_rl_range($left_id, $right_id, $destination_id - $left_id);

		// and correct index values after the source
		$this->_shift_rl_values(++$right_id, (-1 * $treesize));

		// return the moved object
		return $this;
	}
}
