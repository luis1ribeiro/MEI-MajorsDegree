var express = require('express');
var router = express.Router();

var axios = require('axios')

const prefixes = ` PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX xml: <http://www.w3.org/XML/1998/namespace>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX : <http://www.di.uminho.pt/prc2021/A85954-TP5#>
`
/* http://epl.di.uminho.pt:8738/api-docs/ -- ONTOBUD BACKEND API*/
const getLink = "http://epl.di.uminho.pt:8738/api/rdf4j/query/A85954-TP5?query=";
const updLink = "http://epl.di.uminho.pt:8738/api/rdf4j/update/A85954-TP5?query=";

/* - Publicações - */
router.get('/pubs', function (req, res, next) {
    if (!(req.query.type)) { /* Se não fornecer tipo. */
        /* Query para ir buscar todas as Pubs - Desde ARTICLE até aos PROCEEDINGS */
        var query = `SELECT ?s ?title WHERE { ?s rdf:type ?type . ?type rdfs:subClassOf* :Pubs. ?s :title ?title . } ORDER BY (?s) `;
        var encoded = encodeURIComponent(prefixes + query);

        axios.get(getLink + encoded).then(dados => {
            pubs = dados.data.results.bindings.map(bind => {
                return({
                    id: bind.s.value.split('#')[1],
                    title: bind.title.value
                })
            });
            res.status(200).jsonp(pubs);
        }).catch(err => {
            res.status(500).jsonp(err);
        });
    } else { 
        /* Se vier o tipo na req.query. */
        /* req.query.type = article -> ARTICLE */
        type= req.query.type.toUpperCase()
        var query = 'SELECT ?s ?title WHERE { ?s rdf:type :' + type + ' . ?s :title ?title . } ORDER BY (?s)';
        var encoded = encodeURIComponent(prefixes + query);

        axios.get(getLink + encoded).then(dados => {
            pubs = dados.data.results.bindings.map(bind => {
                return({
                    id: bind.s.value.split('#')[1],
                    title: bind.title.value
                })
            });
            res.status(200).jsonp(pubs);
        }).catch(err => {
            res.status(500).jsonp(err);
        });
    }
});

router.get('/pubs/:id', function (req, res, next) {
    
    var query = 'SELECT ?p ?o { :' + req.params.id + ' ?p ?o.} ORDER BY (?p)';
    var encoded = encodeURIComponent(prefixes + query);

    axios.get(getLink + encoded).then(dados => {
        aux_pub = dados.data.results.bindings.map(bind => {
            return({
                p: bind.p.value.split('#')[1],
                o: (bind.o.type == 'literal') ? bind.o.value : bind.o.value.split('#')[1]
            })
        });
        
        /* objeto auxiliar para devolver um pretty json. */
        obj = {}
        aux_pub.forEach(p => {
            if (p['p'] == 'type' && p['o'] == "NamedIndividual") {
                /* skip */
            }
            else{

                /* create a new object */
                s = p['p']
                obj[s] = p['o']
            } 
        }); 
        res.status(200).jsonp(obj);
    }).catch(err => {
        res.status(500).jsonp(err);
    });
});

/* Post de uma publicação */
router.post('/pubs', function(req, res, next) {
    /* Uso da tag INSERT DATA */
    var query = `INSERT DATA { ${req.body} }`
    var encoded = encodeURIComponent(prefixes + query);
  
    axios.post(updLink + encoded)
      .then(dados => console.dir(dados))
      .catch(err => {
        res.status(500).jsonp(err);
      })
})

/* Delete de uma publicação */
router.delete('/pubs/:id', function(req, res, next) {
    var query = `DELETE DATA { ${req.params.id} rdfs:subClassOf* :Pubs . }`
    var encoded = encodeURIComponent(prefixes + query);
  
    axios.post(updLink + encoded)
      .then(dados => console.dir(dados))
      .catch(err => {
        res.status(500).jsonp(err);
      })
})

/* Put/Edit de uma publicação --> Delete e depois Post */
router.put('/pubs/:id', function(req, res, next) {
    var query = `DELETE DATA { ${req.params.id} rdfs:subClassOf* :Pubs . }`
    var encoded = encodeURIComponent(prefixes + query);
  
    axios.post(getLink + encoded)
      .then(dados =>{
        var query = `INSERT DATA { ${req.body} }`
        var encoded = encodeURIComponent(prefixes + query)
  
        axios.post(updLink + encoded)
          .then(dados => console.dir(dados))
          .catch(err => {
            res.status(500).jsonp(err);
          })
        })
      .catch(err => {
        res.status(500).jsonp(err);
      })
  })
/* ---------- */


/* - AUTHORS - */
router.get('/authors', function (req, res, next) {

    /* get every author */
    var query = `SELECT ?s ?name WHERE { ?s a :AUTHOR . OPTIONAL{?s :nome ?name}. } ORDER BY (?s)`;
    var encoded = encodeURIComponent(prefixes + query);

    axios.get(getLink + encoded).then(dados => {
        authors = dados.data.results.bindings.map(bind => {
            return({
                id: bind.s.value.split('#')[1],
                name: bind.name.value
            })
        });
        res.status(200).jsonp(authors);
    }).catch(err => {
        res.status(500).jsonp(err);
    });
});

router.get('/authors/:id', function (req, res, next) {
    /* um autor pode ser o writer ou pode ser refered as autor */
    var query = 'SELECT DISTINCT ?pub ?p ?title WHERE { :' + req.params.id + ' ?p ?pub . ?pub :title ?title . FILTER (?p IN (:writerOf, :referedasAuthor ) )} ORDER BY (?pub)';
    var encoded = encodeURIComponent(prefixes + query);

    axios.get(getLink + encoded).then(dados => {
        authors = dados.data.results.bindings.map(bind => {
            return({
                author: req.params.id,
                publication_info: {
                    p: bind.p.value.split('#')[1],
                    id_pub: bind.pub.value.split('#')[1],
                    title: bind.title.value
                }
            })
        });
        
        /* objeto auxiliar para devolver um pretty json. */
        nome = authors[0].author
        obj = {}
        obj['author'] = nome
        obj['publications'] = []

        authors.forEach(pub => {
            obj['publications'].push(pub.publication_info)
        })

        res.status(200).jsonp(obj);
    }).catch(err => {
        res.status(500).jsonp(err);
    });
});

/* Post de author */
router.post('/authors', function(req, res, next) {
    /* Uso da tag INSERT DATA */
    var query = `INSERT DATA { ${req.body} }`
    var encoded = encodeURIComponent(prefixes + query);
    
    axios.post(updLink + encoded)
      .then(dados => console.dir(dados))
      .catch(err => {
        res.status(500).jsonp(err);
      })
})

/* Delete de um author */
router.delete('/authors/:id', function(req, res, next) {
    /* Uso da tag DELETE DATA */
    var query = `DELETE DATA { ${req.params.id} a :AUTHOR . }`
    var encoded = encodeURIComponent(prefixes + query);
  
    axios.post(updLink + encoded)
      .then(dados => console.dir(dados))
      .catch(err => {
        res.status(500).jsonp(err);
      })
})

/* Put/Edit de um author --> Delete e depois Post */
router.put('/authors/:id', function(req, res, next) {
    var query = `DELETE DATA { ${req.params.id} a :AUTHOR . }`
    var encoded = encodeURIComponent(prefixes + query);
  
    axios.post(updLink + encoded)
    .then(dados => {
      var query = `INSERT DATA { ${req.body} }`
      var encoded = encodeURIComponent(prefixes + query);
  
      axios.post(getLink + encoded)
        .then(dados => console.dir(dados))
        .catch(err => {
            res.status(500).jsonp(err);
          })
      })
      .catch(err => {
        res.status(500).jsonp(err);
      })
  })
/* ---------- */

module.exports = router;