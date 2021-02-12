<template>
  <div class="user-info">
    <div class="user-info--top">
      <div class="user-info--top--img">
        <UserAvatar v-if="!loading" :avatar-prop="userProp.avatar"/>
      </div>
      <div class="user-info--top--name">
        <div class="user-info main-title">{{ userProp.name }}</div>
      </div>
      <router-link v-if="isMypage" to="/mypage/edit" class="user-info--top--edit some-updown-center">
        <fa icon="edit"></fa>
        <span>プロフィールを変更する</span>
      </router-link>
    </div>
    <div class="user-info--profile">
      <div class="user-info--profile--instruments">
        <UserInstrument :userInstrumentsProp="userInstrumentsProp"/>
      </div>
      <div class="user-info--profile--contents">{{ userProp.profile }}</div>
    </div>
  </div>
</template>

<script>
import UserInstrument from "@/components/molecules/instruments/UserInstrument.vue";
import UserAvatar from "@/components/atoms/UserAvatar.vue";

export default {
  components: {
    UserAvatar,
    UserInstrument
  },
  props: {
    userProp: {},
    userInstrumentsProp: {},
    loading: {}
  },
  computed: {
    isMypage() {
      return (location.pathname === '/mypage') ? true : false
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
    &--edit {
      margin-left:auto;
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
  }
  &--profile {
    background: #FFF;
    padding: 10px;
    margin-left: 30px;
    min-height: 300px;
    &--instruments {
      margin-left: 120px;
    }
    &--contents {
      margin-top: 50px;
      font-size: 14px;
      box-sizing: border-box;
      background: #FFF;
      white-space: pre-wrap;
    }
  }
}

@media screen and (max-width: 600px) {
  .user-info {
    margin: 0 auto;
    &--top {
      display: block;
      margin: 0 auto;
      &--img {
        position: static;
        margin: 0 auto;
      }
      &--name {
        margin: 0 auto;
        text-align: center;
      }
      &--edit {
        margin: 0 auto;
        text-align: center;
        svg {
          width: 14px;
        }
        &:hover {
          color: var(--accent-color)
        }
      }
    }
    &--profile {
      padding: 10px;
      margin: 20px 0 0 0;
      &--instruments {
        margin: 0;
      }
      &--contents {
        margin: 20px 0 0 0;
      }
    }
  }
}
</style>