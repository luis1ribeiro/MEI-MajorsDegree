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

/* Removi as operações de post, delete e put 
    const updLink = "http://epl.di.uminho.pt:8738/api/rdf4j/update/A85954-TP5?query=";
*/

/* - Publicações - */
router.get('/pubs', function (req, res, next) {
    if (!(req.query.type)) { /* Se não fornecer tipo. */
        /* Query para ir buscar todas as Pubs - Desde ARTICLE até aos PROCEEDINGS */
        /* TPC6 - Saber o seu tipo e ano de publicação */
        var query = `SELECT ?s ?title ?type ?year WHERE { ?s rdf:type ?type . ?type rdfs:subClassOf* :Pubs. ?s rdf:type ?type. ?s :title ?title . OPTIONAL{?s :year ?year} . } ORDER BY (?s) `;
        var encoded = encodeURIComponent(prefixes + query);

        axios.get(getLink + encoded).then(dados => {
            pubs = dados.data.results.bindings.map(bind => {
                return({
                    id: bind.s.value.split('#')[1],
                    title: bind.title.value,
                    typeofPublication: bind.type.value.split('#')[1],
                    yearofPublication: bind.year.value
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

/* ---------- */


/* - AUTHORS - */
router.get('/authors', function (req, res, next) {

    /* get every author */
    /* TPC 6 - get o numero de publicações */
    var query = `SELECT ?s ?name (COUNT(?pub) AS ?nmrPubs) WHERE { ?s a :AUTHOR . OPTIONAL{?s :nome ?name}. ?s ?p ?pub . FILTER (?p IN (:writerOf, :referedasAuthor )) } GROUP BY ?s ?name ORDER BY (?s)`;
    var encoded = encodeURIComponent(prefixes + query);

    axios.get(getLink + encoded).then(dados => {
        authors = dados.data.results.bindings.map(bind => {
            return({
                id: bind.s.value.split('#')[1],
                name: bind.name.value,
                nmrPubs: bind.nmrPubs.value
            })
        });
        res.status(200).jsonp(authors);
    }).catch(err => {
        res.status(500).jsonp(err);
    });
});

router.get('/authors/:id', function (req, res, next) {
    /* um autor pode ser o writer ou pode ser refered as autor */
    var query = 'SELECT DISTINCT ?name ?pub ?p ?title ?type ?year WHERE { :' + req.params.id + ' ?p ?pub . :' + req.params.id + ' :nome ?name . ?pub :title ?title . ?pub rdf:type ?type. OPTIONAL{?pub :year ?year} . FILTER (?p IN (:writerOf, :referedasAuthor ) )} ORDER BY (?pub)';
    var encoded = encodeURIComponent(prefixes + query);

    axios.get(getLink + encoded).then(dados => {
        authors = dados.data.results.bindings.map(bind => {
            return({
                author: req.params.id,
                name: bind.name.value,
                publication_info: {
                    p: bind.p.value.split('#')[1],
                    id_pub: bind.pub.value.split('#')[1],
                    title: bind.title.value,
                    typeofPublication: bind.type.value.split('#')[1],
                    yearofPublication: bind.year.value
                }
            })
        });
        
        /* objeto auxiliar para devolver um pretty json. */
        id = authors[0].author
        nome = authors[0].name
        
        obj = {}
        obj['author'] = id
        obj['name'] = nome
        obj['publications'] = []

        authors.forEach(pub => {
            if (pub.publication_info.typeofPublication == "NamedIndividual") {
                /* skip */
            }
            else {
                obj['publications'].push(pub.publication_info)
            }    
        })

        res.status(200).jsonp(obj);
    }).catch(err => {
        res.status(500).jsonp(err);
    });
});

/* ---------- */

module.exports = router;