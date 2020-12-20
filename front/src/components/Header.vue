<template>
  <header>
    <router-link to="/" class="main-title">京音</router-link>
    <div class="header-menus">
      <div class="header-menus">
        <a class="header-menu">イベント一覧</a>
        <a class="header-menu">スタジオ予約</a>
        <a class="header-menu">宿泊予約</a>
      </div>
      <div v-if='!$store.getters["user/id"]'>
        <router-link to="/signup" class="sign-btn">新規会員登録</router-link>
        <router-link to="/signin" class="sign-btn">ログイン</router-link>
      </div>
      <div v-else class="header-menus">
        <p class="header-menu">
          {{ $store.getters["user/email"] }}
        </p>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  
}
</script>

<style scoped lang="scss">
header{
  width: 100%;
  height: 60px;
  background: #333;
  display: flex;
  justify-content: space-between;
  color: #FFF;
  .main-title {
    text-align: left;
    line-height: 60px;
    padding: 0 20px;
    color: #FFF;
    font-size: 30px;
    text-decoration: none;
  }
  .header-menus {
    margin-right: 30px;
    display: flex;
    justify-content: flex-end;
    .header-menu {
      line-height: 60px;
      margin: 0 20px;
      font-weight: bold;
      position: relative;
      cursor: pointer;
      &::after {
        position: absolute;
        bottom: 15px;
        left: 0;
        content: '';
        width: 100%;
        height: 2px;
        background: #FFF;
        transform: scale(0, 1);
        transform-origin: center top;
        transition: transform .2s;
      }
      &:hover:after {
        transform: scale(1, 1);
      }
    }
    
    .sign-btn {
      display: block;
      text-decoration: none;
      color:#FFF;
      font-size: 12px;
      font-weight: bold;
      background: linear-gradient(70deg, rgb(85, 85, 236), #13b1c0);
      border: 1px solid;
      margin: 0 10px;
      margin-top: 15px;
      padding: 0 10px;
      border-radius: 5px;
      height: 30px;
      line-height: 30px;
      cursor: pointer;
    }
  }
}
</style>
