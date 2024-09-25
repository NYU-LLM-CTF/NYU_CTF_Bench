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
 * Adds temporal properties to the query object to allow for correct relation
 * filtering on joins.
 *
 * @package Orm
 * @author  Fuel Development Team
 */
class Query_Temporal extends Query
{
	protected $timestamp = null;
	protected $timestamp_end_col = null;
	protected $timestamp_start_col = null;

	/**
	 * Sets the timestamp to be used on joins. If set to null the latest revision
	 * is used.
	 *
	 * @param string $stamp Timestamp to look for
	 * @param string $timestamp_end_col Name of the end timestamp column
	 * @param string $timestamp_start_col Name of teh start timestamp column
	 */
	public function set_temporal_properties(
		$stamp,
		$timestamp_end_col,
		$timestamp_start_col)
	{
		$this->timestamp = $stamp;
		$this->timestamp_end_col = $timestamp_end_col;
		$this->timestamp_start_col = $timestamp_start_col;

		return $this;
	}

	/**
	 * Adds extra where conditions when temporal filtering is needed.
	 *
	 * @param array $join_result
	 * @param string $name
	 * @return array
	 */
	protected function modify_join_result($join_result, $name)
	{
		if ( ! is_null($this->timestamp) and is_subclass_of($join_result[$name]['model'], '\Orm\Model_Temporal'))
		{
			//Add the needed conditions to allow for temporal-ness
			$table      = $join_result[$name]['table'][1];
			$query_time = \DB::escape($this->timestamp);
			$join_result[$name]['join_on'][] = array("$table.$this->timestamp_start_col", '<=', $query_time);
			$join_result[$name]['join_on'][] = array("$table.$this->timestamp_end_col", '>=', $query_time);
		}

		return $join_result;
	}

	public function hydrate(&$row, $models, &$result, $model = null, $select = null, $primary_key = null)
	{
		if( is_subclass_of($model, '\Orm\Model_Temporal'))
		{
			$primary_key[] = $this->timestamp_start_col;
			$primary_key[] = $this->timestamp_end_col;
		}
		parent::hydrate($row, $models, $result, $model, $select, $primary_key);
	}

}
