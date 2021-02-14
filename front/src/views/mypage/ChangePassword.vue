<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="5"/>
    </div>
    <div class="double-container--right">
      <h1 class="main-title text-center">パスワード変更</h1>
      <form v-on:submit.prevent="putPassword" class="change-password-form">
        <ErrMsg :error-messages-prop="apiErrorMessages"/>
        <div class="form-item">
          <p class="form-item--name">現在のパスワード</p>
          <input type="password" v-model="user.current_password" placeholder="" class="default-input">
          <p class="form-item--err-msg">{{ errMsg.current_password }}</p>
        </div>
        <div class="form-item">
          <p class="form-item--name">新しいパスワード</p>
          <input type="password" v-model="user.password" placeholder="" class="default-input">
          <p class="form-item--err-msg">{{ errMsg.password }}</p>
        </div>
        <div class="form-item">
          <p class="form-item--name">確認パスワード</p>
          <input type="password" v-model="user.password_confirmation" placeholder="" class="default-input">
          <p class="form-item--err-msg">{{ errMsg.password_confirmation }}</p>
        </div>
        <button class="default-button">変更する</button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import ErrMsg from "@/components/organisms/common/ErrMsg.vue";
import { userValidates } from '@/mixins/userValidates';

export default {
  mixins: [userValidates],
  components: {
    SideBar,
    ErrMsg
  },
  data() {
    return {
      user: {},
      errMsg: {}
    }
  },
  methods: {
    putPassword: function() {
      if(this.changePasswordValid()) {
        axios.post(
          `http://${g.hostName}/api/users/change_password`,
          {
            user: this.user
          },
          {
            headers: {
              Authorization: this.$store.getters['user/secureToken']
            }
          }
        )
        .then(() => {
          this.$store.dispatch(
            "flash/create",
            { message: "パスワードを変更しました",
              type:    1
            }
          );
          this.$router.push({ 
            name: "MypageTop"
          })
        })
        .catch((error) => {
          this.$store.dispatch(
            "flash/create",
            { message: error.response.data,
              type:    2
            }
          );
        });
      }
    },
    changePasswordValid: function() {
      this.errMsg.password = this.userPasswordValid(this.user.password, this.user.password_confirmation)
      for (var key in this.errMsg) {
        if (this.errMsg[key] != "") {
          return false
        }
      }
      return true
    }
  }
}
</script>

<style scoped lang="scss">
.change-password-form {
  max-width: 400px;
  margin: 30px auto;
}
</style>