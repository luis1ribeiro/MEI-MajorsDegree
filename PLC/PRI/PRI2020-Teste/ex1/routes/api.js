var express = require('express');
var router = express.Router();
var axios = require('axios'); 
var Casamentos = require('../controllers/casamentos')

//GET /api/obras
router.get('/casamentos', function(req,res){
  var nome = req.query.nome
  var ano = req.query.ano
  var byAno = req.query.byAno

  if(nome){
    Casamentos.listporNome(nome)
      .then(dados => res.jsonp(dados))
      .catch(erro => res.status(500).jsonp(erro))
  }
  else if(ano){
    Casamentos.listporAno(ano)
    .then(dados => res.jsonp(dados))
    .catch(erro => res.status(500).jsonp(erro))
  }
  else if(byAno=="true"){
    Casamentos.byAno()
    .then(dados => res.jsonp(dados))
    .catch(erro => res.status(500).jsonp(erro))
  }
  else{
    Casamentos.listar()
    .then(dados => res.jsonp(dados))
    .catch(erro => res.status(500).jsonp(erro))
  }
});

//GET /api/obras/:id
router.get('/casamentos/noivos',function(req,res){
  /* axios.get('/casamentos').then(dados=> {
    var casamentos = dados.data
    casamentos.forEach(a =>{
      noi
    })
  })*/
  Casamentos.noivos()
    .then(dados => res.jsonp(dados))
    .catch(erro => res.status(500).jsonp(erro))
})

//GET /api/obras/:id
router.get('/casamentos/:id',function(req,res){
  Casamentos.consultar(req.params.id)
    .then(dados => res.jsonp(dados))
    .catch(erro => res.status(500).jsonp(erro))
})


module.exports=router;