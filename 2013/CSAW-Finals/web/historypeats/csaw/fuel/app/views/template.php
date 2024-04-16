<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Jenga - <?php echo $title; ?></title>
	<?php echo Asset::css('bootstrap.css'); ?>
    <?php echo Asset::css('signin.css'); ?>

</head>
<body>
<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <?php echo Html::anchor('users','Jenga Blocks', array('class' => 'navbar-brand jenga_title')); ?>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li><?php echo Html::anchor('users','Home'); ?></li>
                <li><?php if(!Auth::check()){echo Html::anchor('users/login','Login');} ?></li>
                <li><?php if(Auth::check()){ echo Html::anchor('users/home','Profile');} ?></li>
                <li><?php if(Auth::check()){ echo Html::anchor('users/logout','Logout');} ?></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</div>
	<div class="container">

<?php if (Session::get_flash('success')): ?>
			<div class="alert alert-success">
				<strong>Success</strong>
				<p>
				<?php echo implode('</p><p>', e((array) Session::get_flash('success'))); ?>
				</p>
			</div>
<?php endif; ?>
<?php if (Session::get_flash('error')): ?>
			<div class="alert alert-danger">
				<strong>Error</strong>
				<p>
				<?php echo implode('</p><p>', e((array) Session::get_flash('error'))); ?>
				</p>
             </div>
<?php endif; ?>
<?php echo $content; ?>
</body>
</html>