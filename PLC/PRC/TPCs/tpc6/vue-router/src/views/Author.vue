<template>
  <Author :idauthor="$route.params.id" />
</template>

<script>
import Author from "@/components/Author.vue";

export default {
  components: {
    Author,
  },
};
</script>