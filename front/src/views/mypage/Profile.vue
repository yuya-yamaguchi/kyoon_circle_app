<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="2"/>
    </div>
    <div class="double-container--right">
      <div class="user-profile-container">
        <h1 class="main-title">プロフィール編集</h1>
        <ErrMsg :error-messages-prop="apiErrorMessages"/>
        <form v-on:submit.prevent="updateProfile">
          <div class="form-item">
            <p>
              ユーザ名
            </p>
            <input type="text" v-model="user.name" class="default-input">
          </div>
          <div>
            <div class="form-item">
              <p>
                プロフィール
              </p>
              <textarea v-model="user.profile"></textarea>
            </div>
          </div>
          <button class="default-button">変更する</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";
import ErrMsg from "@/components/ErrMsg.vue";

export default {
  components: {
    SideBar,
    ErrMsg
  },
  data() {
    return {
      user: {},
      apiErrorMessages: []
    }
  },
  methods: {
    // プロフィール情報の取得
    getProfile: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/${this.$store.getters['user/id']}`
      )
      .then((response) => {
        this.user = response.data
      })
      .catch(function(error) {
        console.log(error.response);
      });
    },
    // プロフィールの更新
    updateProfile: function() {
      axios.put(
        `http://${g.hostName}/api/mypage/${this.$store.getters.['user/id']}`,
        {
          user: {
            name:    this.user.name,
            profile: this.user.profile
          }
        }
      )
      .then((response) => {
        this.$store.dispatch(
          "user/changeUserProfile",
          {
            name: response.data.name
          }
        );
        this.$router.push({ 
          name: "MypageTop"
        })
      })
      .catch((error) => {
        this.apiErrorMessages = error.response.data;
      });
    }
  },
  mounted: function() {
    this.getProfile();
  }
}
</script>

<style lang="scss" scoped>
.user-profile-container {
  width: 80%;
  margin: 0 auto;
}
</style>