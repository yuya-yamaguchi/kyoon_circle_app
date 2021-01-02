<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar/>
    </div>
    <div class="double-container--right">
      <div class="mypage-user-icon">
        <img src="@/assets/logo.png">
        <p class="main-title">{{ $store.getters['user/name'] }}</p>
      </div>
      <p>{{ user.profile }}</p>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";

export default {
  components: {
    SideBar
  },
  data() {
    return {
      user: ""
    }
  },
  methods: {
    getMypageInfo: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/${this.$store.getters['user/id']}`
      )
      .then((response) => {
        this.user   = response.data
      })
      .catch(function(error) {
        console.log(error);
      });
    }
  },
  mounted() {
    this.getMypageInfo();
  }
}
</script>

<style scoped lang="scss">
.mypage-user-icon {
  text-align: center;
  border: 1px solid #888;
}
</style>