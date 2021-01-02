<template>
  <header>
    <router-link to="/" class="main-title">京音</router-link>
    <div class="header-menus">
      <div class="header-menus">
        <router-link to="/events" class="header-menu">イベント一覧</router-link>
        <router-link to="/studios/1" class="header-menu">スタジオ予約</router-link>
        <a class="header-menu">宿泊予約</a>
      </div>
      <template v-if='!$store.getters["user/id"]'>
        <router-link to="/signup" class="sign-btn">新規会員登録</router-link>
        <router-link to="/login" class="sign-btn">ログイン</router-link>
        <a @click="testLogin" class="sign-btn">テストログイン</a>
      </template>
      <template v-else class="header-menus">
        <router-link to="/mypage" class="header-menu">{{ $store.getters["user/name"] }}</router-link>
        <button type="submit" @click="logout()" class="sign-btn">ログアウト</button>
      </template>
    </div>
  </header>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";

export default {
  methods: {
    logout: function() {
      console.log(this.$store.getters['user/uid']);
      // API側にてログアウトを行う
      axios.delete(
        `http://${g.hostName}/api/auth/sign_out`,
        {
          data: {
            "uid":          this.$store.getters['user/uid'],
            "access-token": this.$store.getters['user/token'],
            "client":       this.$store.getters['user/client']
          }
        }
      )
      .then((response) => {
        console.log(response);
        // FRONT側のユーザ情報を削除
        this.$store.dispatch("user/logout");
        this.$router.push({
          name: "Top"
        })
      })
      .catch(function(error) {
        console.log(error);
      });
    },
    testLogin: function(){
      axios.post(`http://${g.hostName}/api/auth/sign_in`,
        {
          email: 'a@gmail.com',
          password: '12345678'
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

<style scoped lang="scss">
header{
  width: 100%;
  height: 60px;
  background: #333;
  display: flex;
  justify-content: space-between;
  color: #FFF;
  .main-title {
    text-align: left;
    line-height: 60px;
    padding: 0 20px;
    color: #FFF;
    font-size: 30px;
    text-decoration: none;
  }
  .header-menus {
    margin-right: 30px;
    display: flex;
    justify-content: flex-end;
    .header-menu {
      text-decoration: none;
      color: #FFF;
      line-height: 60px;
      margin: 0 20px;
      font-weight: bold;
      position: relative;
      cursor: pointer;
      &::after {
        position: absolute;
        bottom: 15px;
        left: 0;
        content: '';
        width: 100%;
        height: 2px;
        background: #FFF;
        transform: scale(0, 1);
        transform-origin: center top;
        transition: transform .2s;
      }
      &:hover:after {
        transform: scale(1, 1);
      }
    }
    
    .sign-btn {
      display: block;
      text-decoration: none;
      color:#FFF;
      font-size: 12px;
      font-weight: bold;
      background: linear-gradient(70deg, rgb(85, 85, 236), #13b1c0);
      border: 1px solid;
      margin: 0 10px;
      margin-top: 15px;
      padding: 0 10px;
      border-radius: 5px;
      height: 30px;
      line-height: 30px;
      cursor: pointer;
    }
  }
}
</style>
