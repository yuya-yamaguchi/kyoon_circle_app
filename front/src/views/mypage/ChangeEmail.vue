<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="7"/>
      </div>
      <div class="double-container--right">
        <div class="change-email-container">
          <h1 class="main-title text-center">メールアドレス変更</h1>
          <form v-on:submit.prevent="putEmail" class="change-email-form">
            <div class="form-item">
              <p class="form-item--name">メールアドレス</p>
              <input type="text" v-model="user.email" class="default-input">
              <p class="form-item--err-msg">{{ errMsg.email }}</p>
            </div>
            <button class="default-button">変更する</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import BreadCrumbs from "@/components/organisms/common/BreadCrumbs.vue";
import SideBar from "@/components/organisms/common/SideBar.vue";
import { userValidates } from '@/mixins/userValidates';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [userValidates, errorMethods],
  components: {
    BreadCrumbs,
    SideBar
  },
  computed: {
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: 'マイページ',
          path: '/mypage'
        },
        { name: '設定',
          path: '/mypage/settings'
        },
        { name: 'メールアドレス変更',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  data() {
    return {
      user: {},
      errMsg: {}
    }
  },
  methods: {
    getEmail: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/${this.$store.getters['user/id']}`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.user = response.data.user
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false;
      });
    },
    putEmail: function() {
      if(this.changeEmailValid()) {
        axios.put(
          `http://${g.hostName}/api/users/${this.$store.getters['user/id']}`,
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
          this.$store.dispatch(
            "flash/create",
            { message: "メールアドレスを変更しました",
              type:    1
            }
          );
          this.$router.push({ 
            name: "Settings"
          })
        })
        .catch((error) => {
          this.apiErrors(error.response);
        });
      }
    },
    changeEmailValid: function() {
      this.errMsg.email = this.userEmailValid(this.user.email)
      for (var key in this.errMsg) {
        if (this.errMsg[key] != "") {
          return false
        }
      }
      return true
    }
  },
  mounted() {
    this.getEmail();
  }
}
</script>

<style scoped lang="scss">
.change-email-container {
  margin-bottom: 30px;
  .change-email-form {
    max-width: 400px;
    margin: 30px auto;
  }
}
</style>