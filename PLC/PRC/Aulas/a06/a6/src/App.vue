<template> 
  <!-- Template Default -->
    <!-- 
      <div id="app">
        <img alt="Vue logo" src="./assets/logo.png" />
        <HelloWorld msg="Welcome to Your Vue.js App" />
      </div>
    -->   
    <div class="w3-container">
      <h1 class="w3-header w3-blue-grey"> Olá turma de PRC2021! </h1>
      <h4>{{(new Date()).toISOString().substring(0,10) }}</h4>
      <p> E quê chefe? Sou eu, o {{autor}}. </p>
      <table class="w3-table-all">
        <tr>
          <th>Produto</th>
          <th>Quantidade</th>
          <th>Operações</th>
        </tr>
        <tr v-for="(p,i) in listaCompras" v-bind:key="p.nome">
          <td>{{p.nome}}</td>
          <td>{{p.qnt}}</td>
          <td>
            <button class="button-transparent" @click="removeProd(i)"><i class="fa fa-trash"></i></button>
          </td>
        </tr>
      </table>
    </div>
</template>

<!--
  <script>
  import HelloWorld from "./components/HelloWorld.vue";
-->
<script>
  export default {
    name: "Primeiro exemplo",

    data() {
      return {
        listaCompras: [
          {nome: "Cenouras", qnt: 7},
          {nome: "Laranjas", qnt: 8},
          {nome: "Peras", qnt: 3},
        ],
        autor: "JCR"
      };
    },

    methods: {
      removeProd: function(ind) {
        this.listaCompras.splice(ind,1)
      }
    }
  };
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
.button-transparent {
    background-color: Transparent;
    background-repeat:no-repeat;
    border: none;
    cursor:pointer;
    overflow: hidden;
    outline:none;
}
.fa-trash {
    color:red !important;
}
.fa-trash:hover {
    color:#b30000 !important;
}
</style>
