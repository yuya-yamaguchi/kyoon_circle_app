<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar :select-menu-prop="6"/>
    </div>
    <div class="double-container--right">
      <div class="tabs">
        <div class="tabs--tab"
             :class="{ active: currentTab === 1 }"
             @click="changeTab(1)">
          宿泊予約
        </div>
        <div class="tabs--tab"
             :class="{ active: currentTab === 2 }"
             @click="changeTab(2)">
          過去の予約履歴
        </div>
      </div>
      <div v-show="currentTab === 1" class="studio-reserves">
        <StayroomReserveList v-if="futureReserves.length!=0" :reserves-prop="futureReserves" :cancel-flg-prop="true"/>
        <p v-else class="nothing-msg">現在、宿泊予約はありません</p>
      </div>
      <div v-show="currentTab === 2" class="studio-reserves">
        <StayroomReserveList v-if="historyReserves.length!=0" :reserves-prop="historyReserves" :cancel-flg-prop="false"/>
        <p v-else class="nothing-msg">過去の宿泊はありません</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/organisms/common/SideBar.vue";
import StayroomReserveList from "@/components/organisms/stayroom/StayroomReserveList.vue";
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [errorMethods],
  components: {
    SideBar,
    StayroomReserveList
  },
  data() {
    return {
      futureReserves: [],
      historyReserves: [],
      currentTab: 1, // 1:スタジオ予約タブ、2:予約履歴タブ
    }
  },
  methods: {
    // ユーザのスタジオ予約状況の取得
    getStudioReserves: function() {
      axios.get(
        `http://${g.hostName}/api/mypage/stayroom_reserves`,
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
      });
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