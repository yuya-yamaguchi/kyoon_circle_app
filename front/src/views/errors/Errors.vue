<template>
  <div class="error-container">
    <div class="page-title some-updown-center">
      <fa icon="exclamation-circle"></fa>
      <p v-if="errorStatusProp==500">{{errorStatusProp}} Internal Server Error</p>
      <p v-else-if="errorStatusProp==403">{{errorStatusProp}} Forbidden</p>
      <p v-else>{{errorStatusProp}}</p>
    </div>
    <div class="message">
      <div v-if="errorStatusProp==500">
        システムエラーが発生しました。<br>
        ご迷惑をお掛けしております。時間をおいてから再度アクセスください。
      </div>
      <div v-else-if="errorStatusProp==403">
        アクセスしようとしたページは表示できませんでした。閲覧が制限されています。
      </div>
      <div v-else>
        エラーが発生しました
      </div>
      <div v-if="isHttpsProtocol()">
        <p>httpsにてアクセスしている方は下記URLをお試しください。</p>
        <a href="http://studio-hummingbird.com/">http://studio-hummingbird.com/</a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    errorStatusProp: {}
  },
  methods: {
    isHttpsProtocol() {
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
    color:  orange;
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