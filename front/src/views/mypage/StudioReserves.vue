<template>
  <div class="double-container">
    <ConfirmModal v-show="cancelFlg"
      :modal-msg-prop="modalMsg"
      @process-confirm="cancelStudioReserve"/>
    <div class="double-container--left">
      <SideBar/>
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
      <div v-show="currentTab === 1" class="studio-reserves">
        <tr v-for="(futureReserve, i) in futureReserves" :key="i" class="reserve">
          <div class="reserve--info">
            <td>{{ formatDate(futureReserve.date) }}</td>
            <td>{{ formatTime(futureReserve.start_time) }} 〜
                {{ formatTime(futureReserve.end_time) }}
            </td>
            <td>{{ futureReserve.payment_fee }}円</td>
          </div>
          <div @click="displayCancelModal(futureReserve)" class="reserve--cancel">取消</div>
        </tr>
      </div>
      <div v-show="currentTab === 2" class="studio-reserves">
        <tr v-for="(historyReserve, i) in historyReserves" :key="i" class="reserve">
          <div class="reserve--info">
            <td>{{ formatDate(historyReserve.date) }}</td>
            <td>{{ formatTime(historyReserve.start_time) }} 〜
                {{ formatTime(historyReserve.end_time) }}
            </td>
            <td>{{ historyReserve.payment_fee }}円</td>
          </div>
        </tr>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";
import ConfirmModal from "@/components/ConfirmModal.vue";

export default {
  components: {
    SideBar,
    ConfirmModal
  },
  data() {
    return {
      futureReserves: [],
      historyReserves: [],
      selectedReserve: "",
      currentTab: 1, // 1:スタジオ予約タブ、2:予約履歴タブ
      cancelFlg: false,
      modalMsg: {
        title: "スタジオ予約取消",
        message: "スタジオの予約を取り消します。よろしいですか？",
        btn: "取消"
      }
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
    // キャンセルモーダルの表示
    displayCancelModal: function(reserve) {
      this.cancelFlg = true;
      this.selectedReserve = reserve;
    },
    // キャンセル処理の実行
    cancelStudioReserve(cancelConfirmFlg) {
      this.cancelFlg = false;
      if (cancelConfirmFlg) {
        axios.delete(
          `http://${g.hostName}/api/studios/${this.selectedReserve.studio_id}/reserves/${this.selectedReserve.id}`
        )
        .then(() => {
          this.getStudioReserves();
        })
        .catch(function(error) {
          console.log(error);
        });
      }
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