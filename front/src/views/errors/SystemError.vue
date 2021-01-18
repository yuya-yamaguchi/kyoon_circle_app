<template>
  <div class="error-container">
    <div class="page-title some-updown-center">
      <fa icon="exclamation-triangle"></fa>
      <p>500 Internal Server Error</p>
    </div>
    <div class="message">
      <p>システムエラーが発生しました。</p>
      <div v-if="isHttpsProtocol()">
        <p>httpsにてアクセスしている方は下記URLをお試しください。</p>
        <a href="http://studio-hummingbird.com/">http://studio-hummingbird.com/</a>
      </div>
      <p v-else>ご迷惑をお掛けしております。時間をおいてから再度アクセスください。</p>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    isHttpsProtocol() {
      console.log(location.protocol);
      if (location.protocol === 'https') {
        return true
      }
      return false
    }
  }
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
    color:  red;
    svg {
      width: 50px;
      margin-right: 10px;
    }
    font-size: 50px;
  }
  .message {
    margin-top: 20px;
    text-align: center;
    p {
      margin: 5px 0;
    }
  }
}
</style>