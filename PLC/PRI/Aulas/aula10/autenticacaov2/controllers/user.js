// Paragraph controller

var mongoose = require('mongoose')
var User = require('../models/user')

// Returns list of paragrahs
module.exports.list = () => {
    return User.find().exec()
}

// Returns a paragraph record
module.exports.lookUp = id => {
    return User.findOne({
        id: id
    }).exec()
}

// Inserts a new paragraph
module.exports.insert = p => {
    console.log(JSON.stringify(p))
    var newUser = new User(p)
    console.log(newUser)
    return newUser.save()
}

// Deletes a paragraph
module.exports.remove = id => {
    return User.deleteOne({
        id: id
    })
}

// Changes a paragraph
module.exports.edit = (id, p) => {
    return User.findByIdAndUpdate(id, p, {
        new: true
    })
}