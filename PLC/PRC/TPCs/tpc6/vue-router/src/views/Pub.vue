<template>
  <Pub :idpub="$route.params.id" />
</template>


<script>
import Pub from "@/components/Pub.vue";

export default {
  components: {
    Pub,
  },
};
</script>