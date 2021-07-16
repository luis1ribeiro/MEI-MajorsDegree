// Controlador para o modelo Tarefa

var Casamento = require('../models/casamento')

// Devolve a lista de Publicações
module.exports.listar = () => {
    return Casamento
        .find()
        .select('_id date title')
        .exec()
}

module.exports.consultar = id => {
    return Casamento
        .findOne({_id: id})
        .exec()
}

module.exports.listarNome = n => {
    return Casamento
        .find({title: { "$regex":n }})
        .select('_id title date')
        .exec()
}

module.exports.listarAno = a => {
    return Casamento
        .find({date: { "$regex":a }})
        .select('_id title date')
        .exec()
}

module.exports.listarByAno = () => {
    return Casamento
        .aggregate([
            {$group: {
                _id: "$date",
                casamentos: { $push: { title: "$title", id: "$_id" } }
                }}
        ])
}

module.exports.listarNoivos = () => {
    return Casamento
        .aggregate([
            {$project:{
                _id:1,
                noivo:{$arrayElemAt:[{$split:[  {$arrayElemAt:[{$split:["$title", ": "]}, 1 ]},  " c.c"]}, 0 ]}
            }
            }
        ]);
}