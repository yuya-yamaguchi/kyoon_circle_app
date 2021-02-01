<template>
  <div class="single-container">
    <div class="auth-container">
      <h1 class="main-title text-center">会員登録が完了しました！</h1>
      <p class="instruments-select">得意な楽器、やりたい楽器を選びましょう！</p>
      <div class="user-instruments">
        <UserInstrumentEdit
            v-if="userInstruments.length!=0"
            :userInstrumentsProp="userInstruments"
            @change-Instruments="changeUserInstruments"/>
      </div>
      <button @click="updateUser()" class="default-button">登録する</button>
      <div class="to-toppage">
        <router-link :to="{name: 'Top'}" >トップページへ</router-link>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import UserInstrumentEdit from "@/components/molecules/instruments/UserInstrumentEdit.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    UserInstrumentEdit
  },
  data() {
    return {
      user: {},
      userInstruments: [],
      loading: true
    }
  },
  methods: {
    getUser: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/${this.$store.getters['user/id']}`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.user = response.data.user,
        this.userInstruments = response.data.user_instruments
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
      .finally(() => {
        this.loading = false;
      });
    },
    updateUser: function() {
      axios.put(
        `http://${g.hostName}/api/mypage/${this.$store.getters['user/id']}`,
        {
          user: this.user
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.$router.push({ 
          name: "MypageTop"
        })
      })
      .catch((error) => {
        this.apiErrorMessages = error.response.data;
      });
    },
    changeUserInstruments: function(instrument_ids) {
      this.user.instrument_ids = instrument_ids
    }
  },
  mounted() {
    this.getUser()
  }
}
</script>

<style scoped lang="scss">
.instruments-select {
  text-align: center;
  margin: 30px 0 10px 0;
}
.user-instruments {
  display: flex;
  justify-content: space-between;
  margin: 5px 20px;
}
.to-toppage {
  text-align: center;
  margin: 0 auto;
  a{
    color: #333;
    font-weight: bold;
  }
}
</style>