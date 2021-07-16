/* Exemplo 2 : Neste exemplo usamos chaves geradas através do openssl, que é PRI2020 */ 

/* Cria um TOKEN e imprime na Consola */
var jwt = require('jsonwebtoken')
var fs = require('fs')
var myToken = ""

var privateKey = fs.readFileSync('mykey.pem');
/* payload - privateKey usada como segredo - opções identificando o algoritmo */
jwt.sign({username: 'jcr'}, privateKey, {algorithm: 'RS256'}, function(err, token){
    if(err){
        console.log('ERRO: '+err);
    }
    else{
        console.log('Token: ' + token + '\n\n')
        myToken = token;
    }
});

fs.readFile('pubkey.pem', function(e,publicKey){
    jwt.verify(myToken, publicKey, {algorithms: ['RS256']}, function(e,decoded){
        if(e) console.log('ERRO: ' + e)
        else console.log('DATA: ' + JSON.stringify(decoded))
    });
})
