<template>
  <div class="user-info">
    <div class="user-info--top">
      <div class="user-info--top--img">
        <UserAvatar v-if="!loading" :avatar-prop="userProp.avatar"/>
      </div>
      <div class="user-info--top--name main-title">
        {{ userProp.name }}
      </div>
      <div v-if="$store.getters['user/id'] != userProp.id">
        <router-link :to="{ name: 'MessageShow', params: { id: $route.params.id }}" class="user-info--top--message-btn some-updown-center">
          <fa icon="envelope"></fa>
          <p>メッセージを送る</p>
        </router-link>
        <div class="user-info--top--follow-btn">
          <FollowBtn
            :is-followed="isFollowed"
            @follow="follow(userProp)"
            @unfollow="unfollow(userProp)"/>
        </div>
      </div>
      <div class="user-info--top--follow">
        <FollowCount :user-prop="user"/>
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
import FollowCount from "@/components/organisms/user/FollowCount.vue";
import FollowBtn from "@/components/atoms/buttons/FollowBtn.vue";
import { userFollow } from '@/mixins/users/userFollow';

export default {
  mixins: [userFollow],
  components: {
    UserAvatar,
    UserInstrument,
    FollowCount,
    FollowBtn
  },
  props: {
    userProp: {},
    userInstrumentsProp: {},
    isFollowedProp: {},
    loading: {}
  },
  data() {
    return {
      user: this.userProp,
      isFollowed: this.isFollowedProp
    }
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
    &--img {
      background: var(--base-color);
      border-radius: 100%;
      width: 120px;
      height: 120px;
      border-radius: 100%;
      margin: 0 auto;
    }
    &--name {
      text-align: center;
      margin: 10px;
    }
    &--message-btn {
      margin: 10px auto;
      width: 150px;
      text-align: center;
      font-weight: bold;
      color: #333;
      text-decoration: none;
      cursor: pointer;
      svg {
        width: 16px;
        margin-right: 5px;
      }
    }
    &--follow-btn {
      margin: 10px auto;
      width: 200px;
    }
    &--follow {
      max-width: 300px;
      margin: 10px auto;
    }
    &--edit {
      margin: 10px;
      text-align: right;
      font-size: 0.8rem;
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
    min-height: 200px;
    &--contents {
      margin-top: 20px;
      font-size: 0.8rem;
      box-sizing: border-box;
      background: #FFF;
      white-space: pre-wrap;
    }
  }
}

@media screen and (max-width: 700px) {
  .user-info {
    margin: 0 auto;
    &--top {
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
      &--contents {
        margin: 20px 0 0 0;
      }
    }
  }
}
</style>