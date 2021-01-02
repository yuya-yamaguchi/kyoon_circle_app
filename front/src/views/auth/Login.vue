<template>
  <div class="auth-container">
    <h1 class="main-title text-center">ログイン</h1>
    <ul v-if="errorMessages" class="error-messages">
      <li v-for="(error, i) in errorMessages" :key="i">
        {{ error }}
      </li>
    </ul>
    <form v-on:submit.prevent="login()">
      <div class="form-item">
        <p>メールアドレス</p>
        <input type="text" v-model="email" placeholder="a@gmail.com">
      </div>
      <div class="form-item">
        <p>パスワード</p>
        <input type="password" v-model="password">
      </div>
      <button class="default-button">ログイン</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";

export default {
  data() {
    return {
      email: "",
      password: "",
      errorMessages: []
    }
  },
  methods: {
    login: function(){
      axios.post(`http://${g.hostName}/api/auth/sign_in`,
        {
          email: this.email,
          password: this.password
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
            adminType: response.data.data.admin_type
          }
        );
        this.$router.push({ 
          name: "Top"
        })
      })
      .catch((error) => {
        if (error.response) {
          this.errorMessages = error.response.data.errors;
        }
      });
    }
  }
}
</script>
