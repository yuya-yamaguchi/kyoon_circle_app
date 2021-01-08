<template>
  <div class="double-container">
    <ConfirmModal v-show="modalFlg"
      :modal-msg-prop="modalMsg"
      @process-confirm="updateStudio"/>
    <div class="double-container--left">
      <SideBar :select-menu-prop="102"/>
    </div>
    <div class="double-container--right">
      <h1 class="main-title">スタジオ内容の変更</h1>
      <form v-on:submit.prevent="displayConfirmModal">
        <div class="form-item">
          <p>
            スタジオ名
          </p>
          <input type="text" v-model="studio.name" class="default-input">
        </div>
        <div>
          <div class="form-item">
            <p>
              料金（1 Hour）
            </p>
            <input type="number" v-model="studio.fee"  class="default-input">
          </div>
        </div>
        <button class="default-button">変更する</button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import SideBar from "@/components/SideBar.vue";
import ConfirmModal from "@/components/ConfirmModal.vue";

var studio_no = 1;

export default {
  components: {
    SideBar,
    ConfirmModal
  },
  data() {
    return {
      studio: {},
      modalFlg: false,
      modalMsg: {
        title: "スタジオ内容の変更",
        message: `スタジオの登録内容変更を行います`,
        btn: "変更"
      }
    }
  },
  methods: {
    // スタジオ情報の取得
    getStudio: function() {
      axios.get(
        `http://${g.hostName}/api/admin/studios/${studio_no}/edit`
      )
      .then((response) => {
        this.studio = response.data
      })
      .catch(function(error) {
        console.log(error);
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
          `http://${g.hostName}/api/admin/studios/${studio_no}`,
          {
            studio: {
              name: this.studio.name,
              fee:  this.studio.fee
            }
          }
        )
        .then(() => {
        })
        .catch(function(error) {
          console.log(error);
        });
      }
    }
  },
  mounted: function() {
    this.getStudio();
  }
}
</script>

<style lang="scss" scoped>
</style>