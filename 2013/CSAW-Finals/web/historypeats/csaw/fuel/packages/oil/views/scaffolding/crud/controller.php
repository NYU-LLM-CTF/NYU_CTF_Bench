<?php echo '<?php' ?>

class <?php echo \Config::get('controller_prefix', 'Controller_').$controller_name; ?> extends <?php echo \Cli::option('extends', $controller_parent) ?>
{

<?php foreach ($actions as $action): ?>
	public function action_<?php echo $action['name']; ?>(<?php echo $action['params']; ?>)
	{
<?php echo $action['code'].PHP_EOL; ?>
	}

<?php endforeach; ?>

}
