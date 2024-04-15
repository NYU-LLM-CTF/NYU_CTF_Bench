function init_reporting(app) {
  app.get('/report', (req, res) => {
    res.send('No reporting backend found');
  })
}


modules.exports = { init_reporting }
