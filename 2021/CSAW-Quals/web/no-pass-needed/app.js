var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
//var hash = require('pbkdf2-password')()   // WT addition
var session = require('express-session'); // WT addition
//var crypto = require("crypto");


var app = express();

//var mysql = require('mysql');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

// view engine setup
app.set('views', path.join(__dirname, 'views'));  
app.set('view engine', 'ejs');  

// Disable Etag to reduce overhead since not using
app.set('etag', false)


// Added by Express generator
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// For authentication
app.use(session({
  resave: false, // dont save session if unmodified
  saveUninitialized: false, // dont create session until something is stored
  secret: 'hmm a secret'
}));

// Routes
app.use('/', indexRouter);
app.use('/users', usersRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
