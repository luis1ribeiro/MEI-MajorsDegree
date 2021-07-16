var file = require('./casamentos.json')
var fs = require('fs')

for (i = 0; i < file.length; i++){
    var r = file[i].ref;
    var nr = r.split("/").join("_");

    file[i]._id = nr;
    delete file[i].ref
}

console.log(file);

var file2 = JSON.stringify(file)
fs.writeFile('casamentos_fixed.json', file2, function (err) {
    if (err) throw err;
    console.log('Saved!');
  });