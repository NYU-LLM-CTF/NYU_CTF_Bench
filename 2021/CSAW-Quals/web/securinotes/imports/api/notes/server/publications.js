import { Meteor } from 'meteor/meteor';
import { Notes } from '../notes.js';

Meteor.publish('notes.private', function () {
    if (!this.userId) {
        return this.ready();
    }

    return Notes.find({
        owner: this.userId,
    });
});