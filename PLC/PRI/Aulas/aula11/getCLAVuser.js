var axios = require('axios')

axios.post('http://clav-api.di.uminho.pt/v2/users/login', {"username": "leo.ramalho99@gmail.com", "password": "123"})
    .then(dados => {
        var token = dados.data.token
        console.log('Token: ' + token + '\n\n')

        axios.get('http://clav-api.di.uminho.pt/v2/classes?estrutura=lista&token=' + token)
            .then(dados2=>{
                console.log('Dados: ' + JSON.stringify(dados2.data))
            }).catch(e => {
                console.log('ERRO: Não consegui obter os dados! ' + e)
            })
    })
    .catch(e=>{
        console.log('ERRO: Não consegui obter o token! ' + e)
    })