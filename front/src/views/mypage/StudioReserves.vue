<template>
  <div class="double-container">
    <div class="double-container--left">
      <SideBar/>
    </div>
    <div class="double-container--right">
      <div class="reserve-tabs">
        <div class="reserve-tabs--tab"
             :class="{ active: currentTab === 1 }"
             @click="changeTab(1)">
          スタジオ予約
        </div>
        <div class="reserve-tabs--tab"
             :class="{ active: currentTab === 2 }"
             @click="changeTab(2)">
          過去の予約履歴
        </div>
      </div>
      <div v-show="currentTab === 1" class="studio-reserves">
        <tr v-for="(futureReserve, i) in futureReserves" :key="i" class="reserve">
          <div class="reserve--info">
            <td>{{ formatDate(futureReserve.date) }}</td>
            <td>{{ formatTime(futureReserve.start_time) }} 〜
                {{ formatTime(futureReserve.end_time) }}
            </td>
            <td>{{ futureReserve.payment_fee }}円</td>
          </div>
          <div @click="cancelStudioReserve(futureReserve)" class="reserve--cancel">取消</div>
        </tr>
      </div>
      <div v-show="currentTab === 2" class="studio-reserves">
        <div v-for="(historyReserve, i) in historyReserves" :key="i" class="studio-reserves--reserve">
          {{ formatDate(historyReserve.date) }}
          {{ formatTime(historyReserve.start_time) }} 〜
          {{ formatTime(historyReserve.end_time) }}
        </div>
      </div>
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
      futureReserves: [],
      historyReserves: [],
      currentTab: 1
    }
  },
  methods: {
    // プロフィール情報の取得
    getStudioReserves: function() {
      axios.get(
        `http://${hostName}/api/mypage/studio_reserves`,
        {
          params: {
            user_id: this.$store.getters['user/id']
          }
        }
      )
      .then((response) => {
        this.futureReserves  = response.data.future_reserves
        this.historyReserves = response.data.history_reserves
      })
      .catch(function(error) {
        console.log(error);
      });
    },
    cancelStudioReserve: function(reserve) {
      axios.delete(
        `http://${hostName}/api/studios/${reserve.studio_id}/reserves/${reserve.id}`
      )
      .then(() => {
        this.getStudioReserves();
      })
      .catch(function(error) {
        console.log(error);
      });
    },
    formatDate: function(date) {
      return date.substr(0, 4) + "年" + date.substr(5, 2) + "月" + date.substr(8, 2) + "日"
    },
    formatTime: function(time) {
      var padding_time = ( '0000' + time ).slice( -4 )
      return Number(padding_time.substr(0, 2)) + "：" + padding_time.substr(2, 2)
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
.reserve-tabs {
  display: flex;
  justify-content: space-between;
  &--tab {
    width: 50%;
    padding: 10px;
    background: #888;
    color: #FFF;
    font-weight: bold;
    text-align: center;
    cursor: pointer;
  }
  &--tab.active {
    background: #FFF;
    color: #333;
    border-top: 2px solid #13b1c0;
  }
}

.studio-reserves {
  background: #FFF;
  padding: 10px;
  .reserve {
    margin: 15px 5px;
    display: flex;
    justify-content: space-between;
    &--info {
      td {
        display: inline-block;
        margin: 0 10px;
      }
    }
    &--cancel {
      background: red;
      border-radius: 5px;
      padding: 2px 10px;
      color: #FFF;
      font-size: 14px;
      font-weight: bold;
      cursor: pointer;
    }
  }
}
</style>