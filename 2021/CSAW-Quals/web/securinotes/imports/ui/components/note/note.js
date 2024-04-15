import { ReactiveVar } from 'meteor/reactive-var'
const markdown = require('markdown').markdown;

import './note.html'

import Materialize from 'materialize-css';

Template.Note.onCreated(function () {
    this.editing = new ReactiveVar(false);
});

Template.Note.helpers({
    to_markdown(m) {
        return markdown.toHTML(m);
    },
    editing() {
        return Template.instance().editing.get();
    },
});

Template.Note.events({
    'click div.card-body': function (e, t) {
        t.editing.set(!t.editing.get());
        Tracker.afterFlush(function() {
            this.find('textarea').focus();
        }.bind(t));
    },
    'change textarea.card-body-edit': function(e, t) {
        t.data.note.body = e.currentTarget.value;
    },
    'focusout textarea.card-body-edit': function(e, t) {
        if (e.currentTarget.value) {
            t.editing.set(!t.editing.get());
        }
    },
    'click .card-delete-btn': function(e, t) {
        Meteor.call('notes.remove', this.note._id, function(err, res) {
            if (err) {
                Materialize.toast({html: 'An error occurred: ' + err.toString(), displayLength: 3000});
            } else {
                Materialize.toast({html: 'Successfully deleted note!', displayLength: 3000});
            }
        })
    }
})
