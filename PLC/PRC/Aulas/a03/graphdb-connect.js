var axios = require('axios')

axios.get("http://localhost:7200/rest/repositories")
    .then(dados => {
        repos = dados.data.map(r => {
            return({
                id: r.id,
                tit: r.title,
                uri: r.uri
            })
        })
        /*
            console.log(JSON.stringify(dados.data))
            console.log("-------------------")
        */
        console.dir(repos)
    })
    .catch(erro => console.log(erro))


/* Retorna me informação dos reps do GraphDB
    {
        id: 'pokemon',
        tit: 'pokemon',
        uri: '.../pokemon'
    },
    {
        ...
    }
*/

/* Para ir buscar o size 
    axios.get("http://localhost:7200/rest/repositories/prc2021-aula3/size")
    .then(dados => {
            console.log("Tamanho do Repositório Advogados" + dados.data)
        })
        .catch(erro => console.log(erro)
*/