<template>
  <div class="w3-container">
    <h3>Users</h3>

    <table class="w3-table-all">
      <thead>
        <tr>
          <th>Id</th>

          <th>Name</th>

          <th>Email</th>
        </tr>
      </thead>

      <tbody>
        <tr v-for="user in users" v-bind:key="user._id">
          <td>{{ user._id }}</td>

          <td>{{ user.name }}</td>

          <td>{{ user.email }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Users",

  data() {
    return {
      users: null,
    };
  },

  created: function () {
    axios

      .get("http://localhost:8080/ontobud/api/users")

      .then((res) => {
        this.users = res.data;
      });
  },
};
</script>

<style>
h3 {
  margin-bottom: 5%;
}
</style>