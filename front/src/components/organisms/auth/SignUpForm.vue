<template>
  <div>
    <ul class="error-messages">
      <li v-for="(error, i) in errorMessages" :key="i">
        {{ error }}
      </li>
    </ul>
    <form v-on:submit.prevent="signUp()" class="form-container">
      <div class="form-item">
        <p>ユーザ名</p>
        <input type="text" v-model="user.name" placeholder="ユーザ名" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.name }}</p>
      </div>
      <div class="form-item">
        <p>メールアドレス</p>
        <input type="text" v-model="user.email" placeholder="kyoon@example.com" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.email }}</p>
      </div>
      <div class="form-item">
        <p>パスワード</p>
        <input type="password" v-model="user.password" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.password }}</p>
      </div>
      <div class="form-item">
        <p>確認用パスワード</p>
        <input type="password" v-model="user.password_confirmation" class="default-input">
      </div>
      <button class="default-button">会員登録する</button>
    </form>
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
      user: {
        mame: "",
        email: "",
        password: "",
        password_confirmation: ""
      },
      errorMessages: [],
      errMsg: {}
    }
  },
  methods: {
    signUp: function(){
      if(this.signUpValid()) {
        axios.post(
          `http://${g.hostName}/api/users`,
          {
            user: this.user
          }
        )
        .then((response) => {
          this.$store.dispatch(
            "user/updateUser",
            {
              id:     response.data.id,
              name:   response.data.name,
              email:  response.data.email,
              adminType: response.data.admin_type,
              secureToken: response.data.token
            }
          );
          this.$router.push({
            name: "FirstIntroduction"
          })
        })
        .catch((error) => {
          error.response
          if (error.response) {
            this.errorMessages = error.response.data;
          }
        });
      }
    },
    signUpValid: function() {
      this.errMsg.name  = this.userNameValid(this.user.name)
      this.errMsg.email = this.userEmailValid(this.user.email)
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