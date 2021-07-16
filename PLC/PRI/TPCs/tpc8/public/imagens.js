/* Script para mostrar a imagem no lado do cliente */

function showImage(name, type) {
    if(type=='image/png' || type=='image/jpeg'){
        var file = $('<img src="/fileStore/' + name + '" width="80%"/>')
    }
    else {
        var file = $('<p>' + name + ', ' + type + '</p>')
    }
    var download = $('<div><a href="/download/' + name + '">Download</a></div>')

    $("#display").empty()
    $("#display").append(file, download)
    $("#display").modal()
}

function add() {
    var file = $('<input class="w3-input w3-border w3-light-grey" type="file" name="myFile">')
    $("#addeds").append(file)
}