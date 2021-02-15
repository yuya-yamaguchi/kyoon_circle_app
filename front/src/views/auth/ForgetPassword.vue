<template>
  <div class="single-container">
    <div class="auth-container">
      <h1 class="main-title text-center">パスワードをお忘れの方</h1>
      <div class="password-forget-form">
        <div class="form-item">
          <p>メールアドレス</p>
          <input type="text" v-model="email" placeholder="ご登録しているメールアドレス" class="default-input">
          <p class="form-item--err-msg">{{ errMsg.email }}</p>
          <p class="form-item--addition">ご登録されたメールアドレスにパスワード再設定のご案内が送信されます</p>
        </div>
        <button class="default-button" @click="sendResetPasswordEmail()">送信する</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";

export default {
  data() {
    return {
      email: "",
      errMsg: {}
    }
  },
  methods: {
    sendResetPasswordEmail: function(){
      axios.post(`http://${g.hostName}/api/users/reset_password_email`,
        {
          email: this.email
        }	
      )
      .then((response) => {
        console.log(response)
      })
      .catch((error) => {
        if (error.response) {
          this.errMsg.email = error.response.data;
        }
      })
    }
  }
}
</script>

<style scoped lang="scss">
.password-forget-form {
  max-width: 350px;
  margin: 30px auto;
}
</style>