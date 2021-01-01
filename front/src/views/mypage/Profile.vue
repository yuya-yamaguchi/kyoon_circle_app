<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar/>
    </div>
    <div class="double-container--right">
      <form v-on:submit.prevent="updateProfile">
        <div class="form-item">
          <p>
            ユーザ名
          </p>
          <input type="text" v-model="user.name">
        </div>
        <div>
          <div class="form-item">
            <p>
              プロフィール
            </p>
            <textarea v-model="user.profile"></textarea>
          </div>
        </div>
        <button class="default-button">変更する</button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import SideBar from "@/components/SideBar.vue";

const hostName = 'localhost:3000';

export default {
  components: {
    SideBar
  },
  data() {
    return {
      user: {}
    }
  },
  methods: {
    // プロフィール情報の取得
    getProfile: function() {
      axios.get(
        `http://${hostName}/api/mypage/${this.$store.getters['user/id']}`
      )
      .then((response) => {
        this.user   = response.data
      })
      .catch(function(error) {
        console.log(error);
      });
    },
    // プロフィールの更新
    updateProfile: function() {
      axios.put(
        `http://${hostName}/api/mypage/${this.$store.getters.['user/id']}`,
        {
          user: {
            name:    this.user.name,
            profile: this.user.profile
          }
        }
      )
      .then((response) => {
        this.$store.dispatch(
          "user/changeUserProfile",
          {
            name: response.data.name
          }
        );
        this.$router.push({ 
          name: "MypageTop"
        })
      })
      .catch(function(error) {
        console.log(error);
      });
    }
  },
  mounted: function() {
    this.getProfile();
  }
}
</script>

<style lang="scss" scoped>
</style>