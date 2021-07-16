var jsonfile = require('jsonfile')

var files = jsonfile.readFileSync("./casamentos_new.json")

for (var i = 0; i < files.length; i++){
    files[i]["_id"] = files[i]["ref"].replace(/\//g, "_");  
}

jsonfile.writeFileSync("./casamentos_fixed.json",files)