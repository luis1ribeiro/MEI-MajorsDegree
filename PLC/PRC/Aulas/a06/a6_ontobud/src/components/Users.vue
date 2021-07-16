<template>
  <div class="w3-container">
    <h3 class="w3-header w3-blue-grey" style="margin-bottom:5%"> Utilizadores do OntoBud </h3>
    <table class="w3-table-all">
      <thead>
        <tr>
          <th>ID</th>
          <th>Nome Utilizador</th>
          <th>Email Utilizador</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(u,i) in users" :key="i">
          <td>{{u._id}}</td>
          <td>{{u.name}}</td>
          <td>{{u.email}}</td>
        </tr>
      </tbody>
    </table> 
  </div>
</template>

<script>
import axios from 'axios'

$(document).ready( function () {
    $.fn.dataTableExt.sErrMode = 'throw';
    var tp = $('#example').DataTable( {
      pageLength : 5,
      "lengthChange": false,
      info: false
    } )
} );

export default {
  name: 'Users',

  data: function() {
    return {
      users: null,
    };
  },

  created: function() {
      /* Uso de um proxy local, especificado no vue.config.js */
      axios.get('ontobud/api/users')
           .then(res => {this.users = res.data;})
           .catch(e => {console.log('ERRO no Get Utilizadores: ' + e)})
  }
}
</script>

