// Controlador para o modelo User

var User = require('../models/user')

// Devolve a lista de Users
module.exports.listar = () => {
    return User
        .find()
        .sort('username')
        .exec()
}

module.exports.consultar = uname => {
    return User
        .findOne({username: uname})
        .exec()
}

module.exports.inserir = u => {
    var novo = new User(u)
    return novo.save()
}

module.exports.remover = function(uname){
    return User.deleteOne({username: uname})
}

module.exports.alterar = function(u){
    return User.findByIdAndUpdate({username: u.username}, u, {new: true})
}
