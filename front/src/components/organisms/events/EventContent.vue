<template>
  <div>
    <ConfirmModal v-show="modalFlg"
      :modal-msg-prop="modalMsg"
      @process-confirm="deleteEvent"/>
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
      <div class="space-between">
        <div>
          <div class="event-middle-info">開催日時 {{ fmtDate(event.start_datetime, 2) }}〜{{ fmtDate(event.end_datetime, 2) }}</div>
          <div class="event-middle-info">開催場所 {{ event.place }}</div>
        </div>
        <div class="entry-btns">
          <div v-if="!entryFlg"
                  @click="postEventEntry()"
                  class="entry-btns--entry"
                  :disabled="cantEntry"
                  :class="{ 'btn-disable': cantEntry}">参加する
          </div>
          <div v-if="entryFlg"
                  @click="postCancelEventEntry()"
                  class="entry-btns--cancel some-updown-center"
                  :disabled="cantCancel"
                  :class="{ 'btn-disable': cantCancel}">
            <span>参加をやめる</span>
            <fa icon="sad-tear"></fa>
          </div>
        </div>
      </div>
      <div class="event-details">
        {{ event.details }}
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import Loading from '@/components/organisms/common/Loading.vue';
import ConfirmModal from "@/components/organisms/common/ConfirmModal.vue";
import { commonMethods } from '@/mixins/commonMethods';
import { errorMethods } from '@/mixins/errorMethods';

var today = new Date();

export default {
  mixins: [commonMethods, errorMethods],
  components: {
    Loading,
    ConfirmModal
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
      modalMsg: {
        title: "イベントの取消",
        message: "イベントの取消を行います。<br>削除したイベントは元へは戻せません。よろしいですか？",
        btn: "削除"
      }
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
        this.$emit('set-event-title', this.event.title);
      })
      .catch((error) => {
        this.apiErrors(error.response.status);
      })
      .finally(() => {
        this.loading = false;
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
        if (error.response.status === 400 || error.response.status === 401) {
          this.$store.dispatch(
            "flash/create",
            { message: error.response.data.error_message,
              type:    2
            }
          );
          if (error.response.status == 401) {
            this.$router.push({ 
              name: "Login"
            })
          }
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
    }
  },
  mounted: function() {
    this.getEvent();
  }
}
</script>

<style scoped lang="scss">
.entry-now-msg {
  color: var(--accent-color);
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
.entry-btns {
  margin-top: auto;
  cursor: pointer;
  color: #FFF;
  width: 150px;
  text-align: center;
  font-weight: bold;
  &--entry {
    background: var(--accent-color);
    padding: 5px 10px;
  }
  &--cancel {
    background: orange;
    padding: 5px 10px;
    svg {
      width: 18px;
      margin-left: 5px;
    }
  }
  :hover {
    opacity: 0.8;
  }
}
.event-details {
  background: #FFF;
  margin: 20px auto;
  padding: 10px;
  white-space: pre-wrap;
  min-height: 200px;
}
.btn-disable {
  background: #888;
}
</style>