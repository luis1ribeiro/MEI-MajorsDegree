/* PARAGRAPH CONTROLLER */

var mongoose = require('mongoose')
var Paragraph = require('../models/para')

/* Return list of paragraphs */
module.exports.list = () => {
    return Paragraph.find().exec()
}

/* Returns a paragraph record */
module.exports.lookup = id => {
    return Paragraph.findOne({_id: mongoose.Types.ObjectId(id)}).exec()
}

/* Inserts a new paragraph */
module.exports.insert = p => {
    console.log(JSON.stringify(p))
    var newParagraph = new Paragraph(p)
    return newParagraph.save()
}

/* Delete a paragraph */
module.exports.remove = id => {
    return Paragraph.deleteOne({_id: id})
}

/* Changes a paragraph */
module.exports.edit = (id, p) => {
    return Paragraph.findByIdAndUpdate(id, p, {new: true})
}