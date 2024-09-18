var express = require('express');
var router = express.Router();
var db = require('../database');

/* GET users route to test DB connection */
router.get('/all', function(req,res,next) {

  /*
  conn.query(`SELECT user_id, uname FROM users`, function(err, result,fields) {
    if (err) {
      console.log(err);
    }
    res.send(JSON.stringify(result));
  });
  */

  let qry = 'SELECT rowid, uname FROM users';
  db.all(qry, [], (err,rows) => {
  if (err) {
    throw err;
  }
  res.send(JSON.stringify(rows));
  });

});

router.post('/login',function(req,res) {
  res.send('You have logged in.')
});

module.exports = router;
