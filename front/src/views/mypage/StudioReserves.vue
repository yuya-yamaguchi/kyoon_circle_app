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
import { scrollable } from '@/mixins/scrollable';

export default {
  mixins: [errorMethods, scrollable],
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
      // スタジオ予約関連
      futureReserves: [],
      futurePage: 0,
      futureLastPage: 1,
      // スタジオ予約履歴関連
      historyReserves: [],
      historyPage: 0,
      historyLastPage: 1,
      currentTab: 1, // 1:スタジオ予約タブ、2:予約履歴タブ
      loading: true
    }
  },
  methods: {
    // ユーザのスタジオ予約状況の取得
    getFutureStudioReserves() {
      this.requesting = true
      axios.get(
        `http://${g.hostName}/api/mypage/future_studio_reserves`,
        {
          params: {
            user_id: this.$store.getters['user/id'],
            page: this.futurePage + 1
          },
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.futureReserves = this.futureReserves.concat(response.data.future_reserves)
        this.futurePage = response.data.pagy.page
        this.futureLastPage = response.data.pagy.last
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false
        this.requesting = false
      })
    },
    // ユーザのスタジオ予約履歴の取得
    getHistoryStudioReserves() {
      this.requesting = true
      axios.get(
        `http://${g.hostName}/api/mypage/history_studio_reserves`,
        {
          params: {
            user_id: this.$store.getters['user/id'],
            page: this.historyPage + 1
          },
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.historyReserves = this.historyReserves.concat(response.data.history_reserves)
        this.historyPage = response.data.pagy.page
        this.historyLastPage = response.data.pagy.last
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false
        this.requesting = false
      })
    },
    changeTab(tabNo) {
      if (this.currentTab === tabNo) { return }

      // 初回読込の時は読込中のCSSを出すため、loadingをTrueにする
      if (this.futurePage === 0 || this.historyPage === 0) { this.loading = true }
      this.currentTab = tabNo
      this.fetchNextPage()
    },
    fetchNextPage() {
      if (this.requesting) { return }
      
      if (this.currentTab === 1) {
        if (this.futureLastPage > this.futurePage) {
          this.getFutureStudioReserves()
        }
      } else {
        if (this.historyLastPage > this.historyPage) {
          this.getHistoryStudioReserves()
        }
      }
    },
  },
  mounted() {
    this.getFutureStudioReserves();
    document.addEventListener('scroll', this.handleScroll)
  },
  unmounted() {
    document.removeEventListener('scroll', this.handleScroll)
  }
}
</script>

<style lang="scss" scoped>
.studio-reserves {
  padding: 10px;
}
</style>