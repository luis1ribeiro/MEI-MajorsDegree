var express = require('express');
var router = express.Router();
var jwt = require('jsonwebtoken')
var passport = require('passport')

var User = require('../controllers/user')

router.get('/', function(req, res){
  User.listar()
    .then(dados => res.status(200).jsonp({dados: dados}))
    .catch(e => res.status(500).jsonp({error: e}))
})

router.post('/', function(req, res){
  User.inserir(req.body)
    .then(dados => res.status(201).jsonp({dados: dados}))
    .catch(e => res.status(500).jsonp({error: e}))
})
  
router.post('/login', passport.authenticate('local'), function(req, res){
  jwt.sign({ username: req.user.username, level: req.user.level, 
    sub: 'aula de DAW2020'}, 
    "DAW2020",
    {expiresIn: 3600},
    function(e, token) {
      if(e) res.status(500).jsonp({error: "Erro na geração do token: " + e}) 
      else res.status(201).jsonp({token: token})
});
})

module.exports = router;