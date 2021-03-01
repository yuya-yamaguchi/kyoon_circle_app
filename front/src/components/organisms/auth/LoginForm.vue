<template>
  <div>
    <ul v-if="errorMessages" class="error-messages">
      <li v-for="(error, i) in errorMessages" :key="i">
        {{ error }}
      </li>
    </ul>
    <form v-on:submit.prevent="login()" class="form-container">
      <div class="form-item">
        <p>メールアドレス</p>
        <input type="text" v-model="email" placeholder="kyoon@example.com" class="default-input">
        <p class="form-item--err-msg">{{ errMsg.email }}</p>
      </div>
      <div class="form-item">
        <p>パスワード</p>
        <input type="password" v-model="password"  class="default-input">
        <p class="form-item--err-msg">{{ errMsg.password }}</p>
      </div>
      <button class="default-button">ログイン</button>
    </form>
    <div class="others">
      <router-link :to="{name: 'ForgetPassword'}" class="password-forget">
        パスワードを忘れた場合はこちら
      </router-link>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import { userValidates } from '@/mixins/userValidates';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [userValidates, errorMethods],
  data() {
    return {
      email: "",
      password: "",
      errorMessages: [],
      errMsg: {}
    }
  },
  methods: {
    login: function(){
      if (this.loginValid())
        axios.post(
          `http://${g.hostName}/api/login`,
          {
            email:    this.email,
            password: this.password
          }	
        )
        .then((response) => {
          this.$store.dispatch(
            "user/updateUser",
            {
              id:          response.data.id,
              name:        response.data.name,
              email:       response.data.email,
              adminType:   response.data.admin_type,
              secureToken: response.data.token
            }
          );
          this.$store.dispatch(
            "flash/create",
            { message: "ログインが完了しました",
              type:    1
            }
          );
          this.$store.dispatch(
            "loginGuide/update", false
          );
          if (location.pathname == '/login') {
            this.$router.push({ 
              name: "Top"
            })
          }
        })
        .catch((error) => {
          this.apiErrors(error.response);
          if (error.response.status==400) {
            this.errorMessages = ['メールアドレスまたはパスワードが正しくありません'];
          }
        })
    },
    loginValid: function() {
      this.errMsg.email = this.userEmailValid(this.email)
      this.errMsg.password = this.userPasswordValid(this.password)
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
.others {
  text-align: center;
  .password-forget {
    color: #333;
    font-size: 14px;
  }
}
</style>