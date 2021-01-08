<template>
  <div class="single-container">
    <Loading v-if="loading"/>
    <div v-else>
      <h1 class="main-title">{{ event.title }}</h1>
      <div v-show="$store.getters['user/adminType']>0">
        <router-link :to="`/event/${event.id}/edit`" class="edit-btn">編集する</router-link>
        <a @click="displayConfirmModal" class="delete-btn">削除する</a>
      </div>
      <ConfirmModal v-show="modalFlg"
        :modal-msg-prop="modalMsg"
        @process-confirm="deleteEvent"/>
      <p v-show="entryFlg" class="entry-now-msg">このイベントに参加しました</p>
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
      <div class="event-middle-info">開催日時 {{ holdStart(event.start_date) }}〜{{ holdStart(event.end_date) }}</div>
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
</template>

<script>
import axios from 'axios';
import g from "@/variable/variable.js";
import Loading from '@/components/Loading.vue';
import ConfirmModal from "@/components/ConfirmModal.vue";

export default {
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
          params:{
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
      .catch(function(error) {
        console.log(error);
      });
    },
    postEventEntry: function() {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/entry`,
        {
          user_id: this.$store.getters['user/id'],
          token:   this.$store.getters['user/secureToken']
        }
      )
      .then((response) => {
        this.entryFlg = true;
        this.entryCnt = response.data;
      })
      .catch((error) => {
        this.$store.dispatch(
          "flash/create",
          { message: error.response.data.error_message,
            type:    2
          }
        );
      });
    },
    postCancelEventEntry: function() {
      axios.post(
        `http://${g.hostName}/api/events/${this.$route.params.id}/entry_cancel`,
        {
          user_id: this.$store.getters['user/id'],
          token:   this.$store.getters['user/secureToken']
        }
      )
      .then((response) => {
        this.entryFlg = false;
        this.entryCnt = response.data;
      })
      .catch((error) => {
        this.$store.dispatch(
          "flash/create",
          { message: error.response.data.error_message,
            type:    2
          }
        );
      });
    },
    deleteEvent: function(confirm) {
      this.modalFlg = false;
      if (confirm) {
        axios.delete(
          `http://${g.hostName}/api/events/${this.event.id}`
        )
        .then(() => {
          this.$store.dispatch(
            "flash/create",
            { message: "イベントを削除しました",
              type:    1
            }
          );
          this.$router.push({ 
            name: "EventEditList"
          })
        })
        .catch(function(error) {
          console.log(error);
        });
      }
    },
    displayConfirmModal: function() {
      this.modalFlg = true;
    },
    holdStart: function(startDate) {
      return startDate.substr(0, 4) + '/' + startDate.substr(5, 2) + '/' + startDate.substr(8, 2) + ' ' + startDate.substr(11, 5)
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
      color: #13b1c0;
      font-size: 1.2rem;
      font-weight: bold;
    }
  }
}
.event-details {
  background: #FFF;
  margin: 20px auto;
  padding: 10px;
}
.edit-btn {
  display: inline-block;
  padding: 2px 15px;
  margin: 10px;
  border-radius: 10px;
  font-weight: bold;
  text-decoration: none;
  color: #FFF;
  cursor: pointer;
  background: orange;
}
.delete-btn {
  display: inline-block;
  padding: 2px 15px;
  margin: 10px;
  border-radius: 10px;
  font-weight: bold;
  text-decoration: none;
  color: #FFF;
  cursor: pointer;
  background: red;
}
</style>