var Casamento = require('../models/casamentos')

// Devolve a lista dos casamentos, com os campos: date, title e ref;
module.exports.listar = () => {
    return Casamento
            .find({},{_id:0,date:1,title:1,ref:1})
            .exec()
}

// Devolve apenas uma lista com os casamentos onde o nome X aparece incluído no título;
module.exports.listporNome = nome =>{
    return Casamento
            .find({title :{$regex:nome}})
            .exec()
}

// Devolve a lista de casamentos realizados no ano YYYY;
module.exports.listporAno = ano =>{
    return Casamento
            .find({date :{$regex: ano}})
            .exec()
}

// Devolve a lista de casamentos agrupadas por ano, ou seja, devolve uma lista de anos em que a cada ano está associada uma lista de casamentos (coloque apenas a ref e o title do casamento);
module.exports.byAno = () =>{
    return Casamento.aggregate([{
        $group: {
            _id: "$date",
            casamentos: {
                $push: {
                    _id: "$_id",
                    title: "$title",
                    href: "$href"
                }
            }
        }
    }]).exec();
}

// Devolve a informação completa de um casamento (nesta rota, considere para id o campo ref);
module.exports.consultar = id =>{
    return Casamento
            .find({_id :id})
            .exec()
}

//Devolve uma lista de nomes dos noivos, ordenada alfabeticamente, e o id do respetivo registo..
module.exports.noivos = () =>{
        return Casamento.aggregate([
            { $addFields: {
                "lista": { $regexFind: { input: "$title", regex: "(?<=: ).*?(?= c)" } }
             }
            },
            {$sort: {lista: 1}},
            {$group:
                {_id:null,
                noivos:{$push:{id:"$_id",noivo:"$lista.match"}}
                }
            },
            {
            $project: {
                _id:0,
              noivos:1
            }}
          
        ]).exec();
    }

