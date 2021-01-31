<template>
  <div class="user-info">
    <div class="user-info--top">
      <div class="user-info--top--img">
        <UserAvatar v-if="!loading" :avatar-prop="userProp.avatar"/>
      </div>
      <div class="user-info--top--name">
        <div class="user-info main-title">{{ userProp.name }}</div>
      </div>
    </div>
    <div class="user-info--profile">
      <router-link v-if="isCurrentUser" to="/mypage/edit" class="user-info--profile--edit some-updown-center">
        <fa icon="edit"></fa>
        <span>プロフィールを変更する</span>
      </router-link>
      <div class="user-info--profile--contents">{{ userProp.profile }}</div>
    </div>
  </div>
</template>

<script>
import UserAvatar from "@/components/atoms/UserAvatar.vue";

export default {
  components: {
    UserAvatar
  },
  props: {
    userProp: {},
    loading: {}
  },
  computed: {
    isCurrentUser() {
      return this.$store.getters['user/id'] == this.$route.params.id ? true : false
    }
  }
}
</script>

<style scoped lang="scss">
.user-info {
  background: var(--base-color);
  &--top {
    position: relative;
    display: flex;
    justify-content: flex-start;
    z-index: 1;
    &--img {
      position: absolute;
      background: var(--base-color);
      border-radius: 100%;
      width: 120px;
      height: 120px;
      border-radius: 100%;
      z-index: 2;
      padding: 10px;
    }
    &--name {
      margin: 10px 0 0 140px;
    }
  }
  &--profile {
    background: #FFF;
    padding: 20px;
    margin-left: 30px;
    min-height: 300px;
    &--edit {
      display: block;
      text-align: right;
      font-size: 14px;
      font-weight: bold;
      text-decoration: none;
      color: #333;
      svg {
        width: 14px;
      }
      &:hover {
        color: var(--accent-color)
      }
    }
    &--contents {
      margin-top: 80px;
      font-size: 14px;
      box-sizing: border-box;
      background: #FFF;
      white-space: pre-wrap;
    }
  }
}
</style>