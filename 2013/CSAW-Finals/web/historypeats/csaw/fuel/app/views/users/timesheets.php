<?php if (isset($errors)){echo $errors;}?>
<?php echo Form::open(array('action' => 'users/timesheets', 'class' => 'form-signin')); ?>
    <h2 class="form-signin-heading">Timesheets</h2>
    <input type="text" name="month" class="form-control" placeholder="Month - June, etc." required>
    <input type="text" name="day" class="form-control" placeholder="Day - Monday, etc." required>
    <input type="text" name="Time" class="form-control" placeholder="Time - 8:21" required>
    <input type="text" name="description" class="form-control" placeholder="Description of work" required>

    <button class="btn btn-lg btn-primary btn-block" type="submit">Submit</button>
<?php echo Form::close(); ?>