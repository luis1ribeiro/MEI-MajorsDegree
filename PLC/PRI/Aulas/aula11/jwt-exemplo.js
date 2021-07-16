/* Exemplo 1 : Criar e descodificar um TOKEN */
/* Neste exemplo usamos um segredo previamente identificado e forçado, que é PRI2020 */ 

/* Cria um TOKEN e imprime na Consola */
var jwt = require('jsonwebtoken')
try{
    var token = jwt.sign({username: 'jcr', level: 'admin', expiresIn: "1d"}, 'PRI2020')
    console.log('TOKEN: ' + token)
}
catch(error){
    console.log('ERROR: Erro na criação do token: ' + error)
}

/*
var decoded = jwt.verify(token,'PRI2020')
console.log(JSON.stringify(decoded))
*/

try {
    var decoded = jwt.verify(token, 'segredo errado')
    console.log(JSON.stringify(decoded))
}
catch(err){
    console.log('ERROR: ' + err)
}

/* callback vs try/catch */
jwt.verify(token, 'PRI2020', function(e, payload) {
    if(e) console.log('ERRO na verificação do token: ' + e)
    else console.log('Descodificado: ' + JSON.stringify(payload))
})