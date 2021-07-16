const mongoose = require('mongoose')

var batismoSchema = new mongoose.Schema({
    _id: { type: String, required: true },
    date:String,
    year:Number,
    title:String,
    pai:String,
    mae:String,
    nome:String,
    ref:String,
    href:String
  });

module.exports = mongoose.model('batismos', batismoSchema)