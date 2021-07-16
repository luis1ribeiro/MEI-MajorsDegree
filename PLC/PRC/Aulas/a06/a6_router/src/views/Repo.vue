<template>
  <ConsultaRepo :idr="$route.params.idRepo" mensagem="Teste" />
</template>



<script>
import ConsultaRepo from "@/components/ConsultaRepo.vue";

export default {
  components: {
    ConsultaRepo,
  },
};
</script>