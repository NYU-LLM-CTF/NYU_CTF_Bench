//jshint esversion:6

const express = require('express')
const app = express()
const session = require('express-session')
const passport = require('passport')
const LocalStrategy = require('passport-local').Strategy
const bodyParser = require("body-parser");
const router = express.Router();
const path = __dirname + '/views/';
const port = 3010;
const ejs = require("ejs");
const _ = require("lodash");


app.locals._ = _
app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.urlencoded({extended: false}))


// PASSPORT  ---------------------------------
app.use(session({
    secret: "secret",
    resave: false ,
    saveUninitialized: true ,
}))

app.use(passport.initialize()) 
app.use(passport.session())   

authUser = (user, password, done) => {
    if (user.toString().toLowerCase().trim() === "nginx" && password.toString().toLowerCase().trim() === '1.17.6') {
        let authenticated_user = { id: 123, name: "nginx" } 
        return done(null, authenticated_user ) 
    }
    return done(null, false ) 
}


passport.use(new LocalStrategy (authUser))

passport.serializeUser( (user, done) => {
    done(null, user.id)
})


passport.deserializeUser((id, done) => {
        done (null, {name: "zoidberg", id: 123} )
})


checkLoggedIn = (req, res, next) => {
  if (req.isAuthenticated()) {
       return res.redirect("/")
   }
  next()
}

checkLoggedIn4Hint = (req, res, next) => {
  if (req.isAuthenticated()) {
       return res.redirect("/succeed_hint")
   }
  next()
}

app.get("/hint", checkLoggedIn4Hint, (req, res) => {
     res.render("hint.ejs")
})


chechAuth4Logout = (req, res, next) => {
  if (req.isAuthenticated()) { return next() }
}

checkAuthenticated = (req, res, next) => {
  if (req.isAuthenticated()) { return next() }
  res.redirect("/hint")
}

app.get("/succeed_hint", checkAuthenticated, (req, res) => {
     res.render("succeed_hint.ejs")
})

app.post ("/hint", passport.authenticate('local', {
    successRedirect: "/succeed_hint",
    failureRedirect: "/hint",
}))


app.delete("/logout", (req,res) => {
    req.logout(function(err) {
    if (err) { return next(err); }
      res.redirect('/');
    });
   console.log(`-------> User Logged out`)
})


app.get('/logout', function(req, res, next){
    req.logout(function(err) {
    if (err) { return next(err); }
      res.redirect('/');
    });
   console.log(`-------> User Logged out`)
});


router.use(function (req,res,next) {
  console.log('/' + req.method);
  next();
});


router.get("/", (req, res) => {
    res.render("index")
})


app.use(express.static(path));
app.use('/', router);



var server = app.listen(port, 'localhost', function () {
  console.log(`Example app listening on port ${port}!`)
})


server.keepAliveTimeout = 30000;



