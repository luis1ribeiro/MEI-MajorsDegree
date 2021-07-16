var axios = require('axios')

var prefixes = `
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX rdfs: <http://w3.org/2000/01/rdf-schema#>
    PREFIX noInferences: <http://www.ontotext.com/explicit>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX adv: <http://www.di.uminho.pt/prc2021/advogacia#>
`

var getLink = "http://localhost:7200/repositories/advogacia" + "?query=" 
var q1 = `SELECT ?s WHERE { ?s rdf:type owl:Class }` // query: Todos os sujeitos que sejam classe.
var q2 = `SELECT ?s WHERE {?s rdf:type adv:Advogado}`
var q3 = `SELECT * WHERE {adv:A3 ?p ?o}` // -> Aqui os bindings são diferentes portanto aquele classes vai ser diferente.

var encoded = encodeURIComponent(prefixes + q3)

axios.get(getLink + encoded)
    .then(dados => {
        // var classes = dados.data.results.bindings.map(bind => bind.s.value.split('#')[0])
        // ['Advogado','Pessoa'] -> q1
        // ['A1','A2','A3','A4','A5'] -> q2
        
        
        // q3
        var classes = dados.data.results.bindings.map(bind => {return {
            p: bind.p.value.split('#')[1],
            o: (bind.o.type == "literal") ? bind.o.value : bind.o.value.split('#')[1] 
        }})
        
        classes.shift();

        console.log(classes)
    })    
    .catch(erro => console.log("Deu erro fds!"))