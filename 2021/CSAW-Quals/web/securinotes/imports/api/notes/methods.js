import { Meteor } from 'meteor/meteor';
import { Notes } from './notes.js';

Meteor.methods({
    'notes.count': function(filter) {
        return Notes.find(filter).count();
    },
    'notes.add': function() {
        let user = this.userId;

        if (!user) {
            throw new Meteor.Error('not-authorized', "You are not logged in.");
        }

        return Notes.insert({
            body: "### Title\n\nNew note\n\nCreated at " + (new Date()).toLocaleString(),
            owner: user,
        });
    },
    'notes.remove': function(id) {
        let user = this.userId;

        if (!user) {
            throw new Meteor.Error('not-authorized', "You are not logged in.");
        }

        return Notes.remove({_id: id, owner: this.userId});
    },
});