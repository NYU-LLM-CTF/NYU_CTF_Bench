<?php echo '<?php echo Form::open(array("class"=>"form-horizontal")); ?>' ?>


	<fieldset>
<?php foreach ($fields as $field): ?>
		<div class="form-group">
			<?php echo "<?php echo Form::label('". \Inflector::humanize($field['name']) ."', '{$field['name']}', array('class'=>'control-label')); ?>\n"; ?>

<?php switch($field['type']):

				case 'text':
					echo "\t\t\t\t<?php echo Form::textarea('{$field['name']}', Input::post('{$field['name']}', isset(\${$singular_name}) ? \${$singular_name}->{$field['name']} : ''), array('class' => 'col-md-8 form-control', 'rows' => 8, 'placeholder'=>'".\Inflector::humanize($field['name'])."')); ?>\n";
				break;

				default:
					echo "\t\t\t\t<?php echo Form::input('{$field['name']}', Input::post('{$field['name']}', isset(\${$singular_name}) ? \${$singular_name}->{$field['name']} : ''), array('class' => 'col-md-4 form-control', 'placeholder'=>'".\Inflector::humanize($field['name'])."')); ?>\n";

endswitch; ?>

		</div>
<?php endforeach; ?>
		<div class="form-group">
			<label class='control-label'>&nbsp;</label>
			<?php echo '<?php'; ?> echo Form::submit('submit', 'Save', array('class' => 'btn btn-primary')); <?php echo '?>'; ?>
		</div>
	</fieldset>
<?php if ($csrf): ?>
	<?php echo '<?php'; ?> echo Form::hidden(Config::get('security.csrf_token_key'), Security::fetch_token()); <?php echo '?>'; ?>
<?php endif; ?>
<?php echo '<?php'; ?> echo Form::close(); <?php echo '?>'; ?>
