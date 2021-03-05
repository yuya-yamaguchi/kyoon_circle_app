<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="double-container">
      <div class="double-container--left">
        <SideBar :select-menu-prop="3"/>
      </div>
      <div class="double-container--right">
        <div class="tabs">
          <div class="tabs--tab"
              :class="{ active: currentTab === 1 }"
              @click="changeTab(1)">
            スタジオ予約
          </div>
          <div class="tabs--tab"
              :class="{ active: currentTab === 2 }"
              @click="changeTab(2)">
            過去の予約履歴
          </div>
        </div>
        <Loading v-if="loading"/>
        <div v-else>
          <div v-show="currentTab === 1" class="studio-reserves">
            <StudioReservedList v-if="futureReserves.length!=0" :reserves-prop="futureReserves" :cancel-flg-prop="true"/>
            <p v-else class="nothing-msg">予約中のスタジオはありません</p>
          </div>
          <div v-show="currentTab === 2" class="studio-reserves">
            <StudioReservedList v-if="historyReserves.length!=0" :reserves-prop="historyReserves" :cancel-flg-prop="false"/>
            <p v-else class="nothing-msg">過去に予約したスタジオはありません</p>
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
import StudioReservedList from "@/components/organisms/studio/StudioReservedList.vue";
import Loading from '@/components/organisms/common/Loading.vue';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    BreadCrumbs,
    SideBar,
    StudioReservedList,
    Loading
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
        { name: 'スタジオ予約確認',
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  data() {
    return {
      futureReserves: [],
      historyReserves: [],
      currentTab: 1, // 1:スタジオ予約タブ、2:予約履歴タブ
      loading: true
    }
  },
  methods: {
    // ユーザのスタジオ予約状況の取得
    getStudioReserves: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/studio_reserves`,
        {
          params: {
            user_id: this.$store.getters['user/id']
          },
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.futureReserves  = response.data.future_reserves
        this.historyReserves = response.data.history_reserves
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false
      })
    },
    changeTab: function(num) {
      this.currentTab = num
    }
  },
  mounted: function() {
    this.getStudioReserves();
  }
}
</script>

<style lang="scss" scoped>
.studio-reserves {
  padding: 10px;
}
</style>