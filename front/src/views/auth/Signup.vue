<template>
  <div class="auth-container">
    <h1 class="main-title text-center">新規会員登録</h1>
    <ul class="error-messages">
      <li v-for="(error, i) in errorMessages" :key="i">
        {{ error }}
      </li>
    </ul>
    <form v-on:submit.prevent="signUp()">
      <div class="form-item">
        <p>ユーザ名</p>
        <input type="text" v-model="userName" placeholder="ユーザ名">
      </div>
      <div class="form-item">
        <p>メールアドレス</p>
        <input type="text" v-model="email" placeholder="a@gmail.com">
      </div>
      <div class="form-item">
        <p>パスワード</p>
        <input type="password" v-model="password">
      </div>
      <div class="form-item">
        <p>確認用パスワード</p>
        <input type="password" v-model="passwordConfirmation">
      </div>
      <button class="default-button">会員登録する</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';

const hostName = 'localhost:3000';

export default {
  data() {
    return {
      userName: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      errorMessages: []
    }
  },
  methods: {
    signUp: function(){
      axios.post(
        `http://${hostName}/api/auth`,
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
            email:  response.data.data.email,
            token:  response.headers['access-token'],
            uid:    response.headers['uid'],
            client: response.headers['client'],
            instructor_flg: response.data.data.instructor_flg,
          }
        );
        this.$router.push({
          name: "Top"
        })
      })
      .catch((error) => {
        if (error.response) {
          this.errorMessages = error.response.data.errors.full_messages;
        }
      });
    }
  }
}
</script>

<style scoped lang="scss">

</style>