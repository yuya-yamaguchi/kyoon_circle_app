<template>
  <div class="error-container">
    <div class="page-title some-updown-center">
      <fa icon="exclamation-triangle"></fa>
      <p>404 NotFound</p>
    </div>
    <p class="message">お探しのページは存在しない、または削除された可能性があります</p>
  </div>
</template>

<script>
export default {
  
}
</script>

<style scoped lang="scss">
.error-container {
  max-width: 1200px;
  margin: 0 auto;
  box-sizing: border-box;
  padding: 100px 10px;
  min-height: calc(100vh - 140px);
  .page-title {
    color: var(--accent-color);
    svg {
      width: 50px;
      margin-right: 10px;
    }
    font-size: 50px;
  }
  .message {
    margin-top: 20px;
    text-align: center;
  }
}
</style>