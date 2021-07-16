<template>
  <div class="w3-container">
    <h3 class="w3-header w3-blue">Repositório {{ idr }}</h3>
    <table class="w3-table-all">
      <thead>
        <tr>
          <th>Sujeito</th>

          <th>Predicado</th>

          <th>Objeto</th>
        </tr>
        <tr v-for="(triplo, i) in dados" v-bind:key="i">
          <td>{{ triplo.s }}</td>

          <td>{{ triplo.p }}</td>

          <td>{{ triplo.o }}</td>
        </tr>
      </thead>
    </table>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Repo",

  props: ["idr", "mensagem"],

  data() {
    return {
      dados: null,
    };
  },

  created: function () {
    axios

      .get(
        "http://localhost:8080/ontobud/api/rdf4j/query/" +
          this.idr +
          "?query=select%20%2A%20where%20%7B%20%3Fs%20%3Fp%20%3Fo%20%7D%20limit%20100&infer=true"
      )

      .then((res) => {
        this.dados = res.data.results.bindings.map((e) => {
          return {
            s: e.p.type == "literal" ? e.p.value : e.p.value.split("#")[1],
            p: e.p.type == "literal" ? e.p.value : e.p.value.split("#")[1],
            o: e.o.type == "literal" ? e.o.value : e.o.value.split("#")[1],
          };
        });
      });
  },
};
</script>

<style>
h3 {
  margin-bottom: 5%;
}
</style>