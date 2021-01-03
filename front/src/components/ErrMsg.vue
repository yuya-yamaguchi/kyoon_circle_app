<template>
  <div class="error-messages-container">
    <div v-for="(errorMessage, i) in errorMessagesProp" :key="i">
      <p class="message">{{ errorMessage }}</p>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    errorMessagesProp: {}
  }
}
</script>

<style scoped lang="scss">
.error-messages-container {
  background: rgb(243, 195, 195);
  .message {
    color: red;
    padding: 10px;
  }
}
</style>