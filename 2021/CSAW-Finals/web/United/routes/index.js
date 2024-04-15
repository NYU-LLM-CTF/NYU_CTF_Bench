var express = require('express');
var router = express.Router();
var passport = require('passport');
const Passport = require('../auth/passport')
const fs = require('fs/promises');

/*
function trim_whitespace(input_str) {
  var trimmed = input_str;
  var bad_chr_ind = null;
  const regex = /[ %]/; // Catch ' ' but also '%20'

  bad_chr_ind = trimmed.search(regex);
  if (bad_chr_ind != -1) {
    trimmed = trimmed.slice(0,bad_chr_ind)
    console.log("Original string: " + input_str);
    console.log("Sanitized string: " + trimmed);
  }
  return trimmed;
}
*/

router.get('/', function(req,res){
  
  // Clear session errors & username on base route
  if (req.session.error) {
    req.session.error = "";
  }
  if (req.session.username) {
    req.session.username = "";
  }
  res.redirect('/home')
});

router.get('/home', function(req,res){
  res.render('index', { title: 'Welcome to the NYU United Home Page', user: req.user  });
});


router.get('/about', function(req,res){
  res.render('about', { user: req.user  });
});


router.get('/administration', function(req,res) {
  //req.session.user = req.user;
  if (req.user) {

    fs.readFile('./secret/flag.txt', 'utf-8')
    .then(flag_in => {
      res.render('admin', { title: 'Admin Section', user: req.user, flag: flag_in });
    });
  } else {
    res.redirect('/admins/login');
  }
  
});


router.get('/robots.txt', function(req,res) {
  robot = "User-agent: *\n"
  robot += "Disallow: /admins/\n"
  robot += "Disallow: /administration\n"
  
  res.type('text/plain');
  res.send(robot)
});


module.exports = router;
