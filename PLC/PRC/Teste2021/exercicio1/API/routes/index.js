var express = require('express');
var router = express.Router();

var axios = require('axios')

const prefixes = ` PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX xml: <http://www.w3.org/XML/1998/namespace>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX : <http://www.di.uminho.pt/prc2021/EMD#>
`
const getLink = "http://localhost:7200/repositories/EMD?query=";


router.get('/emd', function (req, res, next) {
    if (!req.query.res) {
        var query = `
        SELECT ?s ?nome ?date ?result WHERE {
            ?s a :EMD .
            ?a a :Atleta .
            ?s :data ?date .
            ?a :nome ?nome .
            ?a ?resultado ?s .
            FILTER (?resultado IN (:passou,:reprovou)) .
            BIND (strafter(str(?resultado), '#') as ?result)
        }
        `;
        var encoded = encodeURIComponent(prefixes + query);

        axios.get(getLink + encoded).then(dados => {
            emds = dados.data.results.bindings.map(bind => {
                return({
                    id: bind.s.value.split('#')[1],
                    nome: bind.nome.value,
                    data: bind.date.value,
                    resultado: bind.result.value
                })
            });
            res.status(200).jsonp(emds);
        }).catch(err => {
            res.status(500).jsonp(err);
        });
    }
    else {
        if (req.query.res == "OK") {
            var query = `
        SELECT ?s ?nome ?date ?result WHERE {
            ?s a :EMD .
            ?a a :Atleta .
            ?s :data ?date .
            ?a :nome ?nome .
            ?a ?resultado ?s .
            FILTER (?resultado IN (:passou)) .
            BIND (strafter(str(?resultado), '#') as ?result)
        }
        `;
        var encoded = encodeURIComponent(prefixes + query);

        axios.get(getLink + encoded).then(dados => {
            emds = dados.data.results.bindings.map(bind => {
                return({
                    id: bind.s.value.split('#')[1],
                    nome: bind.nome.value,
                    data: bind.date.value,
                    resultado: bind.result.value
                })
            });
            res.status(200).jsonp(emds);
        }).catch(err => {
            res.status(500).jsonp(err);
        });
        }
        
    }

});

router.get('/emd/:id', function (req, res, next) {
    id = req.params.id
    var query = `
        SELECT * {
            :${id} a :EMD .
            :${id} :data ?date .
            ?a a :Atleta . 
            ?a :nome ?nome .
            ?a :passou|:reprovou :${id}.
            ?a ?p1 ?o1 .
        }
        `;
        var encoded = encodeURIComponent(prefixes + query);

    axios.get(getLink + encoded).then(dados => {
        emd = dados.data.results.bindings.map(bind => {
            return({
                data: bind.date.value,
                nome: bind.nome.value,
                p: bind.p1.value.split('#')[1],
                o: (bind.o1.type == 'literal') ? bind.o1.value : bind.o1.value.split('#')[1]
            })
        });
    
    result = {}
    result['nome'] = emd[0].nome
    result['data'] = emd[0].data

    emd.forEach(p => {
        if (p['p'] == 'type') {
            /* skip */
        }
        else{
            if (p['p'] == "passou") {
                result['resultado'] = "passou"
                result['emd'] = p['o']
            }
            if (p['p'] == "reprovou") {
                result['resultado'] = "passou"
                result['emd'] = p['o']
            }
            /* create a new object */
            if (p['p'] != "reprovou" && p['p'] != "passou"){
                s = p['p']
                result[s] = p['o']
            }
        } 
    }); 
        
        
        res.status(200).jsonp(result);
    }).catch(err => {
        res.status(500).jsonp(err);
    });
});


router.get('/modalidades', function (req, res, next) {
    
    var query = `
        SELECT DISTINCT ?s WHERE {
            ?s a :Modalidade .
        }
        `;
        var encoded = encodeURIComponent(prefixes + query);

    axios.get(getLink + encoded).then(dados => {
        m = dados.data.results.bindings.map(bind => {
            return({
                modalidade: bind.s.value.split('#')[1]
            })
        });
        
        
        res.status(200).jsonp(m);
    }).catch(err => {
        res.status(500).jsonp(err);
    });
});

router.get('/modalidades/:id', function (req, res, next) {
    id = req.params.id
    var query = `
        SELECT ?e ?date ?nome {
            :${id} a :Modalidade .
            ?e a :EMD .
            ?e :data ?date .
            ?a a :Atleta . 
            ?a :nome ?nome .
            ?a :passou|:reprovou ?e .
        }
        `;
        var encoded = encodeURIComponent(prefixes + query);

    axios.get(getLink + encoded).then(dados => {
        emd = dados.data.results.bindings.map(bind => {
            return({
                emd: bind.e.value.split('#')[1],
                data: bind.date.value,
                nome: bind.nome.value
            })
        });
        
        res.status(200).jsonp(emd);
    }).catch(err => {
        res.status(500).jsonp(err);
    });
});

router.get('/atletas', function (req, res, next) {
    if (req.query.gen == 'F') {

        var query = `
        SELECT ?nome ?g {
            ?a a :Atleta .
    		?a :género ?g .
    		?a :nome ?nome .
    		FILTER (?g = "F") .
        } ORDER BY ?nome
        `;
        var encoded = encodeURIComponent(prefixes + query);

        axios.get(getLink + encoded).then(dados => {
            atl = dados.data.results.bindings.map(bind => {
                return({
                    nome: bind.nome.value,
                    gen: bind.g.value
                })
            });
            
            res.status(200).jsonp(atl);
        }).catch(err => {
            res.status(500).jsonp(err);
        });
    }

    if (req.query.clube) {
        c = req.query.clube
        var query = `
        SELECT ?nome ?clube {
            :${c} a :Clube .
            ?a a :Atleta . 
            ?a :nome ?nome .
            ?a :pertenceA :${c} .
            BIND (:${c} as ?clube) .
        } ORDER BY ?nome
        `;
        var encoded = encodeURIComponent(prefixes + query);

        axios.get(getLink + encoded).then(dados => {
            atl = dados.data.results.bindings.map(bind => {
                return({
                    nome: bind.nome.value,
                    clube: bind.clube.value
                })
            });
            
            res.status(200).jsonp(atl);
        }).catch(err => {
            res.status(500).jsonp(err);
        });
    }

});


module.exports = router;