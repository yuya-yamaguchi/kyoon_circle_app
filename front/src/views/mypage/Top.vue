<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="1"/>
    </div>
    <div class="double-container--right">
      <div class="mypage-user-icon">
        <img src="/person.png">
        <p class="main-title">{{ $store.getters['user/name'] }}</p>
      </div>
      <div class="user-profile">{{ user.profile }}</div>
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
  display: flex;
  justify-content: flex-start;
  img {
    display: block;
    border: 1px solid;
    border-radius: 100%;
    width: 100px;
  }
  p {
    margin-left: 30px;
    bottom: 0;
  }
}

.user-profile {
  margin: 20px;
}
</style>