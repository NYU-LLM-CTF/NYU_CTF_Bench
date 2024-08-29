import express from 'express';
import { LowSync, MemorySync } from 'lowdb';
import merge from 'merge-objects';
import xss from 'xss';

import { emergencyAlert } from './hero.js';

const app = express();
const db = new LowSync(new MemorySync());
db.data = {'emergencies': [], 'submissions': []}


app.use(express.json());
app.use(express.static('public'));

function sanitize(string) {
    if (!string) return '';

    let sanitized = xss(string);

    // Villians have been keeping tabs on the hero. I think they're tracking
    // him through his cookie...although I can't figure out how they keep 
    // getting past the XSS filtering. This seems to have stopped them for 
    // now until we can figure out a more permanent solution to the problem.
    return sanitized.replace(/C/g, '\u0421').replace(/c/g, '\u0441');
}

app.post('/contact', (req, res) => {
    let details = {
        'name': 'Anonymous',
        'email': 'n/a',
        'phone': 'n/a',
        'emergency': false
    };
    
    // Add check to prevent polluting key global object properties
    const bodyString = JSON.stringify(req.body);
    const badProperties = ['hasOwnProperty', 'isPrototypeOf', 'propertyIsEnumerable', 'toLocaleString', 'toString', 'valueOf'];
    const containsBad = (sub) => bodyString.includes(sub);
    if (badProperties.some(containsBad)) return res.end();

    try {
        merge(details, req.body);
        details.message = sanitize(details.message);
    } catch{
        return res.end()
    } finally {
        // needed only on live version to clean prototype pollution
        // so that it doesn't affect all users or cause errors
        for (const prop in {}.__proto__) {
            delete {}.__proto__[prop];
        }
    }
    
    if (details.message) {
        if (details.emergency) {
            // Update the emergencies list and immediately alert the hero
            db.data.emergencies.push(details);
            emergencyAlert();
        } else {
            // Save non-emergencies for later review
            db.data.submissions.push(details);
        }
    }

    res.end();
});

app.get('/handle-emergency', (req, res) => {
    // Only the hero can access the list of emergencies
    if (req.connection.remoteAddress != '::ffff:127.0.0.1') return res.redirect('/');

    // Retrieve the next emergency and send info back to the hero
    let emergency = db.data.emergencies.shift();
    res.send(emergency.message);
});

app.listen(8080, () => { console.log('Listening on port 8080...'); });