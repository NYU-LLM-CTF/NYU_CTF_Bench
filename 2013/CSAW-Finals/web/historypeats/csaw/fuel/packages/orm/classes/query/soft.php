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
 * Overrides the default Query object to allow for custom soft delete filtering on queries.
 *
 * @package Orm
 * @author  Fuel Development Team
 */
class Query_Soft extends Query
{
	/**
	 * @var null|string Name of the filter column or null for no filtering
	 */
	protected $_col_name = null;

	/**
	 * Enables filtering by setting the column name to filter on.
	 *
	 * @param $col_name string
	 *
	 * @return $this
	 */
	public function set_soft_filter($col_name)
	{
		$this->_col_name = $col_name;
		return $this;
	}

	/**
	 * Make sure the soft-filter is added to get() calls
	 */
	public function get()
	{
		$this->add_soft_filter();
		return parent::get();
	}

	/**
	 * Make sure the soft-filter is added to count() calls
	 */
	public function count($column = null, $distinct = true)
	{
		$this->add_soft_filter();
		return parent::count($column, $distinct);
	}

	/**
	 * Make sure the soft-filter is added to min() calls
	 */
	public function min($column)
	{
		$this->add_soft_filter();
		return parent::min($column);
	}

	/**
	 * Make sure the soft-filter is added to max() calls
	 */
	public function max($column)
	{
		$this->add_soft_filter();
		return parent::max($column);
	}

	protected function modify_join_result($join_result, $name)
	{
		if ( ! is_null($this->_col_name) and is_subclass_of($join_result[$name]['model'], '\Orm\Model_Soft'))
		{
			$table = $join_result[$name]['table'][1];
			$join_result[$name]['join_on'][] = array("$table.$this->_col_name", 'IS', \DB::expr('NULL'));
		}

		return parent::modify_join_result($join_result, $name);
	}

	/**
	 * Add an additional where clause if needed to execute the soft-filter
	 */
	protected function add_soft_filter()
	{
		if ($this->_col_name !== null)
		{
			// Capture any filtering that has already been added
			$current_where = $this->where;

			// If there is no filtering then we don't need to add any special organization
			if ( ! empty($current_where))
			{
				$this->where = array();

				// Make sure the existing filtering is wrapped safely
				$this->and_where_open();
				$this->where = array_merge($this->where, $current_where);
				$this->and_where_close();
			}

			// Finally add the soft delete filtering
			$this->where($this->_col_name, null);
		}
	}

}
