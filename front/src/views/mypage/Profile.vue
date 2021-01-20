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
            <p class="form-item--name">ユーザ名</p>
            <input type="text" v-model="user.name" class="default-input" @blur="userNameChk()" @keyup="userNameChk()">
            <p class="form-item--err-msg">{{ errMsg.name }}</p>
          </div>
          <div>
            <div class="form-item">
              <p class="form-item--name">プロフィール</p>
              <textarea v-model="user.profile" @blur="userProfileChk()" @keyup="userProfileChk()"></textarea>
              <p class="form-item--err-msg">{{ errMsg.profile }}</p>
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
import { commonCheck } from '@/mixins/commonCheck';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonCheck, errorMethods],
  components: {
    SideBar,
    ErrMsg
  },
  data() {
    return {
      user: {},
      errMsg: {
        name: "",
        profile: ""
      },
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
        this.apiErrors(error.response.status);
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
    },
    userNameChk: function() {
      this.errMsg.name = this.formStrChk(this.user.name, 20);
    },
    userProfileChk: function() {
      this.errMsg.profile = this.formStrChk(this.user.profile, 1000, "01");
    }
  },
  mounted: function() {
    this.getProfile();
  }
}
</script>

<style lang="scss" scoped>
.user-profile-container {
  width: 100%;
  margin: 0 auto;
  padding: 20px 0;
  background: #FFF;
  h1 {
    margin: 0 0 20px 20px;
  }
}
</style>