var express = require('express');
var router = express.Router();
var axios = require('axios');

var api = 'http://clav-api.di.uminho.pt/v2/classes'

/* GET home page. */
router.get('/', function(req, res) {
  axios.get(api+'?nivel=1&token=' + token)
    .then(dados=>{
      res.render('index',{ lista: dados.data, stoken: token})
    })
    .catch(erro=>{
      res.render('error',{error: erro});
      })
});

router.get('/:codigo',function(req,res){
  var codigo = req.params.codigo
  var array = []
  var nivel3 = 0
  axios.get(api+'/'+codigo+'?token='+token)
    .then(dados=> {
      pai = dados.data.pai.codigo
      if(dados.data.nivel == 1){
        pai = 0
      }
      if(dados.data.nivel == 3){
        nivel3 = 1
      }
      console.log(array)
      res.render('classe',{classe: dados.data, arr: array, bool: nivel3, pai: pai})
    })
    .catch(erro => res.render('error',{error:erro}))
})




module.exports = router;