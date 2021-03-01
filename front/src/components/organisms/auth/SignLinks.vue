<template>
  <div class="other-auth-links">
    <router-link v-show="isLinkShow('/signup')" to="/signup" class="other-auth-links--sign-up">会員登録はこちら</router-link>
    <router-link v-show="isLoginLinkShow()" to="/login" class="other-auth-links--login">ログインはこちら</router-link>
    <a @click="guestLogin('normal@example.com')" class="other-auth-links--guest-login">ゲストログイン<br>（一般ユーザ）</a>
    <a @click="guestLogin('admin@example.com')" class="other-auth-links--guest-login">ゲストログイン<br>（管理ユーザ）</a>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  methods: {
    isLinkShow: function(link){
      if (link == location.pathname) {
        return false
      }
      return true
    },
    isLoginLinkShow: function() {
      return (location.pathname == '/signup') ? true : false;
    },
    guestLogin: function(email){
      axios.post(
        `http://${g.hostName}/api/login`,
        {
          email:     email,
          password: '12345678'
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
        this.$store.dispatch(
          "flash/create",
          { message: "ログインが完了しました",
            type:    1
          }
        );
        this.$store.dispatch(
          "loginGuide/update", false
        );
        if (location.pathname == '/login' || location.pathname == '/signup') {
          this.$router.push({ 
            name: "Top"
          })
        }
      })
      .catch((error) => {
        this.apiErrors(error.response);
        this.errorMessages = error.response.data.errors;
      });
    }
  }
}
</script>

<style scoped lang="scss">
.other-auth-links {
  max-width: 280px;
  min-width: 230px;
  margin: 30px auto;
  a {
    display: block;
    border: 1px solid;
    margin: 20px;
    text-align: center;
    padding: 10px 0;
    border-radius: 20px;
    font-weight: bold;
    text-decoration: none;
    cursor: pointer;
  }
  &--sign-up {
    color: #FFF;
    background: #333;
  }
  &--login {
    color: #FFF;
    background: #333;
  }
  &--guest-login {
    color: #FFF;
    background: var(--accent-color);
  }
}
</style>
