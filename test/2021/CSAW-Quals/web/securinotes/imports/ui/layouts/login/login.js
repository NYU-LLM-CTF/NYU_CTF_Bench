import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base';
import { ReactiveVar } from 'meteor/reactive-var';

import './login.html';

import Materialize from 'materialize-css';
import $ from 'jquery';

Template.Layout_login.onCreated(function () {
    var self = this;
    this.notescount = new ReactiveVar(0);

    function noteCountUpdater() {
        Meteor.call('notes.count', {body: {$ne: ''}}, function(err, res) {
            //console.log(res)
            self.notescount.set(res);
        });
    }
    noteCountUpdater();
    this.refresher = Meteor.setInterval(noteCountUpdater, 1000);
});

Template.Layout_login.onDestroyed(function () {
    Meteor.clearInterval(this.refresher);
});

Template.Layout_login.onRendered(function () {
    $('.tabs').tabs();
});

Template.Layout_login.helpers({
    'notescount': function() {
        return Template.instance().notescount.get();
    }
});

Template.Layout_login.events({
    'click #btn-login': function (e, t) {
        var email = t.find('#email').value;
        var password = t.find('#password').value;
        if (!email || !password) {
                Materialize.toast({html: "Email and password required!", displayLength: 3000});
        }
        else {
            Meteor.loginWithPassword({username: email}, password, function (err, res) {
                if (err) {
                    Materialize.toast({html: "Login failed!", displayLength: 3000});
                } else {
                    FlowRouter.go('/');
                }
            });
        }
    },
    'click #btn-signup': function (e, t) {
        var email = t.find('#signup-email').value;
        var password = t.find('#signup-password').value;
        var passwordConfirm = t.find('#signup-password-confirm').value;
        if (password == passwordConfirm) {
            Accounts.createUser({username: email, password: password}, function (err, res) {
                if (err) {
                    Materialize.toast({html: "Sign up failed!", displayLength: 3000});
                    return;
                }
                Materialize.toast({html: "Registered!", displayLength: 3000});
                Meteor.loginWithPassword({username: email}, password, function (err, res) {
                    if (err) {
                        Materialize.toast({html: "Login failed!", displayLength: 3000});
                        return;
                    } else {
                        FlowRouter.go('/');
                    }
                });
            });
        } else {
            Materialize.toast({html: "Passwords do not match!", displayLength: 3000});
        }
    },
});
