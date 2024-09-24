import { Meteor } from 'meteor/meteor';
import { Notes } from '../../api/notes/notes.js';
import { Random } from 'meteor/random'
const faker = require('faker');

// if the database is empty on server start, create some sample data.
Meteor.startup(() => {
  if (Notes.find().count() === 0) {
    var data = [
      {
        body: "###Reminders\n\nDon't forget to change the password!",
        owner: Random.id(),
      },
      {
        body: "###TODO\n\nHoist the flag on 4th of July!",
        owner: Random.id(),
      },
      {
        body: "Call terry",
        owner: Random.id(),
      },
      {
        body: "Super secret password: flag{4lly0Urb4s3}",
        owner: Random.id(),
      },
    ];

    for (var i = 0; i < 37; i++) {
      data.push({
        body: '',
        owner: Random.id(),
      });
    }

    var total = Math.floor(Math.random() * 2000) + 1000;
    for (var i = 0; i < total; i++) {
      data.push({
        body: faker.lorem.sentence(),
        owner: Random.id(),
      });
    }

    data.forEach((note) => {
      Notes.insert(note);
    });
  }

  (function addNote() {
    Notes.insert({
      body: faker.lorem.sentence(),
      owner: Random.id(),
    });
    Meteor.setTimeout(addNote, Math.floor(Math.random() * 5000));
  })();
});
