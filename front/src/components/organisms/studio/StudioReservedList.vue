<template>
  <div>
    <ConfirmModal v-show="cancelFlg"
      :modal-msg-prop="modalMsg"
      @process-confirm="cancelStudioReserve"/>
    <div v-for="(reserve, i) in reserves" :key="i">
      <transition name="fade-default" :key="i">
        <div class="reserve">
          <div class="reserve--info">
            <div class="reserve--info--top">
              <div class="reserve--info--top--date">
                {{ formatDate(reserve.date, 'YYYY年M月D日') }}
              </div>
              <div class="reserve--info--top--time">
                {{ formatDate(reserve.start_time, 'HH24:MI') }} 〜
                {{ formatDate(reserve.end_time, 'HH24:MI') }}
              </div>
            </div>
            <p>{{ reserve.fee }}円</p>
          </div>
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
      selectedReserve: "",
      cancelFlg: false,
      removeNo: 0,
      modalMsg: {
        title: "スタジオ予約取消",
        message: "スタジオの予約を取り消します。よろしいですか？",
        btn: "取消"
      }
    }
  },
  methods: {
    // キャンセルモーダルの表示
    displayCancelModal: function(reserve , i) {
      this.cancelFlg = true;
      this.selectedReserve = reserve;
      this.removeNo = i;
    },
    // キャンセル処理の実行
    cancelStudioReserve(cancelConfirmFlg) {
      this.cancelFlg = false;
      if (cancelConfirmFlg) {
        axios.delete(
          `http://${g.hostName}/api/studios/${this.selectedReserve.studio_id}/reserves/${this.selectedReserve.id}`,
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
            { message: error.response.data.error_message,
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
  &--info {
    padding: 10px;
    &--top {
      display: flex;
      justify-content: flex-start;
      &--date {
        padding-right: 10px;
      }
    }
  }
  &--cancel {
    display: block;
    color:  red;
    font-size: 14px;
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