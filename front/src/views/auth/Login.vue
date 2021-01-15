<template>
  <div class="auth-container">
    <div class="text-center some-updown-center">
      <span class="main-title">ログイン</span>
      <fa icon="sign-in-alt" class="default-icon"></fa>
    </div>
    <ul v-if="errorMessages" class="error-messages">
      <li v-for="(error, i) in errorMessages" :key="i">
        {{ error }}
      </li>
    </ul>
    <form v-on:submit.prevent="login()">
      <div class="form-item">
        <p>メールアドレス</p>
        <input type="text" v-model="email" placeholder="a@gmail.com"  class="default-input">
      </div>
      <div class="form-item">
        <p>パスワード</p>
        <input type="password" v-model="password"  class="default-input">
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
        console.log(response.data.data);
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
        this.$store.dispatch(
          "flash/create",
          { message: "ログインが完了しました",
            type:    1
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
