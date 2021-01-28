<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="1"/>
    </div>
    <div class="double-container--right">
      <div class="my-page">
        <div class="my-page--top">
          <div class="my-page--top--img">
            <img src="/person.png">
          </div>
          <div class="my-page--top--name">
            <div class="my-page main-title">{{ user.name }}</div>
          </div>
        </div>
        <div class="my-page--profile">
          <router-link to="/mypage/edit" class="my-page--profile--edit some-updown-center">
            <fa icon="edit"></fa>
            <span>プロフィールを変更する</span>
          </router-link>
          <div class="my-page--profile--contents">{{ user.profile }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    SideBar
  },
  data() {
    return {
      user: ""
    }
  },
  methods: {
    getMypageInfo: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/${this.$store.getters['user/id']}`
      )
      .then((response) => {
        this.user = response.data
      })
      .catch(function(error) {
        this.apiErrors(error.response.status);
      });
    }
  },
  mounted() {
    this.getMypageInfo();
  }
}
</script>

<style scoped lang="scss">
.my-page {
  background: var(--base-color);
  &--top {
    position: relative;
    display: flex;
    justify-content: flex-start;
    z-index: 1;
    &--img {
      position: absolute;
      background: var(--base-color);
      border-radius: 100%;
      width: 120px;
      height: 120px;
      border-radius: 100%;
      z-index: 2;
      img {
        display: block;
        border: 1px solid;
        border-radius: 100%;
        width: 100px;
        margin: 10px;
        background: rgb(241, 209, 144);
      }
    }
    &--name {
      margin: 10px 0 0 140px;
    }
  }
  &--profile {
    background: #FFF;
    padding: 20px;
    margin-left: 30px;
    min-height: 300px;
    &--edit {
      display: block;
      text-align: right;
      font-size: 14px;
      font-weight: bold;
      text-decoration: none;
      color: #333;
      svg {
        width: 14px;
      }
      &:hover {
        color: var(--accent-color)
      }
    }
    &--contents {
      margin-top: 50px;
      font-size: 14px;
      box-sizing: border-box;
      background: #FFF;
      white-space: pre-wrap;
    }
  }
}
</style>