var express = require('express');
var router = express.Router();
var passport = require('passport')

/* GET users listing. */
router.get('/login', function(req, res) {
  res.render('login-form');
});

router.get('/register', function(req, res) {
  res.send('register-form');
});

router.get('/logout', function(req, res) {
  req.logout();
  res.redirect('/')
})

router.post('/login', passport.authenticate('local'),
   function(req, res){
    console.log('cb do post login..')
    console.log('Auth: ' +JSON.stringify(req.user))
    res.redirect('/protegida')
})

router.post('/register', function(req, res){
  console.log('cb do post register..')
  console.log(req.body)
  res.send('a tratar register')
})



module.exports = router;
