<template>
  <div v-if="$store.getters['response/status']!=0" class="error-messages-container">
    <div v-if="(typeof errorMessages) == 'string'">
      <div class="message">{{ errorMessages }}</div>
    </div>
    <div v-else>
      <div v-for="(errorMessage, i) in errorMessages" :key="i">
        <div class="message">{{ errorMessage }}</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  computed: {
    errorMessages() {
      return this.$store.getters['response/messages']
    }
  },
  unmounted() {
    this.$store.dispatch(
      "response/update",
      { status: 0,
        messages: '' }
    );
  }
}
</script>

<style scoped lang="scss">
.error-messages-container {
  // background: rgb(243, 195, 195);
  border: 1px solid red;
  margin: 10px 0;
  .message {
    font-size: 15px;
    color: red;
    padding: 2px 5px;
  }
}
</style>