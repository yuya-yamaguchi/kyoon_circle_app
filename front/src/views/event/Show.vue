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
        <div>
          <button v-if="!entryFlg"
                  @click="postEventEntry()"
                  class="default-button">参加する
          </button>
          <button v-if="entryFlg"
                  @click="postCancelEventEntry()"
                  class="cancel-button">参加をやめる
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
      modalMsg: {
        title: "イベントの取消",
        message: "イベントの取消を行います。<br>削除したイベントは元へは戻せません。よろしいですか？",
        btn: "削除"
      }
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
        .catch(function(error) {
          this.apiErrors(error.response.status);
        });
      }
    },
    displayConfirmModal: function() {
      this.modalFlg = true;
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
</style>