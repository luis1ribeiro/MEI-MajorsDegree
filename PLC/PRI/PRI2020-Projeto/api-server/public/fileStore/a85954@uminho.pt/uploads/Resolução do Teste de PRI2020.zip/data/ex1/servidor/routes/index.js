var express = require('express');
var router = express.Router();
const Casamento = require('../controllers/casamento')

/* GET home page. */

router.get('/casamentos', function(req, res) {
  if(req.query.nome)
    Casamento.listarNome(req.query.nome)
      .then(dados => res.status(200).jsonp(dados))
      .catch(e => res.status(500).jsonp({error: e}))
  else
    if(req.query.ano)
      Casamento.listarAno(req.query.ano)
        .then(dados => res.status(200).jsonp(dados))
        .catch(e => res.status(500).jsonp({error: e}))
  else
    if(req.query.byAno)
      Casamento.listarByAno()
        .then(dados => res.status(200).jsonp(dados))
        .catch(e => res.status(500).jsonp({error: e}))
  else{
    Casamento.listar()
      .then(dados => res.status(200).jsonp(dados) )
      .catch(e => res.status(500).jsonp({error: e}))
  }
});

router.get('/casamentos/noivos', function(req, res) {
  Casamento.listarNoivos()
    .then(dados => res.status(200).jsonp(dados))
    .catch(e => res.status(500).jsonp({error: e}))
});

router.get('/casamentos/:id', function(req, res) {
  Casamento.consultar(req.params.id)
    .then(dados => res.status(200).jsonp(dados))
    .catch(e => res.status(500).jsonp({error: e}))
});




router.get('/types/pubs', function(req, res) {
  Pub.consultarTypesPub(req.params.id)
    .then(dados => res.status(200).jsonp(dados))
    .catch(e => res.status(500).jsonp({error: e}))
});

router.get('/types', function(req, res) {
  Pub.listarTypes()
    .then(dados => res.status(200).jsonp(dados))
    .catch(e => res.status(500).jsonp({error: e}))
});

router.get('/autores', function(req, res) {
  Pub.listarAutores()
    .then(dados => res.status(200).jsonp(dados))
    .catch(e => res.status(500).jsonp({error: e}))
});


/*
GET /api/pubs - Devolve a lista de publicações apenas com os campos "id", "title", "year" e "type";
GET /api/pubs/:id - Devolve a informação completa de uma publicação;
GET /api/types - Devolve a lista de tipos, sem repetições;
GET /api/pubs?type=YYY - Devolve a lista de publicações que tenham o campo "type" com o valor "YYY";
GET /api/pubs?type=YYY&year=AAAA - Devolve a lista de publicações que tenham o campo "type" com o valor "YYY" e o campo "year" com um valor superior a "AAAA";
GET /api/autores - Devolve uma lista ordenada alfabeticamente com os nome dos autores ;
GET /api/pubs?autor=AAA - Devolve uma lista com as publicações do autor.
*/

module.exports = router;
