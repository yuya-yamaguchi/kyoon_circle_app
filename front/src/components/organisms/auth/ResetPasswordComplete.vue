<template>
  <div>
    <h1 class="main-title text-center">変更が完了しました</h1>
    <div class="complete-message">
      <p>
        パスワードの変更が完了しました。<br>
        再度ログインしてご利用ください。
      </p>
    </div>
    <div class="destination-links">
      <router-link :to="{name: 'Login'}" class="destination-link">ログイン画面へ</router-link>
      <router-link :to="{name: 'Top'}" class="destination-link">トップページへ</router-link>
    </div>
  </div>
</template>

<style scoped lang="scss">
.complete-message {
  margin: 30px auto;
  text-align: center;
}
.destination-link {
  color: #2C3E50;
  display: flex;
  justify-content: center;
  margin: 20px auto;
}
</style>