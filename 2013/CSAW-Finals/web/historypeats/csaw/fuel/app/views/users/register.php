<?php if (isset($errors)){echo $errors;}?>
<?php echo Form::open(array('action' => 'users/register', 'class' => 'form-signin')); ?>
    <h2 class="form-signin-heading">Registration</h2>
    <p><input type="text" name="username" class="form-control" placeholder="Username" required></p>
    <p><input type="text" name="email" class="form-control" placeholder="Email" required></p>
    <p><input type="password" name="password" class="form-control" placeholder="Password" required></p>
    <p><input type="password" name="password2" class="form-control" placeholder="Re-type Password" required></p>
    <p><input type="text" name="nickname" class="form-control" placeholder="Nickname" required></p>
    <button class="btn btn-lg btn-primary btn-block" type="submit">Register</button>
<?php echo Form::close(); ?>