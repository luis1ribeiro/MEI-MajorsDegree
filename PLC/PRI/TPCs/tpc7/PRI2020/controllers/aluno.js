var Aluno = require('../models/aluno')

//Devolve a lista de alunos
module.exports.listar = () => {
    return Aluno
        .find()
        .exec()
}

module.exports.consultar = id => {
    return Aluno
        .findOne({_id: id})
        .exec()
}

module.exports.remove = id => {
    return Aluno
        .deleteOne({_id: id})
        .exec()
}

module.exports.inserir = a => {
    var values = [0,0,0,0,0,0];
    if (a.body.tpc1 == 'on')
        values[0] = 1
    if (a.body.tpc2 == 'on')
        values[1] = 1
    if (a.body.tpc3 == 'on')
        values[2] = 1
    if (a.body.tpc4 == 'on')
        values[3] = 1
    if (a.body.tpc5 == 'on')
        values[4] = 1
    if (a.body.tpc6 == 'on')
        values[5] = 1
    var novo = new Aluno(a.body)
    novo.tpc = values
    return novo.save()
}

module.exports.editar = a => {
    console.log(a.body)
    var values = [0,0,0,0,0,0];
    if (a.body.tpc1 == 'on')
        values[0] = 1
    if (a.body.tpc2 == 'on')
        values[1] = 1
    if (a.body.tpc3 == 'on')
        values[2] = 1
    if (a.body.tpc4 == 'on')
        values[3] = 1
    if (a.body.tpc5 == 'on')
        values[4] = 1
    if (a.body.tpc6 == 'on')
        values[5] = 1
    var id = a.body._id
    console.log(id)
    return Aluno
        .update({_id: id}, {$set : {Nome: a.body.Nome, Número: a.body.Número, Git: a.body.Git, tpc: values}})
        .exec()
}