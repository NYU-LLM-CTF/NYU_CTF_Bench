var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var session = require('express-session'); 
var app = express();

var indexRouter = require('./routes/index');
var adminsRouter = require('./routes/admins');
var playersRouter = require('./routes/players');

// View engine setup
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

// Session & Passport setup
app.use(session({
  resave: false, // dont save session if unmodified
  saveUninitialized: false, // dont create session until something is stored
  secret: 'hmm a secret'
}));
require('./auth/passport')(app)

// Routes
app.use('/', indexRouter);
app.use('/admins', adminsRouter);
app.use('/players', playersRouter);

// Catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// Error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // Render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
