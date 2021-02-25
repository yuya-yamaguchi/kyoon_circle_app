<template>
  <div class="user-follow">
    <div class="follow">
      <p class="follow--name">フォロー</p>
      <p class="follow--count">{{ userProp.following_count }}</p>
    </div>
    <div class="follow">
      <p class="follow--name">フォロワー</p>
      <p class="follow--count">{{ userProp.followers_count }}</p>
    </div>
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
    &--count {
      font-weight: bold;
      margin-left: 5px;
    }
  }
}
</style>