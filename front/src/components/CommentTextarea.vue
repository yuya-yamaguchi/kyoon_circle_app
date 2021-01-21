<template>
  <div class="comments">
    <form v-on:submit.prevent="sendComment()" class="comments--form">
      <textarea
        v-model="textareaComment"
        @keydown="textareaChange"
        ref="adjustTextarea"
        class="comments--form--textarea"
        placeholder="コメントを入力..."/>
      <div class="space-between">
        <div class="form-item--err-msg">
          {{ errMsg.text }}
        </div>
        <div class="comment-btns">
          <div class="comment-btns--cancel" @click="cancelComment()">キャンセル</div>
          <button
            :disabled="!textareaComment.match(/\S/g) || textareaComment.length > 200"
            :class="{ 'btn-disable': !textareaComment.match(/\S/g) || textareaComment.length > 200}"
            class="comment-btns--post">コメント</button>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
import { commonCheck } from '@/mixins/commonCheck';

export default {
  mixins: [commonCheck],
  props: {
    commentProp: {}
  },
  data() {
    return {
      textareaComment: this.commentProp,
      errMsg: {
        text: ""
      }
    }
  },
  watch: {
    textareaComment() {
      this.adjustHeight();
    }
  },
  methods: {
    sendComment: function() {
      this.$emit('doen-comment', this.textareaComment);
      this.textareaComment = "";
    },
    cancelComment: function() {
      this.$emit('doen-comment', "");
      this.textareaComment = ""
    },
    textareaChange: function(){
      this.adjustHeight();
      this.errMsg.text = this.formStrChk(this.textareaComment, 200, "01");
    },
    adjustHeight: function() {
      const textarea = this.$refs.adjustTextarea
      const resetHeight = new Promise(function(resolve) {
        resolve(textarea.style.height = '28px')
      });
      resetHeight.then(function(){
        textarea.style.height = textarea.scrollHeight + 'px'
      });
    }
  }
}
</script>

<style scoped lang="scss">
.comments {
  &--form {
    &--textarea {
      width: 100%;
      display: block;
      border: none;
      outline: none;
      border-bottom: 1px solid #888;
      height: 28px;
      background: var(--base-color);
      &:focus {
        border-bottom: 1px solid var(--accent-color);
      }
    }
    .comment-btns {
      display: flex;
      justify-content: flex-end;
      margin-top: 5px;
      color: #FFF;
      &--cancel {
        cursor: pointer;
        width: 90px;
        padding: 2px;
        text-align: center;
        background: #888;
        margin-right: 10px;
        font-size: 15px;
      }
      &--post {
        border: none;
        outline: none;
        font-size: 15px;
        color: #FFF;
        cursor: pointer;
        width: 90px;
        padding: 2px;
        text-align: center;
        background: #888;
        background: var(--accent-color);
      }
    }
  }
  .btn-disable {
    background: #888;
  }
}
</style>