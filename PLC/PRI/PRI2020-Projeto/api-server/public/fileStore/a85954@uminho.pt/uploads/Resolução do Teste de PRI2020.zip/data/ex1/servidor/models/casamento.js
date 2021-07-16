const mongoose = require('mongoose')

var casSchema = new mongoose.Schema({
    _id: {type: String, required: true},
    href: String,
    title: String,
    date: String
  });

module.exports = mongoose.model('casamento', casSchema)

