<template>
  <div class="w3-container">
    <h2>Publications Available</h2>
    <div>
    		<v-data-table :headers="headers" :items="pubs" item-key="id" class="elevation-1" :search="search" :custom-filter="filterOnlyCapsText">
    		</v-data-table>
  	</div>
  </div>
</template>

<script>
import axios from "axios";

export default {

  data() {
    return {
      pubs: [] /* não pode ser null por causa da sintaxe datatable */
    };
  },

  /* needed for headers field on v-data-table */
  computed: {
      	headers () {
        	return [
          		{ text: 'Publication ID', align: 'start', value: 'id'},
          		{ text: 'Title', value: 'title' },
          		{ text: 'Type', value: 'typeofPublication' },
          		{ text: 'Year of Publication', value: 'yearofPublication' },
        	]
      	},
    },
  
  created: function () {
    axios.get("http://localhost:8080/api/pubs")
      .then((res) => {
        this.pubs = res.data;
      });
  },
  /* Get pub by id -> on value field 
  methods: {
    pubInfo: function (value) {
      this.$router.push("/pubs/" + value.id);
    },
  }, */
}; 
</script>