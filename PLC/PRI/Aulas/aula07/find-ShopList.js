//Import the mongoose module
var mongoose = require('mongoose');

//Set up default mongoose connection
var mongoDB = 'mongodb://127.0.0.1/PRI2020';
mongoose.connect(mongoDB, {useNewUrlParser: true, useUnifiedTopology: true});

//Get the default connection
var db = mongoose.connection;

//Bind connection to error event (to get notification of connection errors)
db.on('error', console.error.bind(console, 'MongoDB connection error...'));
db.once('open', function() {
    console.log("Conexão ao MongoDB realizada com sucesso...")
});

var shopListSchema = new mongoose.Schema({
    Product: String,
    Quantity: Number,
    Category: String
});

var shopListModel = mongoose.model('list', shopListSchema)

shopListModel.find(function(err, docs){
    if(err){
        console.log('Error retrieving list records: ' + err)
    }
    else {
        docs.forEach(d => {
            console.log(d.Category + " - " + d.Product + " - " + d.Quantity)
        })
    }
})

console.log("That's all folks...")
