var express = require('express');
var router = express.Router();

function verificaNivel(ad, lvl){
  return ad==lvl
}

/* GET home page. */
router.get('/', function(req, res, next) {
  res.status(200).jsonp({dados: "O token foi verificado! E estou no get '/'!"})
});

/* GET área protegida. Testar o nível! */
router.get('/secreta', function(req, res, next) {
  if(verificaNivel('admin', req.user.level)) {
    res.status(200).jsonp({dados: "O token foi verificado! Sou admin e estou na zona secreta!"})
  }
  else{
    res.status(401).jsonp({error: "Não tenho acesso a esta rota!"})
  }
  /* Podiamos por o verificaNivel como middleware e mandar o req, res como argumentos */
});


module.exports = router;
