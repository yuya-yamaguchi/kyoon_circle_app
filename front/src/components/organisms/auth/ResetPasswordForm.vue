<template>
  <div>
    <h1 class="main-title text-center">新しいパスワードの設定</h1>
    <div class="reset-password-form">
      <div class="form-item">
        <p>新しいパスワード</p>
        <input type="password" v-model="user.password" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.password }}</p>
      </div>
      <div class="form-item">
        <p>確認用パスワード</p>
        <input type="password" v-model="user.password_confirmation" class="default-input">
      </div>
      <button class="default-button" @click="postResetPassword()">設定する</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import { userValidates } from '@/mixins/userValidates';

export default {
  mixins: [userValidates],
  data() {
    return {
      user: {},
      errMsg: {}
    }
  },
  methods: {
    postResetPassword: function() {
      if (this.passwordValid())
        axios.post(
          `http://${g.hostName}/api/users/reset_password`,
          {
            token: this.$route.query.token,
            user: this.user
          }
        )
        .then(() => {
          this.$emit('reset-password-complete');
        })
        .catch((error) => {
          this.apiErrors(error.response);
        })
    },
    passwordValid: function() {
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

<style scoped>
.reset-password-form {
  margin: 30px auto;
  max-width: 350px;
}
</style>