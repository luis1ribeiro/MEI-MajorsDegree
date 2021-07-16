<template>
  <div class="w3-container">
    <h3>Repositórios:</h3>

    <table class="w3-table-all">
      <thead>
        <tr>
          <th>Id</th>

          <th>Título</th>

          <th>URI</th>
        </tr>
      </thead>

      <tbody>
        <tr
          v-for="r in repos"
          v-bind:key="r.id.value"
          @click="goRepo(r.id.value)"
        >
          <td>{{ r.id.value }}</td>

          <td>{{ r.title.value }}</td>

          <td>{{ r.uri.value }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Repos",

  data() {
    return {
      repos: null,
    };
  },

  created: function () {
    axios

      .get("http://localhost:8080/ontobud/api/rdf4j/management/listRepos")

      .then((res) => {
        this.repos = res.data;
      });
  },

  methods: {
    goRepo: function (id) {
      this.$router.push("/repos/" + id);
    },
  },
};
</script>

<style>
h3 {
  margin-bottom: 5%;
}
</style>

Prima Shift + Tab para navegar para o histórico de conversações.






