<?php if (isset($errors)){echo $errors;}?>
<?php echo Form::open(array('action' => 'users/profile', 'class' => 'form-signin')); ?>
    <h2 class="form-signin-heading">Update Profile</h2>
    <p><input type="text" name="email" class="form-control" placeholder="Email" ></p>
    <p><input type="password" name="password" class="form-control" placeholder="Password" ></p>
    <p><input type="password" name="password2" class="form-control" placeholder="Password" ></p>
    <p><input type="text" name="nickname" class="form-control" placeholder="Nickname" ></p>
    <button class="btn btn-lg btn-primary btn-block" type="submit">Update</button>
<?php echo Form::close(); ?>