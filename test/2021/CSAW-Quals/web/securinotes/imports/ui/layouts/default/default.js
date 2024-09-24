import { Meteor } from 'meteor/meteor';
import { Template } from 'meteor/templating';
import { FlowRouter } from 'meteor/kadira:flow-router';

import './default.html';

import Materialize from 'materialize-css';
import $ from 'jquery';

Template.Layout_default.onRendered(function () {
    $(".sidenav").sidenav();
});

Template.Layout_default.helpers({
    'username': function () {
        var user = Meteor.user();
        return user ? user.username : '';
    }
})

Template.Layout_default.events({
    'click #logout': function (e, t) {
        Meteor.logout(function () {
            $('.sidenav').sidenav('close');
            FlowRouter.go('/login');
            Materialize.toast({html: "Logged out!", displayLength: 3000});
        })
    }
})
