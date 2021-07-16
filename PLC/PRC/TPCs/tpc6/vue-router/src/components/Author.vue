<template>
  <div class="w3-container">
    <h3 class="w3-header">{{ idauthor }} - {{author_info.name}}</h3>
    <div>
    		<v-data-table :headers="headers" :items="author_info.publications" item-key="id" class="elevation-1" :search="search" :custom-filter="filterOnlyCapsText">
    		</v-data-table>
  	</div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Author",
  props: ["idauthor"],

  data() {
    return {
      author_info: null,
    };
  },

  computed: {
      	headers () {
        	return [
          		{ text: 'Publication ID', align: 'start', value: 'id_pub'},
          		{ text: 'Title', value: 'title' },
          		{ text: 'Type', value: 'typeofPublication' },
          		{ text: 'Year of Publication', value: 'yearofPublication' },
        	]
      	},
    },
  
  created: function () {
    axios.get("http://localhost:8080/api/authors/" + this.idauthor)
      .then((res) => {
        this.author_info = res.data
      });
  },
};
</script>