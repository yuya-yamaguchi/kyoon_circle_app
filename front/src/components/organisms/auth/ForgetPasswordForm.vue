<template>
  <div>
    <h1 class="main-title text-center">パスワードをお忘れの方</h1>
    <div class="password-forget-form">
      <div class="form-item">
        <p>メールアドレス</p>
        <input type="text" v-model="email" placeholder="ご登録しているメールアドレスを入力" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.email }}</p>
        <p class="form-item--addition">ご登録されたメールアドレスにパスワード再設定のご案内が送信されます</p>
      </div>
      <button class="default-button" @click="sendResetPasswordEmail()">送信する</button>
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
      email: "",
      errMsg: {}
    }
  },
  methods: {
    sendResetPasswordEmail: function(){
      if (this.emailValid()) {
        this.$emit('sending-email', true);
        axios.post(
          `http://${g.hostName}/api/users/reset_password_email`,
          {
            email: this.email
          }	
        )
        .then(() => {
          this.$emit('sent-email', this.email);
        })
        .catch((error) => {
          if (error.response) {
            this.errMsg.email = error.response.data;
          }
        })
        .finally(() => {
          this.$emit('sending-email', false);
        })
      }
    },
    emailValid: function() {
      this.errMsg.email = this.userEmailValid(this.email)
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
.password-forget-form {
  max-width: 350px;
  margin: 30px auto;
}
</style>