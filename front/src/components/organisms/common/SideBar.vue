<template>
  <div>
    <div class="side-menus">
      <router-link to="/mypage" :class="{'select-menu': selectMenuProp==1}" class="side-menu first-menu">マイページトップ</router-link>
      <router-link to="/mypage/studio/reserves" :class="{'select-menu': selectMenuProp==3}" class="side-menu">スタジオ予約確認</router-link>
      <router-link to="/mypage/stayrooms" :class="{'select-menu': selectMenuProp==6}" class="side-menu">宿泊予約確認</router-link>
      <router-link to="/mypage/events" :class="{'select-menu': selectMenuProp==4}" class="side-menu">参加イベント一覧</router-link>
      <router-link to="/mypage/settings" :class="{'select-menu': selectMenuProp==7}" class="side-menu last-menu">設定</router-link>
    </div>
    <div v-if="$store.getters['user/adminType']">
      <p class="admin-menu">管理者メニュー</p>
      <div class="side-menus">
        <router-link to="/admin" :class="{'select-menu': selectMenuProp==100}" class="side-menu first-menu">管理メニュートップ</router-link>
        <router-link to="/users" :class="{'select-menu': selectMenuProp==101}" class="side-menu first-menu">登録ユーザ一覧</router-link>
        <router-link to="/studio/1/edit" :class="{'select-menu': selectMenuProp==102}" class="side-menu">スタジオ情報編集</router-link>
        <router-link to="/admin/studio/1/reserves?week=0" :class="{'select-menu': selectMenuProp==107}" class="side-menu">スタジオ予約確認</router-link>
        <router-link to="/admin/stayrooms?month=0" :class="{'select-menu': selectMenuProp==108}" class="side-menu">宿泊予約確認</router-link>
        <router-link to="/event/new" :class="{'select-menu': selectMenuProp==103}" class="side-menu">イベント登録</router-link>
        <router-link to="/events/editlist?page=1" :class="{'select-menu': selectMenuProp==104}" class="side-menu">イベント編集</router-link>
        <router-link to="/news/new" :class="{'select-menu': selectMenuProp==105}" class="side-menu">お知らせ登録</router-link>
        <router-link to="/news/editlist" :class="{'select-menu': selectMenuProp==106}" class="side-menu  last-menu">お知らせ編集</router-link>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    selectMenuProp: {}
  }
}
</script>

<style scoped lang="scss">
.side-menus {
  border: 1px solid lightgray;
  border-radius: 10px;
  background: #FFF;
  margin-bottom: 20px;
  .side-menu {
    display: block;
    color: #333;
    text-decoration: none;
    border-bottom: 1px solid lightgray;
    padding: 5px;
    font-size: 15px;
    &:hover {
      background: lightgray;
      font-weight: bold;
      transition: .3s;
    }
  }
  .first-menu {
    border-radius: 10px 10px 0 0;
  }
  .last-menu {
    border: 0px;
    border-radius: 0 0 10px 10px;
  }
  .select-menu {
    background: lightgray;
    font-weight: bold;
  }
}
</style>