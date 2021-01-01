<template>
  <div>
    <div>
      <p class="sub-title">メニュー</p>
      <router-link to="/mypage" class="side-menu">マイページトップ</router-link>
      <router-link to="/mypage/profile" class="side-menu">プロフィール編集</router-link>
      <router-link to="/mypage/studio/reserves" class="side-menu">スタジオ予約一覧</router-link>
      <router-link to="/mypage/events" class="side-menu">参加イベント一覧</router-link>
    </div>
    <div v-if="$store.getters['user/adminType'] > 0">
      <p class="sub-title">管理者用メニュー</p>
      <router-link to="/users" class="side-menu">登録ユーザ一覧</router-link>
      <router-link to="/studio/1/edit" class="side-menu">スタジオ内容編集</router-link>
      <router-link to="/event/new" class="side-menu">イベントの登録</router-link>
      
    </div>
  </div>
</template>

<script>
export default {
  
}
</script>

<style scoped>
.side-menu {
  display: block;
  text-decoration: none;
  color: #333;
  font-weight: bold;
  margin-bottom: 15px;
  padding-left: 20px;
}
</style>