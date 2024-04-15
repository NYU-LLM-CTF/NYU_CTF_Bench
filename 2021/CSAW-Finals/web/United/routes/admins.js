var express = require('express');
var router = express.Router();
var db = require('../db/database');
var passport = require('passport');
const Passport = require('../auth/passport')

/* GET users route to test DB connection */
router.get('/all', function(req,res,next) {

  let qry = 'SELECT rowid, username, name FROM admins';
  db.all(qry, [], (err,rows) => {
  if (err) {
    throw err;
  }
  res.send(JSON.stringify(rows));
  });

});

router.get('/login', function(req,res){
  var auth_error = req.session.error;  // Authentication error
  var username = req.session.username; // Sanitized username used
  res.render('login', { title: "Administrator Login", "error": auth_error, "username": username});
});


router.post('/login', 
  passport.authenticate('local',
  { 
    successRedirect: '/administration',
    failureRedirect: '/admins/login',
    failureFlash: true
  }
));

router.get('/logout', function(req,res) {
  req.logout();
  res.redirect('./login');
});


router.get('/contact', function(req,res) {
  res.render('contact', { user: req.user })
})


module.exports = router;
