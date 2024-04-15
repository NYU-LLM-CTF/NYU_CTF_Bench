// To-do: move middleware to new file

var express = require('express');
var router = express.Router();

// Middleware

var crypto = require("crypto");
var db = require('../database');

function restrict(req,res,next){
  if(req.session.user) {
    next();
  } else {
    req.session.error = 'Access denied!';
    res.redirect('/');
  }
}

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

function authenticate(name, pass, fn) {
  if (!module.parent) console.log('Authenticating %s %s', name, pass);

  hash = crypto.createHash('sha256').update(pass).digest('hex');
  
  var qry = `SELECT rowid FROM users WHERE uname = '${name}' AND pass = '${hash}'`;
  console.log(qry);

  db.get(qry, [], (err,row) => {
    
    if (err) {
      console.log("There was an issue with the query");
    }
    
    if(row) {
      console.log('User found');
      console.log(row);
      return fn(null, row);
    }
    else {
      console.log('User not found');
      //return row;
    }
    return fn(null, row);
  });
}

// Routes

router.get('/', function(req,res){
  
  // Clear session errors & username on base route
  if (req.session.error) {
    req.session.error = "";
  }
  if (req.session.username) {
    req.session.username = "";
  }

  res.redirect('/login');
});

router.get('/home', restrict, function(req,res){
  res.render('index', { title: 'Super Secure Section' });
});

router.get('/login', function(req,res){
  var auth_error = req.session.error;  // Authentication error
  var username = req.session.username; // Sanitized username used
  res.render('login', {"error": auth_error, "username": username});
});

router.post('/login', function(req,res){
  
  // Trim any whitespace
  var username = trim_whitespace(req.body.username);
  var password = trim_whitespace(req.body.password);
  
  // Replace admin with nothing
  username = username.replace('admin', '');

  req.session.username = username;

  authenticate(username, password, function(err,user){
    
    if(user) {
      //console.log("User: " + user['rowid']);
      // Regen session when signing in to prevent fixation
      req.session.regenerate(function(){
        // Store user's primary key in the session store to be retrieved
        req.session.user = user['rowid'];
        console.log(req.session);
        req.session.success = 'Authenticated as ' + req.session.user;
        res.redirect('/home');
      });
    } else {
      console.log("Failed at post route");
      req.session.error = "Authentication failed.";
      res.redirect('/login');
    }
  });
});

module.exports = router;
