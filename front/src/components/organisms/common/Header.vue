<template>
  <div>
    <transition name="slide" appear>
      <ForSmartPhoneMunus v-if="hideMenu"
        @logout="logout()"
        @close-hide-menu="hideMenu=false"/>
    </transition>
    <header>
      <router-link to="/" class="site-title">京音</router-link>
      <div class="header-menus">
        <div class="header-menus">
          <router-link to="/news" class="header-menu">お知らせ</router-link>
          <router-link to="/studios/1?week=0" class="header-menu">スタジオ予約</router-link>
          <router-link to="/events?page=1" class="header-menu">イベント</router-link>
          <router-link to="/stayrooms?month=0" class="header-menu">宿泊</router-link>
        </div>
        <template v-if='!$store.getters["user/id"]'>
          <router-link to="/signup" class="sign-btn">新規会員登録</router-link>
          <router-link to="/login" class="sign-btn">ログイン</router-link>
        </template>
        <template v-else class="header-menus">
          <router-link to="/mypage" class="header-menu">マイページ</router-link>
          <button type="submit" @click="logout()" class="sign-btn">ログアウト</button>
        </template>
      </div>
      <div @click="hideMenu=true" class="hide-menu">
        <fa icon="bars"></fa>
      </div>
    </header>
  </div>
</template>

<script>
import ForSmartPhoneMunus from "@/components/organisms/common/ForSmartPhoneMunus.vue";

export default {
  components: {
    ForSmartPhoneMunus
  },
  data() {
    return {
      hideMenu: false
    }
  },
  methods: {
    logout: function() {
      // FRONT側のユーザ情報を削除
      this.$store.dispatch("user/logout");
      this.$store.dispatch(
        "flash/create",
        { message: "ログアウトが完了しました",
          type:    1
        }
      );
      this.$router.push({
        name: "Top"
      })
    }
  }
}
</script>

<style scoped lang="scss">
header{
  width: 100%;
  height: 60px;
  background: var(--main-color);
  display: flex;
  justify-content: space-between;
  color: #FFF;
  position: fixed;
  z-index: 2;
  .site-title {
    text-align: left;
    line-height: 60px;
    padding: 0 10px;
    color: #FFF;
    font-size: 30px;
    text-decoration: none;
    white-space: nowrap;
  }
  .header-menus {
    margin-right: 20px;
    display: flex;
    justify-content: flex-end;
    .header-menu {
      text-decoration: none;
      color: #FFF;
      line-height: 60px;
      margin: 0 20px;
      font-weight: bold;
      position: relative;
      cursor: pointer;
      white-space: nowrap;
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
      background: linear-gradient(70deg, var(--gradation-color), var(--accent-color));
      border: 1px solid;
      margin: 0 10px;
      margin-top: 15px;
      padding: 0 10px;
      border-radius: 5px;
      height: 30px;
      line-height: 30px;
      cursor: pointer;
      white-space: nowrap;
    }
  }
  .hide-menu {
    display: none;
  }
}

@media screen and (max-width: 600px) {
  header {
    .header-menus {
      display: none;
    }
    .hide-menu {
      display: block;
      width: 20px;
      margin: 0 20px;
      line-height: 70px;
      cursor: pointer;
    }
  }
}
</style>
