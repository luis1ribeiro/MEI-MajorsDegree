var mongoose = require('mongoose')

var avalSchema = new mongoose.Schema({
    Número: String,
    Nome: String,
    Git: String,
    tpc: [Number]
});

module.exports = mongoose.model('PRI2020', avalSchema, 'work')