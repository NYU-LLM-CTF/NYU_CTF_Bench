const MemoryStorage = require('simple-memory-storage');

const db = new MemoryStorage();

db.set('nimda', {
    'username': 'nimda',
    'password': 'nimda',
    'balance': '5',
    'portfolio': [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
});
db.set('alice', {
    'username': 'alice',
    'password': 'alice',
    'balance': '5',
    'portfolio': [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
});
db.set('bob', {
    'username': 'bob',
    'password': 'bob',
    'balance': '5',
    'portfolio': [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
});

module.exports = db;

