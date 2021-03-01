<template>
  <div class="error-container">
    <div class="page-title some-updown-center">
      <fa icon="exclamation-circle"></fa>
      <p >403 Forbidden</p>
    </div>
    <div class="message">
      <p>
        アクセスしようとしたページは表示できませんでした。<br>
        閲覧が制限されています。
      </p>
    </div>
  </div>
</template>

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