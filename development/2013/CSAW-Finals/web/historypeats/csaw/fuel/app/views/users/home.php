<div class="row row-offcanvas row-offcanvas-right">

    <div class="col-xs-12 col-sm-9">
        <p class="pull-right visible-xs">
            <button type="button" class="btn btn-primary btn-xs" data-toggle="offcanvas">Toggle nav</button>
        </p>
        <br />
        <div class="jumbotron jumbotron-edits">
            <h1>Submit your timesheets!</h1>
            <p>This is an example to show the potential of an offcanvas layout pattern in Bootstrap. Try some responsive-range viewport sizes to see it in action.</p>
        </div>
        <div class="row">
            <div class="col-6 col-sm-6 col-lg-4">
                <h2>Company News</h2>
                <p>After popular demand, Sloppy Joe Thursdays will be reinstated. You can all thank Henry Johnson, The Meat King, for reaching out to management.</p>
                <p><a class="btn btn-default" href="#" role="button">View details »</a></p>
            </div><!--/span-->
            <div class="col-6 col-sm-6 col-lg-4">
                <h2>Public Relations</h2>
                <p>Our very own Megan Twofish will premier tonight on the Jimmy Kimmel show. Be sure to tune into CBS @ 9PM EST and show her some support!</p>
                <p><a class="btn btn-default" href="#" role="button">View details »</a></p>
            </div><!--/span-->
            <div class="col-6 col-sm-6 col-lg-4">
                <h2>Job Openings</h2>
                <p>Hallway Ninja</p>
                <p><a class="btn btn-default" href="#" role="button">View details »</a></p>
            </div><!--/span-->
        </div><!--/row-->
    </div><!--/span-->
    <br />
    <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
        <div class="list-group">
            <?php echo Html::anchor('users/timesheets','Timesheets', array('class' => 'list-group-item')); ?>
            <?php echo Html::anchor('users/profile','Update Profile', array('class' => 'list-group-item')); ?>
        </div>
    </div><!--/span-->
</div>