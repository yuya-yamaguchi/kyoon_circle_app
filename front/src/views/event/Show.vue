<template>
  <div>
    <BreadCrumbs :breadCrumbs="breadCrumbs"/>
    <div class="single-container">
      <Loading v-if="loading"/>
      <div v-else>
         <div class="space-between">
          <h1 class="main-title">{{ event.title }}</h1>
          <div v-show="$store.getters['user/adminType']>0">
            <router-link :to="`/event/${event.id}/edit`" class="edit-btn some-updown-center">
              <fa icon="edit"></fa>
              <span>編集する</span>
            </router-link>
            <a @click="displayConfirmModal" class="delete-btn some-updown-center">
              <fa icon="trash"></fa>
              <span>削除する</span>
            </a>
          </div>
        </div>
        <ConfirmModal v-show="modalFlg"
          :modal-msg-prop="modalMsg"
          @process-confirm="deleteEvent"/>
        <p v-show="entryFlg" class="entry-now-msg">このイベントに参加しています</p>
        <p v-if="isEventEnd()" class="cant-entry-msg">このイベントは終了しました</p>
        <p v-else-if="isOverCapacity()" class="cant-entry-msg">このイベントは定員に達しました</p>
        <div class="event-top-info">
          <div class="number-info">
            <p class="number-info--title">参加費</p>
            <p class="number-info--value">{{ event.fee }}</p>
          </div>
          <div class="number-info">
            <p class="number-info--title">参加人数</p>
            <p class="number-info--value">
              <span>{{ entryCnt }}人</span>
              <span v-show="event.max_entry>0"> / {{ event.max_entry }}人</span>
            </p>
          </div>
        </div>
        <div class="event-middle-info">開催日時 {{ fmtDate(event.start_datetime, 2) }}〜{{ fmtDate(event.end_datetime, 2) }}</div>
        <div class="event-middle-info">開催場所 {{ event.place }}</div>
        <div class="event-details">{{ event.details }}</div>
        <div class="event-comments">
          <form v-on:submit.prevent="displayConfirm()" class="event-comments--form">
            <textarea
              v-model="textareaVal"
              @keydown="adjustHeight"
              ref="adjustTextarea"
              class="event-comments--form--textarea"
              placeholder="コメントを入力..."/>
            <div class="comment-btns">
              <div class="comment-btns--cancel">キャンセル</div>
              <button class="comment-btns--post">コメント</button>
            </div>
          </form>
          <div class="event-comments--display">
            <div v-for="message in eventMessages" :key="message" class="message-card">
              <div class="message-card--left">
                <div class="message-userimg">
                  <img src="/person.png">
                </div>
              </div>
              <div class="message-card--right">
                <div class="message-info">
                  <div class="message-info--username">ユーザ名</div>
                  <div class="message-info--time">10分前</div>
                </div>
                <div class="message-text">{{ message.text }}</div>
              </div>
            </div>
          </div>
        </div>
        <div>
          <button v-if="!entryFlg"
                  @click="postEventEntry()"
                  class="default-button"
                  :disabled="cantEntry"
                  :class="{ 'btn-disable': cantEntry}">参加する
          </button>
          <button v-if="entryFlg"
                  @click="postCancelEventEntry()"
                  class="cancel-button"
                  :disabled="cantCancel"
                  :class="{ 'btn-disable': cantCancel}">参加をやめる
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import Loading from '@/components/Loading.vue';
import ConfirmModal from "@/components/ConfirmModal.vue";
import BreadCrumbs from "@/components/BreadCrumbs.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

var today = new Date();

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    Loading,
    ConfirmModal,
    BreadCrumbs
  },
  data() {
    return {
      event: "",
      entryFlg: false,
      entryCnt: 0,
      loading: true,
      modalFlg: false,
      cantEntry: false,
      cantCancel: false,
      eventMessage: {
        text: ""
      },
      eventMessages: [{text: "a"},{text: "b"}],
      modalMsg: {
        title: "イベントの取消",
        message: "イベントの取消を行います。<br>削除したイベントは元へは戻せません。よろしいですか？",
        btn: "削除"
      },
      textareaVal: ""
    }
  },
  watch: {
    textareaVal() {
      this.adjustHeight();
    }
  },
  computed: {
    breadCrumbs() {
      var breadCrumbsLists = [
        {
          name: 'トップ',
          path: '/'
        },
        {
          name: 'イベント一覧',
          path: '/events?page=1'
        },
        {
          name: this.event.title,
          path: ''
        }
      ]
      return breadCrumbsLists
    }
  },
  methods: {
    getEvent: function() {
      axios.get(
        `http://${g.hostName}/api/events/${this.$route.params.id}`,
        {
          params: {
            user_id: this.$store.getters['user/id']
          }
        }
      )
      .then((response) => {
        this.event = response.data.event;
        this.entryFlg = response.data.entry_flg;
        this.entryCnt = response.data.entry_cnt;
        this.loading = false;
      })
      .catch((error) => {
        this.loading = false;
        this.apiErrors(error.response.status);
      });
    },
    postEventEntry: function() {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/entry`,
        {
          user_id: this.$store.getters['user/id']
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.entryFlg = true;
        this.entryCnt = response.data;
      })
      .catch((error) => {
        if (error.response.status === 400 || error.response.status === 401) {
          this.$store.dispatch(
            "flash/create",
            { message: error.response.data.error_message,
              type:    2
            }
          );
          if (error.response.status === 401) {
            this.$router.push({ 
              name: "Login"
            })
          }
        }
        this.apiErrors(error.response.status);
      });
    },
    postCancelEventEntry: function() {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/entry_cancel`,
        {
          user_id: this.$store.getters['user/id']
        },
        {
          headers: {
            Authorization: this.$store.getters['user/secureToken']
          }
        }
      )
      .then((response) => {
        this.entryFlg = false;
        this.entryCnt = response.data;
      })
      .catch((error) => {
        if (error.response.status == 401) {
          this.$store.dispatch(
            "flash/create",
            { message: error.response.data.error_message,
              type:    2
            }
          );
          this.$router.push({ 
            name: "Login"
          })
        }
        this.apiErrors(error.response.status);
      });
    },
    deleteEvent: function(confirm) {
      this.modalFlg = false;
      if (confirm) {
        axios.delete(
          `http://${g.hostName}/api/events/${this.event.id}`,
          {
            headers: {
              Authorization: this.$store.getters['user/secureToken']
            }
          }
        )
        .then(() => {
          this.$store.dispatch(
            "flash/create",
            { message: "イベントを削除しました",
              type:    1
            }
          );
          this.$router.push({ 
            name: "EventEditList",
            query: {
              page: 1
            }
          })
        })
        .catch((error) => {
          this.apiErrors(error.response.status);
        });
      }
    },
    displayConfirmModal: function() {
      this.modalFlg = true;
    },
    isEventEnd: function()  {
      var start_date = new Date(this.event.start_datetime.substr(0, 4), 
                                Number(this.event.start_datetime.substr(5, 2)-1),
                                this.event.start_datetime.substr(8, 2), 23, 59, 59);
      if ( today > start_date ) {
        this.cantEntry = true
        this.cantCancel = true
        return true
      }
      return false
    },
    isOverCapacity: function() {
      if ( this.event.max_entry != 0 && 
           this.event.max_entry <= this.entryCnt ) {
        this.cantEntry = true
        return true
      }
      this.cantEntry = false
      return false
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
  mounted: function() {
    this.getEvent();
  }
}
</script>

<style scoped lang="scss">
.entry-now-msg {
  color: red;
  font-weight: bold;
  margin: 10px;
}
.cant-entry-msg {
  color: #888;
  font-weight: bold;
  margin: 10px;
}
.event-top-info {
  margin: 20px 0;
  display: flex;
  justify-content: flex-start;
  .number-info {
    background: rgb(222, 222, 245);
    border-radius: 10px;
    width: 120px;
    padding: 10px;
    text-align: center;
    margin-right: 20px;
    &--value {
      color: var(--accent-color);
      font-size: 1.2rem;
      font-weight: bold;
    }
  }
}
.event-details {
  background: #FFF;
  margin: 20px auto;
  padding: 10px;
  white-space: pre-wrap;
}
.event-comments {
  margin: 20px;
  &--form {
    &--textarea {
      width: 100%;
      display: block;
      border: none;
      outline: none;
      border-bottom: 1px solid #888;
      height: 28px;
      background: var(--base-color);

    }
    .comment-btns {
      display: flex;
      justify-content: flex-end;
      margin-top: 5px;
      color: #FFF;
      &--cancel {
        cursor: pointer;
        width: 100px;
        padding: 3px;
        text-align: center;
        background: #888;
        margin-right: 10px;
        font-size: 16px;
      }
      &--post {
        border: none;
        outline: none;
        font-size: 16px;
        color: #FFF;
        cursor: pointer;
        width: 100px;
        padding: 3px;
        text-align: center;
        background: #888;
        background: var(--accent-color);
      }
    }
  }
  &--display {
    .message-card {
      margin-bottom: 20px;
      display: flex;
      justify-content: flex-start;
      &--left {
        .message-userimg {
          img {
            width: 30px;
            border: 1px solid;
            border-radius: 100%;
          }
        }
      }
      &--right {
        margin-left: 10px;
        .message-info {
          display: flex;
          justify-content: flex-start;
          font-size: 15px;
          &--username {
            margin-right: 10px;
          }
          &--time {
            color: #888;
          }
        }
        .message-text {
          background: #FFF;
          border-radius: 5px;
          padding: 10px;
        }
      }
    }
  }
}
</style>