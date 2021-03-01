<template>
  <div>
    <ConfirmModal v-show="modalFlg"
      :modal-msg-prop="modalMsg"
      @process-confirm="updateStudio"/>
    <form v-on:submit.prevent="displayConfirmModal">
      <ErrMsg :error-messages-prop="apiErrorMessages"/>
      <div class="form-item">
        <p class="form-item--name">
          スタジオ名
        </p>
        <input type="text" v-model="studio.name" class="default-input" @blur="studioNameChk()" @keyup="studioNameChk()">
        <p class="form-item--err-msg">{{ errMsg.name }}</p>
      </div>
      <div>
        <div class="form-item">
          <p class="form-item--name">
            料金（1 Hour）
          </p>
          <input type="number" v-model="studio.fee"  class="default-input" @blur="studioFeeChk()" @keyup="studioFeeChk()">
          <p class="form-item--err-msg">{{ errMsg.fee }}</p>
        </div>
      </div>
      <button class="default-button">変更する</button>
    </form>
  </div>
</template>

<script>
import g from "@/variable/variable.js";
import axios from 'axios';
import ConfirmModal from "@/components/organisms/common/ConfirmModal.vue";
import ErrMsg from "@/components/organisms/common/ErrMsg.vue";
import { commonCheck } from '@/mixins/commonCheck';
import { errorMethods } from '@/mixins/errorMethods';

export default {
  mixins: [commonCheck, errorMethods],
  components: {
    ConfirmModal,
    ErrMsg
  },
  data() {
    return {
      studio: {},
      modalFlg: false,
      modalMsg: {
        title: "スタジオ内容の変更",
        message: "スタジオの登録内容変更を行います",
        btn: "変更"
      },
      errMsg: {
        name: "",
        fee: ""
      },
      apiErrorMessages: []
    }
  },
  methods: {
    // スタジオ情報の取得
    getStudio: function() {
      axios.get(
        `http://${g.hostName}/api/admin/studios/${this.$route.params.id}/edit`
      )
      .then((response) => {
        this.studio = response.data
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
    // 確認モーダル画面の表示
    displayConfirmModal: function() {
      this.modalFlg = true;
    },
    // スタジオ情報の更新
    updateStudio: function(confirm) {
      this.modalFlg = false;
      if (confirm) {
        axios.put(
          `http://${g.hostName}/api/admin/studios/${this.$route.params.id}`,
          {
            studio: {
              name: this.studio.name,
              fee:  this.studio.fee
            }
          }
        )
        .then(() => {
        })
        .catch((error) => {
          this.apiErrors(error.response);
          this.apiErrorMessages = error.response.data;
        });
      }
    },
    studioNameChk: function() {
      this.errMsg.name = this.formStrChk(this.studio.name, 20);
    },
    studioFeeChk: function() {
      this.errMsg.fee = this.formStrChk(this.studio.fee, 0, "10");
    }
  },
  mounted: function() {
    this.getStudio();
  }
}
</script>