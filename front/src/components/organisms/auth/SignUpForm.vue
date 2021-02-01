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
        <input type="text" v-model="userName" placeholder="ユーザ名" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.name }}</p>
      </div>
      <div class="form-item">
        <p>メールアドレス</p>
        <input type="text" v-model="email" placeholder="kyoon@example.com" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.email }}</p>
      </div>
      <div class="form-item">
        <p>パスワード</p>
        <input type="password" v-model="password" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.password }}</p>
      </div>
      <div class="form-item">
        <p>確認用パスワード</p>
        <input type="password" v-model="passwordConfirmation" class="default-input">
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
      userName: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      errorMessages: [],
      errMsg: {}
    }
  },
  methods: {
    signUp: function(){
      if(this.signUpValid()) {
        axios.post(
          `http://${g.hostName}/api/auth`,
          {
            name:                  this.userName,
            email:                 this.email,
            password:              this.password,
            password_confirmation: this.passwordConfirmation
          }
        )
        .then((response) => {
          this.$store.dispatch(
            "user/updateUser",
            {
              id:     response.data.data.id,
              name:   response.data.data.name,
              email:  response.data.data.email,
              token:  response.headers['access-token'],
              uid:    response.headers['uid'],
              client: response.headers['client'],
              adminType: response.data.data.admin_type,
              secureToken: response.data.data.token
            }
          );
          this.$router.push({
            name: "FirstIntroduction"
          })
        })
        .catch((error) => {
          if (error.response) {
            this.errorMessages = error.response.data.errors.full_messages;
          }
        });
      }
    },
    signUpValid: function() {
      this.errMsg.name  = this.userNameValid(this.userName)
      this.errMsg.email = this.userEmailValid(this.email)
      this.errMsg.password = this.userPasswordValid(this.password, this.passwordConfirmation)
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