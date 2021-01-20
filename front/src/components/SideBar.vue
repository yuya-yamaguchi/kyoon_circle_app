<template>
  <div class="side-menus">
    <div>
      <p class="sub-title">メニュー</p>
      <router-link to="/mypage" :class="{'select-menu': selectMenuProp==1}" class="side-menu">マイページトップ</router-link>
      <router-link to="/mypage/profile" :class="{'select-menu': selectMenuProp==2}" class="side-menu">プロフィール編集</router-link>
      <router-link to="/mypage/studio/reserves" :class="{'select-menu': selectMenuProp==3}" class="side-menu">スタジオ予約一覧</router-link>
      <router-link to="/mypage/events" :class="{'select-menu': selectMenuProp==4}" class="side-menu">参加イベント一覧</router-link>
    </div>
    <div v-if="$store.getters['user/adminType'] > 0">
      <p class="sub-title">管理者メニュー</p>
      <router-link to="/users" :class="{'select-menu': selectMenuProp==101}" class="side-menu">登録ユーザ一覧</router-link>
      <router-link to="/studio/1/edit" :class="{'select-menu': selectMenuProp==102}" class="side-menu">スタジオ内容編集</router-link>
      <router-link to="/event/new" :class="{'select-menu': selectMenuProp==103}" class="side-menu">イベント登録</router-link>
      <router-link to="/events/editlist?page=1" :class="{'select-menu': selectMenuProp==104}" class="side-menu">イベント編集</router-link>
      <router-link to="/news/new" :class="{'select-menu': selectMenuProp==105}" class="side-menu">お知らせ登録</router-link>
      <router-link to="/news/editlist" :class="{'select-menu': selectMenuProp==106}" class="side-menu">お知らせ編集</router-link>
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
.side-menu {
  display: block;
  text-decoration: none;
  color: #333;
  font-weight: bold;
  margin-bottom: 15px;
  padding-left: 20px;
}
.select-menu {
  color: var(--accent-color);
}
</style>