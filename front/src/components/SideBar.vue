<template>
  <div>
    <router-link to="/mypage" class="side-menu">マイページトップ</router-link>
    <router-link to="/mypage/profile" class="side-menu">プロフィール編集</router-link>
    <router-link to="/mypage/studio/reserves" class="side-menu">スタジオ予約一覧</router-link>
    <router-link to="/mypage/events" class="side-menu">参加イベント一覧</router-link>
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
  margin-top: 10px;
}
</style>