
import { Meteor } from 'meteor/meteor';
import { Template } from 'meteor/templating';
import { Notes } from '../../../api/notes/notes.js';

const md = require('markdown').markdown;

import '../../../api/notes/methods.js';
import '../../components/note/note.js';

import './home.html';

import Materialize from 'materialize-css';

Template.Home.onCreated(function () {
    Meteor.subscribe('notes.private');
});

Template.Home.helpers({
    notes: Notes.find(),
    no_notes: function() {
        return Notes.find().count() == 0;
    },
    user: function() {
        return Meteor.user();
    },
});

Template.Home.events({
    'click .fixed-action-btn': function (e, t) {
        Meteor.call('notes.add', function (err, res) {
            if (err) {
                Materialize.toast({html: 'An error occurred: ' + err.toString(), displayLength: 3000});
            } else {
                Materialize.toast({html: 'Successfully created a new note!', displayLength: 3000});
            }
        });
    },
});
