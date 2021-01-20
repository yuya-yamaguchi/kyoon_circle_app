<template>
  <div>
    <transition name="fade-default" appear>
      <ConfirmModal v-show="modalFlg"
        :modal-msg-prop="modalMsgProp"
        @process-confirm="postNews"/>
    </transition>
    <form v-on:submit.prevent="displayConfirm()">
      <div class="form-item">
        <p class="form-item--name">タイトル</p>
        <input type="text" v-model="news.title" placeholder="" class="default-input" @blur="newsTitleChk()" @keyup="newsTitleChk()">
        <p class="form-item--err-msg">{{ errMsg. title }}</p>
      </div>
      <div class="form-item">
        <p class="form-item--name">内容</p>
        <textarea v-model="news.details" @blur="newsDetailsChk()" @keyup="newsDetailsChk()"></textarea>
        <p class="form-item--err-msg">{{ errMsg.details }}</p>
      </div>
      <div class="form-item" v-if="displayLinePush()">
        <p class="form-item--name">グループLINEへの通知</p>
        <p class="form-item--addition">※現在は開発用に作成したグループに通知されます</p>
        <input type="checkbox" id="lineMsgFlg" class="checkbox" v-model="news.line_msg_push">
        <label for="lineMsgFlg">通知する</label>
      </div>
      <button class="default-button">{{ modalMsgProp.btn }}</button>
    </form>
  </div>
</template>

<script>
import ConfirmModal from "@/components/ConfirmModal.vue";
import { commonCheck } from '@/mixins/commonCheck';

export default {
  mixins: [commonCheck],
  components: {
    ConfirmModal
  },
  props: {
    newsProp: {},
    modalMsgProp: {}
  },
  data() {
    return {
      news: this.newsProp,
      modalFlg: false,
      errMsg: {
        title: "",
        details: ""
      }
    }
  },
  methods: {
    displayConfirm: function() {
      this.newsTitleChk();
      this.newsDetailsChk();
      this.displayLinePush();
      // エラーがある場合、確認モーダルを表示しない
      for (var key in this.errMsg) {
        if (this.errMsg[key] != "") {
          return
        }
      }
      this.modalFlg = true
    },
    postNews: function(confirm) {
      this.modalFlg = false;
      if (confirm) {
        this.$emit('post-news', this.news);
      }
    },
    newsTitleChk: function() {
      this.errMsg.title = this.formStrChk(this.news.title, 40);
    },
    newsDetailsChk: function() {
      this.errMsg.details = this.formStrChk(this.news.details, 1000);
    },
    displayLinePush: function() {
      if (location.pathname == '/news/new') {
        return true
      }
      return false
    }
  }
}
</script>

<style scoped lang="scss">
</style>