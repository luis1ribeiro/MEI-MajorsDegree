// Controlador para o modelo Filme

var Batismo = require('../models/batismo')




module.exports.listar1 = () => {
    return Batismo
        .find({}, { _id: 1, date: 1, title: 1, ref: 1 })
        .exec()
}
module.exports.consultar2 = id => {
    return Batismo
        .findOne({ _id: id })
        .exec()
}

module.exports.listar3 = () => {
    return Batismo
        .aggregate([

            { $project: { _id: 0, nome: 1 } },
            { $sort: { nome: 1 } }
        ])
}

module.exports.listar4 = () => {
    return Batismo
        .aggregate([

            { $project: { _id: 1, mae:1,pai:1 } },
            { $sort: { _id: 1 } }
        ])
}

module.exports.listar5 = (ano) => {
    return Batismo
        .find({year:ano}, {})
        .exec()
}

module.exports.stats6 = () => {
    return Batismo
        .aggregate([
        
            {$group: {_id:"$year",numero:{$sum:1}}},
            {$project: {_id:0,"year":"$_id",numberOfBirth:"$numero"}}
        ])
}