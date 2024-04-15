<?php if (isset($errors)){echo $errors;}?>
<?php echo Form::open(array('action' => 'users/login', 'class' => 'form-signin')); ?>
    <h2 class="form-signin-heading">Please sign in</h2>
    <input type="text" name="username" class="form-control" placeholder="username" required autofocus>
    <input type="password" name="password" class="form-control" placeholder="Password" required>
    <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
<?php echo Html::anchor('users/register','Register to submit your timesheets!'); ?>
<?php echo Form::close(); ?>