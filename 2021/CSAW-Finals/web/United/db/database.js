const sqlite3 = require('sqlite3').verbose();
const { open } = require('sqlite');
var crypto = require("crypto");
//const faker = require('faker');
const fs = require('fs/promises');
const { hash_password } = require('../auth/hash'); 

// Constants
const NUM_PLAYERS = 10;


// Create the DB
var db = new sqlite3.Database(':memory:', (err) => {
  if (err) {
    return console.error(err.message);
  }
  console.log('Connected to the database');
});

// Seed the players

fs.readFile('./secret/player_seed.json', 'utf-8')
.then(data => {
  const p_data = JSON.parse(data);

  let players = '';
  for (let i = 0; i < NUM_PLAYERS; i++) {
    players += `('${p_data[i].first}','${p_data[i].last}','${p_data[i].specialty}')`;
    if (i < NUM_PLAYERS -1 ) { players += ','}
  }

  db.serialize(function() { 
    db.run(`CREATE TABLE 'players' (
            first TEXT NOT NULL,
            last TEXT NOT NULL,
            specialty TEXT NOT NULL)`);
    
    db.run(`INSERT INTO players (first,last,specialty) VALUES ${players}`);
    });
})

// Seed the admins
fs.readFile('./secret/admin_seed.json', 'utf-8')
.then(data => {
  const p_data = JSON.parse(data);

  let admins = `('${p_data[0].username}','${hash_password(p_data[0].password)}','${p_data[0].name}'),
              ('${p_data[1].username}','${hash_password(p_data[1].password)}','${p_data[1].name}')`;

  db.serialize(function() { 
    db.run(`CREATE TABLE 'admins' (
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            name TEXT NOT NULL)`);
    
    db.run(`INSERT INTO admins (username,password,name) VALUES ${admins}`);
  });
})

module.exports = db;