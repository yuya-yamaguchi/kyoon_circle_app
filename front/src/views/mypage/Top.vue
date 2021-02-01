<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="1"/>
    </div>
    <div class="double-container--right">
      <UserInfo :user-prop="user" :userInstrumentsProp="userInstruments" :loading="loading"/>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import UserInfo from "@/components/organisms/user/UserInfo.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    SideBar,
    UserInfo
  },
  data() {
    return {
      user: "",
      userInstruments: [],
      loading: true
    }
  },
  methods: {
    getMypageInfo: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/${this.$store.getters['user/id']}`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.user = response.data.user,
        this.userInstruments = response.data.user_instruments
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
      .finally(() => {
        this.loading = false;
      });
    }
  },
  mounted() {
    this.getMypageInfo();
  }
}
</script>

<style scoped lang="scss">

</style>