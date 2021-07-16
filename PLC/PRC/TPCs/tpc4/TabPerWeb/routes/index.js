var express = require('express');
var router = express.Router();
var axios = require('axios');

const prefixes = `
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX : <http://www.daml.org/2003/01/periodictable/PeriodicTable#>
    prefix tabP: <http://www.daml.org/2003/01/periodictable/PeriodicTable#>
`
const getLink = "http://localhost:7200/repositories/tabPeriodica?query=";

/* ------------------------------------------------------------ */
/* GET home page. Links para os Elementos, Grupos e Períodos */
router.get('/', function (req, res, next) {
  res.render('index', {});
});
/* ------------------------------------------------------------ */

/* ------------------------------------------------------------ */
/* GET Elementos */
router.get('/elementos', function(req,res){

  /* Query feita em aula */
  var query = `SELECT ?s ?simb ?name ?anumber WHERE { ?s rdf:type tabP:Element ; :symbol ?simb ; :name ?name ; :atomicNumber ?anumber.} ORDER BY (?anumber)`;
  var encoded = encodeURIComponent(prefixes + query)
 
  axios.get(getLink + encoded)
    .then(dados => {

      els = dados.data.results.bindings.map(bind => {
        return({
            id: bind.s.value.split('#')[1],
            numeroAtomico: bind.anumber.value,
            nomeElemento: bind.name.value,
            simbolo: bind.simb.value
        })
    });

      // console.log(els)
      res.render('elementos', { elementos: els});
        
    }).catch(e => {
        res.render('error', {error: e});
    });
});

/* GET Elemento */
router.get('/elementos/:id', function (req, res, next) {
  
  id = req.params.id
  /* Query feita em aula */
  var query = 'SELECT DISTINCT ?name ?symbol ?anumber ?aweight ?color ?block ?classification ?group ?period ?standardstate WHERE {  tabP:' + id +' ?p ?o ; :name ?name ; :symbol ?symbol ; :atomicNumber ?anumber ; :atomicWeight ?aweight ; :color ?color ; :block ?block ; :classification ?classification ; :group ?group ; :period ?period ; :standardState ?standardstate . }'
  var encoded = encodeURIComponent(prefixes + query);

  axios.get(getLink + encoded).then(dados => {
      elemento = dados.data.results.bindings.map(bind => {
          return({
              name: bind.name.value,
              symbol: bind.symbol.value,
              anumber: bind.anumber.value,
              aweight: bind.aweight.value,
              classification: bind.classification.value.split('#')[1],
              color: bind.color.value,
              block: bind.block.value.split('#')[1],
              group: bind.group.value.split('#')[1],
              period: bind.period.value.split('#')[1].split('_')[1],
              standardstate: bind.standardstate.value.split('#')[1]
          })
      });
      
      // console.log(elemento)
      res.render('elemento', {
          elemento: elemento[0]
      });

  }).catch(e => {
      res.render('error', {error: e});
  });
});

/* ------------------------------------------------------------ */

/* ------------------------------------------------------------ */
/* GET Grupos */
router.get('/grupos', function(req,res){

  var query = `SELECT ?g ?name ?number WHERE { ?g a tabP:Group . OPTIONAL{ ?g :name ?name } . OPTIONAL{ ?g :number ?number } . }`;
  var encoded = encodeURIComponent(prefixes + query)
 
  axios.get(getLink + encoded)
    .then(dados => {
      grupos = dados.data.results.bindings.map(bind => {
        return({
            id: bind.g.value.split('#')[1],
            nome: (bind.name) ? bind.name.value : "Nome não definido",
            numero: (bind.number) ? bind.number.value : "Número de Grupo não definido"
        })
    });
    
    /* Dentro da dataTable não consigo ordenar por número, por ter strings... */
    res.render('grupos', { grupos: grupos});
        
    }).catch(e => {
        res.render('error', {error: e});
    });
});

/* GET Grupo */
router.get('/grupos/:id', function (req, res, next) {
  
  id = req.params.id
  var query = 'SELECT ?elements ?number ?nome WHERE { tabP:'+id+' :element ?elements . OPTIONAL{ tabP:'+id+' :name ?nome } . OPTIONAL{ tabP:'+id+' :number ?number } .}';
  var encoded = encodeURIComponent(prefixes + query);


  axios.get(getLink + encoded).then(dados => {
      grupo = dados.data.results.bindings.map(bind => {
          return({
              nomeG: (typeof bind.nome != "undefined") ? bind.nome.value : '',
              numeroG: (typeof bind.number != "undefined") ? bind.number.value : '',
              elemento: bind.elements.value.split('#')[1]
          })
      });

      res.render('grupo', {
          nome: grupo[0].nomeG,
          numero: grupo[0].numeroG,
          elementos: grupo
      });

  }).catch(e => {
      res.render('error', {error: e});
  });
});


/* ------------------------------------------------------------ */

/* ------------------------------------------------------------ */
/* GET Periodos */
router.get('/periodos', function(req,res){

  var query = `SELECT ?p ?number WHERE { ?p a tabP:Period . ?p :number ?number }`;
  var encoded = encodeURIComponent(prefixes + query)
 
  axios.get(getLink + encoded)
    .then(dados => {

      pers = dados.data.results.bindings.map(bind => {
        return({
            // id = period_*numero*
            numero: (bind.number) ? bind.number.value : "Número Atómico não definido"
        })
    });

      res.render('periodos', { periodos: pers});
        
    }).catch(e => {
        res.render('error', {error: e});
    });
});

/* GET Periodo */
router.get('/periodos/:id', function (req, res, next) {

  id = req.params.id
  n = "period_"+id
  console.log(n)
  var query = 'SELECT distinct ?elemento WHERE { tabP:' + n + ' ?p ?o . tabP:' + n + ' :element ?elemento } ORDER BY ?elemento';
  var encoded = encodeURIComponent(prefixes + query);

  axios.get(getLink + encoded).then(dados => {
      periodo = dados.data.results.bindings.map(bind => {
          return({
              element: bind.elemento.value.split('#')[1]
          })
      });
      
      // console.log(id + "    tudo bem")
      res.render('periodo', {
          id: id,
          elementos: periodo
      });

  }).catch(e => {
      res.render('error', {error: e});
  });
});

/* ------------------------------------------------------------ */


module.exports = router;