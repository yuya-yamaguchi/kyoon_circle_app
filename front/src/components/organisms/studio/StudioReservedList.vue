<template>
  <div>
    <ConfirmModal v-show="cancelFlg"
      :modal-msg-prop="modalMsg"
      :is-processing-prop="isCanceling"
      @process-confirm="cancelStudioReserve"/>
    <StudioReserveUpdateModal v-if="updateReserve!=''"
      :click-reserve-prop="updateReserve"
      @update-success="updateSuccess"
      @close-modal="closeUpdateModal"
      />
    <div v-for="(reserve, i) in reserves" :key="i">
      <transition name="fade-default" :key="i">
        <div class="reserve">
          <div class="reserve--top">
            {{ formatDate(reserve.date, 'M月D日') }}
            ({{ calcWeek(reserve.date, 1) }})
            {{ formatDate(reserve.start_time, 'HH24:MI') }} 〜
            {{ formatDate(reserve.end_time, 'HH24:MI') }}
          </div>
          <div class="reserve--info">
            <div class="reserve--info--left">
              <div class="reserve--info--left--detail">
                人数 {{ reserve.users_num }}人
              </div>
              <div class="reserve--info--left--detail">
                料金 ¥{{ reserve.fee }}
              </div>
            </div>
            <div class="reserve--info--right">
              <div>
                <a v-if="cancelFlgProp" @click="displayUpdateModal(reserve, i)" class="reserve--info--right--cancel">
                  <fa icon="redo-alt"/>
                  <span>変更</span>
                </a>
                <a v-if="cancelFlgProp" @click="displayCancelModal(reserve, i)" class="reserve--info--right--cancel">
                  <fa icon="trash"/>
                  <span>取消</span>
                </a>
              </div>
            </div>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import ConfirmModal from "@/components/organisms/common/ConfirmModal.vue";
import StudioReserveUpdateModal from '@/components/organisms/studio/StudioReserveUpdateModal.vue';
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    ConfirmModal,
    StudioReserveUpdateModal
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
      updateReserve: "",
      updateFlg: false,
      updateNo: 0,
      modalMsg: {
        title: "スタジオ予約取消",
        message: "スタジオの予約を取り消します。よろしいですか？",
        btn: "取消"
      },
      isCanceling: false
    }
  },
  methods: {
    // キャンセルモーダルの表示
    displayCancelModal: function(reserve , i) {
      this.cancelFlg = true;
      this.selectedReserve = reserve;
      this.removeNo = i;
    },
    // 変更モーダルの表示
    displayUpdateModal: function(reserve, i) {
      this.updateReserve = reserve;
      this.updateNo = i;
      this.updateReserve.hour = Number(reserve.start_time.substr(11, 2));
      this.updateReserve.minutes = reserve.start_time.substr(14, 2);
      this.updateReserve.end_hour = Number(reserve.end_time.substr(11, 2));
      this.updateReserve.end_minutes = reserve.end_time.substr(14, 2);
      this.updateFlg = true;
    },
    // キャンセル処理の実行
    cancelStudioReserve(cancelConfirmFlg) {
      if (cancelConfirmFlg) {
        if (!this.isCanceling) {
          this.isCanceling = true;
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
              { message: error.response.data[0],
                type:    2
              }
            );
            this.apiErrors(error.response);
          })
          .finally(() => {
            this.isCanceling = false;
            this.cancelFlg = false;
          });
        }
      } else {
        this.cancelFlg = false;
      }
    },
    updateSuccess(updateReserve) {
      this.updateFlg = false;
      this.reserves[this.updateNo] = updateReserve;
      this.updateReserve = "";
    },
    // 変更モーダルを閉じる
    closeUpdateModal() {
      this.updateFlg = false;
      this.updateReserve = "";
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
  background: #FFF;
  font-size: 0.8rem;
  &--top {
    background: #888;
    color: #FFF;
    font-size: 1.1rem;
    font-weight: bold;
    padding: 2px 5px;
  }
  &--info {
    padding: 5px 10px;
    display: flex;
    justify-content: space-between;
    &--left {
      &--detail {
        margin: 5px;
      }
    }
    &--right {
      display: flex;
      align-items: center;
      &--cancel {
        display: block;
        color:  #888;
        margin: 5px 0;
        font-size: 0.8rem;
        font-weight: bold;
        display: flex;
        align-items: center;
        cursor: pointer;
        svg {
          width: 14px;
          margin-right: 10px;
        }
      }
    }
  }
}
</style>