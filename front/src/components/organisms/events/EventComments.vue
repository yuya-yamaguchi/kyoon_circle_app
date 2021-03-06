<template>
  <div>
    <Loading v-if="loading"/>
    <div v-else class="event-comments">
      <template v-if="$store.getters['user/id']!=0">
        <CommentTextarea :comment-prop="''" @doen-comment="postEventComment"/>
      </template>
      <div class="event-comments--display">
        <div v-for="(comment, i) in eventComments" :key="i" class="comment-card">
          <div class="comment-card--left">
            <router-link :to="{name: 'UserShow', params: { id: comment.user_id }}" class="comment-userimg">
              <UserAvatar :avatar-prop="comment.user_avatar"/>
            </router-link>
          </div>
          <div class="comment-card--right">
            <div class="comment-info">
              <router-link :to="{name: 'UserShow', params: { id: comment.user_id }}" class="comment-info--username">
                {{ comment.user_name }}
              </router-link>
              <div class="comment-info--time">{{ howManyAgo(comment.created_at) }}</div>
            </div>
            <p v-if="eventComments[i].text" class="comment-text">{{ comment.text }}</p>
            <div v-else class="comment-edit">
              <CommentTextarea :comment-prop="editComment.text" @doen-comment="putEventComment"/>
            </div>
          </div>
          <div v-if="$store.getters['user/id']==comment.user_id && eventComments[i].text" class="comment-card--btns">
            <div @click="editEventComment(i)" class="comment-card--btns--edit some-updown-center">
              <fa icon="edit" class="default-icon"></fa>
              <span>編集</span>
            </div>
            <div @click="deleteEventComment(comment.id, i)" class="comment-card--btns--delete some-updown-center">
              <fa icon="trash" class="default-icon"></fa>
              <span>削除</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import Loading from '@/components/organisms/common/Loading.vue';
import CommentTextarea from "@/components/molecules/common/CommentTextarea.vue";
import UserAvatar from "@/components/atoms/UserAvatar.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

CommentTextarea

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    Loading,
    CommentTextarea,
    UserAvatar
  },
  data() {
    return {
      eventComment: {
        text: ""
      },
      eventComments: [],
      editComment: {
        id:   0,
        text: "",
        i:    0 // 配列番号
      },
      loading: true
    }
  },
  watch: {
    textareaComment() {
      this.adjustHeight();
    }
  },
  methods: {
    getEventCommnts: function() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.id}/comments`
      )
      .then((response) => {
        this.eventComments = response.data;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      })
      .finally(() => {
        this.loading = false;
      });
    },
    postEventComment: function(textareaComment) {
      if (!textareaComment) return
      this.eventComment.text = textareaComment;
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/comments`,
        {
          user_id: this.$store.getters['user/id'],
          event_comment: this.eventComment
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.eventComments.unshift(response.data);
        // 他コメント編集中の状態で新規コメントを行った場合、配列がずれるため、編集中コメントの添字を更新
        this.editComment.i += 1;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });
    },
    editEventComment: function(i) {
      // 前回のコメントがエスケープされている場合、元の配列に戻す
      // コメントを編集している状態から他の編集ボタンを押下した際の考慮
      if (this.editComment.text) {
        this.eventComments[this.editComment.i].text = this.editComment.text;
      }
      this.editComment.text = this.eventComments[i].text;
      this.editComment.id   = this.eventComments[i].id;
      this.editComment.i    = i;
      this.eventComments[i].text = "";
    },
    putEventComment: function(updateComment) {
      // コメントが変更されている場合、更新する
      if (updateComment && updateComment != this.editComment.text) {
        axios.put(
          `http://${g.hostName}/api/events/${this.$route.params.id}/comments/${this.editComment.id}`,
          {
            user_id: this.$store.getters['user/id'],
            event_comment: { text: updateComment}
          },
          {
            headers: {
              Authorization: this.$store.getters['user/secureToken']
            }
          }
        )
        .then(() => {
          this.editComment.text = "";
          this.eventComments[this.editComment.i].text = updateComment;
        })
        .catch((error) => {
          this.apiErrors(error.response);
        });
      }
      // キャンセルの場合
      else {
        this.eventComments[this.editComment.i].text = this.editComment.text;
      }
    },
    deleteEventComment(id, i) {
      axios.delete(
        `http://${g.hostName}/api/events/${this.$route.params.id}/comments/${id}`,
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then(() => {
        this.eventComments.splice(i, 1);
        // 編集中のコメントがある状態で、削除が行われた場合、
        // 配列がずれるため、添字を更新する
        if (i < this.editComment.i) this.editComment.i -= 1;
      })
      .catch((error) => {
        this.apiErrors(error.response);
      });

    },
    adjustHeight: function(){
      const textarea = this.$refs.adjustTextarea
      const resetHeight = new Promise(function(resolve) {
        resolve(textarea.style.height = '28px')
      });
      resetHeight.then(function(){
        textarea.style.height = textarea.scrollHeight + 'px'
      });
    }
  },
  mounted() {
    this.getEventCommnts();
  }
}
</script>

<style scoped lang="scss">
.event-comments {
  margin: 30px 20px;
  &--display {
    margin-top: 30px;
    .comment-card {
      margin-bottom: 30px;
      display: flex;
      justify-content: flex-start;
      &--left {
        .comment-userimg {
          display: block;
          width: 45px;
          height: 45px;
        }
      }
      &--right {
        width: 100%;
        margin-left: 10px;
        .comment-info {
          display: flex;
          justify-content: flex-start;
          font-size: 0.9rem;
          &--username {
            margin-right: 10px;
            color: #333;
          }
          &--time {
            font-size: 0.8rem;
            color: #888;
            
          }
        }
        .comment-text {
          background: #FFF;
          border-radius: 7px;
          padding: 5px 10px;
          white-space: pre-wrap;
          word-break:break-all;
          display: inline-block;
        }
        .comment-edit {
          width: 100%;
        }
      }
      &--btns {
        margin-left: auto;
        margin-top: 20px;
        padding-left: 20px;
        white-space: nowrap;
        font-size: 0.8rem;
        div {
          margin-bottom: 3px;
          cursor: pointer;
          svg {
            width: 12px;
            margin-right: 2px;
          }
        }
      }
    }
  }
}
</style>