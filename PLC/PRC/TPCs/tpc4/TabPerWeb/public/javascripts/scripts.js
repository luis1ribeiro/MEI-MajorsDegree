$(document).ready( function () {
    $.fn.dataTableExt.sErrMode = 'throw';
    var tp = $('#TP').DataTable( {
      pageLength : 10,
      "lengthChange": false,
      info: false
    } )
} );