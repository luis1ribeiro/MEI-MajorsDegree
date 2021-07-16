var express = require('express');
var router = express.Router();
var jwt = require('jsonwebtoken')

/* GET users listing.
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
}); */

var userAdmin = {username: "jcr", pwd: "123", level: "admin"};
var user = {username: "pj", pwd: "456", level: "consumer"};

/* 
    * O utilizador identifica-se com username e pwd.
    * Se as credenciais estiverem corretas, um TOKEN é gerado e enviado como resposta.
*/
router.post('/', function (req, res) {
  if ((req.body.username == user.username) && (req.body.password == user.password)) {
      jwt.sign({
          username: user.username,
          level: user.level,
          expiresIn: '1d'
      }, 'PRI2020',function(e,token){
          if(e){
              res.status(500).jsonp({error: "ERRO na verificao do token: " + err})
          }
          else{
              res.status(200).jsonp({token:token});
          }
      });

  } else {
      res.status(401).jsonp({error: "Credenciais inválidas!"})
  }
});

module.exports = router;
