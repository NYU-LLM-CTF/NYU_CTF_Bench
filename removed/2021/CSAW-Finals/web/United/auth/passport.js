//const passport = require('passport');
var passport = require('passport'), LocalStrategy = require('passport-local').Strategy;
//var crypto = require("crypto");
var db = require('../db/database');
const { hash_password } = require('../auth/hash'); 

module.exports = (app) => {
    app.use(passport.initialize());
    app.use(passport.session());

    /*
    function hash_password(password) {
        let hash = crypto.createHash('sha256').update(password).digest('hex');
        return hash;
    }
    */

    passport.use(new LocalStrategy(function(username, password, done) {
        /*
        db.get('SELECT salt FROM users WHERE username = ?', username, function(err, row) {
        if (!row) return done(null, false);
        */
        var hash = hash_password(password);
        db.get('SELECT rowid, username FROM admins WHERE username = ? AND password = ?', username, hash, function(err, row) {
        if (!row) return done(null, false);
        return done(null, row);
        });
        //});
    }));
    
    passport.serializeUser(function(user, done) {
        console.log(user);
        return done(null, user.rowid);
    });
    
    passport.deserializeUser(function(id, done) {
        db.get('SELECT rowid, username FROM admins WHERE rowid = ?', id, function(err, row) {
        if (!row) return done(null, false);
        return done(null, row);
        });
    });

}