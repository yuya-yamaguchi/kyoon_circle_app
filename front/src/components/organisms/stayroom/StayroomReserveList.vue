<template>
  <div>
    <ConfirmModal v-show="cancelFlg"
      :modal-msg-prop="modalMsg"
      @process-confirm="deleteStayroomReserve"/>
    <div v-for="(reserve, i) in reserves" :key="i">
      <transition name="fade-default" :key="i">
        <div class="reserve">
          <table class="reserve--left">
            <tr class="reserve--left--roomname">
              <th>部屋名</th>
              <td>{{ reserve.name }}</td>
            </tr>
            <tr class="reserve--left--checkin">
              <th>チェックイン</th>
              <td>{{ formatDate(reserve.checkin_date, 'YYYY年M月D日') }}</td>
            </tr>
            <tr class="reserve--left--checkout">
              <th>チェックアウト</th>
              <td>{{ formatDate(reserve.checkout_date, 'YYYY年M月D日') }}</td>
            </tr>
            <tr class="reserve--left--fee">
              <th>料金</th>
              <td>{{ reserve.fee }}円</td>
            </tr>
          </table>
          <a v-if="cancelFlgProp" @click="displayCancelModal(reserve, i)" class="reserve--cancel">
            <fa icon="trash"/>
            <span>取消</span>
          </a>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import ConfirmModal from "@/components/organisms/common/ConfirmModal.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    ConfirmModal
  },
  props: {
    reservesProp: {},
    cancelFlgProp: {}
  },
  data() {
    return {
      reserves: this.reservesProp,
      selecteReserve: "",
      cancelFlg: false,
      removeNo: 0,
      modalMsg: {
        title: "宿泊予約取消",
        message: "宿泊の予約を取り消します。よろしいですか？",
        btn: "取消"
      }
    }
  },
  methods: {
    // キャンセルモーダルの表示
    displayCancelModal: function(reserve , i) {
      this.cancelFlg = true;
      this.selecteReserve = reserve;
      this.removeNo = i;
    },
    // キャンセル処理の実行
    deleteStayroomReserve(cancelConfirmFlg) {
      this.cancelFlg = false;
      if (cancelConfirmFlg) {
        axios.delete(
          `http://${g.hostName}/api/stayrooms/${this.selecteReserve.stayroom_id}/reserves/${this.selecteReserve.id}`,
          {
            headers: {
              Authorization: this.$store.getters['user/secureToken']
            }
          }
        )
        .then(() => {
          this.reserves.splice(this.removeNo, 1)
          this.$store.dispatch(
            "flash/create",
            { message: "取消が完了しました",
              type:    1
            }
          );
        })
        .catch((error) => {
          this.$store.dispatch(
            "flash/create",
            { message: error.response.data,
              type:    2
            }
          );
          this.apiErrors(error.response);
        });
      }
    }
  },
  updated() {
    this.reserves = this.reservesProp
  }
}
</script>

<style scoped lang="scss">
.reserve {
  box-shadow:  2px 2px 0 0 rgba(0,0,0,0.3);
  margin: 15px 5px;
  display: flex;
  justify-content: space-between;
  border-radius: 10px;
  background: #FFF;
  &--left {
    display: block;
    padding: 10px;
    tr {
      font-size: 0.8rem;
      th {
        min-width: 120px;
      }
    }
  }
  &--cancel {
    display: block;
    color:  red;
    font-size: 0.8rem;
    font-weight: bold;
    padding: 10px;
    display: flex;
    align-items: center;
    cursor: pointer;
    svg {
      width: 14px;
      margin-right: 10px;
    }
  }
}
</style>