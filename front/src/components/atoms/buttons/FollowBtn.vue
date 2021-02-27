<template>
  <div>
    <div v-if="isFollowed" class="follow-btn unfollow-btn" @click="unfollow()">
      フォロー中
    </div>
    <div v-else class="follow-btn" @click="follow()">
      フォローする
    </div>
  </div>
</template>

<script>
export default {
  props: {
    isFollowed: {}
  },
  methods: {
    follow() {
      this.$emit("follow")
    },
    unfollow() {
      this.$emit("unfollow")
    }
  }
}
</script>

<style scoped lang="scss">
.follow-btn {
  font-size: 14px;
  color: var(--accent-color);
  border: 2px solid var(--accent-color);
  padding: 2px 20px;
  border-radius: 15px;
  font-weight: bold;
  text-align: center;
  min-width: 100px;
  cursor: pointer;
  &:hover {
    opacity: 0.7;
  }
}
.unfollow-btn {
  color: #FFF;
  background: var(--accent-color);
}
</style>