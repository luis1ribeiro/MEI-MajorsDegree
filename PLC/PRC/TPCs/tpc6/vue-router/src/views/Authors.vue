<template>
  <div class="w3-container">
    <h2>Authors</h2>
    <div>
    		<v-data-table :headers="headers" :items="authors" item-key="id" class="elevation-1" :search="search" :custom-filter="filterOnlyCapsText" @click:row="getAuthor">
    		</v-data-table>
  	</div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Authors",

  data() {
    return {
      authors: [] /* não pode ser null por causa da sintaxe datatable */
    };
  },

  /* needed for headers field on v-data-table */
  computed: {
      	headers () {
        	return [
          		{ text: 'Author ID', align: 'start', value: 'id'},
          		{ text: 'Author name', value: 'name' },
          		{ text: 'Total of Publications', value: 'nmrPubs' },
        	]
      	},
    },

  created: function () {
    axios.get("http://localhost:8080/api/authors")
      .then((res) => {
        this.authors = res.data;
      });
  },
  /* Get author by id -> on value field */
  methods: {
    getAuthor: function (value) {
      this.$router.push("/authors/" + value.id);
    },
  }
};
</script>
