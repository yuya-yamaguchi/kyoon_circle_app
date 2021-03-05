<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="1"/>
      </div>
      <div class="double-container--right">
        <UserInfo
          v-if="!loading"
          :user-prop="user"
          :userInstrumentsProp="userInstruments"
          :loading="loading"/>
        <div class="mypage-menus">
          <div class="mypage-menus--block">
            <Menus :menus="myMenus"/>
          </div>
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
import UserInfo from "@/components/organisms/user/UserInfo.vue";
import Menus from "@/components/molecules/common/Menus.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    BreadCrumbs,
    SideBar,
    UserInfo,
    Menus
  },
  computed: {
    myMenus() {
      const menus = [
        { name: "スタジオ予約確認",
          path: "/mypage/studio/reserves",
          icon: "check-circle"
        },
        { name: "参加イベント一覧",
          path: "/mypage/events",
          icon: "calendar-check"
        },
        { name: "宿泊予約確認",
          path: "/mypage/stayrooms",
          icon: "procedures"
        },
        { name: "設定",
          path: "/mypage/settings",
          icon: "cog"
        }
      ]
      return menus
    },
    breadCrumbs() {
      const breadCrumbsLists = [
        { name: 'トップ',
          path: '/'
        },
        { name: 'マイページ',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  data() {
    return {
      user: "",
      userInstruments: [],
      loading: true
    }
  },
  methods: {
    getMypageInfo: function() {
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
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false;
      });
    }
  },
  mounted() {
    this.getMypageInfo();
  }
}
</script>

<style scoped lang="scss">
.mypage-menus {
  margin: 50px auto;
  max-width: 500px;
  &--block {
    margin-bottom: 20px;
  }
}
</style>