<template>
  <div class="follow-list">
    <div v-for="(followUser, i) in followUsers" :key="i" class="user-card">
      <router-link :to="{name: 'UserShow', params: { id: followUser.id }}" class="user-card--left">
        <div class="user-card--left--img">
          <UserAvatar :avatar-prop="followUser.avatar"/>
        </div>
        <div class="user-card--left--info">
          <div class="user-card--left--info--name">
            {{ followUser.name }}
          </div>
          <div class="user-card--left--info--profile">
            {{ cutProfile(followUser.profile) }}
          </div>
        </div>
      </router-link>
      <div class="user-card--right">
        <FollowBtn
          v-if="$store.getters['user/id'] != followUser.id"
          :is-followed="followUser.is_followed"
          @follow="followInList(i)"
          @unfollow="unfollowInList(i)"/>
      </div>
    </div>
    <div v-if="!followUsers.length" class="nothing-msg">
      {{ nothigMsg }}
    </div>
  </div>
</template>

<script>
import UserAvatar from "@/components/atoms/UserAvatar.vue";
import FollowBtn from "@/components/atoms/buttons/FollowBtn.vue";
import { userFollow } from '@/mixins/users/userFollow';

export default {
  mixins: [userFollow],
  props: {
    followUsersProp: {}
  },
  data() {
    return {
      followUsers: this.followUsersProp
    }
  },
  components: {
    UserAvatar,
    FollowBtn
  },
  computed: {
    nothigMsg() {
      let message = ''
      if (this.$route.query.follow === 'following') {
        message = 'フォローしているユーザはいません'
      }
      else if (this.$route.query.follow === 'followers') {
        message = 'フォロー中のユーザはいません'
      }
      return message
    }
  },
  methods: {
    cutProfile(profile) {
      if (profile && profile.length > 40) {
        return profile.slice(0, 40) + '...'
      }
      return profile
    }
  }
}
</script>

<style scoped lang="scss">
.follow-list {
  max-width: 100%;
  .user-card {
    display: flex;
    justify-content: space-between;
    padding: 10px;
    border-bottom: 1px solid lightgray;
    &--left {
      display: flex;
      justify-content: space-between;
      text-decoration: none;
      color: #333;
      &--img {
        width: 50px;
        height: 50px;
        min-width: 50px;
        min-height: 50px;
      }
      &--info {
        margin-left: 20px;
        &--profile {
          margin-top: 5px;
          font-size: 12px;
          color: #888;
        }
      }
    }
    &--right {
      display: flex;
      align-items: center;
      margin-left: 20px;
    }
  }
}
</style>