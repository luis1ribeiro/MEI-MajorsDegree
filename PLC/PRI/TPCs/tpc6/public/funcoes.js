function d(value) {
    /*$.ajax({
        type: 'GET',
        url: "/fechartarefa?id=" + value,
        dataType: 'json',
        success: function() { location.reload(true) },
        data: {},
        async: false
    });*/
    url = "/fechartarefa?id=" + value;
        $.getJSON( url, function( data ) {
            console.log(data.resp);
            //document.getElementById('teste').innerHTML =  data.Hora;
            //debugger;
        }, function( callback ){
            callback();     
        })
        .always(function() { location.reload(true) });
}

function c(value) {
    /*$.ajax({
        type: 'GET',
        url: "/fechartarefa?id=" + value,
        dataType: 'json',
        success: function() { location.reload(true) },
        data: {},
        async: false
    });*/
    url = "/cancelartarefa?id=" + value;
        $.getJSON( url, function( data ) {
            console.log(data.resp);
            //document.getElementById('teste').innerHTML =  data.Hora;
            //debugger;
        }, function( callback ){
            callback();    
        })
        .always(function() { location.reload(true) });
}

function callback(){
    location.reload(true)
}