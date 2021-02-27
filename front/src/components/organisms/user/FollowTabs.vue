<template>
  <div class="tabs">
    <router-link :to="{ name: 'Follow', params: { id: user.id }, query: {follow: 'following'}}"
      class="tabs--tab"
      :class="{ active: currentTab === 1 }">
      フォロー中
    </router-link>
    <router-link :to="{ name: 'Follow', params: { id: user.id }, query: {follow: 'followers'}}"
      class="tabs--tab"
      :class="{ active: currentTab === 2 }">
      フォロワー
    </router-link>
  </div>
</template>

<script>
export default {
  props: {
    currentTab: {},
    user: {}
  }
}
</script>