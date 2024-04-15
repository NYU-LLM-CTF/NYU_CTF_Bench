/*
var mysql = require('mysql');
var connection = mysql.createConnection({
  host: 'mysql',
  user: 'app',
  password: 'thisistheapppass',
  database: 'db',
  multipleStatements: true
});

console.log('Connected to db')

module.exports = connection;
*/

const sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database(':memory:', (err) => {
  if (err) {
    return console.error(err.message);
  }
  console.log('Connected to the database');
});

db.serialize(function() {
  db.run(`CREATE TABLE 'users' (
    uname TEXT NOT NULL,
    pass TEXT NOT NULL)`
  );
  db.run(`INSERT INTO users (uname,pass) VALUES ('admin','8f288474c313275914133669946a7a18dea47e6af874a5cb530af8110a5189b0')`); 
});


module.exports = db;