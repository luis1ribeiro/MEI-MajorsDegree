var axios = require('axios')

axios.post('http://localhost:7001/users', {"username": "jcr", "passwd": "123"})
    .then(dados => {
        var token = dados.data.token
        console.log('Token: ' + token + '\n\n')

        axios.get('http://localhost:7002/infoSecreta?token=' + token)
            .then(dados2=>{
                console.log('Dados: ' + JSON.stringify(dados2.data))
            }).catch(e => {
                console.log('ERRO: Não consegui obter os dados! ' + e)
            })
    })
    .catch(e=>{
        console.log('ERRO: Não consegui obter o token! ' + e)
    })