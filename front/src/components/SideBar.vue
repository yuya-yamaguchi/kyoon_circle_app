<template>
  <div>
    <div>
      <router-link to="/mypage" class="side-menu">マイページトップ</router-link>
      <router-link to="/mypage/profile" class="side-menu">プロフィール編集</router-link>
      <router-link to="/mypage/studio/reserves" class="side-menu">スタジオ予約一覧</router-link>
      <router-link to="/mypage/events" class="side-menu">参加イベント一覧</router-link>
    </div>
    <div v-if="$store.getters['user/adminType'] > 0">
      <p class="sub-title">管理者メニュー</p>
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
}
</style>