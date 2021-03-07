<template>
  <div class="user-follow">
    <router-link :to="{ name: 'Follow', params: { id: userProp.id }, query: {follow: 'following'}}" class="follow">
      <p class="follow--name">フォロー</p>
      <p class="follow--count">{{ userProp.following_count }}</p>
    </router-link>
    <router-link :to="{ name: 'Follow', params: { id: userProp.id }, query: {follow: 'followers'}}" class="follow">
      <p class="follow--name">フォロワー</p>
      <p class="follow--count">{{ userProp.followers_count }}</p>
    </router-link>
  </div>
</template>

<script>
export default {
  props: {
    userProp: {}
  }
}
</script>

<style scoped lang="scss">
.user-follow {
  display: flex;
  justify-content: space-around;
  .follow {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    margin-right: 10px;
    text-decoration: none;
    color: #333;
    &--name {
      font-size: 0.9rem;
    }
    &--count {
      font-weight: bold;
      margin-left: 5px;
    }
  }
}
</style>