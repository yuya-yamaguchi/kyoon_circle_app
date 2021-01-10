<template>
  <div>
    <ConfirmModal v-show="modalFlg"
      :modal-msg-prop="modalMsgProp"
      @process-confirm="postNews"/>
    <form v-on:submit.prevent="displayConfirm()">
      <div class="form-item">
        <p>タイトル</p>
        <input type="text" v-model="news.title" placeholder="イベント名" class="default-input">
      </div>
      <div class="form-item">
        <p>内容</p>
        <textarea v-model="news.details"></textarea>
      </div>
      <div class="form-item" v-if="displayLinePush()">
        <p>グループLINEへの通知</p>
        <input type="checkbox" id="lineMsgFlg" class="checkbox" v-model="news.line_msg_push">
        <label for="lineMsgFlg">通知する</label>
      </div>
      <button class="default-button">確認</button>
    </form>
  </div>
</template>

<script>
import ConfirmModal from "@/components/ConfirmModal.vue";

export default {
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
      modalFlg: false
    }
  },
  methods: {
    displayConfirm: function() {
      this.modalFlg = true;
    },
    postNews: function(confirm) {
      this.modalFlg = false;
      if (confirm) {
        this.$emit('post-news', this.news);
      }
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