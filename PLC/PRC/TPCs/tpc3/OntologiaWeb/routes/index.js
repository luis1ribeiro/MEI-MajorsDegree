var express = require('express');
var router = express.Router();
var axios = require('axios');

const prefixes = `
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://w3.org/2000/01/rdf-schema#>
PREFIX noInferences: <http://www.ontotext.com/explicit>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
`
const p = "http://www.di.uminho.pt/prc2021/"
const uri = "http://localhost:7200/repositories/"

/* ------------------------------------------------------------ */
/* GET all repositorios. */
router.get('/', function(req, res) {
  axios.get("http://localhost:7200/rest/repositories")
    .then(dados => {
        res.render('index', {repositorios: dados.data});
    })
    .catch(erro=>{
      res.render('error',{error: erro});
      })
});
/* ------------------------------------------------------------ */

/* ------------------------------------------------------------ */
/* GET repositorio */
router.get('/:rep',function(req,res){
  var rep_id = req.params.rep
 

  axios.get("http://localhost:7200/rest/repositories/"+rep_id)
    .then(dados=> {
      var info = dados.data;

      var getLink = "http://localhost:7200/repositories/" + req.params.rep + "?query="
      var query = `SELECT ?s WHERE { ?s rdf:type owl:Class}`

      var encoded = encodeURIComponent(prefixes + query)

      axios.get(getLink + encoded)
        .then(dados => {
          // Buscar todas as classes. Preciso do prefix.
          cls = dados.data.results.bindings.map(bind => bind.s.value.split('#')[1]);

          res.render('rep', { info: info, uri: uri, classes: cls, prefixo: p + req.params.rep + '#'});
        
        }).catch(e => {
          res.render('error', {error: e});
        });
    
    }).catch(e => {
      res.render('error', {error: e});
    });
});
/* ------------------------------------------------------------ */

/* ------------------------------------------------------------ */
/* GET classe de repositorio */
router.get('/:rep/:cl', function (req, res, next) {

  var temp = prefixes + "PREFIX v: <" + p + req.params.rep + "#>";

  var getLink = "http://localhost:7200/repositories/" + req.params.rep + "?query="
  var query = `SELECT ?s WHERE { ?s rdf:type v:` + req.params.cl + `}`

  var encoded = encodeURIComponent(temp + query)

  axios.get(getLink + encoded).then(dados => {
      var inds = dados.data.results.bindings.map(bind => bind.s.value.split('#')[1])
      res.render('classe', {
          rep: req.params.rep,
          classe: req.params.cl,
          prefixo: p + req.params.rep + '#',
          inds: inds
      });
  }).catch(e => {
      res.render('error', {error: e});
  })
});
/* ------------------------------------------------------------ */

/* ------------------------------------------------------------ */
/* GET individuo de classe */
router.get('/:rep/:cl/:ind', function (req, res, next) {
  
  var temp = prefixes + "PREFIX v: <" + p + req.params.rep + "#>";

  var getLink = "http://localhost:7200/repositories/" + req.params.rep + "?query="
  var query = `SELECT * WHERE { v:` + req.params.ind + ` ?p ?o}`

  var encoded = encodeURIComponent(temp + query)

  axios.get(getLink + encoded).then(dados => {
      var pps = dados.data.results.bindings.map(bind => {
          return {
              p: bind.p.value.split('#')[1],
              o: (bind.o.type == 'literal') ? bind.o.value : bind.o.value.split('#')[1]
          }
      });

      res.render('individuo', {
          rep: req.params.rep,
          classe: req.params.cl,
          individuo: req.params.ind,
          prefixo: p + req.params.rep + '#',
          propriedades: pps
      });
  }).catch(e => {
      res.render('error', {error: e});
  })
});
/* ------------------------------------------------------------ */


module.exports = router;